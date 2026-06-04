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
}