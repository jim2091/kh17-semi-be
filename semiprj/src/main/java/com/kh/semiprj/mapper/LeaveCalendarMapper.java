package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.LeaveCalendarVO;

@Component
public class LeaveCalendarMapper implements RowMapper<LeaveCalendarVO>{
@Override
public LeaveCalendarVO mapRow(ResultSet rs, int rowNum) throws SQLException {
	LeaveCalendarVO vo = new LeaveCalendarVO();
	
	vo.setEmpNo(rs.getString("emp_no"));
	vo.setEmpName(rs.getString("emp_name"));
	vo.setDeptName(rs.getString("dept_name"));
	vo.setLeaveDate(rs.getString("leave_date"));

	return vo;
}
}
