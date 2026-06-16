package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.ManagedDeptVO;

@Component
public class ManagedDeptMapper implements RowMapper<ManagedDeptVO>{
	@Override
	public ManagedDeptVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		ManagedDeptVO vo = new ManagedDeptVO();
		
		vo.setDeptId(rs.getString("dept_id"));
		vo.setDeptName(rs.getString("dept_name"));
		vo.setParentDeptId(rs.getString("parent_dept_id"));
		vo.setDepth(rs.getInt("depth"));
		
		return vo;
	}
}
