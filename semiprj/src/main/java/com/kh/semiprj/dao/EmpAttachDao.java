package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.EmpAttachDto;
import com.kh.semiprj.dto.EmpHistoryDto;
import com.kh.semiprj.mapper.EmpAttachMapper;
import com.kh.semiprj.vo.HistoryPageVO;

@Repository
public class EmpAttachDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private EmpAttachMapper empAttachMapper;
	
	public void insert(String empNo, int attachNo) {
		String sql = "insert into emp_attach(emp_no, attach_no) values(?, ?)";
		Object[] params = { empNo, attachNo };
		jdbcTemplate.update(sql, params);
	}
	
}
