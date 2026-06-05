package com.kh.semiprj.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.DftAppDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DftAppDao {
    private final JdbcTemplate jdbcTemplate;

    public void insertDftApp(DftAppDto dftAppDto) {
        String sql = "insert into dft_app (app_id, dft_date)"
                   + " values(?, ?)";
        Object[] params = {
            dftAppDto.getAppId(),
            dftAppDto.getDftDate()
        };
        jdbcTemplate.update(sql, params);
    }
}