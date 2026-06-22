package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.AppLineDto;
import com.kh.semiprj.mapper.AppLineMapper;
import com.kh.semiprj.vo.PageVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AppLineDao {
	
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private AppLineMapper appLineMapper;
    
    
    //결재자 등록 
    public void insert(AppLineDto appLineDto) {
        String sql = "insert into app_line (app_line_id, app_id, app_app_id, "
                   + "app_line_order, app_line_type, app_line_status) "
                   + "values (app_line_seq.nextval, ?, ?, ?, ?, '대기')"; // ← 시퀀스로!
        Object[] params = {
            appLineDto.getAppId(),
            appLineDto.getAppAppId(),
            appLineDto.getAppLineOrder(),
            appLineDto.getAppLineType()
        };
        jdbcTemplate.update(sql, params);
    }
    
    public void insertAppr(AppLineDto appLineDto) {
        String sql = "insert into app_line "
                   + "(app_line_id, app_id, app_app_id, app_line_order, app_line_type, app_line_status) "
                   + "values(app_line_seq.nextval, ?, ?, ?, ?, ?)"; 
        Object[] params = {
            appLineDto.getAppId(),          
            appLineDto.getAppAppId(),        
            appLineDto.getAppLineOrder(),   
            appLineDto.getAppLineType(),     
            appLineDto.getAppLineStatus()    
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
    
    
 // ===== 💡 [기존 보존] 서비스 레이어의 에러를 방지하기 위해 원본 메서드는 그대로 유지 =====
    public List<AppLineDto> selectMyApprList(String empNo) {
        String sql = "select l.*, a.app_title, a.app_type, a.app_date, e.emp_name "
                   + "from app_line l "
                   + "join app a on l.app_id = a.app_id "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where l.app_app_id = ? "
                   + "order by l.app_line_id desc";
        Object[] params = { empNo };
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AppLineDto.class), params);
    }

    // ===== 💡 [신설 1] PageVO 규격 연동 결재 문서함 필터링 적용 총 개수 카운트 =====
    public int countMyApprListByFilter(String empNo, String searchAppType, String searchAppStatus) {
        String sql = "select count(*) from app_line l "
                   + "join app a on l.app_id = a.app_id "
                   + "where l.app_app_id = ? "
                   + "and (? is null or a.app_type = ?) "
                   + "and (? is null or l.app_line_status = ?) ";
                   
        Object[] params = { empNo, searchAppType, searchAppType, searchAppStatus, searchAppStatus };
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, params);
        
        return count != null ? count : 0;
    }

    // ===== 💡 [신설 2] 선배님의 PageVO 변수(getBeginRownum, getEndRownum) 규격 맞춤형 쿼리 =====
    public List<AppLineDto> selectMyApprListByFilter(PageVO pageVO, String empNo, String searchAppType, String searchAppStatus) {
        String sql = "select * from ("
                   + "    select rownum rn, TMP.* from ("
                   + "        select l.*, a.app_title, a.app_type, a.app_date, e.emp_name "
                   + "        from app_line l "
                   + "        join app a on l.app_id = a.app_id "
                   + "        join emp e on a.app_req_id = e.emp_no "
                   + "        where l.app_app_id = ? "
                   + "        and (? is null or a.app_type = ?) "
                   + "        and (? is null or l.app_line_status = ?) "
                   + "        order by l.app_line_id desc"
                   + "    ) TMP"
                   + ") where rn between ? and ? ";
                   
        Object[] params = { 
            empNo, 
            searchAppType, searchAppType, 
            searchAppStatus, searchAppStatus, 
            pageVO.getBeginRownum(), // 💡 선배님의 VO 내부 메서드명으로 정밀 일치
            pageVO.getEndRownum()    // 💡 선배님의 VO 내부 메서드명으로 정밀 일치
        };
        
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(AppLineDto.class), params);
    }


    // 다음 순서 결재자 진행중으로 변경
    public void activateNext(int appId, int nextOrder) {
        String sql = "update app_line set app_line_status = '진행중' "
                   + "where app_id = ? and app_line_order = ?";
        jdbcTemplate.update(sql, appId, nextOrder);
    }
    
    
 // 단건 조회 (본인 확인용)
    public AppLineDto selectOne(int appLineId) {
        String sql = "select * from app_line where app_line_id = ?";
        List<AppLineDto> list = jdbcTemplate.query(sql, appLineMapper, appLineId);
        return list.isEmpty() ? null : list.get(0);
    }

    public void approve(int appLineId) {
        String sql = "UPDATE app_line " +
                     "SET app_line_status = '완료', " +
                     "    app_line_date = SYSTIMESTAMP " +
                     "WHERE app_line_id = ?";
                     
        jdbcTemplate.update(sql, appLineId);
    }

    // 다음 결재자 진행중으로 변경 (변경된 행 수 반환)
    public int updateNextApprover(int appId, int currentOrder) {
        String sql = "update app_line set app_line_status = '진행중' "
                   + "where app_id = ? and app_line_order = ?";
        return jdbcTemplate.update(sql, appId, currentOrder + 1);
    }

    public void reject(int appLineId, String reason) {
        String sql = "update app_line set app_line_status = '반려', "
                   + "app_line_date = to_char(sysdate, 'YYYY-MM-DD'), " // ← 동일하게 수정
                   + "app_line_rej = ? "
                   + "where app_line_id = ?";
        jdbcTemplate.update(sql, reason, appLineId);
    }
    
    
}