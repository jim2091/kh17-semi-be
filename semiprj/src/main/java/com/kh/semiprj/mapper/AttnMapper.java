package com.kh.semiprj.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import com.kh.semiprj.dto.AttnDto;

@Component
public class AttnMapper implements RowMapper<AttnDto>{
    @Override
    public AttnDto mapRow(ResultSet rs, int rowNum) throws SQLException {
        AttnDto attnDto = new AttnDto();
        attnDto.setAttnId(rs.getLong("attn_id"));
        attnDto.setEmpNo(rs.getString("emp_no"));
        attnDto.setAttnWorkDate(rs.getTimestamp("attn_work_date"));
        attnDto.setAttnInTime(rs.getTimestamp("attn_in_time"));
        attnDto.setAttnOutTime(rs.getTimestamp("attn_out_time"));
        attnDto.setAttnWorkTime(rs.getInt("attn_work_time"));
        attnDto.setAttnStatus(rs.getString("attn_status"));
        attnDto.setAttnRecord(rs.getString("attn_record"));
        return attnDto;
    }
}