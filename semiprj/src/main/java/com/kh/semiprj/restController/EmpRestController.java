package com.kh.semiprj.restController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.MessageDao;
import com.kh.semiprj.dto.EmpDto;

@RestController
@RequestMapping("/rest/emp")
public class EmpRestController {
	
	@Autowired
	private EmpDao empDao;
	@Autowired
	private MessageDao messageDao;
	
	
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
	
	@GetMapping("/search")
	public List<Map<String, Object>> search(@RequestParam String keyword){
		List<EmpDto> originList = empDao.search(keyword);
		
		List<Map<String, Object>> resultList = new ArrayList<>();
		
		for (EmpDto emp : originList) {
			Map<String, Object> map = new HashMap<>();
			
			map.put("empNo", emp.getEmpNo());
			map.put("empName", emp.getEmpName());
			map.put("empPosition", emp.getEmpPosition());
			map.put("empDept", emp.getEmpDept()); 
			if (emp.getEmpDept() != 0) {
				try {
					String deptName = messageDao.selectDetpNameById(emp.getEmpDept());
					map.put("empDeptName", deptName);
				} catch (Exception e) {
					map.put("empDeptName", "소속없음");
				}
			} else {
				map.put("empDeptName", "소속없음");
			}
			
			resultList.add(map);
		}
		
		return resultList;
	}

}
