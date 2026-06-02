package com.kh.semiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.mapper.DeptMapper;
import com.kh.spring09.vo.PageVO;

@Repository
public class DeptDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private DeptMapper deptMapper;
    
    //목록
    public List<DeptDto> selectList(PageVO pageVO) {
        
        
        if (pageVO.isList()) {
            String sql = "select * from ("
                            + "select rownum rn, TMP.* from ("
                                + "select * from dept order by dept_id asc"
                            + ")TMP"
                        + ") where rn between ? and ?";
            
            
            Object[] params = { pageVO.getBeginRownum(), pageVO.getEndRownum() };
            return jdbcTemplate.query(sql, deptMapper, params);
        }
        
        //검색
        Set<String> allowList = Set.of("dept_id", "dept_category", "dept_name");
        if (allowList.contains(pageVO.getColumn()) == false) {
            return List.of();
        }
        
        String sql = "select * from ("
                        + "select rownum rn, TMP.* from ("
                            + "select * from dept "
                            + "where instr(" + pageVO.getColumn() + ", ?) > 0 "
                            + "order by dept_id asc"
                        + ")TMP"
                    + ") where rn between ? and ?";
        
        Object[] params = { 
            pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()
        };
        return jdbcTemplate.query(sql, deptMapper, params);
    }
    
    // 등록을 위한 시퀀스 번호 생성
    public int sequence() {
        String sql = "select dept_seq.nextval from dual";
        return jdbcTemplate.queryForObject(sql, int.class);
    }
    
    // 등록 메소드 완성
    public void insert(DeptDto deptDto) {
        String sql = "insert into dept( "
                + "dept_id, dept_category, dept_name " 
                + ") values (?, ?, ?)";
        
        Object[] params = {
            deptDto.getDeptId(),
            deptDto.getDeptCategory(),
            deptDto.getDeptName()
        };
        jdbcTemplate.update(sql, params); 
    }
    
    // 상세조회 메소드
    public DeptDto selectOne(int deptId) {
        String sql = "select * from dept where dept_id = ?";
        Object[] params = { deptId };
        List<DeptDto> list = jdbcTemplate.query(sql, deptMapper, params);
        return list.isEmpty() ? null : list.get(0);
    }
    
    //페이징 메소드
    public int count(PageVO pageVO) {
        if (pageVO.isList()) { // 일반 목록일 때의 전체 개수
            String sql = "select count(*) from dept";
            return jdbcTemplate.queryForObject(sql, int.class);
        }
        
        // 검색일 때의 결과 개수 세기
        Set<String> allowList = Set.of("dept_id", "dept_category", "dept_name");
        if (allowList.contains(pageVO.getColumn()) == false) {
            return 0;
        }        
        String sql = "select count(*) from dept where instr(" + pageVO.getColumn() + ", ?) > 0";
        Object[] params = { pageVO.getKeyword() };
        return jdbcTemplate.queryForObject(sql, int.class, params);
    }
}