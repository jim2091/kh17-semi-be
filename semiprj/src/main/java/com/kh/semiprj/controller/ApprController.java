package com.kh.semiprj.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.AppLineDao;
import com.kh.semiprj.dao.VacAppDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.AppLineDto;
import com.kh.semiprj.dto.AttachDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.service.LeaveService;
import com.kh.semiprj.service.VacService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/appr")
public class ApprController {

	@Autowired
	private AppDao appDao;

	@Autowired
	private AppLineDao appLineDao;

	@Autowired
	private VacAppDao vacAppDao;

	@Autowired
	private VacService vacService;

	@Autowired
	private LeaveService leaveService;

	@RequestMapping("/list")
	public String list(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		List<AppLineDto> list = appLineDao.selectMyApprList(empNo);

		List<AppDto> appList = new ArrayList<>();
		for (AppLineDto line : list) {
			AppDto appDto = appDao.selectOneById(line.getAppId());
			appList.add(appDto);
		}

		model.addAttribute("list", list);
		model.addAttribute("appList", appList);
		model.addAttribute("currentTab", "appr");
		return "/appr/list";
	}

	@PostMapping("/approve")
	public String approve(@RequestParam int appLineId, @RequestParam int appId, @RequestParam int currentOrder,
			HttpSession session) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login";
		}

		String empNo = appDao.selectEmpNoById(loginId);
		AppLineDto line = appLineDao.selectOne(appLineId);

		if (line == null || !line.getAppAppId().equals(empNo)) {
			return "redirect:./list";
		}

		appLineDao.approve(appLineId);

		int nextCount = appLineDao.updateNextApprover(appId, currentOrder);
		if (nextCount > 0) {
			appDao.updateAppStatus(appId, "처리중");
		} else {
			appDao.updateAppStatus(appId, "승인");

			String appType = appDao.selectAppTypeById(appId);

			if ("휴가신청서".equals(appType)) {
				String requesterEmpNo = appDao.selectEmpNoByAppId(appId);
				VacAppDto vacAppDto = vacAppDao.selectVacOne(appId);

				if (vacAppDto != null) {
					String vacType = vacAppDto.getVacType();

					if ("휴가".equals(vacType)) {
						leaveService.approveLeaveSuccess(appId, requesterEmpNo);
					} else if ("연차".equals(vacType) || "병가".equals(vacType)) {
						vacService.approveVacationSuccess(appId, requesterEmpNo);
					}
				}
			}
		}
		return "redirect:./detail?appId=" + appId;
	}

	@PostMapping("/reject")
	public String reject(@RequestParam int appLineId, @RequestParam int appId, @RequestParam String appLineRej,
			HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login";
		}

		String empNo = appDao.selectEmpNoById(loginId);
		AppLineDto line = appLineDao.selectOne(appLineId);

		if (line == null || !line.getAppAppId().equals(empNo)) {
			return "redirect:./list";
		}

		appLineDao.reject(appLineId, appLineRej);
		appDao.updateAppStatus(appId, "반려");
		return "redirect:./detail?appId=" + appId;
	}

	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login";
		}
		
		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null) {
			return "redirect:/login";
		}

		AppDto appDto = appDao.selectOneById(appId);
		if (appDto == null) {
			return "redirect:/app/list";
		}

		List<AppLineDto> lineList = appLineDao.selectByAppId(appId);

		if (lineList != null) {
			for (AppLineDto line : lineList) {
				String deptCode = line.getEmpDept(); 
				if (deptCode != null) {
					String deptName = appDao.selectDeptNameByCode(deptCode); 
					line.setEmpDept(deptName); 
				}
			}
		}

		AppLineDto myTurn = null;
		if (lineList != null) {
			for (AppLineDto line : lineList) {
				if (line.getAppAppId() != null && line.getAppAppId().equals(empNo) 
						&& "진행중".equals(line.getAppLineStatus())) {
					myTurn = line;
					break;
				}
			}
		}

		List<AttachDto> attachList = appDao.searchFiles(appId);
		model.addAttribute("attachList", attachList);

		if ("휴가신청서".equals(appDto.getAppType())) {
			VacAppDto vacAppDto = appDao.selectVacByAppId(appId);
			model.addAttribute("vacAppDto", vacAppDto);
		} else if ("품의서".equals(appDto.getAppType())) {
			ExpAppDto expAppDto = appDao.selectExpByAppId(appId);
			model.addAttribute("expAppDto", expAppDto);
		} else if ("업무기안서".equals(appDto.getAppType())) {
			DftAppDto dftAppDto = appDao.selectDftByAppId(appId);
			model.addAttribute("dftAppDto", dftAppDto);
		}

		model.addAttribute("appDto", appDto);
		model.addAttribute("lineList", lineList); 
		model.addAttribute("myTurn", myTurn);
		return "appr/detail";
	}
}