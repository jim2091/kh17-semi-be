package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.DeptCategoryDto;
import com.kh.semiprj.mapper.DeptCategoryMapper;

@Repository
public class DeptCategoryDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private DeptCategoryMapper deptCategoryMapper;
	
	//카테고리 조회
	public List<DeptCategoryDto> selectCategoryList(){
		String sql = "select * from dept_category_id "
				+ "order by dept_category_no asc";
		return jdbcTemplate.query(sql, deptCategoryMapper);
	}
	//카테고리 등록
	public int sequence() {
        String sql = "select dept_category_id_seq.nextval from dual";
        return jdbcTemplate.queryForObject(sql, int.class);
	}
	public boolean insert(DeptCategoryDto deptCategoryDto) {
		String sql = "insert into dept_category_id"
				+ "(dept_category_no,dept_category_name) values (?,?)";
		Object[]params = {
					deptCategoryDto.getDeptCategoryNo(),
					deptCategoryDto.getDeptCategoryName()
				};
		return jdbcTemplate.update(sql,params)>0;
	}
	
	//카테고리 중복
	public boolean exists(String deptCategoryName) {
		String sql = "select count(*) from dept_category_id where dept_category_name = ?";
		int count = jdbcTemplate.queryForObject(sql, Integer.class,deptCategoryName);
		return count>0;
	}
}
