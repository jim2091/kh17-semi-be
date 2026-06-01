package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.VacAppDto;

@Repository
public class VacAppMapper implements RowMapper<VacAppDto>{

	@Override
	public VacAppDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		VacAppDto vacAppDto = new VacAppDto();
		vacAppDto.setAppId(rs.getInt("app_id"));
		vacAppDto.setVacStartDate(rs.getTimestamp("vac_start_date"));
		vacAppDto.setVacEndDate(rs.getTimestamp("vac_end_date"));
		vacAppDto.setVacType(rs.getString("vac_type"));
		return vacAppDto;
	}
}
