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
        
        // ResultSet에서 컬럼 존재 여부를 확인하고 매핑하는 것이 가장 안전합니다.
        try { attnDto.setAttnId(rs.getLong("ATTN_ID")); } catch(Exception e) {}
        try { attnDto.setEmpNo(rs.getString("EMP_NO")); } catch(Exception e) {}
        try { attnDto.setAttnWorkDate(rs.getTimestamp("ATTN_WORK_DATE")); } catch(Exception e) {}
        try { attnDto.setAttnInTime(rs.getTimestamp("ATTN_IN_TIME")); } catch(Exception e) {}
        try { attnDto.setAttnOutTime(rs.getTimestamp("ATTN_OUT_TIME")); } catch(Exception e) {}
        try { attnDto.setAttnWorkTime(rs.getInt("ATTN_WORK_TIME")); } catch(Exception e) {}
        try { attnDto.setAttnStatus(rs.getString("ATTN_STATUS")); } catch(Exception e) {}
        try { attnDto.setAttnRecord(rs.getString("ATTN_RECORD")); } catch(Exception e) {}
        
        // 조인 필드 (이미지 스키마 반영)
        try { attnDto.setEmpName(rs.getString("EMP_NAME")); } catch (Exception e) {}
        try { attnDto.setDeptCode(rs.getString("EMP_DEPT")); } catch (Exception e) {}
        try { attnDto.setPositionCode(rs.getString("EMP_POSITION")); } catch (Exception e) {}
        
        return attnDto;
    }
}