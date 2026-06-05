package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.AppLineDto;

@Component
public class AppLineMapper implements RowMapper<AppLineDto>{

	@Override
	public AppLineDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		AppLineDto applineDto = new AppLineDto();
		applineDto.setAppLineId(rs.getInt("app_line_id"));
		applineDto.setAppId(rs.getInt("app_id"));
		applineDto.setAppAppId(rs.getString("app_app_id"));
		applineDto.setAppLineOrder(rs.getInt("app_line_order"));
		applineDto.setAppLineType(rs.getString("app_line_type"));
		applineDto.setAppLineStatus(rs.getString("app_line_status"));
		applineDto.setAppLineDate(rs.getString("app_line_date"));
		applineDto.setAppLineRej(rs.getString("app_line_rej"));
		return applineDto;
	}

}
