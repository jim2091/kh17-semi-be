package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.mapper.DeptMapper;

@Repository
public class DeptDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private DeptMapper deptMapper;
	
	//첫 화면 조회 메소드
		public List<DeptDto> selectList() {
			String sql = "select * from dept order by dept_category asc";
			return jdbcTemplate.query(sql, deptMapper);
		}
	//등록 메소드
		public int sequence() {
			String sql = "select dept_seq.nextval from dual";
			return jdbcTemplate.queryForObject(sql, int.class);
		}
		public void insert(DeptDto deptDto) {
			String sql = "insert into dept( "
					+ "dept_id, dept_parent_id, dept_name "
					+ ") values (?,?,?)";
					
		}
		
}
