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
import com.kh.semiprj.dto.AttachDto;
import com.kh.semiprj.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/download")
public class FileDownloadController {
	@Autowired
	private AttachDao attachDao;
	
	@Value("${custom.file.upload-path}")
	private String uploadPath;
	
	@RequestMapping("/legacy")
	@ResponseBody
	public void legecy(@RequestParam int attachNo, 
						HttpServletResponse response) throws IOException {
		AttachDto attachDto = attachDao.selectOne(attachNo);
		if(attachDto == null) throw new TargetNotfoundException("존재하지 않는 파일");
		
//		File dir = new File("D:/upload");
		File dir = new File(uploadPath);
		File target = new File(dir, String.valueOf(attachNo));
		if(!target.isFile()) throw new TargetNotfoundException("존재하지 않는 파일");
		
		response.setHeader("Content-Encoding", "UTF-8");
		response.setHeader("Content-Type", attachDto.getAttachTypeString());
		response.setHeader("Content-Length", String.valueOf(attachDto.getAttachSize()));
		StringBuffer sb = new StringBuffer();
		sb.append("attachment");
		sb.append(";");
		sb.append("filename=");
		sb.append("\"");
		sb.append(URLEncoder.encode(attachDto.getAttachName(), "UTF-8"));
		sb.append("\"");
		response.setHeader("Content-Disposition", sb.toString());
		FileInputStream stream = new FileInputStream(target);
		byte[] buffer = new byte[1024];
		
		while(true) {
			int size = stream.read(buffer);
			if(size == -1) break;
			response.getOutputStream().write(buffer, 0, size);
		}
		stream.close();
	}
	
	@RequestMapping("/modern")
	public ResponseEntity<ByteArrayResource> download(@RequestParam int attachNo) throws IOException{
		
		AttachDto attachDto = attachDao.selectOne(attachNo);
		if(attachDto == null) throw new TargetNotfoundException("존재하지 않는 파일");
		
		File dir = new File(uploadPath);
		File target = new File(dir, String.valueOf(attachNo));
		if(!target.isFile()) throw new TargetNotfoundException("존재하지 않는 파일");
		
		byte[] data = FileCopyUtils.copyToByteArray(target);
		ByteArrayResource resource = new ByteArrayResource(data);
		
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
