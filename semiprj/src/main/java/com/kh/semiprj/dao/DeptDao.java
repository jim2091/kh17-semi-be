	package com.kh.semiprj.dao;
	
	import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.DeptCategoryDto;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.mapper.DeptCategoryMapper;
import com.kh.semiprj.mapper.DeptMapper;
import com.kh.semiprj.mapper.EmpMapper;
import com.kh.semiprj.vo.PageVO;
	
	
	
	@Repository
	public class DeptDao {
	
	    @Autowired
	    private JdbcTemplate jdbcTemplate;
	    @Autowired
	    private DeptMapper deptMapper;
	    @Autowired
	    private DeptCategoryMapper deptCategoryMapper;
	    @Autowired
	    private EmpMapper empMapper;
	    
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
	        
	        if (pageVO.getColumn().equals("dept_category_name")) {
	            String sql = "select * from ("
	                       + " select rownum rn, TMP.* from ("
			                       + " select * from dept "
				                       + " where dept_category in ("
					                       + " select dept_category_no from dept_category_id "
					                       + " where instr(dept_category_name, ?) > 0"
				                       + " ) "
				                       + " order by dept_id asc"
		                       + " ) TMP"
	                       + ") where rn between ? and ?";
	            
	            Object[] params = {pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};
	            return jdbcTemplate.query(sql, deptMapper, params);
	        } 
	        
	        else {
	            String sql = "select * from ("
	                       + " select rownum rn, TMP.* from ("
			                       + " select * from dept "
			                       + " where instr(" + pageVO.getColumn() + ", ?) > 0 "
			                       + " order by dept_id asc"
		                       + " ) TMP"
	                       + ") where rn between ? and ?";
	            
	            Object[] params = {pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum()};
	            return jdbcTemplate.query(sql, deptMapper, params);
	        }
	    }
	    
	    // 등록을 위한 시퀀스 번호 생성
	    public int sequence() {
	        String sql = "select dept_seq.nextval from dual";
	        return jdbcTemplate.queryForObject(sql, int.class);
	    }
	    
	    // 등록
	    public void insert(DeptDto deptDto) {
	        String sql = "insert into dept( "
	                + "dept_id, dept_category, dept_head_id, "
	                + "dept_name, dept_content " 
	                + ") values (?, ?, ?, ?, ?)";
	        
	        Object[] params = {
	        	deptDto.getDeptId(), deptDto.getDeptCategory(),
	            deptDto.getDeptHeadId(), deptDto.getDeptName(),
	            deptDto.getDeptContent()
	        };
	        jdbcTemplate.update(sql, params); 
	    }
	    
	    // 상세조회
	    public DeptDto selectOne(int deptId) {
	        String sql = "select * from dept where dept_id = ?";
	        Object[] params = { deptId };
	        List<DeptDto> list = jdbcTemplate.query(sql, deptMapper, params);
	        return list.isEmpty() ? null : list.get(0);
	    }
		//수정
		public boolean update(DeptDto deptDto) {
			String sql = "update dept "
						+ "set dept_category=?, dept_name=?,"
							+ "dept_head_id=?, dept_content=?"
						+ "where dept_id=?";
			Object[] params = {
				deptDto.getDeptCategory(),deptDto.getDeptName(),
				deptDto.getDeptHeadId(),deptDto.getDeptContent(),
				deptDto.getDeptId()
			};
			return jdbcTemplate.update(sql, params) > 0;
		}
		//삭제 메소드
		public boolean delete(int deptId) {
			String sql = "delete dept where dept_id = ?";
			Object[] params = { deptId };
			return jdbcTemplate.update(sql, params) > 0;
		}
	    
	    //페이징
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
	    
	    //활성화 토글 구현하는 메소드
	    public boolean updateDeptYn(DeptDto deptDto) {
	    	String sql = "update dept set dept_yn=? where dept_id=?";
	    	Object[] params = {deptDto.getDeptYn(), deptDto.getDeptId()};
	    	return jdbcTemplate.update(sql,params)>0;
	    }
	    
	    //부서 카테고리 목록보여주는 메소드
	    public List<DeptCategoryDto> selectCategoryList(){
			String sql = "select * from dept_category_id "
					+ "order by dept_category_no asc";
			return jdbcTemplate.query(sql, deptCategoryMapper);
		}
	    
	    //부서 이름 중복확인 메소드
	    public DeptDto selectOneByDeptName(String deptName) {
	    	String sql = "select * from dept where dept_name=?";
	    	Object[]params = {deptName};
	    	List<DeptDto>list = jdbcTemplate.query(sql,deptMapper,params);	    	
	    	return list.isEmpty() ? null : list.get(0);
	    }
	    
	}