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
		String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
				   + "left outer join dept d on e.emp_dept = d.dept_id "
				   + "where e.emp_id = ?";
		Object[] params = { empId };
		List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public EmpDto selectOneByDetail(String empNo) {
		String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
				   + "left outer join dept d on e.emp_dept = d.dept_id "
				   + "where e.emp_no = ?";
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
	
	/*
	 * public List<EmpDto> selectListByUser(){ 
	 * String sql =
	 * "select * from emp where emp_approval_status= 'Y' " +
	 * "and emp_level != '관리자' " + "order by emp_no asc"; return
	 * jdbcTemplate.query(sql, empMapper); }
	 */	
	public List<EmpDto> selectListByUser(){

	    String sql = "select emp.*, "
	               + "(select dept_name from dept where dept_id = emp.emp_dept) as emp_dept_name "
	               + "from emp "
	               + "where emp_approval_status = 'Y' "
	               + "and emp_level != '관리자' "
	               + "order by emp_no asc";
	               
	    return jdbcTemplate.query(sql, empMapper);
	}
	
	public List<EmpDto> selectListByUser(String column, String keyword){ 
		if(column == null || keyword == null) return selectListByUser();
		if(column.isEmpty()||keyword.isEmpty()) return selectListByUser();
		
		if(!allowColumns.contains(column)) return List.of();
		String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
				   + "left outer join dept d on e.emp_dept = d.dept_id "
				   + "where instr(e."+column+", ?) > 0 and e.emp_level != '관리자' "
				   + "and e.emp_approval_status= 'Y' "
				   + "order by e."+column+" asc, e.emp_no asc";
		Object[] params = {keyword};
		return jdbcTemplate.query(sql, empMapper, params);
	}

	public List<EmpDto> selectListByDept(String deptKeyword){
	    if(deptKeyword == null || deptKeyword.isEmpty()) {
	        return selectListByUser();
	    }

	    String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
	               + "left outer join dept d on e.emp_dept = d.dept_id "
	               + "where e.emp_dept = ? and e.emp_level != '관리자' "
	               + "and e.emp_approval_status = 'Y' "
	               + "order by e.emp_no asc";

	    Object[] params = {Integer.parseInt(deptKeyword)};
	    return jdbcTemplate.query(sql, empMapper, params);
	}

	public List<EmpDto> selectListByAdmin(){
		String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
				   + "left outer join dept d on e.emp_dept = d.dept_id "
				   + "where e.emp_approval_status= 'Y' "
				   + "order by e.emp_no asc";
		return jdbcTemplate.query(sql, empMapper);
	}
	
	public List<EmpDto> selectListByAdmin(String column, String keyword){ 
		if(column == null || keyword == null) return selectListByAdmin();
		if(column.isEmpty()||keyword.isEmpty()) return selectListByAdmin();
		
		if(!allowColumns.contains(column)) return List.of();
		String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
				   + "left outer join dept d on e.emp_dept = d.dept_id "
				   + "where instr(e."+column+", ?) > 0 and e.emp_approval_status= 'Y' "
				   + "order by e."+column+" asc, e.emp_no asc";
		Object[] params = {keyword};
		return jdbcTemplate.query(sql, empMapper, params);
	}

	public List<EmpDto> selectListByAdminByDept(String deptKeyword){
	    if(deptKeyword == null || deptKeyword.isEmpty()) {
	        return selectListByAdmin();
	    }

	    String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
	               + "left outer join dept d on e.emp_dept = d.dept_id "
	               + "where e.emp_dept = ? and e.emp_approval_status = 'Y' "
	               + "order by e.emp_no asc";

	    Object[] params = {Integer.parseInt(deptKeyword)};
	    return jdbcTemplate.query(sql, empMapper, params);
	}
	
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

	public void useY(String empNo) {
		 String sql = "update emp set emp_use_yn = 'Y', emp_approval_status= 'Y' where emp_no = ?";
		 Object[] params = {empNo};
		 jdbcTemplate.update(sql, params);
	}
	
	public boolean updateByUser(EmpDto empDto) {
		String sql = "update emp "
				+ "set emp_birth=?, emp_email=?, emp_contact=?, "
				+ "emp_post=?, emp_address1=?, emp_address2=?, emp_email_verified='Y' where emp_no = ?";
		Object[] params = {empDto.getEmpBirth(), empDto.getEmpEmail(), 
				empDto.getEmpContact(), empDto.getEmpPost(), 
				empDto.getEmpAddress1(), empDto.getEmpAddress2(), 
				empDto.getEmpNo() 
				};
		return jdbcTemplate.update(sql, params)>0;
	}
	
	public List<EmpDto> selectListForWaiting(){
		String sql = "select * from emp where emp_approval_status = 'N' and emp_email_verified = 'Y' order by emp_no asc";
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
	
	//부서장 이름 불러오는 메소드
    public EmpDto selectOneDeptHeadId(String empNo) {
    	String sql = "select * from emp where emp_no= ?";
    	Object[]params = {empNo};
    	List<EmpDto> list = jdbcTemplate.query(sql, empMapper, params);
        return list.isEmpty() ? null : list.get(0);
    }
    
    public String selectNamebyNo(String empNo) {
    	String sql = "select emp_name from emp where emp_no = ?";
    	Object[]params = {empNo};
    	return jdbcTemplate.queryForObject(sql, String.class, params);
    }
	
	public List<EmpDto> searchByName(String keyword) {
		String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
				   + "left join dept d on e.emp_dept = d.dept_id "
				   + "where instr(e.emp_name, ?) > 0 and emp_use_yn = 'Y' "
				   + "order by emp_name asc";
		Object[] params = {keyword};
		return jdbcTemplate.query(sql, empMapper, params);
	}
	
	public List<EmpDto> search(String keyword){
		if (keyword == null || keyword.trim().isEmpty()) {
			String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
					   + "left outer join dept d on e.emp_dept = d.dept_id "
					   + "where e.emp_use_yn = 'Y' order by e.emp_name asc";
			return jdbcTemplate.query(sql, empMapper);
		}
		
		String sql = "select e.*, d.dept_name as emp_dept_name from emp e "
				   + "left outer join dept d on e.emp_dept = d.dept_id "
				   + "where e.emp_use_yn = 'Y' and ("
				   + "instr(e.emp_no, ?) > 0 or instr(e.emp_name, ?) > 0 "
				   + "or instr(e.emp_dept, ?) > 0 or instr(e.emp_position, ?) > 0"
				   + ") order by e.emp_name asc";
		Object[] params = {keyword, keyword, keyword, keyword};
		return jdbcTemplate.query(sql, empMapper, params);
	}

	// dept_emp 삽입용 메소드
	public void insertDeptEmp(String empNo, int deptId) {
	    String sql = "insert into dept_emp(emp_no, dept_id) values(?, ?)";
	    jdbcTemplate.update(sql, empNo, deptId);
	}

	// dept_emp 삭제용 메소드
	public void deleteDeptEmp(String empNo) {
	    String sql = "delete from dept_emp where emp_no = ?";
	    jdbcTemplate.update(sql, empNo);
	}

}
