package com.kh.semiprj.dao;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.mapper.AttnMapper;
import com.kh.semiprj.vo.PageVO;

@Repository
public class AttnDao {
    @Autowired private JdbcTemplate jdbcTemplate;
    @Autowired private AttnMapper attnMapper;

    // --- 기존 메서드 ---
    public List<Map<String, String>> selectAllEmployees() {
        String sql = "SELECT emp_no, emp_name FROM emp ORDER BY emp_name ASC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Map<String, String> map = new HashMap<>();
            map.put("empNo", rs.getString("emp_no"));
            map.put("empName", rs.getString("emp_name"));
            return map;
        });
    }

    public Map<String, Object> selectVacationInfo(String empNo) {
        String sql = "SELECT vac_tot, vac_cnt FROM vac_info WHERE emp_no = ?";
        try { return jdbcTemplate.queryForMap(sql, empNo); } catch (Exception e) { return Map.of("VAC_TOT", 0, "VAC_CNT", 0); }
    }

    // [추가] 관리자용 전체 연차 조회
    public List<Map<String, Object>> selectAllVacations() {
        return jdbcTemplate.queryForList("SELECT emp_no, vac_tot, vac_cnt FROM vac_info");
    }

    public List<AttnDto> selectListByMonth(AttnDto attnDto, PageVO pageVO) {
        String sql = "SELECT * FROM (SELECT ROWNUM RN, TMP.* FROM (SELECT * FROM attn WHERE emp_no = ? AND TO_CHAR(attn_work_date, 'YYYY') = ? AND TO_CHAR(attn_work_date, 'MM') = ? ORDER BY attn_work_date DESC) TMP) WHERE RN BETWEEN ? AND ?";
        return jdbcTemplate.query(sql, attnMapper, attnDto.getEmpNo(), attnDto.getYear(), attnDto.getMonth(), pageVO.getBeginRownum(), pageVO.getEndRownum());
    }

    public int countAttendance(AttnDto attnDto) {
        String sql = "SELECT COUNT(*) FROM attn WHERE emp_no = ? AND TO_CHAR(attn_work_date, 'YYYY') = ? AND TO_CHAR(attn_work_date, 'MM') = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, attnDto.getEmpNo(), attnDto.getYear(), attnDto.getMonth());
    }

    // [추가] 관리자 기본 목록 조회 메서드
    public List<AttnDto> selectAdminList(AttnDto s, PageVO p) {
        String sql = "SELECT * FROM (SELECT ROWNUM RN, T.* FROM (SELECT * FROM ATTN ORDER BY ATTN_WORK_DATE DESC) T) WHERE RN BETWEEN ? AND ?";
        return jdbcTemplate.query(sql, attnMapper, p.getBeginRownum(), p.getEndRownum());
    }

    // [추가] 관리자 카운트 메서드
    public int countAdminAttendance(AttnDto s) {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM ATTN", Integer.class);
    }

    public int getWorkTimeSum(String empNo, String startDate, String endDate) {
        String sql = "SELECT NVL(SUM(attn_work_time), 0) FROM attn WHERE emp_no = ? AND attn_work_date >= TO_DATE(?, 'YYYY-MM-DD') AND attn_work_date <= TO_DATE(?, 'YYYY-MM-DD')";
        return jdbcTemplate.queryForObject(sql, Integer.class, empNo, startDate, endDate);
    }

    public void updateStatusToAbsent() {
        String sql = "UPDATE attn SET attn_status = '결근' WHERE TRUNC(attn_work_date) = TRUNC(SYSDATE - 1) AND attn_in_time IS NOT NULL AND attn_out_time IS NULL";
        jdbcTemplate.update(sql);
    }

    public List<String> getEmployeesWithoutOutTime() {
        String sql = "SELECT emp_no FROM attn WHERE TRUNC(attn_work_date) = TRUNC(SYSDATE) AND attn_out_time IS NULL";
        return jdbcTemplate.queryForList(sql, String.class);
    }

    public List<AttnDto> selectAdminListCustom(AttnDto searchDto, PageVO pageVO, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT * FROM (SELECT ROWNUM AS RN, T.* FROM ( ");
        sql.append(" SELECT A.ATTN_ID, A.EMP_NO, A.ATTN_WORK_DATE, A.ATTN_WORK_TIME, A.ATTN_STATUS, A.ATTN_IN_TIME, A.ATTN_OUT_TIME, E.EMP_NAME, E.EMP_DEPT, E.EMP_POSITION ");
        sql.append(" FROM ATTN A JOIN EMP E ON A.EMP_NO = E.EMP_NO WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        if(searchDto.getDeptCode() != null && !searchDto.getDeptCode().isEmpty()) { sql.append(" AND E.EMP_DEPT = ? "); params.add(searchDto.getDeptCode()); }
        if(searchDto.getPositionCode() != null && !searchDto.getPositionCode().isEmpty()) { sql.append(" AND E.EMP_POSITION = ? "); params.add(searchDto.getPositionCode()); }
        if(searchDto.getEmpName() != null && !searchDto.getEmpName().isEmpty()) { sql.append(" AND E.EMP_NAME = ? "); params.add(searchDto.getEmpName()); }
        if(startDate != null && !startDate.isEmpty()) { sql.append(" AND A.ATTN_WORK_DATE >= TO_DATE(?, 'YYYY-MM-DD') "); params.add(startDate); }
        if(endDate != null && !endDate.isEmpty()) { sql.append(" AND A.ATTN_WORK_DATE <= TO_DATE(?, 'YYYY-MM-DD') "); params.add(endDate); }

        sql.append(" ORDER BY A.ATTN_WORK_DATE DESC ) T ) WHERE RN BETWEEN ? AND ?");
        params.add(pageVO.getBeginRownum());
        params.add(pageVO.getEndRownum());
        return jdbcTemplate.query(sql.toString(), attnMapper, params.toArray());
    }

    public int countAdminAttendanceCustom(AttnDto searchDto, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ATTN A JOIN EMP E ON A.EMP_NO = E.EMP_NO WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if(searchDto.getDeptCode() != null && !searchDto.getDeptCode().isEmpty()) { sql.append(" AND E.EMP_DEPT = ? "); params.add(searchDto.getDeptCode()); }
        if(searchDto.getPositionCode() != null && !searchDto.getPositionCode().isEmpty()) { sql.append(" AND E.EMP_POSITION = ? "); params.add(searchDto.getPositionCode()); }
        if(searchDto.getEmpName() != null && !searchDto.getEmpName().isEmpty()) { sql.append(" AND E.EMP_NAME = ? "); params.add(searchDto.getEmpName()); }
        if(startDate != null && !startDate.isEmpty()) { sql.append(" AND A.ATTN_WORK_DATE >= TO_DATE(?, 'YYYY-MM-DD') "); params.add(startDate); }
        if(endDate != null && !endDate.isEmpty()) { sql.append(" AND A.ATTN_WORK_DATE <= TO_DATE(?, 'YYYY-MM-DD') "); params.add(endDate); }
        return jdbcTemplate.queryForObject(sql.toString(), Integer.class, params.toArray());
    }

    public List<Map<String, Object>> selectWorkSystemList() {
        return jdbcTemplate.queryForList("SELECT work_code, work_name, max_hours, UPPER(is_active) AS is_active FROM work_system ORDER BY work_code DESC");
    }

    public int selectActiveMaxHours() {
        try { return jdbcTemplate.queryForObject("SELECT max_hours FROM work_system WHERE UPPER(is_active) = 'Y'", Integer.class); } catch (Exception e) { return 52; }
    }

    public void updateAllWorkSystemDisable() { jdbcTemplate.update("UPDATE work_system SET is_active = 'N'"); }
    public void updateWorkSystemEnable(String workCode) { jdbcTemplate.update("UPDATE work_system SET is_active = 'Y' WHERE LOWER(work_code) = LOWER(?)", workCode); }
}