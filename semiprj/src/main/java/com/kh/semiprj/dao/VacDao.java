package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.VacHistoryDto;

//연차(휴가)관리 dao
@Repository
public class VacDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;

	// 1. 연차 사용 상세 날짜 등록 (vac_history 인입)
	public void insertVacHistory(VacHistoryDto dto) {
		String sql = "insert into vac_history(vac_hist_no, vac_date, app_id) "
				+ "values(vac_history_seq.nextval, ?, ?)";
		Object[] ob = { dto.getVacDate(), dto.getAppId() };
		jdbcTemplate.update(sql, ob);
	}

	// 2. 특정 결재 문서(app_id)에 포함된 휴가 날짜 목록 조회
	public List<VacHistoryDto> selectHistoryByAppId(int appId) {
		String sql = "select * from vac_history where app_id = ? order by vac_date asc";
		Object[] ob = { appId };

		// 람다식을 활용한 RowMapper 구현 (Null 값 방어 포함)
		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			VacHistoryDto dto = new VacHistoryDto();
			dto.setVacHistNo(rs.getInt("vac_hist_no"));
			dto.setVacDate(rs.getString("vac_date"));
			dto.setAppId(rs.getInt("app_id"));
			return dto;
		}, ob);
	}
	
	// 사원의 잔여 연차 감소 및 사용 연차 증가 처리 (vac_info 갱신)
		public void decreaseVacationCount(String empNo, int vacYear, int days) {
			String sql = "UPDATE vac_info "
					   + "SET vac_cnt = vac_cnt - ?, "  // 잔여 일수 차감
					   + "    vac_used = vac_used + ? " // 사용 일수 누적
					   + "WHERE emp_no = ? AND vac_year = ?";
			
			Object[] ob = { days, days, empNo, vacYear };
			jdbcTemplate.update(sql, ob);
		}

}
