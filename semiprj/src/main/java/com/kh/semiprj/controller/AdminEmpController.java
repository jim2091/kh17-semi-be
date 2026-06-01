package com.kh.semiprj.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.EmpDto;

@Controller
@RequestMapping("/admin")
public class AdminEmpController {
	
	@Autowired
	private EmpDao empDao;
	
	@GetMapping("/register")
	public String register() {
		return "admin/register";
	}
	
	@PostMapping("/register")
	public String register(@ModelAttribute EmpDto empDto) {
		System.out.println(empDto);
		empDao.insertFromAdmin(empDto);
		
		return "redirect:/";
		//홈으로 리다이렉트해놓았는데, 사원목록구현후 사원목록페이지로 리다이렉트할 예정입니다
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}
