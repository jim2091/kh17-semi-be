package com.kh.semiprj.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.kh.semiprj.dao.DeptDashboardDao;
import com.kh.semiprj.vo.ApprovalStatVO;
import com.kh.semiprj.vo.AttendanceStatVO;
import com.kh.semiprj.vo.DeptMemberStatusVO;
import com.kh.semiprj.vo.LeaveCalendarVO;
import com.kh.semiprj.vo.ManagedDeptVO;
import com.kh.semiprj.vo.ManagerDashboardVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class DeptDashboardService {
	private final DeptDashboardDao deptDashboardDao;
	
	public ManagerDashboardVO createDashboard(String empNo) {
		String deptId = deptDashboardDao.selectManagedDeptNo(empNo);
		
		if(deptId == null) {
			return null;
		}
		
		List<DeptMemberStatusVO> memberList = deptDashboardDao.selectTodayMemberStatusList(deptId);
		List<AttendanceStatVO> attendanceStats = deptDashboardDao.selectAttendanceStats(deptId);
		List<ApprovalStatVO> approvalStats = deptDashboardDao.selectApprovalStats(deptId);
		List<LeaveCalendarVO> leaveList = deptDashboardDao.selectLeaveList(deptId);
		
		ManagerDashboardVO dashboard = new ManagerDashboardVO();
		
		dashboard.setMemberList(memberList);
		dashboard.setAttendaceStats(attendanceStats);
		dashboard.setApprovalStats(approvalStats);
		dashboard.setLeaveList(leaveList);
		
		dashboard.setMemberCount(memberList.size());
		
		int normalCount = 0;
		for (DeptMemberStatusVO member : memberList) {
			if (member.getAttnRecord().equals("정상근무")) {
				normalCount++;
			}
		}
		dashboard.setNormalCount(normalCount);
		
		int lateCount = 0;
		for (DeptMemberStatusVO member : memberList) {
			if (member.getAttnRecord().equals("지각")) {
				lateCount++;
			}
		}
		dashboard.setLateCount(lateCount);
		
		int earlyLeaveCount = 0;
		for (DeptMemberStatusVO member : memberList) {
			if (member.getAttnRecord().equals("조퇴")) {
				earlyLeaveCount++;
			}
		}
		dashboard.setEarlyLeaveCount(earlyLeaveCount);
		
		int lateEarlyCount = 0;
		for (DeptMemberStatusVO member : memberList) {
			if (member.getAttnRecord().equals("지각/조퇴")) {
				lateEarlyCount++;
			}
		}
		dashboard.setLateEarlyCount(lateEarlyCount);
		
		int leaveCount = 0;
		for (DeptMemberStatusVO member : memberList) {
			if (member.getAttnRecord().equals("휴가")) {
				leaveCount++;
			}
		}
		dashboard.setLeaveCount(leaveCount);
		
		int uncheckedCount = 0;
		for (DeptMemberStatusVO member : memberList) {
			if (member.getAttnRecord().equals("미확인")) {
				uncheckedCount++;
			}
		}
		dashboard.setUncheckedCount(uncheckedCount);
		
		int checkedInCount = 0;
		for (DeptMemberStatusVO member : memberList) {
			if (member.getAttnInTime() != null) {
				checkedInCount++;
			}
		}
		dashboard.setCheckedInCount(checkedInCount);
		
		int WorkingNowCount = 0;
		for (DeptMemberStatusVO member : memberList) {
			if (member.getAttnInTime() != null && member.getAttnOutTime() == null) {
				WorkingNowCount++;
			}
		}
		dashboard.setWorkingNowCount(WorkingNowCount);
		
		int approvalTotalCount = 0;
		int approvalApproveCount = 0;
		int approvalIngCount = 0;
		int approvalRejectCount = 0;
		for (ApprovalStatVO approval : approvalStats) {
			approvalTotalCount += approval.getCount();
			
			if (approval.getStatus().equals("승인")) {
				approvalApproveCount += approval.getCount();
			}
			else if (approval.getStatus().equals("처리중")
					|| approval.getStatus().equals("대기")) {
				approvalIngCount += approval.getCount();
			}
			else if (approval.getStatus().equals("반려")) {
				approvalRejectCount += approval.getCount();
			}
		}
		
		dashboard.setApprovalTotalCount(approvalTotalCount);
		dashboard.setApprovalApproveCount(approvalApproveCount);
		dashboard.setApprovalIngCount(approvalIngCount);
		dashboard.setApprovalRejectCount(approvalRejectCount);
		
		List<ManagedDeptVO> managedDeptList = deptDashboardDao.selectManagedDeptList(deptId);
		dashboard.setManagedDeptId(deptId);
		dashboard.setSelectedDeptId(deptId);
		dashboard.setManagedDeptList(managedDeptList);
		
		return dashboard;
	}
}
