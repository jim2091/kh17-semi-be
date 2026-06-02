package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.EmpHistoryDto;

@Component
public class EmpHistoryMapper implements RowMapper<EmpHistoryDto>{

	@Override
	public EmpHistoryDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		EmpHistoryDto empHistoryDto = new EmpHistoryDto();
		empHistoryDto.setEmpHistoryNo(rs.getInt("emp_history_no"));
		empHistoryDto.setEmpHistoryOrigin(rs.getString("emp_history_origin"));
		empHistoryDto.setEmpHistoryTime(rs.getTimestamp("emp_history_time"));
		empHistoryDto.setEmpHistoryAddress(rs.getString("emp_history_address"));
		empHistoryDto.setEmpHistoryAgent(rs.getString("emp_history_agent"));
		
		return empHistoryDto;
	}

}
