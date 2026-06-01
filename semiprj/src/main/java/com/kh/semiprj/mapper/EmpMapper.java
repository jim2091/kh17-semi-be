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
		empDto.setEmpName(rs.getString("emp_name"));
		empDto.setEmpBirth(rs.getString("emp_birth"));
		empDto.setEmpEmail(rs.getString("emp_email"));
		empDto.setEmpContact(rs.getString("emp_contact"));
		empDto.setEmpPost(rs.getString("emp_post"));
		empDto.setEmpAddress1(rs.getString("emp_address1"));
		empDto.setEmpAddress2(rs.getString("emp_address2"));
		empDto.setEmpLevel(rs.getString("emp_level"));
		empDto.setEmpPosition(rs.getString("emp_position"));
		empDto.setEmpDept(rs.getString("emp_dept"));
		empDto.setEmpApprovalStatus(rs.getString("emp_approval_status"));
		empDto.setEmpUseYn(rs.getString("emp_use_yn"));
		empDto.setEmpHireDate(rs.getTimestamp("emp_hire_date"));
		empDto.setEmpRetiredDate(rs.getTimestamp("emp_retired_date"));
		empDto.setEmpCreateAt(rs.getTimestamp("emp_create_at"));
		empDto.setEmpMentor(rs.getString("emp_mentor"));
		empDto.setEmpPwChange(rs.getTimestamp("emp_pw_change"));
		
		return empDto;
	}
}
