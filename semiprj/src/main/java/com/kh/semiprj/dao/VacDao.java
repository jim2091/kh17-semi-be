package com.kh.semiprj.dao;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.kh.semiprj.dto.VacHistoryDto;
import com.kh.semiprj.dto.VacInfoDto; 

@Repository
public class VacDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;

	// =================================================================
	// 💡 데이터베이스(vac_info)에 영구 저장된 행만 실시간 조회합니다.
	// =================================================================
	public List<VacInfoDto> selectList() {
		String sql = "SELECT * FROM vac_info ORDER BY vac_year DESC, vac_no DESC";
		
		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			VacInfoDto dto = new VacInfoDto();
			dto.setVacNo(rs.getInt("vac_no"));
			dto.setEmpNo(rs.getString("emp_no"));
			dto.setVacYear(rs.getInt("vac_year"));
			dto.setVacTot(rs.getInt("vac_tot"));
			dto.setVacCnt(rs.getInt("vac_cnt"));
			dto.setVacUsed(rs.getInt("vac_used"));
			dto.setVacReason(rs.getString("vac_reason"));
			return dto;
		});
	}

	// =================================================================
	// 🛠️ MERGE INTO 구문을 통해 신규 등록 및 변경 데이터를 완전 처리합니다.
	// =================================================================
	public void insertOrUpdateVacation(String empNo, int vacYear, int vacDays, String vacReason) {
		String sql = "MERGE INTO vac_info v "
				   + "USING dual ON (v.emp_no = ? AND v.vac_year = ?) "
				   + "WHEN MATCHED THEN "
				   + "    UPDATE SET v.vac_tot = ?, "
				   + "               v.vac_cnt = ? - v.vac_used, "
				   + "               v.vac_reason = ? "
				   + "WHEN NOT MATCHED THEN "
				   + "    INSERT (vac_no, emp_no, vac_year, vac_tot, vac_cnt, vac_used, vac_reason) "
				   + "    VALUES (vac_info_seq.nextval, ?, ?, ?, ?, 0, ?)";
		
		Object[] ob = {
			empNo, vacYear,              
			vacDays, vacDays, vacReason, 
			empNo, vacYear, vacDays, vacDays, vacReason 
		};
		
		jdbcTemplate.update(sql, ob);
	}

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
				   + "SET vac_cnt = vac_cnt - ?, "
				   + "    vac_used = vac_used + ? "
				   + "WHERE emp_no = ? AND vac_year = ?";
		
		Object[] ob = { days, days, empNo, vacYear };
		jdbcTemplate.update(sql, ob);
	}

	// 사원 번호 기반 단건 상세조회 기능 구현
	public VacInfoDto selectOneByEmpNo(String empNo) {
		String sql = "SELECT * FROM vac_info WHERE emp_no = ?";
		Object[] ob = { empNo };
		
		try {
			return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
				VacInfoDto dto = new VacInfoDto();
				dto.setVacNo(rs.getInt("vac_no"));
				dto.setEmpNo(rs.getString("emp_no"));
				dto.setVacYear(rs.getInt("vac_year"));
				dto.setVacTot(rs.getInt("vac_tot"));
				dto.setVacCnt(rs.getInt("vac_cnt"));
				dto.setVacUsed(rs.getInt("vac_used"));
				dto.setVacReason(rs.getString("vac_reason"));
				return dto;
			}, ob);
		} catch (EmptyResultDataAccessException e) {
			return null; 
		}
	}

	// =================================================================
	// 🎯 특정 사원의 결재 하위 연차 상세 날짜 이력 일괄 삭제 (컬럼명 수정 완료)
	// =================================================================
	public void deleteHistoryByEmpNo(String empNo) {
		String sql = "DELETE FROM vac_history "
				   + "WHERE app_id IN ("
				   + "    SELECT app_id FROM vac_app WHERE app_id IN ("
				   + "        SELECT app_id FROM app WHERE app_req_id = ?" 
				   + "    )"
				   + ")";
		jdbcTemplate.update(sql, empNo);
	}

	// =================================================================
	// ✨ [새로 추가] 화면에 출력되는 연차 보유 현황 행 자체를 삭제하는 메서드
	// =================================================================
	public void deleteVacInfoByEmpNo(String empNo) {
		String sql = "DELETE FROM vac_info WHERE emp_no = ?";
		jdbcTemplate.update(sql, empNo);
	}
}