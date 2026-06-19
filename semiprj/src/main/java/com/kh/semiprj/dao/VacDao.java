package com.kh.semiprj.dao;

import java.util.ArrayList;
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

	public void insertVacHistory(VacHistoryDto dto) {
		String sql = "insert into vac_history(vac_hist_no, vac_date, app_id) "
				+ "values(vac_history_seq.nextval, ?, ?)";

		Object[] ob = { dto.getVacDate(), dto.getAppId() };
		jdbcTemplate.update(sql, ob);
	}

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
	
	public void decreaseVacationCount(String empNo, int vacYear, int days) {
		String sql = "UPDATE vac_info " 
				   + "SET vac_cnt = vac_cnt - ?, " 
				   + "    vac_used = vac_used + ? " 
				   + "WHERE emp_no = ? AND vac_year = ?";

		Object[] ob = { days, days, empNo, vacYear };
		jdbcTemplate.update(sql, ob);
	}

	public int countVacationDaysFromHistory(int appId) {
		String sql = "select count(*) from vac_history where app_id = ?";
		Object[] ob = { appId };

		if (appId <= 0)
			return 0;

		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, ob);
		return count != null ? count : 0;
	}

	public VacInfoDto selectOneByEmpNoAndYear(String empNo, int vacYear) {
		String sql = "SELECT * FROM vac_info WHERE emp_no = ? AND vac_year = ?";
		Object[] ob = { empNo, vacYear };
		
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
			return null; // 해당 연도의 연차 데이터가 없으면 깔끔하게 null 반환
		}
	}

	public void deleteHistoryByEmpNo(String empNo) {
		String sql = "DELETE FROM vac_history "
				   + "WHERE app_id IN ("
				   + "    SELECT app_id FROM vac_app WHERE app_id IN ("
				   + "        SELECT app_id FROM app WHERE app_req_id = ?" 
				   + "    )"
				   + ")";
		jdbcTemplate.update(sql, empNo);
	}

	public void deleteVacInfoByEmpNo(String empNo) {
		String sql = "DELETE FROM vac_info WHERE emp_no = ?";
		jdbcTemplate.update(sql, empNo);
	}
}