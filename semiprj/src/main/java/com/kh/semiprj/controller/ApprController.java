package com.kh.semiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
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
import com.kh.semiprj.service.NotificationService;
import com.kh.semiprj.service.VacService;
import com.kh.semiprj.vo.PageVO;

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
	
	@Autowired
	private NotificationService notificationService;

	@RequestMapping("/list")
	public String list(HttpSession session, @ModelAttribute PageVO pageVO,
			@RequestParam(required = false) String searchAppType,
			@RequestParam(required = false) String searchAppStatus, Model model) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		String empName = appDao.selectEmpNameById(loginId);

		model.addAttribute("empName", empName);
		model.addAttribute("currentTab", "appr"); // 결재 문서함 탭 활성화 마킹

		// 1. 내 결재 문서함 필터 기준 카운트 가동 후 선배님의 PageVO에 수량 세팅 (setCount 호출 시 내부 블록 연산 자동 구동)
		int totalCount = appLineDao.countMyApprListByFilter(empNo, searchAppType, searchAppStatus);
		pageVO.setCount(totalCount);

		// 2. 사양에 맞춰 오차 없이 리팩토링된 신설 DAO 페이징 메서드 타격
		List<AppLineDto> list = appLineDao.selectMyApprListByFilter(pageVO, empNo, searchAppType, searchAppStatus);

		model.addAttribute("list", list);
		model.addAttribute("pageVO", pageVO);

		// 3. JSP 상태 복원용 속성 바인딩 및 파라미터 캐싱
		model.addAttribute("searchAppType", searchAppType);
		model.addAttribute("searchAppStatus", searchAppStatus);

		String searchParams = "searchAppType=" + (searchAppType != null ? searchAppType : "") + "&searchAppStatus="
				+ (searchAppStatus != null ? searchAppStatus : "");
		model.addAttribute("searchParams", searchParams);

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
			String requesterEmpNo = appDao.selectEmpNoByAppId(appId);
			
			if ("휴가신청서".equals(appType)) {
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
			notificationService.notifyApproval(requesterEmpNo, appId);
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
		String requesterEmpNo = appDao.selectEmpNoByAppId(appId);
		notificationService.notifyReject(requesterEmpNo, appId);
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