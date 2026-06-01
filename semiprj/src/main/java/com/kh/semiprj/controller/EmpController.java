package com.kh.semiprj.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.EmpDto;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/emp")
public class EmpController {
	
	@Autowired
	private EmpDao empDao;

	@GetMapping("/login")
	public String login() {
		return "emp/login";
	}
	
	@PostMapping("/login")
	public String login(@ModelAttribute EmpDto empDto,
						HttpSession session, HttpServletRequest request) {
		//[1] 사용자가 입력한 아이디가 DB에 존재하는지
		EmpDto findEmpDto = empDao.selectOne(empDto.getEmpId());
		if (findEmpDto == null) {
			return "redirect:./login?error";
		}
		//[2] 비밀번호를 비교
		boolean isPasswordValid = empDto.getEmpPw().equals(findEmpDto.getEmpPw());
		
		if (!isPasswordValid) {
			return "redirect:./login?error";
		}
		
		//session에 로그인 되었음을 표시
		session.setAttribute("loginId", findEmpDto.getEmpId());
		session.setAttribute("loginRole", findEmpDto.getEmpLevel());
		
		return "redirect:/";
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		session.removeAttribute("loginId");
		session.removeAttribute("loginLevel");
		
		return "redirect:/";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
