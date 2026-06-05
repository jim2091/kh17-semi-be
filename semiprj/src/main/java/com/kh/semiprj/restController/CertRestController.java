package com.kh.semiprj.restController;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.CertDao;
import com.kh.semiprj.dto.CertDto;
import com.kh.semiprj.service.EmailService;

import jakarta.mail.MessagingException;

@RestController
@RequestMapping("/rest/cert")
public class CertRestController {
	@Autowired
	private EmailService emailService;
	@Autowired
	private CertDao certDao;
	
	@PostMapping("/send")
	public void send(@RequestParam String certEmail) throws MessagingException, IOException {
		emailService.sendCertNumber(certEmail);
	}
	@PostMapping("/check")
	public boolean check(@ModelAttribute CertDto certDto) {
		CertDto findDto = certDao.selectOne(certDto.getCertEmail());
		if(findDto == null) return false; 
		boolean valid = certDto.getCertNumber().equals(findDto.getCertNumber());
		if(valid == false) return false;
		LocalDateTime current = LocalDateTime.now();
		LocalDateTime sent = findDto.getCertTime().toLocalDateTime();
		
		Duration duration = Duration.between(sent, current);
		if(duration.toMinutes() > 10) {
			return false;
		}
		if(findDto.isComplete()) 
			
			return false;
			
		certDao.update(certDto.getCertEmail());
		return true;
		
	}
}
