package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.DeptMemberStatusVO;

@Component
public class MemberStatusMapper implements RowMapper<DeptMemberStatusVO>{
	@Override
	public DeptMemberStatusVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		DeptMemberStatusVO vo = new DeptMemberStatusVO();
		
		vo.setEmpNo(rs.getString("emp_no"));
		vo.setEmpName(rs.getString("emp_name"));
		vo.setDeptName(rs.getString("dept_name"));
		vo.setEmpPosition(rs.getString("position_name"));
		vo.setAttnRecord(rs.getString("attn_record"));
		vo.setAttnInTime(rs.getString("attn_in_time"));
		vo.setAttnOutTime(rs.getString("attn_out_time"));
		
		return vo;
	}
}
