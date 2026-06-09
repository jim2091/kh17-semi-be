package com.kh.semiprj.restController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dto.DeptDto;

@CrossOrigin
@RestController
@RequestMapping("/rest/dept")
public class DeptRestController {
	
	@Autowired
	private DeptDao deptDao;
	
	//부서 이름 중복 검사 통합본 (등록/수정)
	@PostMapping("/validName")
	public boolean validName(
			@RequestParam String deptName,
			@RequestParam(defaultValue = "0") int deptId) {
		
		// 신규등록
		if(deptId == 0) {
			DeptDto deptDto = deptDao.selectOneByDeptName(deptName);
			return deptDto == null; // 결과가 없어야 사용 가능(true)
		}
		
		// 부서수정
		else {
			// 나를 제외한 다른 부서 중 중복명이 있는지 검사 결과 리턴
			return deptDao.checkDuplicateForEdit(deptName, deptId);
		}
	}
	
	//부서 삭제
	@RequestMapping("/delete")
	public boolean delete(@RequestParam int deptId) {
		return deptDao.delete(deptId);
	}
}