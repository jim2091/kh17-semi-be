package com.kh.semiprj.dao;


import java.util.List;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.AppLineDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AppLineDao {
    private final JdbcTemplate jdbcTemplate;

    // 결재선 등록
    public void insert(AppLineDto appLineDto) {
        String sql = "insert into app_line (app_line_id, app_id, app_app_id, "
                   + "app_line_order, app_line_type, app_line_status) "
                   + "values (app_line_seq.nextval, ?, ?, ?, ?, '대기')";
        Object[] params = {
            appLineDto.getAppId(),
            appLineDto.getAppAppId(),
            appLineDto.getAppLineOrder(),
            appLineDto.getAppLineType()
        };
        jdbcTemplate.update(sql, params);
    }

    // 첫번째 결재자 진행중으로 변경
    public void activateFirst(int appId) {
        String sql = "update app_line set app_line_status = '진행중' "
                   + "where app_id = ? and app_line_order = 1";
        jdbcTemplate.update(sql, appId);
    }

    // 특정 문서의 결재선 전체 조회
    public List<AppLineDto> selectByAppId(int appId) {
        String sql = "select l.*, e.emp_name, e.emp_dept, e.emp_position "
                   + "from app_line l "
                   + "join emp e on l.app_app_id = e.emp_no "
                   + "where l.app_id = ? "
                   + "order by l.app_line_order asc";
        Object[] params = { appId };
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AppLineDto.class), params);
    }

    // 내가 결재해야 할 목록 (진행중인 것만)
    public List<AppLineDto> selectMyApprList(String empNo) {
        String sql = "select l.*, a.app_title, a.app_type, a.app_date, "
                   + "e.emp_name "
                   + "from app_line l "
                   + "join app a on l.app_id = a.app_id "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where l.app_app_id = ? "
                   + "and l.app_line_status = '진행중' "
                   + "order by l.app_line_id desc";
        Object[] params = { empNo };
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AppLineDto.class), params);
    }

    // 승인
    public void approve(int appLineId) {
        String sql = "update app_line set app_line_status = '완료', "
                   + "app_line_date = systimestamp  "
                   + "where app_line_id = ?";
        jdbcTemplate.update(sql, appLineId);
    }

    // 반려
    public void reject(int appLineId, String reason) {
        String sql = "update app_line set app_line_status = '반려', "
                   + "app_line_date = systimestamp , "
                   + "app_line_rej = ? "
                   + "where app_line_id = ?";
        jdbcTemplate.update(sql, reason, appLineId);
    }

    // 다음 순서 결재자 진행중으로 변경
    public void activateNext(int appId, int nextOrder) {
        String sql = "update app_line set app_line_status = '진행중' "
                   + "where app_id = ? and app_line_order = ?";
        jdbcTemplate.update(sql, appId, nextOrder);
    }
}