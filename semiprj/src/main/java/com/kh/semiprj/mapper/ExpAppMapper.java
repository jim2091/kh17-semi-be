package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.ExpAppDto;

@Component
public class ExpAppMapper implements RowMapper<ExpAppDto>{

	@Override
	public ExpAppDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return null;
	}

}
