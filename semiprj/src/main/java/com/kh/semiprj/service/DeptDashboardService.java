package com.kh.semiprj.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.semiprj.dao.DeptDashboardDao;
import com.kh.semiprj.vo.ApprovalStatVO;
import com.kh.semiprj.vo.AttendanceStatVO;
import com.kh.semiprj.vo.DeptMemberStatusVO;
import com.kh.semiprj.vo.LeaveCalendarDayVO;
import com.kh.semiprj.vo.LeaveCalendarVO;
import com.kh.semiprj.vo.ManagedDeptVO;
import com.kh.semiprj.vo.ManagerDashboardVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class DeptDashboardService {

    private final DeptDashboardDao deptDashboardDao;

    public ManagerDashboardVO createDashboard(String empNo, String selectedDeptId, String selectedMonth, String attnMode) {
    
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
        // 근태 차트 월/주 설정
        if (attnMode == null || attnMode.isBlank()) {
            attnMode = "month";
        }
        
        // 4. 부서 선택 박스용 목록
        List<ManagedDeptVO> managedDeptList = deptDashboardDao.selectManagedDeptList(managedDeptId);
        
        // 5. 실제 대시보드 데이터 조회
        List<DeptMemberStatusVO> memberList = deptDashboardDao.selectTodayMemberStatusList(selectedDeptId);
        List<AttendanceStatVO> attendanceStats =
                deptDashboardDao.selectAttendanceStats(selectedDeptId, selectedMonth, attnMode);
        List<ApprovalStatVO> approvalStats = deptDashboardDao.selectApprovalStats(selectedDeptId, selectedMonth);
        List<LeaveCalendarVO> leaveList = deptDashboardDao.selectLeaveList(selectedDeptId, selectedMonth);
        
        System.out.println("===== 휴가 조회 결과 =====");
        System.out.println("selectedDeptId = " + selectedDeptId);
        System.out.println("selectedMonth = " + selectedMonth);
        System.out.println("leaveList.size() = " + leaveList.size());

        for (LeaveCalendarVO leave : leaveList) {
            System.out.println(
                leave.getEmpNo() + " / " +
                leave.getEmpName() + " / " +
                leave.getDeptName() + " / " +
                leave.getLeaveDate()
            );
        }
        
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
        	else if ("지각-조퇴".equals(record)) {
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
        
        dashboard.setAttnMode(attnMode);
        
        //근태 차트 관련
        int attendanceMax = 0;

        for (AttendanceStatVO stat : attendanceStats) {
            if (stat.getNormalCount() > attendanceMax) {
                attendanceMax = stat.getNormalCount();
            }
            if (stat.getLateCount() > attendanceMax) {
                attendanceMax = stat.getLateCount();
            }
            if (stat.getEarlyLeaveCount() > attendanceMax) {
                attendanceMax = stat.getEarlyLeaveCount();
            }
            if (stat.getLateEarlyCount() > attendanceMax) {
                attendanceMax = stat.getLateEarlyCount();
            }
            if (stat.getAbsentCount() > attendanceMax) {
                attendanceMax = stat.getAbsentCount();
            }
        }

        int attendanceStep = 5;

        if (attendanceMax <= 5) {
            attendanceStep = 1;
        }
        else if (attendanceMax <= 10) {
            attendanceStep = 2;
        }
        else if (attendanceMax <= 25) {
            attendanceStep = 5;
        }
        else {
            attendanceStep = 10;
        }

        int attendanceChartMax = ((attendanceMax + attendanceStep - 1) / attendanceStep) * attendanceStep;

        if (attendanceChartMax == 0) {
            attendanceChartMax = 5;
        }
        
        dashboard.setAttendanceChartMax(attendanceChartMax);
        dashboard.setAttendanceChart4(attendanceChartMax * 4 / 5);
        dashboard.setAttendanceChart3(attendanceChartMax * 3 / 5);
        dashboard.setAttendanceChart2(attendanceChartMax * 2 / 5);
        dashboard.setAttendanceChart1(attendanceChartMax * 1 / 5);
        
        //결재 차트 관련
        int approvalApprovePercent = 0;
        int approvalIngPercent = 0;
        int approvalRejectPercent = 0;
        int approvalIngEndPercent = 0;

        if (approvalTotalCount > 0) {
            approvalApprovePercent = (int)Math.round((double) approvalApproveCount / approvalTotalCount * 100);
            approvalIngPercent = (int)Math.round((double) approvalIngCount / approvalTotalCount * 100);
            approvalRejectPercent = 100 - approvalApprovePercent - approvalIngPercent;

            if (approvalRejectPercent < 0) {
                approvalRejectPercent = 0;
            }

            approvalIngEndPercent = approvalApprovePercent + approvalIngPercent;
        }

        dashboard.setApprovalApprovePercent(approvalApprovePercent);
        dashboard.setApprovalIngPercent(approvalIngPercent);
        dashboard.setApprovalRejectPercent(approvalRejectPercent);
        dashboard.setApprovalIngEndPercent(approvalIngEndPercent);
        
        List<List<LeaveCalendarDayVO>> leaveCalendarWeeks =
                createLeaveCalendarWeeks(selectedMonth, leaveList);
        dashboard.setLeaveCalendarWeeks(leaveCalendarWeeks);
        
        // 부서 구성원 현황
        List<DeptMemberStatusVO> directMemberList =
                deptDashboardDao.selectDirectMemberStatusList(selectedDeptId);
        dashboard.setDirectMemberList(directMemberList);
        dashboard.setDirectMemberCount(directMemberList.size());
        
        return dashboard;
        
    }
    
    private List<List<LeaveCalendarDayVO>> createLeaveCalendarWeeks(
    		String selectedMonth,
    		List<LeaveCalendarVO> leaveList) {
    	
    	Map<String, Integer> leaveCountMap = new HashMap<>();
    	
    	for (LeaveCalendarVO leave : leaveList) {
    		String date = leave.getLeaveDate();
    		
    		int count = leaveCountMap.getOrDefault(date, 0);
    		leaveCountMap.put(date, count + 1);
    	}
    	
    	LocalDate firstDay = LocalDate.parse(selectedMonth + "-01");
    	LocalDate startDay = firstDay.minusDays(firstDay.getDayOfWeek().getValue() % 7);
    	
    	LocalDate lastDay = firstDay.plusMonths(1).minusDays(1);
    	LocalDate endDay = lastDay.plusDays(6 - (lastDay.getDayOfWeek().getValue() % 7));
    	
    	List<List<LeaveCalendarDayVO>> weeks = new ArrayList<>();
    	
    	LocalDate current = startDay;
    	
    	while (!current.isAfter(endDay)) {
    		List<LeaveCalendarDayVO> week = new ArrayList<>();
    		
    		for (int i = 0; i < 7; i++) {
    			LeaveCalendarDayVO day = new LeaveCalendarDayVO();
    			
    			String dateText = current.toString();
    			
    			day.setDate(dateText);
    			day.setDay(current.getDayOfMonth());
    			day.setCurrentMonth(current.getMonthValue() == firstDay.getMonthValue());
    			day.setLeaveCount(leaveCountMap.getOrDefault(dateText, 0));
    			
    			week.add(day);
    			current = current.plusDays(1);
    		}
    		
    		weeks.add(week);
    	}
    	
    	return weeks;
    }
}

