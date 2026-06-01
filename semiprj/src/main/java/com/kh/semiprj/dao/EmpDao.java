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
		String sql = "select * from emp_test where emp_id = ?";
		Object[] params = { empId };
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
}
