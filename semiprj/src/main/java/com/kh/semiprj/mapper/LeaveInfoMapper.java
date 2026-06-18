package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.LeaveInfoDto;

@Component
public class LeaveInfoMapper implements RowMapper<LeaveInfoDto>{

	@Override
	public LeaveInfoDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		LeaveInfoDto leaveInfoDto = new LeaveInfoDto();
		leaveInfoDto.setLeaveNo(rs.getInt("leave_no"));
		leaveInfoDto.setEmpNo(rs.getString("emp_no"));
		leaveInfoDto.setLeaveYear(rs.getInt("leave_year"));
		leaveInfoDto.setLeaveTot(rs.getInt("leave_tot"));
		leaveInfoDto.setLeaveCnt(rs.getInt("leave_cnt"));
		leaveInfoDto.setLeaveUsed(rs.getInt("leave_used"));
		return leaveInfoDto;
	}

}
