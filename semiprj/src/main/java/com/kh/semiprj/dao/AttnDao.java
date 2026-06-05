package com.kh.semiprj.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
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

    // 직원용 메서드 (기존 유지)
    public Map<String, Object> selectVacationInfo(String empNo) {
        String sql = "SELECT vac_tot, vac_cnt FROM vac_info WHERE emp_no = ?";
        try { return jdbcTemplate.queryForMap(sql, empNo); } catch (Exception e) { return Map.of("VAC_TOT", 0, "VAC_CNT", 0); }
    }

    public List<AttnDto> selectListByMonth(AttnDto attnDto, PageVO pageVO) {
        String sql = "SELECT * FROM (SELECT ROWNUM RN, TMP.* FROM (SELECT * FROM attn WHERE emp_no = ? AND TO_CHAR(attn_work_date, 'YYYY') = ? AND TO_CHAR(attn_work_date, 'MM') = ? ORDER BY attn_work_date DESC) TMP) WHERE RN BETWEEN ? AND ?";
        return jdbcTemplate.query(sql, attnMapper, attnDto.getEmpNo(), attnDto.getYear(), attnDto.getMonth(), pageVO.getBeginRownum(), pageVO.getEndRownum());
    }

    public int countAttendance(AttnDto attnDto) {
        String sql = "SELECT COUNT(*) FROM attn WHERE emp_no = ? AND TO_CHAR(attn_work_date, 'YYYY') = ? AND TO_CHAR(attn_work_date, 'MM') = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, attnDto.getEmpNo(), attnDto.getYear(), attnDto.getMonth());
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

    // 관리자용 메서드 (스키마 반영 완료)
    public List<AttnDto> selectAdminList(AttnDto searchDto, PageVO pageVO) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM (SELECT ROWNUM AS RN, T.* FROM ( ");
        sql.append("    SELECT A.ATTN_ID, A.EMP_NO, A.ATTN_WORK_DATE, A.ATTN_WORK_TIME, A.ATTN_STATUS, ");
        sql.append("           E.EMP_NAME, E.EMP_DEPT, E.EMP_POSITION ");
        sql.append("    FROM ATTN A JOIN EMP E ON A.EMP_NO = E.EMP_NO WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        if(searchDto.getDeptCode() != null && !searchDto.getDeptCode().isEmpty()) { sql.append(" AND E.EMP_DEPT = ? "); params.add(searchDto.getDeptCode()); }
        if(searchDto.getPositionCode() != null && !searchDto.getPositionCode().isEmpty()) { sql.append(" AND E.EMP_POSITION = ? "); params.add(searchDto.getPositionCode()); }
        if(searchDto.getEmpName() != null && !searchDto.getEmpName().isEmpty()) { sql.append(" AND E.EMP_NAME LIKE '%' || ? || '%' "); params.add(searchDto.getEmpName()); }
        
        sql.append("    ORDER BY A.ATTN_WORK_DATE DESC ) T ) WHERE RN BETWEEN ? AND ?");
        params.add(pageVO.getBeginRownum());
        params.add(pageVO.getEndRownum());
        return jdbcTemplate.query(sql.toString(), attnMapper, params.toArray());
    }

    public int countAdminAttendance(AttnDto searchDto) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ATTN A JOIN EMP E ON A.EMP_NO = E.EMP_NO WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if(searchDto.getDeptCode() != null && !searchDto.getDeptCode().isEmpty()) { sql.append(" AND E.EMP_DEPT = ? "); params.add(searchDto.getDeptCode()); }
        if(searchDto.getPositionCode() != null && !searchDto.getPositionCode().isEmpty()) { sql.append(" AND E.EMP_POSITION = ? "); params.add(searchDto.getPositionCode()); }
        if(searchDto.getEmpName() != null && !searchDto.getEmpName().isEmpty()) { sql.append(" AND E.EMP_NAME LIKE '%' || ? || '%' "); params.add(searchDto.getEmpName()); }
        return jdbcTemplate.queryForObject(sql.toString(), Integer.class, params.toArray());
    }
}