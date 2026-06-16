package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.VacHistoryDto;

@Component
public class VacHistoryMapper implements RowMapper<VacHistoryDto> {

	@Override
	public VacHistoryDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		VacHistoryDto vacHistoryDto = new VacHistoryDto();
		vacHistoryDto.setVacHistNo(rs.getInt("vac_hist_no"));
		vacHistoryDto.setAppId(rs.getInt("app_id"));
		vacHistoryDto.setVacDate(rs.getString("vac_date"));
		return vacHistoryDto;
	}
}
