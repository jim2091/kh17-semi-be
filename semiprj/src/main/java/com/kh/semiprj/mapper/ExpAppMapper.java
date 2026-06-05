package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.ExpAppDto;

@Component
public class ExpAppMapper implements RowMapper<ExpAppDto>{

	@Override
	public ExpAppDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		ExpAppDto expAppDto = new ExpAppDto();
		expAppDto.setAppId(rs.getInt("app_id"));
		expAppDto.setExpDate(rs.getString("exp_date"));
		expAppDto.setExpPrice(rs.getInt("exp_price"));
		expAppDto.setExpHistory(rs.getString("exp_history"));
		expAppDto.setExpHow(rs.getString("exp_how"));
		expAppDto.setExpPurpose(rs.getString("exp_purpose"));
		return expAppDto;
	}

}
