package com.kh.semiprj.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class AlsDao {
	//결재라인 저장 
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	
}
