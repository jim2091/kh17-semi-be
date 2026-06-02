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

	
	 public void insert(EmpHistoryDto empHistoryDto) { 
		 String sql = "insert into emp_history(" 
				 	+ "emp_history_no, emp_history_origin, "
				 	+ "emp_history_address, emp_history_agent " 
				 	+ ") values(emp_history_seq.nextval, ?, ?, ?)"; 
		 Object[] params = {
				 empHistoryDto.getEmpHistoryOrigin(),
				 empHistoryDto.getEmpHistoryAddress(),
				 empHistoryDto.getEmpHistoryAgent() }; 
		 jdbcTemplate.update(sql, params);
	 }
	 

	public List<EmpHistoryDto> selectList(String empHistoryOrigin, int beginRow, int endRow) {
		String sql = "select * from (" + "select rownum RN, TMP.* from (" + "select * from emp_history "
				+ "where emp_history_origin = ? " + "order by emp_history_time desc, emp_history_no desc " + ")TMP"
				+ ") where RN between ? and ?";
		Object[] params = { empHistoryOrigin, beginRow, endRow };
		return jdbcTemplate.query(sql, empHistoryMapper, params);
	}

}
