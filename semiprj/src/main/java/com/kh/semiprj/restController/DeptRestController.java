package com.kh.semiprj.restController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.DeptCategoryDao;
import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dto.DeptCategoryDto;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.exception.SameNameException;

@CrossOrigin
@RestController
@RequestMapping("/rest/dept")
public class DeptRestController {
	
	@Autowired
	private DeptCategoryDao deptCategoryDao;
	@Autowired
	private DeptDao deptDao;

	//부서 카테고리 등록
	@PostMapping("/insert")
	public int insert(@RequestParam String deptCategoryName) throws Exception{
		//중복되는지
		boolean isSame = deptCategoryDao.exists(deptCategoryName);
		
		if(isSame) {
			throw new SameNameException("이미 존재하는 카테고리명 입니다.");
		}
		
		int nextNo = deptCategoryDao.sequence();
		
		DeptCategoryDto deptCategoryDto = new DeptCategoryDto();
		deptCategoryDto.setDeptCategoryNo(nextNo);
		deptCategoryDto.setDeptCategoryName(deptCategoryName);
		deptCategoryDao.insert(deptCategoryDto);
		
		return nextNo;
	}
	
	//부서 이름 중복
	@PostMapping("/validName")
	public boolean validName(@RequestParam String deptName) {
		DeptDto deptDto = deptDao.selectOneByDeptName(deptName);
        return deptDto == null;
		
	}
}
