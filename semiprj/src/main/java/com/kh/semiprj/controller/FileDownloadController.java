package com.kh.semiprj.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.semiprj.dao.AttachDao;
import com.kh.semiprj.dao.EmpAttachDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.AttachDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/download")
public class FileDownloadController {
	@Autowired
	private AttachDao attachDao;
	@Value("${custom.file.upload-path}")
	private String uploadPath;
	@Autowired
	private EmpAttachDao empAttachDao;
	@Autowired
	private EmpDao empDao;
	
	
	@RequestMapping("/modern")
	public ResponseEntity<ByteArrayResource> download(@RequestParam int attachNo, HttpSession session) throws IOException{
		
		AttachDto attachDto = attachDao.selectOne(attachNo);
		if(attachDto == null) throw new TargetNotfoundException("존재하지 않는 파일");
		
		File dir = new File(uploadPath);
		File target = new File(dir, String.valueOf(attachNo));
		if(!target.isFile()) throw new TargetNotfoundException("존재하지 않는 파일");
		
		byte[] data = FileCopyUtils.copyToByteArray(target);
		ByteArrayResource resource = new ByteArrayResource(data);
		
		String loginId = (String)session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		empAttachDao.insert(empDto.getEmpNo(), attachNo);
		
		return ResponseEntity.ok()
				.contentLength(attachDto.getAttachSize())
				.header(HttpHeaders.CONTENT_TYPE,  attachDto.getAttachTypeString())
				.header(HttpHeaders.CONTENT_ENCODING, "UTF-8")
				.header(HttpHeaders.CONTENT_DISPOSITION, 
					ContentDisposition
						.attachment()
						.filename(attachDto.getAttachName(), StandardCharsets.UTF_8)
						.build()
						.toString()
				)
				.body(resource);
	}

	
}
