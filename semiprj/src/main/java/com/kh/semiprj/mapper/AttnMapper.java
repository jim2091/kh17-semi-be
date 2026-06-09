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
        
        // 기본 ATTN 테이블 매핑 (예외 안전장치 장착)
        try { attnDto.setAttnId(rs.getLong("ATTN_ID")); } catch(Exception e) {}
        try { attnDto.setEmpNo(rs.getString("EMP_NO")); } catch(Exception e) {}
        try { attnDto.setAttnWorkDate(rs.getTimestamp("ATTN_WORK_DATE")); } catch(Exception e) {}
        try { attnDto.setAttnInTime(rs.getTimestamp("ATTN_IN_TIME")); } catch(Exception e) {}
        try { attnDto.setAttnOutTime(rs.getTimestamp("ATTN_OUT_TIME")); } catch(Exception e) {}
        try { attnDto.setAttnWorkTime(rs.getInt("ATTN_WORK_TIME")); } catch(Exception e) {}
        try { attnDto.setAttnStatus(rs.getString("ATTN_STATUS")); } catch(Exception e) {}
        try { attnDto.setAttnRecord(rs.getString("ATTN_RECORD")); } catch(Exception e) {}
        
        // 조인 필드 컬럼명 매핑 처리 완료
        try { attnDto.setEmpName(rs.getString("EMP_NAME")); } catch (Exception e) {}
        try { attnDto.setDeptCode(rs.getString("EMP_DEPT")); } catch (Exception e) {}
        try { attnDto.setPositionCode(rs.getString("EMP_POSITION")); } catch (Exception e) {}
        
        return attnDto;
    }
}