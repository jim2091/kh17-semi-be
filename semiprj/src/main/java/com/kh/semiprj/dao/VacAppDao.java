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
}
