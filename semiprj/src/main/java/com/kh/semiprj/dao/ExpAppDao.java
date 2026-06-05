package com.kh.semiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.ExpAppDto;

@Repository
public class ExpAppDao {
//품의서 등록 dao
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	public void insert(ExpAppDto expAppDto) {
		String sql = "insert into exp_app("
					+ " app_id, exp_date, exp_price, exp_history,"
					+ " exp_how, exp_purpose)"
					+ " values(?,?,?,?,?,?)";
		Object[] params = { 
							expAppDto.getAppId(), expAppDto.getExpDate(),
							expAppDto.getExpPrice(), expAppDto.getExpHistory(),
							expAppDto.getExpHow(), expAppDto.getExpPurpose()
							};
		jdbcTemplate.update(sql, params);
		
	}
	
}
