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
	
	//부서 이름 중복
	@PostMapping("/validName")
	public boolean validName(@RequestParam String deptName) {
		DeptDto deptDto = deptDao.selectOneByDeptName(deptName);
        return deptDto == null;
		
	}
	
	//부서 삭제
	@RequestMapping("/delete")
	public boolean delete(@RequestParam int deptId) {
		return deptDao.delete(deptId);
	}
}
