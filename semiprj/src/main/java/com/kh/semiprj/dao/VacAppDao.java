package com.kh.semiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.mapper.VacAppMapper;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class VacAppDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private VacAppMapper vacAppMapper;

	// 시퀀스 발급기
	public int sequence() {
		String sql = "select app_seq.nextval from dual";
		Integer seq = jdbcTemplate.queryForObject(sql, Integer.class);
		return seq != null ? seq : 0;
	}

	public void insertVacApp(VacAppDto vacAppDto) {
		String sql = "insert into vac_app (app_id, vac_start_date, vac_end_date, vac_type)" 
					+ " values(?, ?, ?, ?)";
		Object[] params = { vacAppDto.getAppId(), vacAppDto.getVacStartDate(), vacAppDto.getVacEndDate(),
				vacAppDto.getVacType() };
		jdbcTemplate.update(sql, params);
	}

	public VacAppDto selectVacOne(int appId) {
		String sql = "select * from vac_app where app_id = ?";
		Object[] params = { appId };
		return jdbcTemplate.queryForObject(sql, vacAppMapper, params);
	}
}
