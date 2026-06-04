package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.ReplyDto;
import com.kh.semiprj.mapper.ReplyMapper;

@Repository
public class ReplyDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private ReplyMapper replyMapper;
	
	//댓글 등록 메소드
	public long sequence() {
		String sql = "select reply_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, long.class);
	}
	public void insert(ReplyDto replyDto) {
		String sql = "insert into reply("
						+ "reply_no, reply_writer, reply_origin, reply_content"
					+ ") values(?, ?, ?, ?)";
		Object[] params = {
				replyDto.getReplyNo(), replyDto.getReplyWriter(), 
				replyDto.getReplyOrigin(), replyDto.getReplyContent()};
		jdbcTemplate.update(sql, params);	
	}
	
	//댓글 수정 메소드
	public boolean update(ReplyDto replyDto) {
		String sql = "update reply set "
						+ "reply_content = ?, reply_etime = systimestamp "
					+ "where reply_no = ?";
		Object[] params = {replyDto.getReplyContent(), replyDto.getReplyNo()};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//댓글 삭제 메소드
	public boolean delete(long replyNo) {
		String sql = "delete reply where reply_no = ?";
		Object[] params = {replyNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//댓글 목록 메소드
	public List<ReplyDto> selectList(long replyOrigin) {
		String sql = "select r.reply_no, "
						+ "r.reply_writer, e.emp_name, "
						+ "r.reply_origin, r.reply_content, "
						+ "r.reply_wtime, r.reply_etime "
					+ "from reply r "
					+ "left outer join emp e on r.reply_writer = e.emp_no "
					+ "where r.reply_origin = ? "
					+ "order by r.reply_no asc";
		Object[] params = {replyOrigin};
	    return jdbcTemplate.query(sql, replyMapper, params);
	}
	
	//댓글 상세 조회 메소드
	public ReplyDto selectOne(long replyNo) {
		String sql = "select r.reply_no, "
						+ "r.reply_writer, e.emp_name, "
						+ "r.reply_origin, r.reply_content, "
						+ "r.reply_wtime, r.reply_etime "
			      + "from reply r "
			      + "left outer join emp e on r.reply_writer = e.emp_no "
			      + "where r.reply_no = ?";
		Object[] params = {replyNo};
		List<ReplyDto> list = jdbcTemplate.query(sql, replyMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
}
