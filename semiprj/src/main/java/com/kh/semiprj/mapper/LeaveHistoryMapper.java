package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.LeaveHistoryDto;

@Component
public class LeaveHistoryMapper implements RowMapper<LeaveHistoryDto>{

	@Override
	public LeaveHistoryDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		LeaveHistoryDto leaveHistoryDto = new LeaveHistoryDto();
		leaveHistoryDto.setLeaveHistNo(rs.getInt("leave_hist_no"));
		leaveHistoryDto.setAppId(rs.getInt("app_id"));
		leaveHistoryDto.setLeaveDate(rs.getString("leave_date"));
		return leaveHistoryDto;
	}
	
}
