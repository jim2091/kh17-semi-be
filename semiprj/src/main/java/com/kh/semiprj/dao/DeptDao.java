	package com.kh.semiprj.dao;
	
	import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.dto.EmpDto;
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
	    private EmpMapper empMapper;
	    
	    
	    //목록 및 검색 (페이징처리)
	    public List<DeptDto> selectList(PageVO pageVO) {
	        
	        
	        if (pageVO.isList()) {
	            String sql = "select * from ("
	            				+ "select rownum rn, TMP.* from ("
	            					+ "select * from dept_profile_view order by dept_id asc"
	            				+ ")TMP"
	            			+ ") where rn between ? and ?";
	            
	            Object[] params = { pageVO.getBeginRownum(), pageVO.getEndRownum() };
	            return jdbcTemplate.query(sql, deptMapper, params);
	        } 
	        else {
	            String sql = "select * from ("
	                       + " select rownum rn, TMP.* from ("
			                       + " select * from dept_profile_view "
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
	    
	    // 등록 메소드
	    public void insert(DeptDto deptDto) {
	        String sql = "insert into dept( "
	                + "dept_id, parent_dept_id, dept_head_id, "
	                + "dept_name, dept_content " 
	                + ") values (?, ?, ?, ?, ?)";
	        
	        Object[] params = {
	        	deptDto.getDeptId(), deptDto.getParentDeptId(),
	            deptDto.getDeptHeadId(), deptDto.getDeptName(),
	            deptDto.getDeptContent()
	        };
	        jdbcTemplate.update(sql, params); 
	    }
	    
	    // 상세조회 메소드
	    public DeptDto selectOne(int deptId) {
	        String sql = "select * from dept_profile_view where dept_id = ?";
	        Object[] params = { deptId };
	        List<DeptDto> list = jdbcTemplate.query(sql, deptMapper, params);
	        return list.isEmpty() ? null : list.get(0);
	    }
		//수정 메소두
		public boolean update(DeptDto deptDto) {
			String sql = "update dept "
						+ "set parent_dept_id=?, dept_name=?,"
							+ "dept_head_id=?, dept_content=? "
						+ "where dept_id=?";
			Object[] params = {
				deptDto.getParentDeptId(),deptDto.getDeptName(),
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
	    
	    //페이징 메소드
	    public int count(PageVO pageVO) {
	        if (pageVO.isList()) { // 일반 목록일 때의 전체 개수
	            String sql = "select count(*) from dept";
	            return jdbcTemplate.queryForObject(sql, int.class);
	        }
	        
	        // 검색일 때의 결과 개수 세기
	        Set<String> allowList = Set.of("dept_id", "parent_dept_id", "dept_name","parent_dept_name");
	        if (allowList.contains(pageVO.getColumn()) == false) {
	            return 0;
	        }        
	        String sql = "select count(*) from dept_profile_view where instr(" + pageVO.getColumn() + ", ?) > 0";
	        Object[] params = { pageVO.getKeyword() };
	        return jdbcTemplate.queryForObject(sql, int.class, params);
	    }
	    
	    //활성화 토글 구현하는 메소드
	    public boolean updateDeptYn(DeptDto deptDto) {
	    	String sql = "update dept set dept_yn=? where dept_id=?";
	    	
	    	Object[] params = {deptDto.getDeptYn(), deptDto.getDeptId()};
	    	
	    	return jdbcTemplate.update(sql,params)>0;
	    }
	    
	    //부서 이름 중복 메소드
	    public DeptDto selectOneByDeptName(String deptName) {
	    	String sql = "select * from dept_profile_view where dept_name=?";
	    	Object[]params = {deptName};
	    	List<DeptDto>list = jdbcTemplate.query(sql,deptMapper,params);	    	
	    	return list.isEmpty() ? null : list.get(0);
	    }
	    
	    //해당 부서에 소속된 사원 목록 조회 메소드
	    public List<EmpDto> selectListByDept(int deptId) {
	        String sql = "select * from emp "
	        		+ "where emp_no in (select emp_no from dept_emp where dept_id = ?) "
	        		+ "order by emp_name asc";
	        
	        Object[] params = { deptId };
	        
	        return jdbcTemplate.query(sql, empMapper, params);
	    }
	    
	    //조직도 목록조회 메소드(전체조회) 페이징처리한 리스트는 같이 못씀
	    public List<DeptDto> selectTreeList() {
	    	String sql = "select * from dept_profile_view order by dept_id asc";
	        return jdbcTemplate.query(sql, deptMapper);
	    }
	    
	    //부서명 중복체크 메소드
	    public boolean checkDuplicateForEdit(String deptName, int deptId) {
	        // 내 부서 번호(dept_id)가 아니면서, 입력한 부서명과 일치하는 행의 개수 카운트
	        String sql = "select count(*) from dept where dept_id != ? and dept_name = ?";
	        Object[] params = { deptId, deptName };
	        int count = jdbcTemplate.queryForObject(sql, int.class, params);
	        
	        return count == 0; // 0개면 중복 없으므로 true(사용 가능), 1개 이상이면 false(중복)
	    }
	    
	    //하위 부서 찾는 메소드
	    public List<DeptDto> selectChildDept(int parentDeptId) {
	    	String sql = "select * from dept_profile_view where parent_dept_id = ? order by dept_id asc";
	    	Object[]params = {parentDeptId};
	    	
	    	return jdbcTemplate.query(sql, deptMapper,params);
	    }
	    
	    //상위부서에 속한 부서의 사원 목록 메소드
	    public List<EmpDto> selectListByDeptRecursive(int deptId) {
	        String sql = "SELECT DISTINCT E.* " + 
	                     "FROM emp E " +
	                     "INNER JOIN dept_emp DE ON E.emp_no = DE.emp_no " +
	                     "WHERE DE.dept_id IN (" +
	                     "    SELECT dept_id FROM dept " +
	                     "    START WITH dept_id = ? " + 
	                     "    CONNECT BY NOCYCLE  PRIOR dept_id = parent_dept_id" +
	                     ") " +
	                     "ORDER BY E.emp_name ASC"; 
	                     
	        return jdbcTemplate.query(sql, empMapper, deptId);
	    }
	    
	    // 수정 화면용 - 자기 자신 + 하위 부서 제외한 목록(순환되는거 막는 메소드)
	    public List<DeptDto> selectAvailableParents(int deptId) {
	        String sql = "SELECT * FROM dept_profile_view "
	                   + "WHERE dept_id NOT IN ( "
	                   + "    SELECT dept_id FROM dept "
	                   + "    START WITH dept_id = ? "
	                   + "    CONNECT BY NOCYCLE PRIOR dept_id = parent_dept_id "
	                   + ") "
	                   + "ORDER BY dept_id ASC";
	        
	        return jdbcTemplate.query(sql, deptMapper, deptId);
	    }
	    
	}