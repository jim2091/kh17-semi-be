package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.mapper.EmpMapper;

@Repository
public class EmpDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private EmpMapper empMapper;
	
	public EmpDto selectOne(String empId) {
		String sql = "select * from emp where emp_id = ?";
		Object[] params = { empId };
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public void insertFromAdmin(EmpDto empDto) {
		String sql = "insert into emp("
					+ "emp_no, emp_id, emp_pw, emp_name, "
					+ "emp_birth, emp_level, emp_position, "
					+ "emp_dept, emp_hire_date, emp_mentor) "
					+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {
				empDto.getEmpNo(), empDto.getEmpId(), empDto.getEmpPw(), 
				empDto.getEmpName(), empDto.getEmpBirth(), empDto.getEmpLevel(), 
				empDto.getEmpPosition(), empDto.getEmpDept(), empDto.getEmphireDate(), 
				empDto.getEmpMentor() 
		};
		
		jdbcTemplate.update(sql, params);
	}
	
	
	
	
	
	
	
	
	
	
}
