package com.kh.semiprj.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.BoardDao;
import com.kh.semiprj.dao.EventDao;
import com.kh.semiprj.dao.MessageDao;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	@Autowired
	private AppDao appDao;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MessageDao messageDao;
	@Autowired
	private EventDao eventDao;
	
	
	@RequestMapping("/")
	public String home(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
	    String empNo = appDao.selectEmpNoById(loginId);
	    
	    // 내 전자결재 최근 3개만
	    model.addAttribute("myAppList", appDao.selectMyRecentList(empNo));
	    model.addAttribute("boardList", boardDao.selectRecentList());
	    model.addAttribute("noticeList", boardDao.selectRecentNoticeList());
	    model.addAttribute("penddingAppCount", appDao.countMyPenddingApp(empNo));
	    model.addAttribute("unreadMessageCount", messageDao.countUnread(empNo));
	    model.addAttribute("todayEventCount", eventDao.countTodayEvent(empNo));
	    model.addAttribute("todayEventList" , eventDao.selectTodayEvent(empNo));
		return "/home2";
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