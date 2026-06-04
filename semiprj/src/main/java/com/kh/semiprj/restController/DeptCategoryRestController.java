package com.kh.semiprj.restController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.DeptCategoryDao;
import com.kh.semiprj.dto.DeptCategoryDto;
import com.kh.semiprj.exception.SameNameException;

@CrossOrigin
@RestController
@RequestMapping("/rest/deptCategory")
public class DeptCategoryRestController {
	
	@Autowired
	private DeptCategoryDao deptCategoryDao;

	@PostMapping("/insert")
	public int insert(@RequestParam String deptCategoryName) throws Exception{
		
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
}
