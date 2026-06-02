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
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.spring09.exception.TargetNotfoundException;
import com.kh.spring09.exception.WhoAreYouException;
import com.kh.spring09.vo.PageVO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/dept")
public class DeptController {
	@Autowired
	private DeptDao deptDao;

	//목록 및 검색
	@RequestMapping("/list")
	public String list(@ModelAttribute PageVO pageVO, Model model) {
		
		pageVO.setSize(10); 
		int count = deptDao.count(pageVO);
		pageVO.setCount(count);
	    
		//목록 조회
		List<DeptDto> list = deptDao.selectList(pageVO);
		
		//모델에 첨부
		model.addAttribute("list",list);
		model.addAttribute("pageVO",pageVO);
		
		return "dept/list";
	}
	
	
	
	//등록
	@GetMapping("/insert")
	public String insert(HttpServletRequest request ) {
		EmpDto loginUser = (EmpDto) request.getAttribute("loginUser");
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
	
	//상세
	@RequestMapping("/detail")
	public String detail(@RequestParam int deptId, Model model) {
		DeptDto deptDto = deptDao.selectOne(deptId);
		if(deptDto == null)
			throw new TargetNotfoundException("존재하지 않는 부서 정보");
			model.addAttribute("deptDto",deptDto);
			
			return "dept/detail";
	}
	
}
