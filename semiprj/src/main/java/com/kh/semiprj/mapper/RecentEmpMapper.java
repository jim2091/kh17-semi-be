package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.RecentEmpVO;

@Component
public class RecentEmpMapper implements RowMapper<RecentEmpVO> {

    @Override
    public RecentEmpVO mapRow(ResultSet rs, int rowNum) throws SQLException {
        RecentEmpVO vo = new RecentEmpVO();

        vo.setEmpNo(rs.getString("emp_no"));
        vo.setEmpName(rs.getString("emp_name"));
        vo.setEmpPosition(rs.getString("emp_position"));
        vo.setDeptName(rs.getString("dept_name"));
        vo.setEmpCreateAt(rs.getString("emp_create_at"));

        return vo;
    }
}