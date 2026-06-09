package com.kh.semiprj.restController;

import java.io.IOException;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.kh.semiprj.service.AttachService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/rest/attach")
public class AttachRestController {
	private final AttachService attachService;
	
	@PostMapping("/upload")
	public int upload(@RequestParam MultipartFile attach) throws IllegalStateException, IOException {
		return attachService.save(attach);
	}
}
