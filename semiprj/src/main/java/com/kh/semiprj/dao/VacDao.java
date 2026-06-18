package com.kh.semiprj.dao;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.kh.semiprj.dto.VacHistoryDto;

@Repository
public class VacDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	// 1. [교정 완결] 연차 사용 상세 날짜 등록 (오라클 시퀀스 직접 이식)
	public void insertVacHistory(VacHistoryDto dto) {
		// 💡 물음표를 2개로 줄이고, 첫 번째 기본키 자리에 시퀀스를 직접 선언했습니다.
		String sql = "insert into vac_history(vac_hist_no, vac_date, app_id) "
				+ "values(vac_history_seq.nextval, ?, ?)";

		// 💡 중복 에러의 주범이었던 dto.getVacHistNo()를 과감히 제거하고 날짜와 appId만 바인딩합니다.
		Object[] ob = { dto.getVacDate(), dto.getAppId() };
		jdbcTemplate.update(sql, ob);
	}

	// 2. 특정 결재 문서(app_id)에 포함된 휴가 날짜 목록 조회
	public List<VacHistoryDto> selectHistoryByAppId(int appId) {
		String sql = "select * from vac_history where app_id = ? order by vac_date asc";
		Object[] ob = { appId };

		if (appId <= 0)
			return new ArrayList<>();

		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			VacHistoryDto dto = new VacHistoryDto();
			dto.setVacHistNo(rs.getInt("vac_hist_no"));
			dto.setVacDate(rs.getString("vac_date"));
			dto.setAppId(rs.getInt("app_id"));
			return dto;
		}, ob);
	}

	// 3. 사원의 잔여 연차 감소 및 사용 연차 증가 처리 (vac_info 갱신)
	public void decreaseVacationCount(String empNo, int vacYear, int days) {
		String sql = "UPDATE vac_info " + "SET vac_cnt = vac_cnt - ?, " // 잔여 일수 차감
				+ "    vac_used = vac_used + ? " // 사용 일수 누적
				+ "WHERE emp_no = ? AND vac_year = ?";

		Object[] ob = { days, days, empNo, vacYear };
		jdbcTemplate.update(sql, ob);
	}

	// 4. 연차 차감 일수 산출을 위한 기록 카운트
	public int countVacationDaysFromHistory(int appId) {
		String sql = "select count(*) from vac_history where app_id = ?";
		Object[] ob = { appId };

		if (appId <= 0)
			return 0;

		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, ob);
		return count != null ? count : 0;
	}
}
