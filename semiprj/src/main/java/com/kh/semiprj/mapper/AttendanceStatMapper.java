package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.AttendanceStatVO;

@Component
public class AttendanceStatMapper implements RowMapper<AttendanceStatVO>{
	@Override
	public AttendanceStatVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		AttendanceStatVO vo = new AttendanceStatVO();
		
		vo.setLabel(rs.getString("label"));
		vo.setNormalCount(rs.getInt("normal_count"));
		vo.setLateCount(rs.getInt("late_count"));
		vo.setEarlyLeaveCount(rs.getInt("early_leave_count"));
		vo.setLateEarlyCount(rs.getInt("late_early_count"));
		vo.setLeaveCount(rs.getInt("leave_count"));
		vo.setUncheckedCount(rs.getInt("unchecked_count"));
		return vo;
	}
}
