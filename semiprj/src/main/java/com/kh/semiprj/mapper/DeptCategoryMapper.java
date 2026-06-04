package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.DeptCategoryDto;

@Component
public class DeptCategoryMapper implements RowMapper<DeptCategoryDto>{

	@Override
	public DeptCategoryDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		DeptCategoryDto deptCategoryDto = new DeptCategoryDto();
		
		deptCategoryDto.setDeptCategoryNo(rs.getInt("dept_category_no"));
		deptCategoryDto.setDeptCategoryName(rs.getString("dept_category_name"));
		
		return deptCategoryDto;
	}


}
