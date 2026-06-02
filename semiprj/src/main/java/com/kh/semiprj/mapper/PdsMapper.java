package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.PdsDto;

@Component
public class PdsMapper implements RowMapper<PdsDto>{
	@Override
	public PdsDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		PdsDto pdsDto = new PdsDto();
		pdsDto.setPdsNo(rs.getLong("pds_no"));
		pdsDto.setPdsTitle(rs.getString("pds_title"));
		pdsDto.setPdsContent(rs.getString("pds_content"));
		pdsDto.setPdsWriter(rs.getString("pds_writer"));
		pdsDto.setPdsReadcount(rs.getLong("pds_readcount"));
		pdsDto.setPdsWtime(rs.getTimestamp("pds_wtime"));
		
		return pdsDto;
	}
}
