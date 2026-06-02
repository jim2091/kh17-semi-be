package com.kh.semiprj.service;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kh.semiprj.dao.AttachDao;
import com.kh.semiprj.dto.AttachDto;


@Service
public class AttachService {
	@Autowired
	private AttachDao attachDao;
	
	@Value("${custom.file.upload-path}")
    private String uploadPath;
	
	public int save(MultipartFile attach) throws IllegalStateException, IOException {
		int attachNo = attachDao.sequence();
		AttachDto attachDto = new AttachDto();
		attachDto.setAttachNo(attachNo);
		attachDto.setAttachName(attach.getOriginalFilename());
		attachDto.setAttachType(attach.getContentType());
		attachDto.setAttachSize(attach.getSize());
		attachDao.insert(attachDto);
		
		File dir = new File(uploadPath);
		if(!dir.exists()) {
		    dir.mkdirs();
		}
		
		File target = new File(dir, String.valueOf(attachNo));
		attach.transferTo(target);
		
		return attachNo;
	}
	
	public void delete(int attachNo) {
		AttachDto attachDto = attachDao.selectOne(attachNo);
		if(attachDto == null) throw new com.kh.semiprj.exception.TargetNotfoundException("존재하지 않는 파일");
		
		attachDao.delete(attachNo);
		
		File dir = new File(uploadPath);
		File target = new File(dir, String.valueOf(attachNo));
		target.delete();
	}
}
