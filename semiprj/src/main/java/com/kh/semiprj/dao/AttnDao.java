package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.mapper.AttnMapper;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AttnDao {

    private final JdbcTemplate jdbcTemplate;
    private final AttnMapper attnMapper;

    public List<AttnDto> selectList() {
        String sql = """
                select *
                from attn
                order by attn_id asc
                """;

        return jdbcTemplate.query(sql, attnMapper);
    }

    public AttnDto selectOne(long attnId) {
        String sql = """
                select *
                from attn
                where attn_id = ?
                """;

        List<AttnDto> list = jdbcTemplate.query(sql, attnMapper, attnId);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<AttnDto> selectByPeriod(int startDate, int endDate) {
        String sql = """
                select *
                from attn
                where attn_work_date between ? and ?
                order by attn_work_date asc
                """;

        return jdbcTemplate.query(sql, attnMapper, startDate, endDate);
    }
    public List<AttnDto> selectByDate(String attn_workDate) {

        String sql = """
            select *
            from attn
            where trunc(attn_work_date)
                  = to_date(?, 'yyyy-mm-dd')
            order by attn_id
        """;

        return jdbcTemplate.query(sql, attnMapper, attn_workDate);
    }
}