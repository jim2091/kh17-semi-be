package com.kh.semiprj.advice;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.NotificationDao;
import com.kh.semiprj.dto.EmpDto;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalModelAdvice {
	private final NotificationDao notificationDao;
	private final EmpDao empDao;
	
	@ModelAttribute
	public void notification(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		//로그인 안되어있으면
		if (empDto == null) return;
		
		model.addAttribute("recentNotificationList", notificationDao.selectRecent(empDto.getEmpNo()));
		model.addAttribute("unreadNotificationCount", notificationDao.countUnread(empDto.getEmpNo()));
	}
}
