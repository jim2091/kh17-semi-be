package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.AlsDto;

@Component
public class AlsMapper implements RowMapper<AlsDto> {

	@Override
	public AlsDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		AlsDto alsDto = new AlsDto();
		alsDto.setAlsId(rs.getInt("als_id"));
		alsDto.setAlsOrder(rs.getInt("als_order"));
		alsDto.setAlsRegId(rs.getString("als_reg_id"));
		alsDto.setAlsApprId(rs.getString("als_appr_id"));
		alsDto.setAlsCreateDate(rs.getTimestamp("als_create_date"));
		return alsDto;
	}

}
