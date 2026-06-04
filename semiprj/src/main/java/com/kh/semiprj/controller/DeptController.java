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

import com.kh.semiprj.dao.DeptCategoryDao;
import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dto.DeptCategoryDto;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.exception.WhoAreYouException;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/dept")
public class DeptController {
	@Autowired
	private DeptDao deptDao;
	
	// 💡 [수정] 변수명 첫 글자를 소문자로 올바르게 교정했습니다.
	@Autowired
	private DeptCategoryDao deptCategoryDao;

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
		
		
		List<DeptCategoryDto> categoryList = deptCategoryDao.selectCategoryList();
		model.addAttribute("categoryList",categoryList);
		
		return "dept/list";
	}
	
	//등록
	@GetMapping("/insert")
	public String insert(HttpSession session, Model model ) {
		String loginRole = (String)session.getAttribute("loginRole");
		if(loginRole == null || !loginRole.equals("관리자")){
			throw new WhoAreYouException("관리자 권한이 필요한 기능입니다.");
		}
		
		List<DeptCategoryDto> categoryList = deptCategoryDao.selectCategoryList();
		model.addAttribute("categoryList",categoryList);
		
		return "dept/insert";
	}
	
	@PostMapping("/insert")
	public String insert(@ModelAttribute DeptDto deptDto) throws IllegalStateException, IOException {
		
		int deptId = deptDao.sequence();
		deptDto.setDeptId(deptId);
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
		if(deptDto == null) {
			throw new TargetNotfoundException("존재하지 않는 부서 정보");
		}
		model.addAttribute("deptDto",deptDto);
		
		return "dept/detail";
	}
	
	//수정
	@GetMapping("/edit")
	public String edit(@RequestParam int deptId, Model model, HttpSession session) {
		String loginRole = (String)session.getAttribute("loginRole");
		if(loginRole == null || !loginRole.equals("관리자")) {
			throw new WhoAreYouException("관리자 권한이 필요합니다.");
		}
		
		DeptDto deptDto = deptDao.selectOne(deptId);
		
		if(deptDto == null) throw new TargetNotfoundException("존재하지 않은 부서");
		
		model.addAttribute("deptDto",deptDto);
		return "dept/edit";
	}
	
	@PostMapping("/edit")
	public String edit(@ModelAttribute DeptDto deptDto,HttpSession session) {
		String loginRole = (String) session.getAttribute("loginRole");
		if(loginRole == null|| !loginRole.equals("관리자")) {
			throw new WhoAreYouException("관리자권한이 필요한 기능입니다.");
		}
		deptDao.update(deptDto);
		return "redirect:./detail?deptId="+deptDto.getDeptId();
	}
	
	@RequestMapping("/block")
	public String block(@RequestParam int deptId, HttpSession session) {
		String loginRole = (String) session.getAttribute("loginRole");
		if(loginRole == null || !loginRole.equals("관리자")) {
			throw new WhoAreYouException("관리자 권한이 필요합니다.");
		}		
		DeptDto deptDto = deptDao.selectOne(deptId);
		if(deptDto == null) {	
			throw new TargetNotfoundException("존재하지 않는 부서입니다.");
		}
			
		String current = deptDto.getDeptYn();
		String future = current.equals("Y") ? "N" : "Y";
		deptDto.setDeptYn(future);
		deptDao.updateDeptYn(deptDto);
		
		return "redirect:./detail?deptId="+deptId;
	}
}