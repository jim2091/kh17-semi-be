package com.kh.semiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class BoardLikeDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	//등록(= 좋아요 설정)
	public void insert(String empId, int boardNo) {
		String sql = "insert into board_like(emp_id, board_no) values(?, ?)";
		Object[] params = {empId, boardNo};
		jdbcTemplate.update(sql, params);
	}
	//삭제(= 좋아요 해제)
	public boolean delete(String empId, int boardNo) {
		String sql = "delete board_like where emp_id=? and board_no=?";
		Object[] params = {empId, boardNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
	//검사(좋아요 여부)
	public boolean check(String memberId, int boardNo) {
		String sql = "select count(*) from board_like where member_id=? and board_no=?";
		Object[] params = {memberId, boardNo};
		return jdbcTemplate.queryForObject(sql, int.class, params) > 0;
	}
	//개수(좋아요 개수)
	public int count(int boardNo) {
		String sql = "select count(*) from board_like where board_no=?";
		Object[] params = {boardNo};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
}
