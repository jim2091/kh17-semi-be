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
import com.kh.semiprj.dto.AttachDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.mapper.AppMapper;
import com.kh.semiprj.mapper.AttachMapper;
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
    @Autowired
    private AttachMapper attachMapper;

    // 검색 허용
    private Set<String> allowList = Set.of("app_type", "app_status");

    // ===== 시퀀스 =====
    public int sequence() {
        String sql = "select app_seq.nextval from dual";
        Integer seq = jdbcTemplate.queryForObject(sql, Integer.class);
        return seq != null ? seq : 0;
    }

    // ===== 첨부파일 =====
    public void insertAppFile(int appId, int attachNo) {
        String sql = "INSERT INTO app_files (app_id, attach_no) VALUES (?, ?)";
        jdbcTemplate.update(sql, appId, attachNo);
    }

    public void connect(int appId, int attachNo) {
        String sql = "insert into app_files(app_id, attach_no) values(?, ?)";
        jdbcTemplate.update(sql, appId, attachNo);
    }

    public boolean disconnect(int appId, int attachNo) {
        String sql = "delete app_files where app_id = ? and attach_no = ?";
        return jdbcTemplate.update(sql, appId, attachNo) > 0;
    }

    public List<AttachDto> searchFiles(int appId) {
        String sql = "select attach.* from attach join app_files "
                   + "on attach.attach_no = app_files.attach_no where app_files.app_id = ?";
        return jdbcTemplate.query(sql, attachMapper, appId);
    }

    // ===== 등록 =====
    public void insert(AppDto appDto) {
        String sql = "insert into app (app_id, app_req_id, app_title, "
                   + "app_content, app_status, app_date, app_save_yn, app_type) "
                   + "values(?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] params = {
            appDto.getAppId(), appDto.getAppReqId(), appDto.getAppTitle(),
            appDto.getAppContent(), appDto.getAppStatus(), appDto.getAppDate(),
            appDto.getAppSaveYn(), appDto.getAppType()
        };
        jdbcTemplate.update(sql, params);
    }

    public void insert(VacAppDto vacAppDto) {
        String sql = "insert into app (app_id, app_req_id, app_title, "
                   + "app_content, app_type, app_status, app_date, app_save_yn) "
                   + "values(?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] params = {
            vacAppDto.getAppId(), vacAppDto.getAppReqId(), vacAppDto.getAppTitle(),
            vacAppDto.getAppContent(), vacAppDto.getAppType(), vacAppDto.getAppStatus(),
            vacAppDto.getAppDate(), vacAppDto.getAppSaveYn()
        };
        jdbcTemplate.update(sql, params);
    }

    public void insert(ExpAppDto expAppDto) {
        String sql = "insert into app (app_id, app_req_id, app_title, "
                   + "app_content, app_type, app_status, app_date, app_save_yn) "
                   + "values(?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] params = {
            expAppDto.getAppId(), expAppDto.getAppReqId(), expAppDto.getAppTitle(),
            expAppDto.getAppContent(), expAppDto.getAppType(), expAppDto.getAppStatus(),
            expAppDto.getAppDate(), expAppDto.getAppSaveYn()
        };
        jdbcTemplate.update(sql, params);
    }

    public void insert(DftAppDto dftAppDto) {
        String sql = "insert into app (app_id, app_req_id, app_title, "
                   + "app_content, app_type, app_status, app_date, app_save_yn) "
                   + "values(?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] params = {
            dftAppDto.getAppId(), dftAppDto.getAppReqId(), dftAppDto.getAppTitle(),
            dftAppDto.getAppContent(), dftAppDto.getAppType(), dftAppDto.getAppStatus(),
            dftAppDto.getAppDate(), dftAppDto.getAppSaveYn()
        };
        jdbcTemplate.update(sql, params);
    }

    // ===== 단건 조회 =====
    public AppDto selectOne(String appReqId) {
        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where a.app_req_id = ?";
        List<AppDto> list = jdbcTemplate.query(sql, appMapper, appReqId);
        return list.isEmpty() ? null : list.get(0);
    }

    public AppDto selectOneById(int appId) {
        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where a.app_id = ?";
        List<AppDto> list = jdbcTemplate.query(sql, appMapper, appId);
        return list.isEmpty() ? null : list.get(0);
    }

    public String selectAppTypeById(int appId) {
        if (appId <= 0) return "";
        String sql = "select app_type from app where app_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, String.class, appId);
        } catch (Exception e) {
            return "";
        }
    }

    public String selectEmpNoByAppId(int appId) {
        String sql = "select app_req_id from app where app_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, String.class, appId);
        } catch (Exception e) {
            return null;
        }
    }

    // ===== 추가 정보 조회 (문서 종류별) =====
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

    // ===== 목록 조회 =====
    public List<AppDto> selectList(int page, int size) {
        String sql = "select * from ("
                   + "  select rownum rn, TMP.* from ("
                   + "    select a.*, e.emp_name from app a "
                   + "    join emp e on a.app_req_id = e.emp_no "
                   + "    order by a.app_id desc"
                   + "  ) TMP"
                   + ") where rn between ? and ?";
        int beginRow = page * size - (size - 1);
        int endRow   = page * size;
        return jdbcTemplate.query(sql, appMapper, beginRow, endRow);
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

    public List<AppDto> selectMyList(String empNo) {
        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where a.app_req_id = ? "
                   + "order by a.app_id desc";
        return jdbcTemplate.query(sql, appMapper, empNo);
    }

    public List<AppDto> selectMyRecentList(String empNo) {
        String sql = "select * from ("
                   + "  select a.*, e.emp_name from app a "
                   + "  join emp e on a.app_req_id = e.emp_no "
                   + "  where a.app_req_id = ? "
                   + "  order by a.app_id desc"
                   + ") where rownum <= 5";
        return jdbcTemplate.query(sql, appMapper, empNo);
    }

    public List<AppDto> selectMyListByType(String appReqId, String appType) {
        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where a.app_req_id = ? and a.app_type = ? "
                   + "order by a.app_id desc";
        return jdbcTemplate.query(sql, appMapper, appReqId, appType);
    }

    public List<AppDto> selectMyListByFilter(PageVO pageVO, String empNo,
            String searchAppType, String searchAppStatus) {
        if (empNo == null || pageVO.getBeginRownum() <= 0) return new ArrayList<>();

        String baseSql = "select a.*, e.emp_name from app a "
                       + "join emp e on a.app_req_id = e.emp_no "
                       + "where a.app_req_id = ? ";

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

        String finalSql = "select * from ("
                        + "  select rownum RN, TMP.* FROM (" + baseSql + ") TMP"
                        + ") where RN between ? and ?";

        paramList.add(pageVO.getBeginRownum());
        paramList.add(pageVO.getEndRownum());

        return jdbcTemplate.query(finalSql, appMapper, paramList.toArray());
    }

    public int countMyListByFilter(String empNo, String searchAppType, String searchAppStatus) {
        if (empNo == null) return 0;

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
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, paramList.toArray());
            return count != null ? count : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    public List<AppDto> selectMyApprList(String empNo) {
        String sql = "select a.*, e.emp_name from app_line l "
                   + "join app a on l.app_id = a.app_id "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where l.app_app_id = ? "
                   + "order by a.app_id desc";
        return jdbcTemplate.query(sql, appMapper, empNo);
    }

    public List<AppDto> selectMyApprListByFilter(PageVO pageVO, String empNo,
            String searchAppType, String searchAppStatus) {
        if (empNo == null || pageVO.getBeginRownum() <= 0) return new ArrayList<>();

        String baseSql = "select a.*, e.emp_name from app_line l "
                       + "join app a on l.app_id = a.app_id "
                       + "join emp e on a.app_req_id = e.emp_no "
                       + "where l.app_app_id = ? ";

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

        String finalSql = "select * from ("
                        + "  select rownum RN, TMP.* FROM (" + baseSql + ") TMP"
                        + ") where RN between ? and ?";

        paramList.add(pageVO.getBeginRownum());
        paramList.add(pageVO.getEndRownum());

        return jdbcTemplate.query(finalSql, appMapper, paramList.toArray());
    }

    public int countMyApprListByFilter(String empNo, String searchAppType, String searchAppStatus) {
        if (empNo == null) return 0;

        String sql = "select count(*) from app_line l "
                   + "join app a on l.app_id = a.app_id "
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
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, paramList.toArray());
            return count != null ? count : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    public List<AppDto> selectMyNoneList(String empNo) {
        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where a.app_req_id = ? and a.app_status = '대기' "
                   + "order by a.app_id desc";
        return jdbcTemplate.query(sql, appMapper, empNo);
    }

    public List<AppDto> selectMyIngList(String empNo) {
        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where a.app_req_id = ? and a.app_status = '진행중' "
                   + "order by a.app_id desc";
        return jdbcTemplate.query(sql, appMapper, empNo);
    }

    public List<AppDto> selectMyRejList(String empNo) {
        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where a.app_req_id = ? and a.app_status = '반려' "
                   + "order by a.app_id desc";
        return jdbcTemplate.query(sql, appMapper, empNo);
    }

    // ===== 전체 조회 (관리자용) =====
    public List<AppDto> selectAllList(PageVO pageVO, String searchEmpName,
            String searchAppType, String searchAppStatus) {
        String baseSql = "select a.*, e.emp_name from app a "
                       + "join emp e on a.app_req_id = e.emp_no "
                       + "where 1=1 ";

        List<Object> paramList = new ArrayList<>();

        if (searchEmpName != null && !searchEmpName.trim().isEmpty()) {
            baseSql += "and e.emp_name like ? ";
            paramList.add("%" + searchEmpName.trim() + "%");
        }
        if (searchAppType != null && !searchAppType.trim().isEmpty()) {
            baseSql += "and a.app_type = ? ";
            paramList.add(searchAppType.trim());
        }
        if (searchAppStatus != null && !searchAppStatus.trim().isEmpty()) {
            baseSql += "and a.app_status = ? ";
            paramList.add(searchAppStatus.trim());
        }

        baseSql += "order by a.app_id desc";

        String finalSql = "select * from ("
                        + "  select rownum RN, TMP.* FROM (" + baseSql + ") TMP"
                        + ") where RN between ? and ?";

        paramList.add(pageVO.getBeginRownum());
        paramList.add(pageVO.getEndRownum());

        if (pageVO.getBeginRownum() <= 0 || pageVO.getEndRownum() <= 0) return new ArrayList<>();
        return jdbcTemplate.query(finalSql, appMapper, paramList.toArray());
    }

    public int countAll(String searchEmpName, String searchAppType, String searchAppStatus) {
        String sql = "select count(*) from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where 1=1 ";

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
            return 0;
        }
    }

    // ===== 검색 =====
    public List<AppDto> searchList(String empNo, String column, String keyword) {
        Set<String> allowSearch = Set.of("app_title", "app_type", "app_status");
        if (!allowSearch.contains(column)) return new ArrayList<>();

        String sql = "select a.*, e.emp_name from app a "
                   + "join emp e on a.app_req_id = e.emp_no "
                   + "where a.app_req_id = ? "
                   + "and a." + column + " like ? "
                   + "order by a.app_id desc";
        return jdbcTemplate.query(sql, appMapper, empNo, "%" + keyword + "%");
    }

    public List<AppDto> searchApprover(String keyword) {
        String sql = "select emp_no, emp_name, emp_dept, emp_position "
                   + "from emp "
                   + "where (emp_name like ? or emp_dept like ?) "
                   + "and emp_use_yn = 'Y'";
        return jdbcTemplate.query(sql, (rs, rn) -> {
            AppDto dto = new AppDto();
            dto.setAppReqId(rs.getString("emp_no"));
            dto.setAppTitle(rs.getString("emp_name"));
            dto.setAppContent(rs.getString("emp_dept"));
            dto.setAppType(rs.getString("emp_position"));
            return dto;
        }, "%" + keyword + "%", "%" + keyword + "%");
    }

    // picker용 결재자 검색
    public List<Map<String, Object>> searchApproverForPicker(String keyword, List<String> excludes) {
        String sql = "select e.emp_no, e.emp_name, e.emp_position, d.dept_name as emp_dept, p.position_level "
                   + "from emp e "
                   + "left join dept d on to_number(e.emp_dept) = d.dept_id "
                   + "left join position_item p on e.position_id = p.position_id "
                   + "where e.emp_use_yn = 'Y' "
                   + "and (e.emp_name like ? or d.dept_name like ?) ";

        List<Object> params = new ArrayList<>();
        params.add("%" + keyword + "%");
        params.add("%" + keyword + "%");

        if (excludes != null && !excludes.isEmpty()) {
            String placeholders = excludes.stream()
                    .map(e -> "?")
                    .collect(java.util.stream.Collectors.joining(", "));
            sql += "and e.emp_no not in (" + placeholders + ") ";
            params.addAll(excludes);
        }

        sql += "order by p.position_level asc nulls last, e.emp_name asc";

        return jdbcTemplate.query(sql, (rs, rn) -> {
            Map<String, Object> map = new HashMap<>();
            map.put("empNo",       rs.getString("emp_no"));
            map.put("empName",     rs.getString("emp_name"));
            map.put("empPosition", rs.getString("emp_position"));
            map.put("empDept",     rs.getString("emp_dept"));
            int level = rs.getInt("position_level");
            map.put("positionLevel", rs.wasNull() ? 99 : level);
            return map;
        }, params.toArray());
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

    // ===== 수정/삭제 =====
    public void updateAppStatus(int appId, String status) {
        String sql = "update app set app_status = ? where app_id = ?";
        jdbcTemplate.update(sql, status, appId);
    }

    public boolean delete(int appId) {
        String sql = "delete app where app_id = ?";
        return jdbcTemplate.update(sql, appId) > 0;
    }

    // ===== 카운트 =====
    public int countMyPenddingApp(String empNo) {
        String sql = "select count(*) from app a join app_line al "
                   + "on a.app_id = al.app_id "
                   + "where al.app_app_id = ? and al.app_line_status = '진행중'";
        try {
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, empNo);
            return count != null ? count : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    // ===== 유틸 =====
    public String selectEmpNameById(String loginId) {
        String sql = "select emp_name from emp where emp_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, String.class, loginId);
        } catch (Exception e) {
            return null;
        }
    }

    public String selectEmpNoById(String loginId) {
        String sql = "select emp_no from emp where emp_id = ?";
        List<String> list = jdbcTemplate.queryForList(sql, String.class, loginId);
        return list.isEmpty() ? null : list.get(0);
    }

    public String selectDeptNameById(int deptId) {
        String sql = "select dept_name from dept where dept_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, String.class, deptId);
        } catch (Exception e) {
            return "소속없음";
        }
    }

    public String selectDeptNameByCode(String deptNo) {
        if (deptNo == null || deptNo.isEmpty()) return "-";
        String sql = "select dept_name from dept where dept_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, String.class, deptNo);
        } catch (Exception e) {
            return "-";
        }
    }

    public List<AppDto> selectByAppTypeList(PageVO pageVO) {
        if (pageVO == null) return selectList(1, 10);
        if (pageVO.isList() || !allowList.contains(pageVO.getColumn())) {
            return selectList(pageVO.getPage(), pageVO.getSize());
        }

        String sql = "select * from ("
                   + "  select rownum RN, TMP.* from ("
                   + "    select a.*, e.emp_name from app a "
                   + "    join emp e on a.app_req_id = e.emp_no "
                   + "    where a.app_type = ? order by a.app_id desc"
                   + "  ) TMP"
                   + ") where rn between ? and ?";
        return jdbcTemplate.query(sql, appMapper,
                pageVO.getKeyword(), pageVO.getBeginRownum(), pageVO.getEndRownum());
    }
}