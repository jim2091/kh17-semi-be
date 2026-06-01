package com.kh.semiprj.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dto.DeptDto;

@Controller
@RequestMapping("/dept")
public class DeptController {
	@Autowired
	private DeptDao deptDao;

	//목록
	@RequestMapping("/list")
	public String list() {
		return "dept/list";
	}
	
	//등록
	@GetMapping("/insert")
	public String insert() {
		return "dept/insert";
	}
	@PostMapping("/insert")
	public String insert(@ModelAttribute DeptDto deptDto) throws IllegalStateException, IOException {
		deptDao.insert(deptDto);
		
		return "redirect:./insertComplete";
	}
	@RequestMapping("/insertComplete")
	public String insertComplete() {
		return "dept/insertComplete";
	}
}
