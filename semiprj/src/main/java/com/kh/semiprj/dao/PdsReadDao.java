package com.kh.semiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class PdsReadDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	public void insert(String empNo, int pdsNo) {
		String sql = "insert into pds_read(emp_no, pds_no) values(?, ?)";
		Object[] params = {empNo, pdsNo};
		jdbcTemplate.update(sql, params);
	}
	
	public int count(String empNo, int pdsNo) {
		String sql = "select count(*) from pds_read where "
						+ "emp_no = ? and pds_no = ?";
		
		Object[] params = {empNo, pdsNo};
		
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
}
