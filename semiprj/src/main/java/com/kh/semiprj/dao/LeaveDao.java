package com.kh.semiprj.dao;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.kh.semiprj.dto.LeaveHistoryDto;

@Repository
public class LeaveDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	// 1. [교정 완결] 휴가 사용 상세 날짜 등록 (leave_history_seq 시퀀스 직접 이식)
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

	// 3. 사원의 남은 휴가 개수 감소 및 사용 휴가 개수 증가 처리 (leave_info 갱신)
	public void decreaseLeaveCount(String empNo, int leaveYear, int days) {
		String sql = "UPDATE leave_info " 
				+ "SET leave_cnt = leave_cnt - ?, "    // 남은 휴가 일수 차감
				+ "    leave_used = leave_used + ? "   // 사용한 휴가 일수 누적
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
}