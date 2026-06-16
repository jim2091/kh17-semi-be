package com.kh.semiprj.dao;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kh.semiprj.mapper.ApprovalStatMapper;
import com.kh.semiprj.mapper.AttendanceStatMapper;
import com.kh.semiprj.mapper.LeaveCalendarMapper;
import com.kh.semiprj.mapper.ManagedDeptMapper;
import com.kh.semiprj.mapper.MemberStatusMapper;
import com.kh.semiprj.vo.ApprovalStatVO;
import com.kh.semiprj.vo.AttendanceStatVO;
import com.kh.semiprj.vo.DeptMemberStatusVO;
import com.kh.semiprj.vo.LeaveCalendarVO;
import com.kh.semiprj.vo.ManagedDeptVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DeptDashboardDao {
	private final JdbcTemplate jdbcTemplate;
	private final MemberStatusMapper memberStatusMapper;
	private final AttendanceStatMapper attendanceStatMapper;
	private final ApprovalStatMapper approvalStatMapper;
	private final LeaveCalendarMapper leaveCalendarMapper;
	private final ManagedDeptMapper managedDeptMapper;
	
	public String selectManagedDeptNo(String empNo) {
		String sql = "select dept_id from dept where dept_head_id = ?";
		Object[] params = { empNo };
		List<String> list = jdbcTemplate.queryForList(sql, String.class, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public List<ManagedDeptVO> selectManagedDeptList(String deptId) {
		String sql = """
				select 
					dept_id, 
					dept_name, 
					parent_dept_id, 
					level - 1 as depth 
				from dept 
				start with dept_id = ? 
				connect by prior dept_id = parent_dept_id 
				order siblings by dept_name asc
				""";
		Object[] params = { deptId };
		return jdbcTemplate.query(sql, managedDeptMapper, params);
	}
	
	public List<DeptMemberStatusVO> selectTodayMemberStatusList(String deptId){
		String sql = """
				select
					e.emp_no,
					e.emp_name,
					d.dept_name,
					p.position_name,
					a.attn_record,
					to_char(a.attn_in_time, 'HH24:MI') as attn_in_time,
					to_char(a.attn_out_time, 'HH24:MI') as attn_out_time
				from emp e 
				join dept d on e.emp_dept = d.dept_id 
				left join position_item p on e.emp_position = p.position_name 
				left join attn a 
					on e.emp_no = a.emp_no 
					and a.attn_work_date = trunc(sysdate)
				where e.emp_dept in (
					select dept_id 
					from dept 
					start with dept_id = ? 
					connect by prior dept_id = parent_dept_id 
				)
				order by d.dept_name asc, p.position_level desc, e.emp_name asc
				""";
		Object[] params = { deptId };
		return jdbcTemplate.query(sql, memberStatusMapper, params);
	}
	
	public List<AttendanceStatVO> selectAttendanceStats(String deptId, String month){
		String sql = """
				select 
					to_char(attn_work_date, 'W') || '주차' as label, 
					
					sum(case when attn_record = '정상근무' then 1 else 0 end) as normal_count,
					sum(case when attn_record = '지각' then 1 else 0 end) as late_count,
					sum(case when attn_record = '조퇴' then 1 else 0 end) as early_leave_count,
					sum(case when attn_record = '지각/조퇴' then 1 else 0 end) as late_early_count,
					sum(case when attn_record = '휴가' then 1 else 0 end) as leave_count,
					sum(case when attn_record = '미확인' then 1 else 0 end) as unchecked_count
					
				from attn a 
				join emp e on a.emp_no = e.emp_no 
				where e.emp_dept in (
					select dept_id from dept 
					start with dept_id = ? 
					connect by prior dept_id = parent_dept_id 
				)
				and a.attn_work_date >= to_date(? || '-01', 'YYYY-MM-DD') 
				and a.attn_work_date < add_months(to_date(? || '-01', 'YYYY-MM-DD'), 1) 
				group by to_char(a.attn_work_date, 'W') 
				order by to_number(to_char(a.attn_work_date, 'W'))
				""";
		Object[] params = { deptId, month, month };
		return jdbcTemplate.query(sql, attendanceStatMapper, params);
	}
	
	public List<ApprovalStatVO> selectApprovalStats(String deptId, String month){
		String sql = """
				select 
					a.app_status as status, 
					count(*) as count 
				from app a 
				join emp e on a.app_req_id = e.emp_no 
				where e.emp_dept in (
					select dept_id 
					from dept 
					start with dept_id = ? 
					connect by prior dept_id = parent_dept_id
				)
				and a.app_date >= ? || '-01'
				and a.app_date < to_char(add_months(to_date(? || '-01', 'YYYY-MM-DD'), 1), 'YYYY-MM-DD')
				group by a.app_status 
				order by 
					case a.app_status 
						when '승인' then 1 
						when '처리중' then 2
						when '대기' then 3
						when '반려' then 4 
						else 5 
					end
				""";
		Object[] params = { deptId, month, month };
		return jdbcTemplate.query(sql, approvalStatMapper, params);
	}
	
	public List<LeaveCalendarVO> selectLeaveList(String deptId, String month){
		String sql = """
				select
					e.emp_no,
					e.emp_name,
					d.dept_name,
					v.vac_date as leave_date
				from vac_history v 
				join app a on v.app_id = a.app_id 
				join emp e on a.app_req_id = e.emp_no 
				join dept d on e.emp_dept = d.dept_id 
				where e.emp_dept in (
					select dept_id from dept 
					start with dept_id = ? 
					connect by prior dept_id = parent_dept_id
				)
				and v.vac_date >= ? || '-01'
				and v.vac_date < to_char(add_months(to_date(? || '-01', 'YYYY-MM-DD'), 1), 'YYYY-MM-DD')
				order by v.vac_date asc, d.dept_name asc, e.emp_name asc
				""";
		Object[] params = { deptId, month, month };
		return jdbcTemplate.query(sql, leaveCalendarMapper, params);
	}
	
	
}
