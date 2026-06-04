package com.kh.semiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.DftAppDto;

@Repository
public class DftAppDao {
	
	//결제기안서 등록용 dao
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	public void insert(DftAppDto dftAppDto) {
		String sql = "insert into dft_app(app_id, dft_date)values(?, ?)";
		Object[] params = { dftAppDto.getAppId(), dftAppDto.getDftDate() };
		jdbcTemplate.update(sql, params);
	}
	
}
