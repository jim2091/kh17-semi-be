package com.kh.semiprj.restController;

import java.util.List;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.NotificationDao;
import com.kh.semiprj.dto.NotificationDto;
import com.kh.semiprj.dto.PdsDto;
import com.kh.semiprj.exception.TargetNotfoundException;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/rest/notification")
public class NotificationRestController {
	private final NotificationDao notificationDao;
	
	@PostMapping("/read")
	public void readNotification(NotificationDto notificationDto) {
		notificationDao.update(notificationDto);
	}
	
}
