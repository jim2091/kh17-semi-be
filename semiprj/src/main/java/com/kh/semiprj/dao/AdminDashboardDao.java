package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.mapper.ApprovalStatMapper;
import com.kh.semiprj.mapper.AttendanceStatMapper;
import com.kh.semiprj.mapper.DeptEmpCountMapper;
import com.kh.semiprj.mapper.LoginStatMapper;
import com.kh.semiprj.mapper.RecentEmpMapper;
import com.kh.semiprj.mapper.RecentNoticeMapper;
import com.kh.semiprj.mapper.TodayBirthdayMapper;
import com.kh.semiprj.vo.ApprovalStatVO;
import com.kh.semiprj.vo.AttendanceStatVO;
import com.kh.semiprj.vo.DeptEmpCountVO;
import com.kh.semiprj.vo.LoginStatVO;
import com.kh.semiprj.vo.RecentEmpVO;
import com.kh.semiprj.vo.RecentNoticeVO;
import com.kh.semiprj.vo.TodayBirthdayVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AdminDashboardDao {

    private final JdbcTemplate jdbcTemplate;
    private final AttendanceStatMapper attendanceStatMapper;
    private final ApprovalStatMapper approvalStatMapper;
    private final DeptEmpCountMapper deptEmpCountMapper;
    private final RecentEmpMapper recentEmpMapper;
    private final TodayBirthdayMapper todayBirthdayMapper;
    private final RecentNoticeMapper recentNoticeMapper;
    private final LoginStatMapper loginStatMapper;

    // 전체 직원 수
    public int selectTotalEmpCount() {
        String sql = """
                select count(*)
                from emp
                where emp_level != '관리자'
                """;
        return jdbcTemplate.queryForObject(sql, int.class);
    }

    // 오늘 출근한 직원 수
    public int selectTodayCheckedInCount() {
        String sql = """
                select count(*)
                from attn
                where attn_work_date = trunc(sysdate)
                and attn_in_time is not null
                """;
        return jdbcTemplate.queryForObject(sql, int.class);
    }

    // 가입 승인 대기 직원 수
    public int selectWaitingEmpCount() {
        String sql = """
                select count(*)
                from emp
                where emp_use_yn = 'N'
                """;
        return jdbcTemplate.queryForObject(sql, int.class);
    }

    // 선택 월 휴가 사용 일수
    public int selectMonthlyLeaveCount(String month) {
        String sql = """
                select count(*)
                from vac_history
                where vac_date >= ? || '-01'
                and vac_date < to_char(add_months(to_date(? || '-01', 'YYYY-MM-DD'), 1), 'YYYY-MM-DD')
                """;

        Object[] params = {month, month};
        return jdbcTemplate.queryForObject(sql, int.class, params);
    }

    // 전사 근태 통계 - 월간
    public List<AttendanceStatVO> selectAttendanceStats(String month) {
        String sql = """
                select 
                    to_char(a.attn_work_date, 'W') || '주차' as label,

                    sum(case when a.attn_record = '정상근무' then 1 else 0 end) as normal_count,
                    sum(case when a.attn_record = '지각' then 1 else 0 end) as late_count,
                    sum(case when a.attn_record = '조퇴' then 1 else 0 end) as early_leave_count,
                    sum(case when a.attn_record = '지각-조퇴' then 1 else 0 end) as late_early_count,
                    sum(case when a.attn_record = '결근' then 1 else 0 end) as absent_count,
                    sum(case when a.attn_record = '휴가' then 1 else 0 end) as leave_count,
                    sum(case when a.attn_record = '미확인' then 1 else 0 end) as unchecked_count

                from attn a
                join emp e on a.emp_no = e.emp_no
                where e.emp_level != '관리자'
                and e.emp_use_yn = 'Y' 
                and a.attn_work_date >= to_date(? || '-01', 'YYYY-MM-DD')
                and a.attn_work_date < add_months(to_date(? || '-01', 'YYYY-MM-DD'), 1)
                group by to_char(a.attn_work_date, 'W')
                order by to_number(to_char(a.attn_work_date, 'W'))
                """;

        Object[] params = {month, month};
        return jdbcTemplate.query(sql, attendanceStatMapper, params);
    }

    // 전사 결재 통계
    public List<ApprovalStatVO> selectApprovalStats(String month) {
        String sql = """
                select 
                    app_status as status,
                    count(*) as count
                from app
                where app_date >= ? || '-01'
                and app_date < to_char(add_months(to_date(? || '-01', 'YYYY-MM-DD'), 1), 'YYYY-MM-DD')
                group by app_status
                order by
                    case app_status
                        when '승인' then 1
                        when '처리중' then 2
                        when '대기' then 3
                        when '반려' then 4
                        else 5
                    end
                """;

        Object[] params = {month, month};
        return jdbcTemplate.query(sql, approvalStatMapper, params);
    }

    // 부서별 직원 수
    public List<DeptEmpCountVO> selectDeptEmpCountList() {
        String sql = """
                select
                    parent.dept_id,
                    parent.dept_name,
                    count(e.emp_no) as emp_count
                from dept parent
                left join dept child
                    on child.dept_id in (
                        select dept_id
                        from dept
                        start with dept_id = parent.dept_id
                        connect by prior dept_id = parent_dept_id
                    )
                left join emp e
                    on e.emp_dept = child.dept_id
                    and e.emp_level != '관리자'
                    and e.emp_use_yn = 'Y' 
                where parent.parent_dept_id = 10
                group by parent.dept_id, parent.dept_name
                order by parent.dept_id
                """;

        return jdbcTemplate.query(sql, deptEmpCountMapper);
    }

    // 최근 가입 직원
    public List<RecentEmpVO> selectRecentEmpList() {
        String sql = """
                select *
                from (
                    select
                        e.emp_no,
                        e.emp_name,
                        e.emp_position,
                        d.dept_name,
                        to_char(e.emp_create_at, 'YYYY-MM-DD') as emp_create_at
                    from emp e
                    left join dept d on e.emp_dept = d.dept_id
                    where e.emp_level != '관리자'
                    order by e.emp_create_at desc
                )
                where rownum <= 3
                """;

        return jdbcTemplate.query(sql, recentEmpMapper);
    }
    
    public List<TodayBirthdayVO> selectTodayBirthdayList() {
        String sql = """
                select
                    e.emp_no,
                    e.emp_name,
                    e.emp_position,
                    d.dept_name
                from emp e
                left join dept d on e.emp_dept = d.dept_id
                where e.emp_level != '관리자'
                and substr(e.emp_birth, 6, 5) = to_char(sysdate, 'MM-DD')
                order by e.emp_name asc
                """;

        return jdbcTemplate.query(sql, todayBirthdayMapper);
    }
    
    public List<RecentNoticeVO> selectRecentNoticeList() {
        String sql = """
                select *
                from (
                    select
                        board_no as notice_no,
                        board_title as notice_title,
                        to_char(board_wtime, 'YYYY-MM-DD') as notice_date
                    from board
                    where board_head = '공지'
                    order by board_no desc
                )
                where rownum <= 4
                """;

        return jdbcTemplate.query(sql, recentNoticeMapper);
    }
    
    public List<LoginStatVO> selectLoginStatList() {
        String sql = """
                select
                    to_char(base.day, 'MM/DD') as label,
                    count(h.emp_history_origin) as count
                from (
                    select trunc(sysdate) - 6 + level - 1 as day
                    from dual
                    connect by level <= 7
                ) base
                left join emp_history h
                    on trunc(h.emp_history_time) = base.day
                group by base.day
                order by base.day
                """;

        return jdbcTemplate.query(sql, loginStatMapper);
    }
}