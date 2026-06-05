package com.kh.semiprj.dao;

import java.util.List;
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
        // [방어 코드 1] int.class 대신 래퍼 클래스인 Integer.class를 사용하여 내부 Null 에러 방지
        Integer seq = jdbcTemplate.queryForObject(sql, Integer.class);
        return seq != null ? seq : 0;
    }   


	// 목록 및 검색
	public List<AppDto> selectList(int page, int size) {
		String sql = "select * from (" + "	select rownum rn, TMP.* from("
				+ "		select * from app order by app_no desc" + "	)TMP" + ") where rn between ? and ?";
		int beginRow = page * size - (size - 1);
		int endRow = page * size;
		Object[] params = { beginRow, endRow };
		return jdbcTemplate.query(sql, appMapper, params);
	}

	// 목록 (자신의 것만 볼수있는 버전)
	public List<AppDto> selectMyList(String appReqId) {
		String sql = " select * from app where app_req_id=? order by app_id desc";
		Object[] params = { appReqId };
		return jdbcTemplate.query(sql, appMapper, params);

	}

//	//app_type 에 따라 달라지는 목록
//	public List<AppDto> selectListByAppType(String appType){
//		String sql = "select * from app where app_type=? order by app_id desc";
//		Object[] params = { appType };
//		return jdbcTemplate.query(sql, appMapper, params);
//	}

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
				+ "    select * from app where app_type = ? order by app_no desc " + "  ) TMP "
				+ ") where rn between ? and ?";
		Object[] params = { pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum() };
		return jdbcTemplate.query(sql, appMapper, params);

	}

	// 등록 할 때 생각해야할 점 : 품의서, 휴가신청서, 업무기안서 를 세개의 테이블로 나눠서 진행할 때, 어떤 sql 구문을 써야 하는가

	// 등록 
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
	
	//app_req_id 가 아닌 emp_name이 출력될수 있게 해주는 메소드
	public String selectEmpNameById(String loginId) {
	    String sql = "select emp_name from emp where emp_id = ?";
	    Object[] params = { loginId }; 
	    return jdbcTemplate.queryForObject(sql, String.class, params);
	}
	
	//근데 들어가야할 정보는 name 이 아니라 No 여야 해서 만든 메소드
	public String selectEmpNoById(String loginId) {
        String sql = "select emp_no from emp where emp_id = ?";
        Object[] params = { loginId };
        return jdbcTemplate.queryForObject(sql, String.class, params);
    }
	
	public void insert(VacAppDto vacAppDto) {
	    String sql = "insert into app (app_id, app_req_id, app_title, "
	               + "app_content, app_type, app_status, app_date, app_save_yn)"
	               //                  ↑ 여기
	               + " values(?, ?, ?, ?, ?, ?, ?, ?)";
	    Object[] params = {
	        vacAppDto.getAppId(),
	        vacAppDto.getAppReqId(),
	        vacAppDto.getAppTitle(),
	        vacAppDto.getAppContent(),
	        vacAppDto.getAppType(),   // ← 여기
	        vacAppDto.getAppStatus(),
	        vacAppDto.getAppDate(),
	        vacAppDto.getAppSaveYn()
	    };
	    jdbcTemplate.update(sql, params);
	}
	

	// 상세(기인자)
	public AppDto selectOne(String appReqId) {
		String sql = "select * from app where app_req_id=?";
		Object[] params = { appReqId };
		List<AppDto> list = jdbcTemplate.query(sql, appMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 삭제
	public boolean delete(int appId) {
		String sql = "delete app where app_id=?";
		Object[] params = { appId };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
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

	public List<AppDto> selectMyListByType(String appReqId, String appType) {
	    String sql = "select * from app where app_req_id=? and app_type=? order by app_id desc";
	    Object[] params = { appReqId, appType };
	    return jdbcTemplate.query(sql, appMapper, params);
	}
}
