package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.EmpAttachDto;

@Component
public class EmpAttachMapper implements RowMapper<EmpAttachDto>{
	@Override
	public EmpAttachDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		EmpAttachDto empAttachDto = new EmpAttachDto();
		empAttachDto.setEmpNo(rs.getString("emp_no"));
		empAttachDto.setAttachNo(rs.getInt("attach_no"));
		empAttachDto.setDownloadTime(rs.getTimestamp("download_time"));
		return empAttachDto;
	}
}
