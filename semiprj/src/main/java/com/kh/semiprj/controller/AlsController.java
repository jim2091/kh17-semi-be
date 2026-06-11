package com.kh.semiprj.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.semiprj.dao.AlsDao;
import com.kh.semiprj.dto.AlsDto;

@Controller
@RequestMapping("/als")
public class AlsController {

	@Autowired
	private AlsDao alsDao;

	// 팝업 페이지 자체를 열어주는 매핑
	@GetMapping("/popup")
	public String popup() {
		return "als/popup"; 
	}

	// 결재선 생성
	@PostMapping("/create")
	public Map<String, Object> create(@RequestBody AlsDto alsDto) {
		alsDao.create(alsDto);
		return Map.of("result", "success");
	}

	// 결재선 삭제
	@PostMapping("/delete")
	public Map<String, Object> delete(@RequestParam int alsId) {
		boolean result = alsDao.delete(alsId);
		return Map.of("result", result ? "success" : "fail");
	}

	// 결재선 수정
	@PostMapping("/update")
	public Map<String, Object> update(@RequestBody AlsDto alsDto) {
		boolean result = alsDao.update(alsDto);
		return Map.of("result", result ? "success" : "fail");
	}
}
