package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.ApprovalStatVO;

@Component
public class ApprovalStatMapper implements RowMapper<ApprovalStatVO>{
	@Override
	public ApprovalStatVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		ApprovalStatVO vo = new ApprovalStatVO();
		
		vo.setStatus(rs.getString("status"));
		vo.setCount(rs.getInt("count"));
		return vo;
	}
}
