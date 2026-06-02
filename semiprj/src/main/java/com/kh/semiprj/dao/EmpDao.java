package com.kh.semiprj.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.mapper.EmpMapper;

@Repository
public class EmpDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private EmpMapper empMapper;
	
	private Set<String> allowColumns = Set.of( 
			"emp_no", "emp_id", "emp_dept", "emp_position", "emp_name", "emp_use_yn"
	);
	
	public EmpDto selectOne(String empId) {
		String sql = "select * from emp where emp_id = ?";
		Object[] params = { empId };
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public EmpDto selectOneByDetail(String empNo) {
		String sql = "select * from emp where emp_no = ?";
		Object[] params = { empNo };
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	
	public void insertFromAdmin(EmpDto empDto) {
		String sql = "insert into emp("
					+ "emp_no, emp_id, emp_pw, emp_name, "
					+ "emp_birth, emp_level, emp_position, "
					+ "emp_dept, emp_hire_date, emp_mentor) "
					+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {
				empDto.getEmpNo(), empDto.getEmpId(), empDto.getEmpPw(), 
				empDto.getEmpName(), empDto.getEmpBirth(), empDto.getEmpLevel(), 
				empDto.getEmpPosition(), empDto.getEmpDept(), empDto.getEmpHireDate(), 
				empDto.getEmpMentor() 
		};
		
		jdbcTemplate.update(sql, params);
	}
	
	public List<EmpDto> selectList(){
		String sql = "select * from emp order by emp_no asc";
		return jdbcTemplate.query(sql, empMapper);
	}
	
	public List<EmpDto> selectList(String column, String keyword){ 
		if(column == null || keyword == null) return selectList();
		if(column.isEmpty()||keyword.isEmpty()) return selectList();
		

		if(!allowColumns.contains(column)) return List.of();
		String sql = "select * from emp "
				+ "where instr( "+column+", ?) >0 and emp_level != '관리자' "
						+ "order by "+column+" asc, emp_no asc";
		Object[] params = {keyword};
		return jdbcTemplate.query(sql, empMapper, params);
	}
	
	//관리자가 사원정보에서 수정해야할 부분 - 사원권한,사원부서,사원직위,사원담당사수,사원활성화,사원입사일,사원퇴사일
	public boolean updateByMaster(EmpDto empDto) {
		String sql = "update emp "
				+ "set emp_level=?, emp_dept=?, emp_position=?, "
				+ "emp_mentor=?, emp_use_yn=?, emp_hire_date=?, "
				+ "emp_retired_date=? where emp_no = ?";
		Object[] params = {empDto.getEmpLevel(), empDto.getEmpDept(), 
				empDto.getEmpPosition(), empDto.getEmpMentor(), 
				empDto.getEmpUseYn(), empDto.getEmpHireDate(), 
				empDto.getEmpRetiredDate(), empDto.getEmpNo()
				};
		return jdbcTemplate.update(sql, params)>0;
	}
	public void useN(String empNo) {//사원 비활성화 
		 String sql = "update emp set emp_use_yn = 'N' where emp_no = ?";
		 Object[] params = {empNo};
		    jdbcTemplate.update(sql, params);
	}

	public void useY(String empNo) {//사원 활성화
		 String sql = "update emp set emp_use_yn = 'Y' where emp_no = ?";
		 Object[] params = {empNo};
		 jdbcTemplate.update(sql, params);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
