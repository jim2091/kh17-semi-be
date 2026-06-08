package com.kh.semiprj.controller;

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
import com.kh.semiprj.mapper.AppLineMapper;

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
		model.addAttribute("list", list);
		return "/appr/list";
	}

	// 결재자가 보는 디테일
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
		AppDto appDto = appDao.selectOneById(appId); // appId로 조회
		if (appDto == null)
			return "redirect:./list";

		// 결재선도 함께 조회
		List<AppLineDto> lineList = appLineDao.selectByAppId(appId);
		model.addAttribute("appDto", appDto);
		model.addAttribute("lineList", lineList);
		return "appr/detail";

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
			appDao.updateAppStatus(appId, "결재중"); // ← appDao로 수정!
		} else {
			appDao.updateAppStatus(appId, "승인"); // ← appDao로 수정!
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
		appDao.updateAppStatus(appId, "반려"); // ← appDao로 수정!
		return "redirect:./detail?appId=" + appId;
	}

}
