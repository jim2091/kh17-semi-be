package com.kh.semiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.VacAppDto;

@Repository
public class VacAppDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	//휴가 신청서 생성용 dao
	
	public void insert(VacAppDto vacAppDto) {
		String sql = "insert into vac_app (app_id, vac_start_date, vac_end_date, vac_type) "
					+ " values(?, ?, ?, ?)";
		Object[] params = {
							vacAppDto.getAppId(), vacAppDto.getVacStartDate(),
							vacAppDto.getVacEndDate(), vacAppDto.getVacType()
						};
		jdbcTemplate.update(sql, params);
		
	}
}
