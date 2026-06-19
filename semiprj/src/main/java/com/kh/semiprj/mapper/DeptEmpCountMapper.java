package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.DeptEmpCountVO;

@Component
public class DeptEmpCountMapper implements RowMapper<DeptEmpCountVO> {

    @Override
    public DeptEmpCountVO mapRow(ResultSet rs, int rowNum) throws SQLException {
        DeptEmpCountVO vo = new DeptEmpCountVO();

        vo.setDeptId(rs.getInt("dept_id"));
        vo.setDeptName(rs.getString("dept_name"));
        vo.setEmpCount(rs.getInt("emp_count"));

        return vo;
    }
}