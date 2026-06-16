package com.kh.semiprj.dao;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.vo.PageVO;

@Repository
public class AttnDao {

    @Autowired 
    private JdbcTemplate jdbcTemplate;

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
        try { 
            return jdbcTemplate.queryForMap(sql, empNo); 
        } catch (Exception e) { 
            return Map.of("VAC_TOT", 0, "VAC_CNT", 0); 
        }
    }

    public List<Map<String, Object>> selectAllVacations() {
        return jdbcTemplate.queryForList("SELECT emp_no, vac_tot, vac_cnt FROM vac_info");
    }

    public List<AttnDto> getAttendanceList(AttnDto attnDto, PageVO pageVO) {
        String sql = "SELECT * FROM ( "
                   + "SELECT ROWNUM RN, TMP.* FROM ( "
                   + "SELECT "
                   + "  a.attn_id, a.emp_no, a.attn_work_date, a.attn_in_time, a.attn_out_time, a.attn_work_time, "
                   + "  CASE "
                   + "    WHEN EXISTS ( "
                   + "      SELECT 1 FROM vac_history vh "
                   + "      JOIN app main_app ON vh.app_id = main_app.app_id "
                   + "      WHERE main_app.app_req_id = a.emp_no "
                   + "        AND vh.vac_date = TO_CHAR(a.attn_work_date, 'MM/DD') "
                   + "    ) THEN '휴가' "
                   + "    ELSE a.attn_record "
                   + "  END AS v_record "
                   + "FROM attn a "
                   + "WHERE a.emp_no = ? "
                   + "  AND TO_CHAR(a.attn_work_date, 'YYYY') = ? "
                   + "  AND TO_CHAR(a.attn_work_date, 'MM') = ? "
                   + "ORDER BY a.attn_work_date DESC "
                   + ") TMP "
                   + ") WHERE RN BETWEEN ? AND ?";
        
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            AttnDto dto = new AttnDto();
            dto.setAttnId(rs.getLong("attn_id"));
            dto.setEmpNo(rs.getString("emp_no"));
            dto.setAttnWorkDate(rs.getTimestamp("attn_work_date"));
            dto.setAttnInTime(rs.getTimestamp("attn_in_time"));
            dto.setAttnOutTime(rs.getTimestamp("attn_out_time"));
            dto.setAttnWorkTime(rs.getDouble("attn_work_time"));
            dto.setAttnRecord(rs.getString("v_record")); 
            return dto;
        }, attnDto.getEmpNo(), attnDto.getYear(), attnDto.getMonth(), pageVO.getBeginRownum(), pageVO.getEndRownum());
    }

    public int countAttendance(AttnDto attnDto) {
        String sql = "SELECT COUNT(*) FROM attn WHERE emp_no = ? AND TO_CHAR(attn_work_date, 'YYYY') = ? AND TO_CHAR(attn_work_date, 'MM') = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, attnDto.getEmpNo(), attnDto.getYear(), attnDto.getMonth());
    }

    public List<AttnDto> selectAdminList(AttnDto s, PageVO p) {
        String sql = "SELECT * FROM (SELECT ROWNUM RN, T.* FROM (SELECT * FROM ATTN ORDER BY ATTN_WORK_DATE DESC) T) WHERE RN BETWEEN ? AND ?";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            AttnDto dto = new AttnDto();
            dto.setAttnId(rs.getLong("attn_id"));
            dto.setEmpNo(rs.getString("emp_no"));
            dto.setAttnWorkDate(rs.getTimestamp("attn_work_date"));
            dto.setAttnInTime(rs.getTimestamp("attn_in_time"));
            dto.setAttnOutTime(rs.getTimestamp("attn_out_time"));
            dto.setAttnWorkTime(rs.getDouble("attn_work_time"));
            dto.setAttnRecord(rs.getString("attn_record"));
            return dto;
        }, p.getBeginRownum(), p.getEndRownum());
    }

    public int countAdminAttendance(AttnDto s) {
        return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM ATTN", Integer.class);
    }

    public double getWorkTimeSum(String empNo, String startDate, String endDate) {
        String sql = "SELECT NVL(SUM(attn_work_time), 0) FROM attn WHERE emp_no = ? AND attn_work_date >= TO_DATE(?, 'YYYY-MM-DD') AND attn_work_date <= TO_DATE(?, 'YYYY-MM-DD')";
        return jdbcTemplate.queryForObject(sql, Double.class, empNo, startDate, endDate);
    }

    public void updateStatusToAbsent() {
        String sql = "UPDATE attn SET "
                   + "  attn_record = '결근' "
                   + "WHERE TRUNC(attn_work_date) = TRUNC(SYSDATE - 1) "
                   + "  AND attn_in_time IS NULL " 
                   + "  AND emp_no NOT IN ( "
                   + "      SELECT main_app.app_req_id FROM vac_history vh "
                   + "      JOIN app main_app ON vh.app_id = main_app.app_id "
                   + "      WHERE vh.vac_date = TO_CHAR(SYSDATE - 1, 'MM/DD') "
                   + "  )";
        jdbcTemplate.update(sql);
    }

    public List<String> getEmployeesWithoutOutTime() {
        String sql = "SELECT emp_no FROM attn WHERE TRUNC(attn_work_date) = TRUNC(SYSDATE) AND attn_out_time IS NULL";
        return jdbcTemplate.queryForList(sql, String.class);
    }

    public List<AttnDto> selectAdminListCustom(AttnDto searchDto, PageVO pageVO, String startDate, String endDate) {
        StringBuilder sql = new StringBuilder("SELECT * FROM (SELECT ROWNUM AS RN, T.* FROM ( ");
        sql.append(" SELECT A.ATTN_ID, A.EMP_NO, A.ATTN_WORK_DATE, A.ATTN_WORK_TIME, A.ATTN_IN_TIME, A.ATTN_OUT_TIME, E.EMP_NAME, E.EMP_DEPT, E.EMP_POSITION, A.ATTN_RECORD ");
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
        
        return jdbcTemplate.query(sql.toString(), (rs, rowNum) -> {
            AttnDto dto = new AttnDto();
            dto.setAttnId(rs.getLong("attn_id"));
            dto.setEmpNo(rs.getString("emp_no"));
            dto.setAttnWorkDate(rs.getTimestamp("attn_work_date"));
            dto.setAttnInTime(rs.getTimestamp("attn_in_time"));
            dto.setAttnOutTime(rs.getTimestamp("attn_out_time"));
            dto.setAttnWorkTime(rs.getDouble("attn_work_time"));
            dto.setAttnRecord(rs.getString("attn_record"));
            dto.setEmpName(rs.getString("emp_name"));
            dto.setDeptCode(rs.getString("emp_dept"));
            dto.setPositionCode(rs.getString("emp_position"));
            return dto;
        }, params.toArray());
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
        try { 
            return jdbcTemplate.queryForObject("SELECT max_hours FROM work_system WHERE UPPER(is_active) = 'Y'", Integer.class); 
        } catch (Exception e) { 
            return 52; 
        }
    }

    public void updateAllWorkSystemDisable() { jdbcTemplate.update("UPDATE work_system SET is_active = 'N'"); }
    
    public void updateWorkSystemEnable(String workCode) { jdbcTemplate.update("UPDATE work_system SET is_active = 'Y' WHERE LOWER(work_code) = LOWER(?)", workCode); }

    public void createTodayAttendance() {
        String sql = "INSERT INTO attn (attn_id, emp_no, attn_work_date, attn_record) "
                   + "SELECT attn_seq.nextval, e.emp_no, TRUNC(SYSDATE), "
                   + "       CASE "
                   + "           WHEN EXISTS ( "
                   + "               SELECT 1 FROM vac_history vh "
                   + "               JOIN app main_app ON vh.app_id = main_app.app_id "
                   + "               WHERE main_app.app_req_id = e.emp_no "
                   + "                 AND vh.vac_date = TO_CHAR(SYSDATE, 'MM/DD') "
                   + "           ) THEN '휴가' "
                   + "           ELSE '미확인' "
                   + "       END AS attn_record "
                   + "FROM emp e "
                   + "WHERE e.emp_use_yn = 'Y' " 
                   + "  AND NOT EXISTS ( "
                   + "      SELECT 1 FROM attn a "
                   + "      WHERE a.emp_no = e.emp_no AND TRUNC(a.attn_work_date) = TRUNC(SYSDATE) "
                   + "  )";
        jdbcTemplate.update(sql);
    }

    public void insertNewAttendance(AttnDto attnDto) {
        String sql = "INSERT INTO attn (attn_id, emp_no, attn_work_date, attn_in_time, attn_record) "
                   + "VALUES (attn_seq.nextval, ?, TRUNC(SYSDATE), SYSDATE, ?)";
        jdbcTemplate.update(sql, attnDto.getEmpNo(), attnDto.getAttnRecord());
    }

    public void updateCheckIn(AttnDto attnDto) {
        String sql = "UPDATE attn SET "
                   + "  attn_in_time = SYSDATE, "
                   + "  attn_record = ? "  
                   + "WHERE emp_no = ? AND TRUNC(attn_work_date) = TRUNC(SYSDATE)"; 
        jdbcTemplate.update(sql, attnDto.getAttnRecord(), attnDto.getEmpNo());
    }

    public void updateCheckOut(String empNo) {
        String sql = "UPDATE attn SET "
                   + "  attn_out_time = SYSDATE, "
                   + "  attn_work_time = CASE "
                   + "      WHEN TO_CHAR(SYSDATE, 'HH24MI') < '1200' THEN GREATEST(ROUND((SYSDATE - attn_in_time) * 24, 2), 0) "
                   + "      ELSE GREATEST(ROUND(((SYSDATE - attn_in_time) * 24) - 1, 2), 0) "
                   + "  END, "
                   + "  attn_record = CASE "
                   + "      WHEN CASE "
                   + "          WHEN TO_CHAR(SYSDATE, 'HH24MI') < '1200' THEN GREATEST(ROUND((SYSDATE - attn_in_time) * 24, 2), 0) "
                   + "          ELSE GREATEST(ROUND(((SYSDATE - attn_in_time) * 24) - 1, 2), 0) "
                   + "      END < 8.0 AND attn_record = '정상근무' THEN '조퇴' "
                   + "      ELSE attn_record "
                   + "  END "
                   + "WHERE emp_no = ? AND TRUNC(attn_work_date) = TRUNC(SYSDATE)";
        jdbcTemplate.update(sql, empNo);
    }

    // 💡 [핵심 추가] 서비스 레이어의 복합 분기 결과('지각-조퇴' 등)를 명확히 갱신하기 위한 전용 메서드
    public void updateLeftEarlyStatus(String empNo, String recordStatus) {
        String sql = "UPDATE attn SET attn_record = ? WHERE emp_no = ? AND TRUNC(attn_work_date) = TRUNC(SYSDATE)";
        jdbcTemplate.update(sql, recordStatus, empNo);
    }

    public Map<String, Object> selectTodayAttnDetails(String empNo) {
        String sql = "SELECT ATTN_RECORD, TO_CHAR(ATTN_IN_TIME, 'HH24:MI') AS IN_TIME, TO_CHAR(ATTN_OUT_TIME, 'HH24:MI') AS OUT_TIME "
                   + "FROM ATTN WHERE EMP_NO = ? AND TRUNC(ATTN_WORK_DATE) = TRUNC(SYSDATE) AND ROWNUM = 1";
        try {
            return jdbcTemplate.queryForMap(sql, empNo);
        } catch (Exception e) {
            return Collections.emptyMap();
        }
    }

    public void deleteAttendanceByEmpNo(String empNo) {
        String sql = "DELETE FROM attn WHERE emp_no = ? AND TRUNC(attn_work_date) = TRUNC(SYSDATE)";
        jdbcTemplate.update(sql, empNo);
    }
}