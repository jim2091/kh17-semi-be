package com.kh.semiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class BoardReadDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	//등록 메소드
	public void insert(String empId, long boardNo) {
		String sql = "insert into board_read(emp_id, board_no) values(?, ?)";
		Object[] params = {empId, boardNo};
		jdbcTemplate.update(sql,params);
	}
	
	//카운트 메소드
	public int count(String empId, long boardNo) {
		String sql = "select count(*) fromg board_read "
					+ "where emp_id = ? and board_no = ?";
		Object[] params = {empId, boardNo};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
}
