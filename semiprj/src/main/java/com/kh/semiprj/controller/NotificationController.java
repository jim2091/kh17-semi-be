package com.kh.semiprj.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.NotificationDao;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.NotificationDto;
import com.kh.semiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notification")
public class NotificationController {
	private final NotificationDao notificationDao;
	private final EmpDao empDao;
	
	
	@RequestMapping("list")
	public String list(HttpSession session, Model model, 
						@RequestParam(defaultValue = "all") String type) {
		String loginId = (String) session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		List<NotificationDto> list = notificationDao.selectList(empDto.getEmpNo(), type);
		
		model.addAttribute("type", type);
		model.addAttribute("list", list);
		
		return "notification/list";
	}
	
	@RequestMapping("/delete")
	public String delete(@RequestParam int notificationNo) {
		NotificationDto notificationDto = notificationDao.selectOne(notificationNo);
		if(notificationDto == null) throw new TargetNotfoundException("존재하지 않는 알림입니다");
		notificationDao.delete(notificationNo);
		return "redirect:./list";
	}
	@RequestMapping("/deleteAll")
	public String deleteAll(@RequestParam List<Integer> notificationNoList) {
		for(Integer notificationNo : notificationNoList)	{
			NotificationDto notificationDto = notificationDao.selectOne(notificationNo);
			if(notificationDto == null) throw new TargetNotfoundException("존재하지 않는 알림 포함되어있습니다");
		}
		for(Integer notificationNo : notificationNoList)	{
			notificationDao.delete(notificationNo);
		}

		return "redirect:./list";
	}
}
