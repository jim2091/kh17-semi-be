package com.kh.semiprj.restController;

import java.util.List;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.NotificationDao;
import com.kh.semiprj.dto.NotificationDto;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/rest/notification")
public class NotificationRestController {
	private final NotificationDao notificationDao;
	private final EmpDao empDao;
	
	@PostMapping("/read")
	public void readNotification(NotificationDto notificationDto) {
		notificationDao.update(notificationDto);
	}
	
	@GetMapping("/listMore")
	public List<NotificationDto> listMore(
			@RequestParam(defaultValue = "1") int page, HttpSession session,
			@RequestParam(defaultValue = "all") String type){
		String loginId = (String) session.getAttribute("loginId");
		String loginNo = empDao.selectOne(loginId).getEmpNo();
		
		int size = 10;
		int endRow = page * size;
		int beginRow = endRow - size + 1;
		
		return notificationDao.selectListByPaging(loginNo, type, beginRow, endRow);
	}
	
}
