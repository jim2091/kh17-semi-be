package com.kh.semiprj.controller;

import java.io.File;
import java.io.IOException;
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

import com.kh.semiprj.dao.AttachDao;
import com.kh.semiprj.dto.AttachDto;
import com.kh.semiprj.exception.TargetNotfoundException;


@Controller
@RequestMapping("/download")
public class FileDownloadController {
	@Autowired
	private AttachDao attachDaol;
	
	@Value("${custom.file.upload-path}")
    private String uploadPath;
	
	@RequestMapping("/modern")
	public ResponseEntity<ByteArrayResource> download(@RequestParam int attachNo) throws IOException{
		
		AttachDto attachDto = attachDaol.selectOne(attachNo);
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
