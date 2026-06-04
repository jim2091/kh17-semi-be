package com.kh.semiprj.restController;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.CertDao;
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
	
}
