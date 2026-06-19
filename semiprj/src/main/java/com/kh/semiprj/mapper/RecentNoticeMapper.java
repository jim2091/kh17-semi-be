package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.kh.semiprj.vo.RecentNoticeVO;

@Component
public class RecentNoticeMapper implements RowMapper<RecentNoticeVO> {
    @Override
    public RecentNoticeVO mapRow(ResultSet rs, int rowNum) throws SQLException {
        RecentNoticeVO vo = new RecentNoticeVO();

        vo.setNoticeNo(rs.getInt("notice_no"));
        vo.setNoticeTitle(rs.getString("notice_title"));
        vo.setNoticeDate(rs.getString("notice_date"));

        return vo;
    }
}