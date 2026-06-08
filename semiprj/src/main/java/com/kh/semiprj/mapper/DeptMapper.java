package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.DeptDto;

@Component
public class DeptMapper implements RowMapper<DeptDto>{
	
	@Override
	public DeptDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		DeptDto deptDto = new DeptDto();
		
		deptDto.setDeptId(rs.getInt("dept_id"));
		deptDto.setParentDeptId(rs.getInt("parent_dept_id"));
		deptDto.setDeptHeadId(rs.getString("dept_head_id"));
		deptDto.setDeptName(rs.getString("dept_name"));
		deptDto.setDeptYn(rs.getString("dept_yn"));
		deptDto.setDeptCreateAt(rs.getTimestamp("dept_create_at"));
		deptDto.setDeptContent(rs.getString("dept_content"));
		
		deptDto.setParentDeptName(rs.getString("parent_dept_name"));
		
		return deptDto;
	}
}
