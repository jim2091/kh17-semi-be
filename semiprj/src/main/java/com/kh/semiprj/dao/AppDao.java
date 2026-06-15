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
	
	// 검색 허용 목록
	private Set<String> allowList = Set.of("app_type", "app_status", "app_title");

	// 시퀀스 발급기
	public int sequence() {
		String sql = "select app_seq.nextval from dual";
		Integer seq = jdbcTemplate.queryForObject(sql, Integer.class);
		return seq != null ? seq : 0;
	}   
	
	// [호환용] 인자 없는 기존 관리자 메서드 (기본 1페이지 호출)
	public List<AppDto> selectAllList() {
		PageVO defaultPageVO = new PageVO();
		return selectAllList(defaultPageVO);
	}

	// [통합 수정] 관리자용 리스트 페이징 및 검색 조회 (PageVO 스펙 반영)
	public List<AppDto> selectAllList(PageVO pageVO) {
		if (pageVO == null) pageVO = new PageVO();

		String sql;
		Object[] params;

		// 검색어와 선택 컬럼이 허용 목록에 안전하게 존재하는지 검증 후 분기
		if (pageVO.isSearch() && allowList.contains(pageVO.getColumn())) {
			sql = "select * from ("
				+ "  select rownum rn, TMP.* from ("
				+ "    select a.*, e.emp_name from app a "
				+ "    join emp e on a.app_req_id = e.emp_no "
				+ "    where " + pageVO.getColumn() + " like ? "
				+ "    order by a.app_id desc"
				+ "  ) TMP"
				+ ") where rn between ? and ?";
			params = new Object[]{ "%" + pageVO.getKeyword() + "%", pageVO.getBeginRownum(), pageVO.getEndRownum() };
		} else {
			// 검색 조건이 없는 경우 전체 목록 조회
			sql = "select * from ("
				+ "  select rownum rn, TMP.* from ("
				+ "    select a.*, e.emp_name from app a "
				+ "    join emp e on a.app_req_id = e.emp_no "
				+ "    order by a.app_id desc"
				+ "  ) TMP"
				+ ") where rn between ? and ?";
			params = new Object[]{ pageVO.getBeginRownum(), pageVO.getEndRownum() };
		}

		try {
			return jdbcTemplate.query(sql, appMapper, params);
		} catch (Exception e) {
			System.err.println("[AppDao Error] selectAllList 실패: " + e.getMessage());
			return new ArrayList<>(); // 에러 시 널포인터 방지용 빈 리스트 리턴
		}
	}

	// [추가] 관리자 화면용 전체 데이터 개수 반환 (일반/검색 통합 카운팅)
	public int countAdmin(PageVO pageVO) {
		if (pageVO == null) return 0;
		
		String sql;
		Object[] params;
		
		if (pageVO.isSearch() && allowList.contains(pageVO.getColumn())) {
			sql = "select count(*) from app a join emp e on a.app_req_id = e.emp_no where " + pageVO.getColumn() + " like ?";
			params = new Object[]{ "%" + pageVO.getKeyword() + "%" };
		} else {
			sql = "select count(*) from app";
			params = new Object[]{};
		}
		
		try {
			Integer totalCount = jdbcTemplate.queryForObject(sql, Integer.class, params);
			return totalCount != null ? totalCount : 0;
		} catch (Exception e) {
			return 0;
		}
	}

	// [추가] 사원용 본인 문서함 페이징 및 검색 통합 조회
	public List<AppDto> selectMyList(String empNo, PageVO pageVO) {
		if (pageVO == null) pageVO = new PageVO();

		String sql;
		Object[] params;

		if (pageVO.isSearch() && allowList.contains(pageVO.getColumn())) {
			sql = "select * from ("
				+ "  select rownum rn, TMP.* from ("
				+ "    select a.*, e.emp_name from app a "
				+ "    join emp e on a.app_req_id = e.emp_no "
				+ "    where a.app_req_id = ? and " + pageVO.getColumn() + " like ? "
				+ "    order by a.app_id desc"
				+ "  ) TMP"
				+ ") where rn between ? and ?";
			params = new Object[]{ empNo, "%" + pageVO.getKeyword() + "%", pageVO.getBeginRownum(), pageVO.getEndRownum() };
		} else {
			sql = "select * from ("
				+ "  select rownum rn, TMP.* from ("
				+ "    select a.*, e.emp_name from app a "
				+ "    join emp e on a.app_req_id = e.emp_no "
				+ "    where a.app_req_id = ? "
				+ "    order by a.app_id desc"
				+ "  ) TMP"
				+ ") where rn between ? and ?";
			params = new Object[]{ empNo, pageVO.getBeginRownum(), pageVO.getEndRownum() };
		}

		try {
			return jdbcTemplate.query(sql, appMapper, params);
		} catch (Exception e) {
			System.err.println("[AppDao Error] selectMyList 실패: " + e.getMessage());
			return new ArrayList<>();
		}
	}

	// [추가] 사원 화면용 본인 작성 글 개수 반환 (일반/검색 통합 카운팅)
	public int countMyList(String empNo, PageVO pageVO) {
		if (pageVO == null) return 0;
		
		String sql;
		Object[] params;
		
		if (pageVO.isSearch() && allowList.contains(pageVO.getColumn())) {
			sql = "select count(*) from app where app_req_id = ? and " + pageVO.getColumn() + " like ?";
			params = new Object[]{ empNo, "%" + pageVO.getKeyword() + "%" };
		} else {
			sql = "select count(*) from app where app_req_id = ?";
			params = new Object[]{ empNo };
		}
		
		try {
			Integer totalCount = jdbcTemplate.queryForObject(sql, Integer.class, params);
			return totalCount != null ? totalCount : 0;
		} catch (Exception e) {
			return 0;
		}
	}

	// 기존 구형 selectList 유지 (영향도 최소화)
	public List<AppDto> selectList(int page, int size) {
		String sql = "select a.*, e.emp_name from ("
				   + "  select rownum rn, TMP.* from ("
				   + "    select a.*, e.emp_name from app a "
				   + "    join emp e on a.app_req_id = e.emp_no "
				   + "    order by a.app_id desc"
				   + "  ) TMP"
				   + ") where rn between ? and ?";
		int beginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = { beginRow, endRow };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// app_type 전용 기본 페이징 처리 메서드
	public List<AppDto> selectByAppTypeList(PageVO pageVO) {
		if (pageVO == null) {
			return selectList(1, 10);
		}
		if (pageVO.isList() || !allowList.contains(pageVO.getColumn())) {
			return selectList(pageVO.getPage(), pageVO.getSize());
		}

		String sql = "select * from ( " + "  select rownum RN, TMP.* from ( "
				+ "    select * from app where app_type = ? order by app_no desc " + "  ) TMP "
				+ ") where rn between ? and ?";
		Object[] params = { pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum() };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 마스터 결재 정보 등록
	public void insert(AppDto appDto) {
		String sql = "insert into app (app_id, app_req_id, app_title,  "
				+ "app_content, app_status,app_date, app_save_yn)"
				+ " values(?, ?, ?, ?, ?, ?, ?)";
		Object[] params = { 
				appDto.getAppId(), 
				appDto.getAppReqId(), 
				appDto.getAppTitle(), 
				appDto.getAppContent(),
				appDto.getAppStatus(),
				appDto.getAppDate(),
				appDto.getAppSaveYn()
		};
		jdbcTemplate.update(sql, params);
	}
	
	// 세션 로그인 ID 기반 사원명 추출
	public String selectEmpNameById(String loginId) {
		String sql = "select emp_name from emp where emp_id = ?";
		Object[] params = { loginId }; 
		try {
			return jdbcTemplate.queryForObject(sql, String.class, params);
		} catch (Exception e) {
			return "";
		}
	}
	
	// 세션 로그인 ID 기반 사원 고유 번호(No) 추출
	public String selectEmpNoById(String loginId) {
		String sql = "select emp_no from emp where emp_id = ?";
		Object[] params = { loginId };
		List<String> list = jdbcTemplate.queryForList(sql, String.class, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	// 기안 서류 삭제
	public boolean delete(int appId) {
		String sql = "delete app where app_id=?";
		Object[] params = { appId };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	// 휴가신청서 서브 세부 정보 조회
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
	
	// 지출품의서 서브 세부 정보 조회
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
	
	// 업무기안서 서브 세부 정보 조회
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
	
	// 오버로딩: 휴가신청서 다형성 등록
	public void insert(VacAppDto vacAppDto) {
		String sql = "insert into app (app_id, app_req_id, app_title, "
				   + "app_content, app_type, app_status, app_date, app_save_yn)"
				   + " values(?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {
			vacAppDto.getAppId(),
			vacAppDto.getAppReqId(),
			vacAppDto.getAppTitle(),
			vacAppDto.getAppContent(),
			vacAppDto.getAppType(),   
			vacAppDto.getAppStatus(),
			vacAppDto.getAppDate(),
			vacAppDto.getAppSaveYn()
		};
		jdbcTemplate.update(sql, params);
	}

	// 오버로딩: 지출품의서 다형성 등록
	public void insert(ExpAppDto expAppDto) {
		String sql = "insert into app (app_id, app_req_id, app_title, "
				   + "app_content, app_type, app_status, app_date, app_save_yn)"
				   + " values(?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {
			expAppDto.getAppId(),
			expAppDto.getAppReqId(),
			expAppDto.getAppTitle(),
			expAppDto.getAppContent(),
			expAppDto.getAppType(),
			expAppDto.getAppStatus(),
			expAppDto.getAppDate(),
			expAppDto.getAppSaveYn()
		};
		jdbcTemplate.update(sql, params);
	}

	// 오버로딩: 업무기안서 다형성 등록
	public void insert(DftAppDto dftAppDto) {
		String sql = "insert into app (app_id, app_req_id, app_title, "
				   + "app_content, app_type, app_status, app_date, app_save_yn)"
				   + " values(?, ?, ?, ?, ?, ?, ?, ?)";
		Object[] params = {
			dftAppDto.getAppId(),
			dftAppDto.getAppReqId(),
			dftAppDto.getAppTitle(),
			dftAppDto.getAppContent(),
			dftAppDto.getAppType(),
			dftAppDto.getAppStatus(),
			dftAppDto.getAppDate(),
			dftAppDto.getAppSaveYn()
		};
		jdbcTemplate.update(sql, params);
	}

	// 사번 및 사원명 기준 단건 매핑 검색
	public List<AppDto> searchApprover(String keyword) {
		String sql = "select emp_no, emp_name, emp_dept, emp_position "
				   + "from emp "
				   + "where (emp_name like ? or emp_dept like ?) "
				   + "and emp_use_yn = 'Y'";
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
	
	// 최종 문서 결재 처리 상태 변경
	public void updateAppStatus(int appId, String status) {
		String sql = "update app set app_status = ? where app_id = ?";
		jdbcTemplate.update(sql, status, appId);
	}
	
	// 기안사원번호 매칭 단건 서류 조회
	public AppDto selectOne(String appReqId) {
		String sql = "select a.*, e.emp_name from app a "
				   + "join emp e on a.app_req_id = e.emp_no "
				   + "where a.app_req_id = ?";
		Object[] params = { appReqId };
		List<AppDto> list = jdbcTemplate.query(sql, appMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 고유 문서 ID 기준 단건 서류 조회
	public AppDto selectOneById(int appId) {
		String sql = "select a.*, e.emp_name from app a "
				   + "join emp e on a.app_req_id = e.emp_no "
				   + "where a.app_id = ?";
		Object[] params = { appId };
		List<AppDto> list = jdbcTemplate.query(sql, appMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	// 내 서류 문서 종류별 필터 조회
	public List<AppDto> selectMyListByType(String appReqId, String appType) {
		String sql = "select a.*, e.emp_name from app a "
				   + "join emp e on a.app_req_id = e.emp_no "
				   + "where a.app_req_id = ? and a.app_type = ? "
				   + "order by a.app_id desc";
		Object[] params = { appReqId, appType };
		return jdbcTemplate.query(sql, appMapper, params);
	}
	
	// 결재 라인에 포섭된 본인 미결재 문서함 목록 조회
	public List<AppDto> selectMyApprList(String empNo) {
		String sql = "select a.*, e.emp_name from app_line l "
				   + "join app a on l.app_id = a.app_id "
				   + "join emp e on a.app_req_id = e.emp_no "
				   + "where l.app_app_id = ? "
				   + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}
	
	// 대기 상태인 본인 상신 문서함 목록 조회
	public List<AppDto> selectMyNoneList(String empNo) {
		String sql = "select a.*, e.emp_name from app a "
				   + "join emp e on a.app_req_id = e.emp_no "
				   + "where a.app_req_id = ? "
				   + "and a.app_status = '대기' "
				   + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}
	
	// 진행중 상태인 본인 상신 문서함 목록 조회
	public List<AppDto> selectMyIngList(String empNo) {
		String sql = "select a.*, e.emp_name from app a "
				   + "join emp e on a.app_req_id = e.emp_no "
				   + "where a.app_req_id = ? "
				   + "and a.app_status = '진행중' "
				   + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 반려 상태인 본인 상신 문서함 목록 조회
	public List<AppDto> selectMyRejList(String empNo) {
		String sql = "select a.*, e.emp_name from app a "
				   + "join emp e on a.app_req_id = e.emp_no "
				   + "where a.app_req_id = ? "
				   + "and a.app_status = '반려' "
				   + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}
	
	// [호환용] 인자 없는 기존 사원 전체 목록 조회
	public List<AppDto> selectMyList(String empNo) {
		String sql = "select a.*, e.emp_name from app a "
				   + "join emp e on a.app_req_id = e.emp_no "
				   + "where a.app_req_id = ? "       
				   + "order by a.app_id desc";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}
	
	// 구형 검색 처리 리스트
	public List<AppDto> searchList(String empNo, String column, String keyword) {
		if (!allowList.contains(column)) return new ArrayList<>();

		String sql = "select a.*, e.emp_name from app a "
				   + "join emp e on a.app_req_id = e.emp_no "
				   + "where a.app_req_id = ? "
				   + "and " + column + " like ? "
				   + "order by a.app_id desc";
		Object[] params = { empNo, "%" + keyword + "%" };
		return jdbcTemplate.query(sql, appMapper, params);
	}
	
	// 활성화 상태 전체 사원 스캔
	public List<AppDto> selectAllEmp() {
		String sql = "select emp_no, emp_name, emp_dept, emp_position "
				   + "from emp where emp_use_yn = 'Y'";
		return jdbcTemplate.query(sql, (rs, rn) -> {
			AppDto dto = new AppDto();
			dto.setAppReqId(rs.getString("emp_no"));
			dto.setAppTitle(rs.getString("emp_name"));
			dto.setAppContent(rs.getString("emp_dept"));
			dto.setAppType(rs.getString("emp_position"));
			return dto;
		});
	}
	
	// 대시보드 표출용 최근 3개 기안 이력 조회
	public List<AppDto> selectMyRecentList(String empNo) {
		String sql = "select * from ("
				   + "  select a.*, e.emp_name from app a "
				   + "  join emp e on a.app_req_id = e.emp_no "
				   + "  where a.app_req_id = ? "
				   + "  order by a.app_id desc"
				   + ") where rownum <= 3";
		Object[] params = { empNo };
		return jdbcTemplate.query(sql, appMapper, params);
	}
	
	// 내 미결재 할당 문서 count
	public int countMyPenddingApp(String empNo) {
		String sql = "select count(*) from app a join app_line al "
				+ "on a.app_id = al.app_id "
				+ "where al.app_app_id = ? and al.app_line_status = '진행중'";
		Object[] params = { empNo };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}

	// [수정 완료] picker를 사용하기 위한 메소드 (본인 제외 방어 코드 추가)
		public List<Map<String, Object>> searchApproverForPicker(String keyword, List<String> excludes, String loginEmpNo) {
			// 방어 코드: excludes 배열이 null이면 내부적으로 안전하게 새 리스트 생성
			if (excludes == null) {
				excludes = new ArrayList<>();
			}
			
			// 비즈니스 룰 방어: 본인 사번(loginEmpNo)이 누락되지 않았다면 예외 대상 리스트에 강제 추가
			if (loginEmpNo != null && !excludes.contains(loginEmpNo)) {
				excludes.add(loginEmpNo);
			}

			String sql = "select emp_no, emp_name, emp_position, emp_dept "
					+ "from emp "
					+ "where emp_use_yn = 'Y' "
					+ "and (emp_name like ? or emp_dept like ?) ";
			
			List<Object> params = new ArrayList<>();
			params.add("%" + keyword + "%");
			params.add("%" + keyword + "%");
			
			// 본인 사번을 포함한 모든 제외 대상 사번을 Not In 서브쿼리 플레이스홀더로 가변 결합
			if (!excludes.isEmpty()) {
				String placeholders = excludes.stream()
						.map(e -> "?")
						.collect(java.util.stream.Collectors.joining(", "));
				sql += "and emp_no not in (" + placeholders + ") ";
				params.addAll(excludes);
			}
			
			sql += "order by emp_dept, emp_name";
			
			return jdbcTemplate.query(sql, (rs, rn) -> {
				Map<String, Object> map = new HashMap<>();
				map.put("empNo",       rs.getString("emp_no"));
				map.put("empName",     rs.getString("emp_name"));
				map.put("empPosition", rs.getString("emp_position"));
				map.put("empDept",     rs.getString("emp_dept"));
				map.put("positionLevel", 0);
				return map;
			}, params.toArray());
		}
}