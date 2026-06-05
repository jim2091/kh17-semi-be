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
	
	public EmpDto selectOneforFindId(String empEmail, String empName) {
		String sql = "select * from emp where emp_email=? and emp_Name=?";
		Object[] params = { empEmail, empName };
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public String selectIdByEmail(String empEmail) {
		String sql = "select emp_id from emp where emp_email = ?";
		Object[] params = { empEmail };
		return jdbcTemplate.queryForObject(sql, String.class, params);
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
	
	public List<EmpDto> selectListByUser(){
		String sql = "select * from emp where emp_approval_status= 'Y' "
				+ "and emp_level != '관리자' "
				+ "order by emp_no asc";
		return jdbcTemplate.query(sql, empMapper);
	}
	
	public List<EmpDto> selectListByUser(String column, String keyword){ 
		if(column == null || keyword == null) return selectListByUser();
		if(column.isEmpty()||keyword.isEmpty()) return selectListByUser();
		

		if(!allowColumns.contains(column)) return List.of();
		String sql = "select * from emp "
				+ "where instr( "+column+", ?) >0 and emp_level != '관리자' "
						+ "and emp_approval_status= 'Y' "
						+ "order by "+column+" asc, emp_no asc";
		Object[] params = {keyword};
		return jdbcTemplate.query(sql, empMapper, params);
	}
	public List<EmpDto> selectListByAdmin(){
		String sql = "select * from emp where emp_approval_status= 'Y' "
				+ "order by emp_no asc";
		return jdbcTemplate.query(sql, empMapper);
	}
	
	public List<EmpDto> selectListByAdmin(String column, String keyword){ 
		if(column == null || keyword == null) return selectListByAdmin();
		if(column.isEmpty()||keyword.isEmpty()) return selectListByAdmin();
		

		if(!allowColumns.contains(column)) return List.of();
		String sql = "select * from emp "
				+ "where instr( "+column+", ?) >0 "
						+ "and emp_approval_status= 'Y' "
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
		 String sql = "update emp set emp_use_yn = 'N', emp_approval_status = 'N' where emp_no = ?";
		 Object[] params = {empNo};
		    jdbcTemplate.update(sql, params);
	}

	public void useY(String empNo) {//사원 활성화
		 String sql = "update emp set emp_use_yn = 'Y', emp_approval_status= 'Y' where emp_no = ?";
		 Object[] params = {empNo};
		 jdbcTemplate.update(sql, params);
	}
	
	
	//사용자가 변경해야할 정보 : 생년월일, 이메일(인증까지),연락처, 주소
	public boolean updateByUser(EmpDto empDto) {
		String sql = "update emp "
				+ "set emp_birth=?, emp_email=?, emp_contact=?, "
				+ "emp_post=?, emp_address1=?, emp_address2=? where emp_no = ?";
		Object[] params = {empDto.getEmpBirth(), empDto.getEmpEmail(), 
				empDto.getEmpContact(), empDto.getEmpPost(), 
				empDto.getEmpAddress1(), empDto.getEmpAddress2(), 
				empDto.getEmpNo() 
				};
		return jdbcTemplate.update(sql, params)>0;
	}
	
	public List<EmpDto> selectListForWaiting(){
		String sql = "select * from emp where emp_approval_status = 'N' order by emp_no asc";
		return jdbcTemplate.query(sql, empMapper);
	}
	
	public boolean updateEmpPw(EmpDto empDto) {
		String sql = "update emp "
				+ "set emp_pw= ?, emp_pw_change=systimestamp "
				+ "where emp_id = ?";
		Object[] params = {empDto.getEmpPw(), empDto.getEmpId()};
		return jdbcTemplate.update(sql, params)>0;
	}
	
	public void connect(String empNo, int attachNo) {
		String sql = "insert into emp_profile(emp_no, attach_no) values(?, ?)";
		Object[] params = {empNo, attachNo};
		jdbcTemplate.update(sql, params);
		}
	
	public int searchProfile(String empNo) {
		String sql = "select attach_no from ("
				+ "select attach_no from emp_profile where emp_no = ? order by attach_no desc) "
				+ "where rownum = 1";
		Object[] params = {empNo};
		
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	public EmpDto selectOneByEmpEmail(String empEmail) {
		String sql = "select * from emp where emp_email=?";
		Object[] params = {empEmail};
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
			return list.isEmpty() ? null : list.get(0);
	}
	
	//부서장 이름을 보여주는 메소드
    public EmpDto selectOneDeptHeadId(String empNo) {
    	String sql = "select * from emp where emp_no= ?";
    	Object[]params = {empNo};
    	List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
        
        return list.isEmpty() ? null : list.get(0);
    }
	
	
	
	
	
	
	
	
	
	
	
	
}
