package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.EmpHistoryDto;
import com.kh.semiprj.mapper.EmpHistoryMapper;
import com.kh.semiprj.vo.HistoryPageVO;

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
	public List<EmpHistoryDto> selectList(String empHistoryOrigin, HistoryPageVO historyPageVO){

		
		if(historyPageVO.getBeginDate() == null || historyPageVO.getEndDate() == null) return List.of();
		if(historyPageVO.getBeginDate().isEmpty() || historyPageVO.getEndDate().isEmpty()) return List.of();
		
		String sql = "select * from ("
						+ "select rownum RN, TMP.* from ("
								+ "select * from emp_history "
									+ "where emp_history_origin = ? "
									+ "and emp_history_time between "
									+ "to_timestamp( ? || ' ' || '00:00:00.000' , 'YYYY-MM-DD HH24:MI:SS.FF3') and to_timestamp( ? || ' ' ||'23:59:59.999'  , 'YYYY-MM-DD HH24:MI:SS.FF3') "
									+ "order by emp_history_time desc, emp_history_no desc"
								+ ")TMP"
						+ ") where RN between ? and ? ";
		Object[] params = {empHistoryOrigin, historyPageVO.getBeginDate(), historyPageVO.getEndDate(), 
									historyPageVO.getBeginRownum(), historyPageVO.getEndRownum()};
		return jdbcTemplate.query(sql, empHistoryMapper, params);
	}
//	public int count(String empHistoryOrigin) {
//		String sql= "select count(*) from emp_history "
//					+ "where emp_history_origin = ? ";
//		Object[] params = {empHistoryOrigin};
//		return jdbcTemplate.queryForObject(sql, int.class, params);
//	}
	public int count(String empHistoryOrigin, HistoryPageVO historyPageVO) {
		if(historyPageVO.getBeginDate() == null || historyPageVO.getEndDate() == null) return 0;
		if(historyPageVO.getBeginDate().isEmpty() || historyPageVO.getEndDate().isEmpty()) return 0;
		
		String sql = "select count(*) from emp_history "
						+ "where emp_history_origin = ? "
						+ "and emp_history_time >= "
						+ "to_date( ?, 'YYYY-MM-DD') "
						+ "and emp_history_time < to_date( ?, 'YYYY-MM-DD') + 1";
		Object[] params = {empHistoryOrigin, historyPageVO.getBeginDate(), historyPageVO.getEndDate()};
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}

}
