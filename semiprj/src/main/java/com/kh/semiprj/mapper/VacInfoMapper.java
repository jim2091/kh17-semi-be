package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.dto.VacInfoDto;

@Component
public class VacInfoMapper implements RowMapper<VacInfoDto> {

	@Override
	public VacInfoDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		VacInfoDto vacInfoDto = new VacInfoDto();
		vacInfoDto.setVacNo(rs.getInt("vac_no"));
		vacInfoDto.setEmpNo(rs.getString("emp_no"));
		vacInfoDto.setVacYear(rs.getInt("vac_year"));
		vacInfoDto.setVacTot(rs.getInt("vac_tot"));
		vacInfoDto.setVacCnt(rs.getInt("vac_cnt"));
		vacInfoDto.setVacUsed(rs.getInt("vac_used"));
		return vacInfoDto;
	}

}
