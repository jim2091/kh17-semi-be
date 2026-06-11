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
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.AppLineDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;

import jakarta.servlet.http.HttpSession;

//결재자를 통제하는 컨트롤러
@Controller
@RequestMapping("/appr")
public class ApprController {
	@Autowired
	private AppDao appDao;
	@Autowired
	private AppLineDao appLineDao;

	// 결재자가 보는 리스트
	@RequestMapping("/list")
	public String list(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		List<AppLineDto> list = appLineDao.selectMyApprList(empNo);

		// appDto 목록도 같이 조회
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

	// 승인
	@PostMapping("/approve")
	public String approve(@RequestParam int appLineId, @RequestParam int appId, @RequestParam int currentOrder,
			HttpSession session) {
		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
		AppLineDto line = appLineDao.selectOne(appLineId);
		if (!line.getAppAppId().equals(empNo))
			return "redirect:./list";

		appLineDao.approve(appLineId);

		int nextCount = appLineDao.updateNextApprover(appId, currentOrder);
		if (nextCount > 0) {
			appDao.updateAppStatus(appId, "결재중");
		} else {
			appDao.updateAppStatus(appId, "승인");
		}
		return "redirect:./detail?appId=" + appId;
	}

	// 반려
	@PostMapping("/reject")
	public String reject(@RequestParam int appLineId, @RequestParam int appId, @RequestParam String appLineRej,
			HttpSession session) {
		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
		AppLineDto line = appLineDao.selectOne(appLineId);
		if (!line.getAppAppId().equals(empNo))
			return "redirect:./list";

		appLineDao.reject(appLineId, appLineRej);
		appDao.updateAppStatus(appId, "반려");
		return "redirect:./detail?appId=" + appId;
	}

	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		String empNo = appDao.selectEmpNoById(loginId);

		AppDto appDto = appDao.selectOneById(appId);
		if (appDto == null)
			return "redirect:./list";

		List<AppLineDto> lineList = appLineDao.selectByAppId(appId);

		// 내 차례인지 확인
		AppLineDto myTurn = null;
		for (AppLineDto line : lineList) {
			if (line.getAppAppId().equals(empNo) && line.getAppLineStatus().equals("진행중")) {
				myTurn = line;
				break;
			}
		}

		// 문서 종류에 따라 추가 정보 조회
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
