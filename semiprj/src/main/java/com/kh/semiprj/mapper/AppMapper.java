package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.AppDto;

@Component
public class AppMapper implements RowMapper<AppDto>{

	@Override
	public AppDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		AppDto appDto = new AppDto();
		appDto.setAppId(rs.getInt("app_id"));
		appDto.setAppReqId(rs.getString("app_req_id"));
		appDto.setAppTitle(rs.getString("app_title"));
		appDto.setAppContent(rs.getString("app_content"));
		appDto.setAppType(rs.getString("app_type"));
		appDto.setAppDate(rs.getTimestamp("app_date"));
		appDto.setAppStatus(rs.getString("app_status"));
		appDto.setAppSaveYn(rs.getString("app_save_yn"));
		return appDto;
	}

	

}
