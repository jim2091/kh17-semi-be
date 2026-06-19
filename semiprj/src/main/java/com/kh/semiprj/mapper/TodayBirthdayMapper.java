package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.TodayBirthdayVO;

@Component
public class TodayBirthdayMapper implements RowMapper<TodayBirthdayVO> {
    @Override
    public TodayBirthdayVO mapRow(ResultSet rs, int rowNum) throws SQLException {
        TodayBirthdayVO vo = new TodayBirthdayVO();

        vo.setEmpNo(rs.getString("emp_no"));
        vo.setEmpName(rs.getString("emp_name"));
        vo.setEmpPosition(rs.getString("emp_position"));
        vo.setDeptName(rs.getString("dept_name"));

        return vo;
    }
}