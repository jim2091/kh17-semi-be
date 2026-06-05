package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.DftAppDto;

@Component
public class DftAppMapper implements RowMapper<DftAppDto>{

	@Override
	public DftAppDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		DftAppDto dftAppDto = new DftAppDto();
		dftAppDto.setAppId(rs.getInt("app_id"));
		dftAppDto.setDftDate(rs.getString("dft_date"));
		return dftAppDto;
	}

}
