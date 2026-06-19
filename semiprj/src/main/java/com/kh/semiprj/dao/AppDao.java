package com.kh.semiprj.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.mapper.AppMapper;
import com.kh.semiprj.mapper.EmpMapper;
import com.kh.semiprj.vo.PageVO;

@Repository
public class AppDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private AppMapper appMapper;
	@Autowired
	private EmpMapper empMapper;

	// 검색 허용
	private Set<String> allowList = Set.of("app_type", "app_status");

	// 시퀀스 발급기
	public int sequence() {
		String sql = "select app_seq.nextval from dual";
		Integer seq = jdbcTemplate.queryForObject(sql, Integer.class);
		return seq != null ? seq : 0;
	}

	// 1. [관리자] 다중 중첩 필터링(기안자+문서종류+진행상황) 통합 페이징 조회
	public List<AppDto> selectAllList(PageVO pageVO, String searchEmpName, String searchAppType,
			String searchAppStatus) {
		// 기본 뼈대 쿼리 작성 (동적 쿼리 구성을 위해 where 1=1 전략 사용)
		String baseSql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no " + "where 1=1 ";

		List<Object> paramList = new ArrayList<>();

		// 조건 ①: 기안자 이름 검색 (포함 연산)
		if (searchEmpName != null && !searchEmpName.trim().isEmpty()) {
			baseSql += "and e.emp_name like ? ";
			paramList.add("%" + searchEmpName.trim() + "%");
		}
		// 조건 ②: 문서종류 필터링 (일치 연산)
		if (searchAppType != null && !searchAppType.trim().isEmpty()) {
			baseSql += "and a.app_type = ? ";
			paramList.add(searchAppType.trim());
		}
		// 조건 ③: 진행상황 필터링 (일치 연산)
		if (searchAppStatus != null && !searchAppStatus.trim().isEmpty()) {
			baseSql += "and a.app_status = ? ";
			paramList.add(searchAppStatus.trim());
		}

		// 정렬 기준 결합
		baseSql += "order by a.app_id desc";

		// 오라클 페이징 3중 서브쿼리 래핑 마감
		String finalSql = "select * from (" + "  select rownum RN, TMP.* FROM (" + baseSql + "  ) TMP"
				+ ") where RN between ? and ?";

		// 페이징 파라미터 하단 유입 순서대로 적재
		paramList.add(pageVO.getBeginRownum());
		paramList.add(pageVO.getEndRownum());

		// 방어 코드: 잘못된 페이징 범위 차단
		if (pageVO.getBeginRownum() <= 0 || pageVO.getEndRownum() <= 0) {
			return new ArrayList<>();
		}

		return jdbcTemplate.query(finalSql, appMapper, paramList.toArray());
	}

	// 2. [관리자] 다중 중첩 필터링 대응 전체 카운트 메서드
	public int countAll(String searchEmpName, String searchAppType, String searchAppStatus) {
		String sql = "select count(*) from app a " + "join emp e on a.app_req_id = e.emp_no " + "where 1=1 ";

		List<Object> paramList = new ArrayList<>();

		if (searchEmpName != null && !searchEmpName.trim().isEmpty()) {
			sql += "and e.emp_name like ? ";
			paramList.add("%" + searchEmpName.trim() + "%");
		}
		if (searchAppType != null && !searchAppType.trim().isEmpty()) {
			sql += "and a.app_type = ? ";
			paramList.add(searchAppType.trim());
		}
		if (searchAppStatus != null && !searchAppStatus.trim().isEmpty()) {
			sql += "and a.app_status = ? ";
			paramList.add(searchAppStatus.trim());
		}

		try {
			Integer count = jdbcTemplate.queryForObject(sql, Integer.class, paramList.toArray());
			return count != null ? count : 0;
		} catch (Exception e) {
			return 0; // 예외 발생 시 인프라 방어선 구동
		}
	}

	// app_type 페이징
	public List<AppDto> selectByAppTypeList(PageVO pageVO) {
		if (pageVO == null) {
			return selectList(1, 10);
		}
		// 검색 목록이 아니거나(isList), 검색 조건이 allowList에 없는 경우 기본 목록 반환
		if (pageVO.isList() || !allowList.contains(pageVO.getColumn())) {
			return selectList(pageVO.getPage(), pageVO.getSize());
		}

		String sql = "select * from ( " + "  select rownum RN, TMP.* from ( "
				+ "    select * from app where app_type = ? order by app_id desc " + "  ) TMP "
				+ ") where rn between ? and ?";
		Object[] params = { pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum() };
		return jdbcTemplate.query(sql, appMapper, params);

	}

	// 등록 할 때 생각해야할 점 : 품의서, 휴가신청서,
	// 업무기안서 를 세개의 테이블로 나눠서 진행할 때,
	// 어떤 sql 구문을 써야 하는가

	// 등록
	public void insert(AppDto appDto) {
		String sql = "insert into app (app_id, app_req_id, app_title,  "
				+ "app_content, app_status, app_date, app_save_yn, app_type)" + " values(?, ?, ?, ?, ?, ?, ?)";
		Object[] params = { appDto.getAppId(), appDto.getAppReqId(), appDto.getAppTitle(), appDto.getAppContent(),
				appDto.getAppStatus(), appDto.getAppDate(), appDto.getAppSaveYn(), appDto.getAppType() };
		jdbcTemplate.update(sql, params);
	}

	// app_req_id 가 아닌 emp_name이 출력될수 있게 해주는 메소드
	public String selectEmpNameById(String loginId) {
		String sql = "select emp_name from emp where emp_id = ?";
		Object[] params = { loginId };
		return jdbcTemplate.queryForObject(sql, String.class, params);
	}

	// 근데 들어가야할 정보는 name 이 아니라 No 여야 해서 만든 메소드
	public String selectEmpNoById(String loginId) {
		String sql = "select emp_no from emp where emp_id = ?";
		Object[] params = { loginId };
		List<String> list = jdbcTemplate.queryForList(sql, String.class, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// dept_id 가 아닌 dept_name 이 출력될 수 있게 해주는 메소드
	public String selectDeptNameById(int deptId) {
		String sql = "select dept_name from dept where dept_id=?";
		Object[] params = { deptId };
		return jdbcTemplate.queryForObject(sql, String.class, params);
	}

	// 삭제
	public boolean delete(int appId) {
		String sql = "delete app where app_id=?";
		Object[] params = { appId };
		return jdbcTemplate.update(sql, params) > 0;
	}

	// 추가 정보 조회용 메소드
	public VacAppDto selectVacByAppId(int appId) {
		String sql = "select * from vac_app where app_id = ?";
		List<VacAppDto> list = jdbcTemplate.query(sql, (rs, rn) -> {
			VacAppDto dto = new VacAppDto();
			dto.setAppId(rs.getInt("app_id"));
			dto.setVacStartDate(rs.getString("vac_start_date"));
			dto.setVacEndDate(rs.getString("vac_end_date"));
			dto.setVacType(rs.getString("vac_type"));
			return dto;
		}, appId);
		return list.isEmpty() ? null : list.get(0);
	}

	public ExpAppDto selectExpByAppId(int appId) {
		String sql = "select * from exp_app where app_id = ?";
		List<ExpAppDto> list = jdbcTemplate.query(sql, (rs, rn) -> {
			ExpAppDto dto = new ExpAppDto();
			dto.setAppId(rs.getInt("app_id"));
			dto.setExpDate(rs.getString("exp_date"));
			dto.setExpPrice(rs.getInt("exp_price"));
			dto.setExpHistory(rs.getString("exp_history"));
			dto.setExpHow(rs.getString("exp_how"));
			dto.setExpPurpose(rs.getString("exp_purpose"));
			return dto;
		}, appId);
		return list.isEmpty() ? null : list.get(0);
	}

	public DftAppDto selectDftByAppId(int appId) {
		String sql = "select * from dft_app where app_id = ?";
		List<DftAppDto> list = jdbcTemplate.query(sql, (rs, rn) -> {
			DftAppDto dto = new DftAppDto();
			dto.setAppId(rs.getInt("app_id"));
			dto.setDftDate(rs.getString("dft_date"));
			return dto;
		}, appId);
		return list.isEmpty() ? null : list.get(0);
	}

	// 휴가신청서 품의서 업무기안서 등록
	public void insert(VacAppDto vacAppDto) {
		String sql = "insert into app (app_id, app_req_id, app_title, "
				+ "app_content, app_type, app_status, app_date, app_save_yn)" + " values(?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = { vacAppDto.getAppId(), vacAppDto.getAppReqId(), vacAppDto.getAppTitle(),
				vacAppDto.getAppContent(), vacAppDto.getAppType(), vacAppDto.getAppStatus(), vacAppDto.getAppDate(),
				vacAppDto.getAppSaveYn() };
		jdbcTemplate.update(sql, params);
	}

	public void insert(ExpAppDto expAppDto) {
		String sql = "insert into app (app_id, app_req_id, app_title, "
				+ "app_content, app_type, app_status, app_date, app_save_yn)" + " values(?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = { expAppDto.getAppId(), expAppDto.getAppReqId(), expAppDto.getAppTitle(),
				expAppDto.getAppContent(), expAppDto.getAppType(), expAppDto.getAppStatus(), expAppDto.getAppDate(),
				expAppDto.getAppSaveYn() };
		jdbcTemplate.update(sql, params);
	}

	public void insert(DftAppDto dftAppDto) {
		String sql = "insert into app (app_id, app_req_id, app_title, "
				+ "app_content, app_type, app_status, app_date, app_save_yn)" + " values(?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = { dftAppDto.getAppId(), dftAppDto.getAppReqId(), dftAppDto.getAppTitle(),
				dftAppDto.getAppContent(), dftAppDto.getAppType(), dftAppDto.getAppStatus(), dftAppDto.getAppDate(),
				dftAppDto.getAppSaveYn() };
		jdbcTemplate.update(sql, params);
	}

	// 이름 또는 부서로 결재자 검색
	public List<AppDto> searchApprover(String keyword) {
		String sql = "select emp_no, emp_name, emp_dept, emp_position " + "from emp "
				+ "where (emp_name like ? or emp_dept like ?) " + "and emp_use_yn = 'Y'";
		Object[] params = { "%" + keyword + "%", "%" + keyword + "%" };
		return jdbcTemplate.query(sql, (rs, rn) -> {
			AppDto dto = new AppDto();
			dto.setAppReqId(rs.getString("emp_no"));
			dto.setAppTitle(rs.getString("emp_name"));
			dto.setAppContent(rs.getString("emp_dept"));
			dto.setAppType(rs.getString("emp_position"));
			return dto;
		}, params);
	}

	public List<AppDto> selectList(int page, int size) {
		String sql = "select a.*, e.emp_name from (" + "  select rownum rn, TMP.* from ("
				+ "    select a.*, e.emp_name from app a " + "    join emp e on a.app_req_id = e.emp_no "
				+ "    order by a.app_id desc" + "  ) TMP" + ") where rn between ? and ?";
		int beginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = { beginRow, endRow };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	public int count() {
		String sql = "select count(*) from app";
		try {
			Integer count = jdbcTemplate.queryForObject(sql, Integer.class);
			return count != null ? count : 0;
		} catch (Exception e) {
			return 0;
		}
	}

	// 문서 상태 변경
	public void updateAppStatus(int appId, String status) {
		String sql = "update app set app_status = ? where app_id = ?";
		jdbcTemplate.update(sql, status, appId);
	}

	// 뭐든 해당 사원이 포함되는걸로 검색
	public AppDto selectOne(String appReqId) {
		String sql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no "
				+ "where a.app_req_id = ?";
		Object[] params = { appReqId };
		List<AppDto> list = jdbcTemplate.query(sql, appMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 기인자로 검색
	public AppDto selectOneById(int appId) {
		String sql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no "
				+ "where a.app_id = ?";
		Object[] params = { appId };
		List<AppDto> list = jdbcTemplate.query(sql, appMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 추후 쓰지 않거나 과한 기능은 정리

	// 내 서류를 타입에 따라 필터링
	public List<AppDto> selectMyListByType(String appReqId, String appType) {
		String sql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no "
				+ "where a.app_req_id = ? and a.app_type = ? " + "order by a.app_id desc";
		Object[] params = { appReqId, appType };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 내가 결재해야 하는 (app_line에서 조회)
	public List<AppDto> selectMyApprList(String empNo) {
		String sql = "select a.*, e.emp_name from app_line l " + "join app a on l.app_id = a.app_id "
				+ "join emp e on a.app_req_id = e.emp_no " + "where l.app_app_id = ? " + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 내가 기안한 것 중 대기중 (아무것도 진행 안된)
	public List<AppDto> selectMyNoneList(String empNo) {
		String sql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no "
				+ "where a.app_req_id = ? " + "and a.app_status = '대기' " + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 내가 기안한 것 중 진행중
	public List<AppDto> selectMyIngList(String empNo) {
		String sql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no "
				+ "where a.app_req_id = ? " + "and a.app_status = '진행중' " + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 내가 기안한 것 중 반려
	public List<AppDto> selectMyRejList(String empNo) {
		String sql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no "
				+ "where a.app_req_id = ? " + "and a.app_status = '반려' " + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	public List<AppDto> selectMyList(String empNo) {
		String sql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no "
				+ "where a.app_req_id = ? " + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 검색
	public List<AppDto> searchList(String empNo, String column, String keyword) {
		// allowList로 SQL injection 방지
		Set<String> allowList = Set.of("app_title", "app_type", "app_status");
		if (!allowList.contains(column))
			return new ArrayList<>();

		String sql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no "
				+ "where a.app_req_id = ? " + "and " + column + " like ? " + "order by a.app_id desc";
		Object[] params = { empNo, "%" + keyword + "%" };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 사원으로 검색
	public List<AppDto> selectAllEmp() {
		String sql = "select emp_no, emp_name, emp_dept, emp_position " + "from emp where emp_use_yn = 'Y'";
		return jdbcTemplate.query(sql, (rs, rn) -> {
			AppDto dto = new AppDto();
			dto.setAppReqId(rs.getString("emp_no"));
			dto.setAppTitle(rs.getString("emp_name"));
			dto.setAppContent(rs.getString("emp_dept"));
			dto.setAppType(rs.getString("emp_position"));
			return dto;
		});
	}

	// 최근 3개만 가져오기
	public List<AppDto> selectMyRecentList(String empNo) {
		String sql = "select * from (" + "  select a.*, e.emp_name from app a "
				+ "  join emp e on a.app_req_id = e.emp_no " + "  where a.app_req_id = ? " + "  order by a.app_id desc"
				+ ") where rownum <= 5";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 내 미결재 문서 count
	public int countMyPenddingApp(String empNo) {
		String sql = "select count(*) from app a join app_line al " + "on a.app_id = al.app_id "
				+ "where al.app_app_id = ? and al.app_line_status = '진행중'";
		Object[] params = { empNo };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}

	// picker를 사용하기 위한 메소드 (오직 직급레벨 순서 최우선 정렬)
	public List<Map<String, Object>> searchApproverForPicker(String keyword, List<String> excludes) {
		String sql = "select e.emp_no, e.emp_name, e.emp_position, d.dept_name as emp_dept, p.position_level "
				+ "from emp e " + "left join dept d on to_number(e.emp_dept) = d.dept_id "
				+ "left join position_item p on e.position_id = p.position_id " + "where e.emp_use_yn = 'Y' "
				+ "and (e.emp_name like ? or d.dept_name like ?) ";

		List<Object> params = new ArrayList<>();
		params.add("%" + keyword + "%");
		params.add("%" + keyword + "%");

		if (excludes != null && !excludes.isEmpty()) {
			String placeholders = excludes.stream().map(e -> "?").collect(java.util.stream.Collectors.joining(", "));
			sql += "and e.emp_no not in (" + placeholders + ") ";
			params.addAll(excludes);
		}

		sql += "order by p.position_level asc nulls last, e.emp_name asc";

		return jdbcTemplate.query(sql, (rs, rn) -> {
			Map<String, Object> map = new HashMap<>();
			map.put("empNo", rs.getString("emp_no"));
			map.put("empName", rs.getString("emp_name"));
			map.put("empPosition", rs.getString("emp_position"));
			map.put("empDept", rs.getString("emp_dept"));

			int level = rs.getInt("position_level");
			map.put("positionLevel", rs.wasNull() ? 99 : level); // 컨트롤러 방어선과 일치하도록 99 부여
			return map;
		}, params.toArray());
	}

	// 특정 결재 문서의 기안자 사원번호 조회
	public String selectEmpNoByAppId(int appId) {
		String sql = "select app_req_id from app where app_id = ?";
		try {
			return jdbcTemplate.queryForObject(sql, String.class, appId);
		} catch (Exception e) {
			return null;
		}
	}

	public List<AppDto> selectMyListByFilter(PageVO pageVO, String empNo, String searchAppType,
			String searchAppStatus) {
		String baseSql = "select a.*, e.emp_name from app a " + "join emp e on a.app_req_id = e.emp_no "
				+ "where a.app_req_id = ? "; // 로그인한 내 문서 기준 보장

		List<Object> paramList = new ArrayList<>();
		paramList.add(empNo);

		if (searchAppType != null && !searchAppType.trim().isEmpty()) {
			baseSql += "and a.app_type = ? ";
			paramList.add(searchAppType.trim());
		}
		if (searchAppStatus != null && !searchAppStatus.trim().isEmpty()) {
			baseSql += "and a.app_status = ? ";
			paramList.add(searchAppStatus.trim());
		}

		baseSql += "order by a.app_id desc";

		String finalSql = "select * from (" + "  select rownum RN, TMP.* FROM (" + baseSql + "  ) TMP"
				+ ") where RN between ? and ?";

		paramList.add(pageVO.getBeginRownum());
		paramList.add(pageVO.getEndRownum());

		if (empNo == null || pageVO.getBeginRownum() <= 0)
			return new ArrayList<>();
		return jdbcTemplate.query(finalSql, appMapper, paramList.toArray());
	}

	// 2. [개인 기안/결재함] 중첩 필터링 대응 전체 카운트 메서드
	public int countMyListByFilter(String empNo, String searchAppType, String searchAppStatus) {
		String sql = "select count(*) from app where app_req_id = ? ";

		List<Object> paramList = new ArrayList<>();
		paramList.add(empNo);

		if (searchAppType != null && !searchAppType.trim().isEmpty()) {
			sql += "and app_type = ? ";
			paramList.add(searchAppType.trim());
		}
		if (searchAppStatus != null && !searchAppStatus.trim().isEmpty()) {
			sql += "and app_status = ? ";
			paramList.add(searchAppStatus.trim());
		}

		try {
			if (empNo == null)
				return 0;
			Integer count = jdbcTemplate.queryForObject(sql, Integer.class, paramList.toArray());
			return count != null ? count : 0;
		} catch (Exception e) {
			return 0;
		}
	}

	public List<AppDto> selectMyApprListByFilter(PageVO pageVO, String empNo, String searchAppType,
			String searchAppStatus) {
		String baseSql = "select a.*, e.emp_name from app_line l " + "join app a on l.app_id = a.app_id "
				+ "join emp e on a.app_req_id = e.emp_no " + "where l.app_app_id = ? ";

		List<Object> paramList = new ArrayList<>();
		paramList.add(empNo);

		if (searchAppType != null && !searchAppType.trim().isEmpty()) {
			baseSql += "and a.app_type = ? ";
			paramList.add(searchAppType.trim());
		}
		if (searchAppStatus != null && !searchAppStatus.trim().isEmpty()) {
			baseSql += "and l.app_line_status = ? ";
			paramList.add(searchAppStatus.trim());
		}

		baseSql += "order by a.app_id desc";

		// 오라클 3중 서브쿼리 페이징 결합
		String finalSql = "select * from (" + "  select rownum RN, TMP.* FROM (" + baseSql + "  ) TMP"
				+ ") where RN between ? and ?";

		paramList.add(pageVO.getBeginRownum());
		paramList.add(pageVO.getEndRownum());

		if (empNo == null || pageVO.getBeginRownum() <= 0)
			return new ArrayList<>();
		return jdbcTemplate.query(finalSql, appMapper, paramList.toArray());
	}

	// 2. [결재자 문서함] 중첩 필터링 대응 전체 카운트 메서드
	public int countMyApprListByFilter(String empNo, String searchAppType, String searchAppStatus) {
		String sql = "select count(*) from app_line l " + "join app a on l.app_id = a.app_id "
				+ "where l.app_app_id = ? ";

		List<Object> paramList = new ArrayList<>();
		paramList.add(empNo);

		if (searchAppType != null && !searchAppType.trim().isEmpty()) {
			sql += "and a.app_type = ? ";
			paramList.add(searchAppType.trim());
		}
		if (searchAppStatus != null && !searchAppStatus.trim().isEmpty()) {
			sql += "and l.app_line_status = ? ";
			paramList.add(searchAppStatus.trim());
		}

		try {
			if (empNo == null)
				return 0;
			Integer count = jdbcTemplate.queryForObject(sql, Integer.class, paramList.toArray());
			return count != null ? count : 0;
		} catch (Exception e) {
			return 0;
		}
	}

	// ⭕ [메서드 추가] 문서 번호로 결재 유형(app_type) 단건 조회 (Null 방어 포함)
	public String selectAppTypeById(int appId) {
		String sql = "select app_type from app where app_id = ?";

		if (appId <= 0)
			return "";

		try {
			return jdbcTemplate.queryForObject(sql, String.class, appId);
		} catch (org.springframework.dao.EmptyResultDataAccessException e) {
			// 데이터가 유실되었거나 없을 경우 안전하게 빈 문자열 반환하여 에러 방어
			return "";
		}
	}

}
