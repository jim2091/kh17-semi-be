package com.kh.semiprj.service;

import java.time.LocalDate;
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

    public ManagerDashboardVO createDashboard(String empNo, String selectedDeptId, String selectedMonth) {

        // 1. 로그인한 사원이 담당하는 최상위 부서
        String managedDeptId = deptDashboardDao.selectManagedDeptNo(empNo);
        
        if(managedDeptId == null) {
        	return null;
        }
        // 2. 선택 부서가 없으면 본인이 관리하는 최상위 부서 기준
        if (selectedDeptId == null || selectedDeptId.isBlank()) {
        	selectedDeptId = managedDeptId;
        }
        
        // 3. 선택 월이 없으면 현재 월
        if (selectedMonth == null || selectedMonth.isBlank()) {
        	selectedMonth = LocalDate.now().toString().substring(0, 7);
        }
        
        // 4. 부서 선택 박스용 목록
        List<ManagedDeptVO> managedDeptList = deptDashboardDao.selectManagedDeptList(managedDeptId);
        
        // 5. 실제 대시보드 데이터 조회
        List<DeptMemberStatusVO> memberList = deptDashboardDao.selectTodayMemberStatusList(selectedDeptId);
        List<AttendanceStatVO> attendanceStats = deptDashboardDao.selectAttendanceStats(selectedDeptId, selectedMonth);
        List<ApprovalStatVO> approvalStats = deptDashboardDao.selectApprovalStats(selectedDeptId, selectedMonth);
        List<LeaveCalendarVO> leaveList = deptDashboardDao.selectLeaveList(selectedDeptId, selectedMonth);
        
        // 6. 대시보드 VO 조립
        ManagerDashboardVO dashboard = new ManagerDashboardVO();
        
        dashboard.setManagedDeptId(managedDeptId);
        dashboard.setSelectedDeptId(selectedDeptId);
        dashboard.setSelectedMonth(selectedMonth);
        dashboard.setManagedDeptList(managedDeptList);
        
        dashboard.setMemberList(memberList);
        dashboard.setAttendanceStats(attendanceStats);
        dashboard.setApprovalStats(approvalStats);
        dashboard.setLeaveList(leaveList);
        
        dashboard.setMemberCount(memberList.size());
        
        // 7. 오늘 근태 요약 집계
        int normalCount = 0;
        int lateCount = 0;
        int earlyLeaveCount = 0;
        int lateEarlyCount = 0;
        int leaveCount = 0;
        int uncheckedCount = 0;
        int checkedInCount = 0;
        int workingNowCount = 0;
        
        for (DeptMemberStatusVO member : memberList) {
        	String record = member.getAttnRecord();
        	
        	if ("정상근무".equals(record)) {
        		normalCount++;
        	}
        	else if ("지각".equals(record)) {
        		lateCount++;
        	}
        	else if ("조퇴".equals(record)) {
        		earlyLeaveCount++;
        	}
        	else if ("지각/조퇴".equals(record)) {
        		lateEarlyCount++;
        	}
        	else if ("휴가".equals(record)) {
        		leaveCount++;
        	}
        	else if ("미확인".equals(record)) {
        		uncheckedCount++;
        	}
        	
        	if (member.getAttnInTime() != null && !member.getAttnInTime().isBlank()) {
        		checkedInCount++;
        	}
        	
        	if (member.getAttnInTime() != null && !member.getAttnInTime().isBlank() 
        		&& (member.getAttnOutTime() == null || member.getAttnOutTime().isBlank())) {
        		workingNowCount++;
        	}
        }
    	dashboard.setNormalCount(normalCount);
        dashboard.setLateCount(lateCount);
        dashboard.setEarlyLeaveCount(earlyLeaveCount);
        dashboard.setLateEarlyCount(lateEarlyCount);
        dashboard.setLeaveCount(leaveCount);
        dashboard.setUncheckedCount(uncheckedCount);
        dashboard.setCheckedInCount(checkedInCount);
        dashboard.setWorkingNowCount(workingNowCount);
        
        // 8. 이번 달 결재 요약 집계
        int approvalTotalCount = 0;
        int approvalApproveCount = 0;
        int approvalIngCount = 0;
        int approvalRejectCount = 0;
        
        for (ApprovalStatVO approval : approvalStats) {
        	String status = approval.getStatus();
        	int count = approval.getCount();
        	
        	approvalTotalCount += count;
        	
        	if ("승인".equals(status)) {
        		approvalApproveCount += count;
        	}
        	else if ("처리중".equals(status) || "대기".equals(status)) {
        		approvalIngCount += count;
        	}
        	else if ("반려".equals(status)) {
        		approvalRejectCount += count;
        	}
        }
        
        dashboard.setApprovalTotalCount(approvalTotalCount);
        dashboard.setApprovalApproveCount(approvalApproveCount);
        dashboard.setApprovalIngCount(approvalIngCount);
        dashboard.setApprovalRejectCount(approvalRejectCount);

        // 9. 이번 달 휴가 사용 일수
        dashboard.setMonthlyLeaveCount(leaveList.size());
        
        //10. 출근율
        double attendanceRate = 0;

        if (dashboard.getMemberCount() > 0) {
            attendanceRate = (double) checkedInCount / dashboard.getMemberCount() * 100;
        }

        dashboard.setAttendanceRate(attendanceRate);
        
        return dashboard;
        
    }
}