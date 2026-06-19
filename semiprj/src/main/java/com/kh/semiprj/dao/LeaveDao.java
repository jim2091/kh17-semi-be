package com.kh.semiprj.dao;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.kh.semiprj.dto.LeaveHistoryDto;
import com.kh.semiprj.dto.LeaveInfoDto;

@Repository
public class LeaveDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	// 전체 휴가 정보 목록 조회
	public List<LeaveInfoDto> selectList() {
		String sql = "SELECT * FROM leave_info ORDER BY leave_year DESC, leave_no DESC";
		
		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			LeaveInfoDto dto = new LeaveInfoDto();
			dto.setLeaveNo(rs.getInt("leave_no"));
			dto.setEmpNo(rs.getString("emp_no"));
			dto.setLeaveYear(rs.getInt("leave_year"));
			dto.setLeaveTot(rs.getInt("leave_tot"));
			dto.setLeaveCnt(rs.getInt("leave_cnt"));
			dto.setLeaveUsed(rs.getInt("leave_used"));
			dto.setLeaveReason(rs.getString("leave_reason"));
			return dto;
		});
	}

	// 휴가 부여 및 수정 (MERGE INTO)
	public void insertOrUpdateLeave(String empNo, int leaveYear, int leaveDays, String leaveReason) {
		String sql = "MERGE INTO leave_info l "
				   + "USING dual ON (l.emp_no = ? AND l.leave_year = ?) "
				   + "WHEN MATCHED THEN "
				   + "    UPDATE SET l.leave_tot = ?, "
				   + "               l.leave_cnt = ? - l.leave_used, "
				   + "               l.leave_reason = ? "
				   + "WHEN NOT MATCHED THEN "
				   + "    INSERT (leave_no, emp_no, leave_year, leave_tot, leave_cnt, leave_used, leave_reason) "
				   + "    VALUES (leave_info_seq.nextval, ?, ?, ?, ?, 0, ?)";
		
		Object[] ob = {
			empNo, leaveYear,      
			leaveDays, leaveDays, leaveReason, 
			empNo, leaveYear, leaveDays, leaveDays, leaveReason 
		};
		
		jdbcTemplate.update(sql, ob);
	}

	// 1. 휴가 사용 상세 날짜 등록
	public void insertLeaveHistory(LeaveHistoryDto dto) {
		String sql = "insert into leave_history(leave_hist_no, leave_date, app_id) "
				+ "values(leave_history_seq.nextval, ?, ?)";

		Object[] ob = { dto.getLeaveDate(), dto.getAppId() };
		jdbcTemplate.update(sql, ob);
	}

	// 2. 특정 결재 문서(app_id)에 포함된 휴가 날짜 목록 조회
	public List<LeaveHistoryDto> selectHistoryByAppId(int appId) {
		String sql = "select * from leave_history where app_id = ? order by leave_date asc";
		Object[] ob = { appId };

		if (appId <= 0)
			return new ArrayList<>();

		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			LeaveHistoryDto dto = new LeaveHistoryDto();
			dto.setLeaveHistNo(rs.getInt("leave_hist_no"));
			dto.setLeaveDate(rs.getString("leave_date")); 
			dto.setAppId(rs.getInt("app_id"));
			return dto;
		}, ob);
	}
	
	// 3. 사원의 남은 휴가 개수 감소 및 사용 휴가 개수 증가 처리
	public void decreaseLeaveCount(String empNo, int leaveYear, int days) {
		String sql = "UPDATE leave_info " 
				+ "SET leave_cnt = leave_cnt - ?, " 
				+ "    leave_used = leave_used + ? " 
				+ "WHERE emp_no = ? AND leave_year = ?";

		Object[] ob = { days, days, empNo, leaveYear };
		jdbcTemplate.update(sql, ob);
	}

	// 4. 휴가 차감 일수 산출을 위한 기록 카운트
	public int countLeaveDaysFromHistory(int appId) {
		String sql = "select count(*) from leave_history where app_id = ?";
		Object[] ob = { appId };

		if (appId <= 0)
			return 0;

		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, ob);
		return count != null ? count : 0;
	}

	// 특정 사원의 단건 휴가 정보 조회 
	public LeaveInfoDto selectOneByEmpNoAndYear(String empNo, int leaveYear) {
		String sql = "SELECT * FROM leave_info WHERE emp_no = ? AND leave_year = ?";
		Object[] ob = { empNo, leaveYear };
		
		try {
			return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
				LeaveInfoDto dto = new LeaveInfoDto();
				dto.setLeaveNo(rs.getInt("leave_no"));
				dto.setEmpNo(rs.getString("emp_no"));
				dto.setLeaveYear(rs.getInt("leave_year"));
				dto.setLeaveTot(rs.getInt("leave_tot"));
				dto.setLeaveCnt(rs.getInt("leave_cnt"));
				dto.setLeaveUsed(rs.getInt("leave_used"));
				dto.setLeaveReason(rs.getString("leave_reason"));
				return dto;
			}, ob);
		} catch (EmptyResultDataAccessException e) {
			return null; 
		}
	}

	// [교정완료] 사원 번호 기준 휴가 히스토리 벌크 삭제
	public void deleteHistoryByEmpNo(String empNo) {
		// 실제 존재하지 않는 테이블 leave_app에서 실존 테이블인 vac_app으로 수정했습니다.
		String sql = "DELETE FROM leave_history "
				   + "WHERE app_id IN ("
				   + "    SELECT app_id FROM vac_app WHERE app_id IN (" 
				   + "        SELECT app_id FROM app WHERE app_req_id = ?" 
				   + "    )"
				   + ")";
		jdbcTemplate.update(sql, empNo);
	}

	// 사원 번호 기준 기본 휴가 정보 삭제
	public void deleteLeaveInfoByEmpNo(String empNo) {
		String sql = "DELETE FROM leave_info WHERE emp_no = ?";
		jdbcTemplate.update(sql, empNo);
	}
}