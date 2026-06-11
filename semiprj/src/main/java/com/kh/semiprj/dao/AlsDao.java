package com.kh.semiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.AlsDto;

@Repository
public class AlsDao {
	//결재선관리 
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	//시퀀스 발급기
	public int sequence() {
		String sql = "select als_seq.nextval from dual";
		Integer seq = jdbcTemplate.queryForObject(sql, Integer.class);
		return seq !=null ? seq : 0;
	}
	
	//결재선관리 생성
	public void create(AlsDto alsDto) {
		String sql = "insert into app_line_save"
				+ "( als_id, als_reg_id, als_appr_id, als_order, als_create_date)"
				+ " values (?, ?, ?, ?, ?)";
		Object[] params = { alsDto.getAlsId(), alsDto.getAlsRegId(), 
							alsDto.getAlsApprId(), alsDto.getAlsOrder(),
							alsDto.getAlsCreateDate() };
		jdbcTemplate.update(sql, params);
	}
	
	//결재선관리 삭제
	public boolean delete(int alsId) {
		String sql = "delete app_line_save where als_id=?";
		Object[] params = { alsId };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//결재선관리 편집
	public boolean update(AlsDto alsDto) {
		String sql = "update app_line_save set als_appr_id=?, als_order=? where als_id=?";
		Object[] params = { alsDto.getAlsApprId(), alsDto.getAlsOrder(), alsDto.getAlsId() };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
}
