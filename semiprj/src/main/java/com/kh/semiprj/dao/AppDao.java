package com.kh.semiprj.dao;

import java.util.ArrayList;
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
        Integer seq = jdbcTemplate.queryForObject(sql, Integer.class);
        return seq != null ? seq : 0;
    }   
    
    //관리자가 전부 확인
    public List<AppDto> selectAllList() {
        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "order by a.app_id desc";
        return jdbcTemplate.query(sql, appMapper);
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
				+ "    select * from app where app_type = ? order by app_no desc " + "  ) TMP "
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
        List<String> list = jdbcTemplate.queryForList(sql, String.class, params);
        return list.isEmpty() ? null : list.get(0);
    }
	
	// 삭제
	public boolean delete(int appId) {
		String sql = "delete app where app_id=?";
		Object[] params = { appId };
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//  추가 정보
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

	// 이름 또는 부서로 결재자 검색
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
	// 문서 상태 변경
	public void updateAppStatus(int appId, String status) {
		String sql = "update app set app_status = ? where app_id = ?";
		jdbcTemplate.update(sql, status, appId);
	}

	
	
	
	
	//뭐든 해당 사원이 포함되는걸로 검색
	public AppDto selectOne(String appReqId) {
	    String sql = "select a.*, e.emp_name from app a "
	               + "join emp e on a.app_req_id = e.emp_no "
	               + "where a.app_req_id = ?";
	    Object[] params = { appReqId };
	    List<AppDto> list = jdbcTemplate.query(sql, appMapper, params);
	    return list.isEmpty() ? null : list.get(0);
	}
	//기인자로 검색
	public AppDto selectOneById(int appId) {
	    String sql = "select a.*, e.emp_name from app a "
	               + "join emp e on a.app_req_id = e.emp_no "
	               + "where a.app_id = ?";
	    Object[] params = { appId };
	    List<AppDto> list = jdbcTemplate.query(sql, appMapper, params);
	    return list.isEmpty() ? null : list.get(0);
	}
	
	
	//추후 쓰지 않거나 과한 기능은 정리
	
	//내 서류를 타입에 따라 필터링
	public List<AppDto> selectMyListByType(String appReqId, String appType) {
	    String sql = "select a.*, e.emp_name from app a "
	               + "join emp e on a.app_req_id = e.emp_no "
	               + "where a.app_req_id = ? and a.app_type = ? "
	               + "order by a.app_id desc";
	    Object[] params = { appReqId, appType };
	    return jdbcTemplate.query(sql, appMapper, params);
	}
	
	
	// 내가 결재해야 하는 (app_line에서 조회)
	public List<AppDto> selectMyApprList(String empNo) {
	    String sql = "select a.*, e.emp_name from app_line l "
	               + "join app a on l.app_id = a.app_id "
	               + "join emp e on a.app_req_id = e.emp_no "
	               + "where l.app_app_id = ? "
	               + "order by a.app_id desc";
	    Object[] params = { empNo };
	    return jdbcTemplate.query(sql, appMapper, params);
	}
	
	// 내가 기안한 것 중 대기중 (아무것도 진행 안된)
		public List<AppDto> selectMyNoneList(String empNo) {
		    String sql = "select a.*, e.emp_name from app a "
		               + "join emp e on a.app_req_id = e.emp_no "
		               + "where a.app_req_id = ? "
		               + "and a.app_status = '대기' "
		               + "order by a.app_id desc";
		    Object[] params = { empNo };
		    return jdbcTemplate.query(sql, appMapper, params);
		}
	

	// 내가 기안한 것 중 진행중
	public List<AppDto> selectMyIngList(String empNo) {
	    String sql = "select a.*, e.emp_name from app a "
	               + "join emp e on a.app_req_id = e.emp_no "
	               + "where a.app_req_id = ? "
	               + "and a.app_status = '진행중' "
	               + "order by a.app_id desc";
	    Object[] params = { empNo };
	    return jdbcTemplate.query(sql, appMapper, params);
	}

	// 내가 기안한 것 중 반려
	public List<AppDto> selectMyRejList(String empNo) {
	    String sql = "select a.*, e.emp_name from app a "
	               + "join emp e on a.app_req_id = e.emp_no "
	               + "where a.app_req_id = ? "
	               + "and a.app_status = '반려' "
	               + "order by a.app_id desc";
	    Object[] params = { empNo };
	    return jdbcTemplate.query(sql, appMapper, params);
	}
	
	public List<AppDto> selectMyList(String empNo) {
	    String sql = "select a.*, e.emp_name from app a "
	               + "join emp e on a.app_req_id = e.emp_no "
	               + "where a.app_req_id = ? "       
	               + "order by a.app_id desc";
	    Object[] params = { empNo };
	    return jdbcTemplate.query(sql, appMapper, params);
	}
	
    
    //검색
    public List<AppDto> searchList(String empNo, String column, String keyword) {
        // allowList로 SQL injection 방지
        Set<String> allowList = Set.of("app_title", "app_type", "app_status");
        if (!allowList.contains(column)) return new ArrayList<>();

        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where a.app_req_id = ? "
                   + "and " + column + " like ? "
                   + "order by a.app_id desc";
        Object[] params = { empNo, "%" + keyword + "%" };
        return jdbcTemplate.query(sql, appMapper, params);
    }
    
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
    
    
 // 최근 3개만 가져오기
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
    
    //내 미결재 문서 count
    public int countMyPenddingApp(String empNo) {
    	String sql = "select count(*) from app a join app_line al "
    			+ "on a.app_id = al.app_id "
    			+ "where al.app_app_id = ? and al.app_line_status = '진행중'";
    	Object[] params = { empNo };
    	return jdbcTemplate.queryForObject(sql, int.class, params);
    }

    
    
}
