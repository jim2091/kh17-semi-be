package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.EmpDto;

@Component
public class EmpMapper implements RowMapper<EmpDto>{
	@Override
	public EmpDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		EmpDto empDto = new EmpDto();
		
		empDto.setEmpNo(rs.getInt("emp_no"));
		empDto.setEmpId(rs.getString("emp_id"));
		empDto.setEmpPw(rs.getString("emp_pw"));
		empDto.setEmpRole(rs.getString("emp_role"));
		
		return empDto;
	}
}
