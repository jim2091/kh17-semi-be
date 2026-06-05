package com.kh.semiprj.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.ExpAppDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ExpAppDao {
    private final JdbcTemplate jdbcTemplate;

    public void insertExpApp(ExpAppDto expAppDto) {
        String sql = "insert into exp_app (app_id, exp_date, exp_price, exp_history, exp_how, exp_purpose)"
                   + " values(?, ?, ?, ?, ?, ?)";
        Object[] params = {
            expAppDto.getAppId(),
            expAppDto.getExpDate(),
            expAppDto.getExpPrice(),
            expAppDto.getExpHistory(),
            expAppDto.getExpHow(),
            expAppDto.getExpPurpose()
        };
        jdbcTemplate.update(sql, params);
    }
}
