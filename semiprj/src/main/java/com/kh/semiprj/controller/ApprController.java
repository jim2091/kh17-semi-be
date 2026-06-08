package com.kh.semiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.AppLineDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.AppLineDto;

import jakarta.servlet.http.HttpSession;

//결재자를 통제하는 컨트롤러
@Controller
@RequestMapping("/appr")
public class ApprController {
	@Autowired
	private AppDao appDao;
	@Autowired
	private AppLineDao appLineDao;
	
	//결재자가 보는 리스트
	@RequestMapping("/list")
	public String list(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		if(loginId == null) return "redirect:/login";
		String empNo = appDao.selectEmpNoById(loginId);
		List<AppLineDto> list = appLineDao.selectMyApprList(empNo);
		model.addAttribute("list",list);
		return "/appr/list";
	}
	
	//결재자가 보는 디테일
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
	    AppDto appDto = appDao.selectOneById(appId); // appId로 조회
	    if (appDto == null) return "redirect:./list";

	    // 결재선도 함께 조회
	    List<AppLineDto> lineList = appLineDao.selectByAppId(appId);
	    model.addAttribute("appDto", appDto);
	    model.addAttribute("lineList", lineList);
	    return "appr/detail";
	
	}
}
