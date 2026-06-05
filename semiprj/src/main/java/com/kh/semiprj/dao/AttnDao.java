package com.kh.semiprj.dao;

import java.util.List;
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

    public List<AttnDto> selectListByMonth(AttnDto attnDto, PageVO pageVO) {
        String sql = "SELECT * FROM (" +
                     "    SELECT ROWNUM RN, TMP.* FROM (" +
                     "        SELECT * FROM attn WHERE emp_no = ? " +
                     "        AND TO_CHAR(attn_work_date, 'YYYY') = ? " +
                     "        AND TO_CHAR(attn_work_date, 'MM') = ? " +
                     "        ORDER BY attn_work_date DESC" +
                     "    ) TMP " +
                     ") WHERE RN BETWEEN ? AND ?";
        
        return jdbcTemplate.query(sql, attnMapper, 
            attnDto.getEmpNo(), attnDto.getYear(), attnDto.getMonth(), 
            pageVO.getBeginRownum(), pageVO.getEndRownum());
    }

    public int countAttendance(AttnDto attnDto) {
        String sql = "SELECT COUNT(*) FROM attn WHERE emp_no = ? " +
                     "AND TO_CHAR(attn_work_date, 'YYYY') = ? " +
                     "AND TO_CHAR(attn_work_date, 'MM') = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, 
            attnDto.getEmpNo(), attnDto.getYear(), attnDto.getMonth());
    }

    public int getWorkTimeSum(String empNo, String startDate, String endDate) {
        String sql = "SELECT NVL(SUM(attn_work_time), 0) FROM attn " +
                     "WHERE emp_no = ? " +
                     "AND attn_work_date >= TO_DATE(?, 'YYYY-MM-DD') " +
                     "AND attn_work_date <= TO_DATE(?, 'YYYY-MM-DD')";
        return jdbcTemplate.queryForObject(sql, Integer.class, empNo, startDate, endDate);
    }
    
    // 출근은 했으나 퇴근 기록이 없는 경우 '결근' 처리
    public void updateStatusToAbsent() {
        String sql = "UPDATE attn SET attn_status = '결근' " +
                     "WHERE TRUNC(attn_work_date) = TRUNC(SYSDATE - 1) " +
                     "AND attn_in_time IS NOT NULL " +
                     "AND attn_out_time IS NULL";
        jdbcTemplate.update(sql);
    }

    public List<String> getEmployeesWithoutOutTime() {
        String sql = "SELECT emp_no FROM attn " +
                     "WHERE TRUNC(attn_work_date) = TRUNC(SYSDATE) " +
                     "AND attn_out_time IS NULL";
        return jdbcTemplate.queryForList(sql, String.class);
    }
}