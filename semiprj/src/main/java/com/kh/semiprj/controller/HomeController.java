package com.kh.semiprj.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.semiprj.dao.AppDao;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	@Autowired
	private AppDao appDao;
	
	
	@RequestMapping("/")
	public String home(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
	    String empNo = appDao.selectEmpNoById(loginId);
	    
	    // 내 전자결재 최근 5개만
	    model.addAttribute("myAppList", appDao.selectMyRecentList(empNo));
		return "/home";
	}
    @PostMapping("/menu/toggle")
    @ResponseBody
    public void toggle(@RequestParam boolean managerToggle,
                       HttpSession session) {

        String empLevel = (String) session.getAttribute("empLevel");

        // 진짜 관리자가 아니면 토글 불가
        if (!"관리자".equals(empLevel)) {
            session.setAttribute("loginRole", "사용자");
            session.removeAttribute("managerToggle");
            return;
        }

        session.setAttribute("managerToggle", managerToggle);

        if (managerToggle) {
            session.setAttribute("loginRole", "관리자");
        }
        else {
            session.setAttribute("loginRole", "사용자");
        }
    }
}