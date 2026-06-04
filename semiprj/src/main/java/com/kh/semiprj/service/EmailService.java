package com.kh.semiprj.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.kh.semiprj.configuration.EmailProperties;
import com.kh.semiprj.dao.CertDao;
import com.kh.semiprj.dto.CertDto;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {
	@Autowired
	private JavaMailSender sender;
	@Autowired
	private RandomService randomService;
	@Autowired
	private CertDao certDao;
	@Autowired
	private EmailProperties emailProperties;
	
	public void sendCertNumber(String memberEmail) throws MessagingException, IOException {
		MimeMessage message = sender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
		
		helper.setFrom(emailProperties.getUsername());
		helper.setTo(memberEmail);
		helper.setSubject("[어디저장될회사명] 인증코드가 도착하였습니다");
		
		String number = randomService.generateNumber(6);
		
		String template = this.createCertHtml(number);
		helper.setText(template, true);
		sender.send(message);
		
		CertDto certDto = certDao.selectOne(memberEmail);
		if(certDto == null) {//처음 보내는 이메일
			certDao.insert(certDto.builder()
									.certEmail(memberEmail)
									.certNumber(number)
									.build());
		}
		else {//이미 보낸적이 있는 이메일
			certDao.update(certDto.builder()
									.certEmail(memberEmail)
									.certNumber(number)
									.build());
		}
		
	}
	
	public String createCertHtml(String certNumber) throws IOException {
		ClassPathResource resource = new ClassPathResource("templates/cert-template.html");
		File target = resource.getFile();
		
		BufferedReader reader = new BufferedReader(new FileReader(target));
		StringBuffer buffer = new StringBuffer();
		
		while(true) {
			String line = reader.readLine();
			if(line == null) break;
			buffer.append(line);
		}
		reader.close();
		
		String html = buffer.toString();
		
		Document document = Jsoup.parse(html);
		
		Elements list = document.select(".number-wrapper");
		
		for(int i = 0; i < list.size(); i++) {
			Element tag = list.get(i);
			char ch = certNumber.charAt(i);
			tag.text(String.valueOf(ch));
		}
		
		return document.toString();
	}
}
