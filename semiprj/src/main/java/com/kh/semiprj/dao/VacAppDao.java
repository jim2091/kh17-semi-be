package com.kh.semiprj.dao;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.VacAppDto;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class VacAppDao {

    private final JdbcTemplate jdbcTemplate;

    // 시퀀스 발급기
    public int sequence() {
        String sql = "select app_seq.nextval from dual";
        Integer seq = jdbcTemplate.queryForObject(sql, Integer.class);
        return seq != null ? seq : 0;
    }
    public void insertVacApp(VacAppDto vacAppDto) {
        String sql = "insert into vac_app (app_id, vac_start_date, vac_end_date, vac_type)"
                   + " values(?, ?, ?, ?)";
        Object[] params = {
            vacAppDto.getAppId(),
            vacAppDto.getVacStartDate(),
            vacAppDto.getVacEndDate(),
            vacAppDto.getVacType()
        };
        jdbcTemplate.update(sql, params);
    }
    
 // 특정 결재 문서 번호(app_id)로 휴가 신청 정보 단건 조회
 	public VacAppDto selectOne(int appId) {
 		String sql = "select * from vac_app where app_id = ?";
 		Object[] ob = { appId };
 		
 		try {
 			// 스프링의 RowMapper 람다식을 사용하여 조회 결과를 DTO에 바인딩합니다.
 			return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
 				VacAppDto dto = new VacAppDto();
 				dto.setAppId(rs.getInt("app_id"));
 				dto.setVacStartDate(rs.getString("vac_start_date"));
 				dto.setVacEndDate(rs.getString("vac_end_date"));
 				dto.setVacType(rs.getString("vac_type"));
 				return dto;
 			}, ob);
 		} catch (org.springframework.dao.EmptyResultDataAccessException e) {
 			// 해당 app_id로 데이터를 찾지 못했을 때 에러를 터뜨리지 않고 null을 반환하여 시스템을 방어합니다.
 			return null; 
 		}
 	}
}
