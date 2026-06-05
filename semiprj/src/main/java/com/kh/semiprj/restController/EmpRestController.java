package com.kh.semiprj.restController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.EmpDto;

@RestController
@RequestMapping("/rest/emp")
public class EmpRestController {
	
	@Autowired
	private EmpDao empDao;
	
	
	@PostMapping("/validEmail")
	public boolean validEmail(@RequestParam String empEmail) {
		EmpDto empDto = empDao.selectOneByEmpEmail(empEmail);
		return empDto == null;
	}
	@RequestMapping("/validNo")
	public boolean validNo(@RequestParam String empNo) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		return empDto == null;
	}
	@RequestMapping("/validId")
	public boolean validId(@RequestParam String empId) {
		EmpDto empDto = empDao.selectOne(empId);
		return empDto == null;
	}

}
