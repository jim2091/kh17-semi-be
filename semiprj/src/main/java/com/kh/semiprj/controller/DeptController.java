package com.kh.semiprj.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.spring09.exception.WhoAreYouException;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/dept")
public class DeptController {
	@Autowired
	private DeptDao deptDao;

	//목록
	@RequestMapping("/list")
	public String list(Model model) {
		List<DeptDto> list =deptDao.selectList();
		model.addAttribute("list",list);
		return "dept/list";
	}
	
	//등록
	@GetMapping("/insert")
	public String insert(HttpSession session) {
		EmpDto loginUser = (EmpDto) session.getAttribute("loginUser");
		if(loginUser == null || !loginUser.getEmpLevel().equals("관리자")){
			throw new WhoAreYouException("관리자 권한이 필요한 기능입니다.");
		}
		
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
