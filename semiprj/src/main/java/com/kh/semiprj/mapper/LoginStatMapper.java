package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.LoginStatVO;

@Component
public class LoginStatMapper implements RowMapper<LoginStatVO> {
    @Override
    public LoginStatVO mapRow(ResultSet rs, int rowNum) throws SQLException {
        LoginStatVO vo = new LoginStatVO();

        vo.setLabel(rs.getString("label"));
        vo.setCount(rs.getInt("count"));

        return vo;
    }
}