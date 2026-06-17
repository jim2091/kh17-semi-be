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
		
		empDto.setEmpNo(rs.getString("emp_no"));
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
		empDto.setEmpDept(rs.getInt("emp_dept"));
		empDto.setEmpApprovalStatus(rs.getString("emp_approval_status"));
		empDto.setEmpUseYn(rs.getString("emp_use_yn"));
		empDto.setEmpHireDate(rs.getTimestamp("emp_hire_date"));
		empDto.setEmpRetiredDate(rs.getTimestamp("emp_retired_date"));
		empDto.setEmpCreateAt(rs.getTimestamp("emp_create_at"));
		empDto.setEmpMentor(rs.getString("emp_mentor"));
		empDto.setEmpPwChange(rs.getTimestamp("emp_pw_change"));
		empDto.setEmpEmailVerified(rs.getString("emp_email_verified"));
		
		
		//부서 이름 출력을 위해 이것만 따로 생성 같이 생성하면 전체 MAPPER오류
		try {
			empDto.setEmpDeptName(rs.getString("emp_dept_name"));
		} catch (SQLException e) {
			// SQL 결과에 emp_dept_name 컬럼이 없어도 에러를 내지 않고 null로 둡니다.
			empDto.setEmpDeptName(null); 
		}
//		empDto.setPositionId(rs.getInt("position_id"));
//		empDto.setPositionName(rs.getString("position_name"));
//		empDto.setPositionLevel(rs.getInt("position_level"));
//		
		return empDto;
	}
}
