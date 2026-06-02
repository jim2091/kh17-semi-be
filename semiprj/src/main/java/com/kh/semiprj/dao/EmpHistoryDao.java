package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.EmpHistoryDto;
import com.kh.semiprj.mapper.EmpHistoryMapper;

@Repository
public class EmpHistoryDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private EmpHistoryMapper empHistoryMapper;

	
	public List<EmpHistoryDto> selectList(int empHistoryOrigin, int beginRow, int endRow){
		String sql = "select * from ("
						+ "select rownum RN, TMP.* from ("
							+ "select * from emp_history "
								+ "where emp_history_origin = ? "
								+ "order by emp_history_time desc, emp_history_no desc "
							+ ")TMP"
						+ ") where RN between ? and ?";
		Object[] params = {empHistoryOrigin, beginRow, endRow};
		return jdbcTemplate.query(sql, empHistoryMapper, params);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
