package com.kh.semiprj.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Service;

import com.kh.semiprj.dao.AdminDashboardDao;
import com.kh.semiprj.vo.AdminDashboardVO;
import com.kh.semiprj.vo.ApprovalStatVO;
import com.kh.semiprj.vo.AttendanceStatVO;
import com.kh.semiprj.vo.DeptEmpCountVO;
import com.kh.semiprj.vo.LoginStatVO;
import com.kh.semiprj.vo.RecentEmpVO;
import com.kh.semiprj.vo.RecentNoticeVO;
import com.kh.semiprj.vo.TodayBirthdayVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminDashboardService {

    private final AdminDashboardDao adminDashboardDao;

    public AdminDashboardVO createDashboard(String selectedMonth) {

        if (selectedMonth == null || selectedMonth.isBlank()) {
            selectedMonth = LocalDate.now().toString().substring(0, 7);
        }

        AdminDashboardVO dashboard = new AdminDashboardVO();

        dashboard.setSelectedMonth(selectedMonth);

        dashboard.setTotalEmpCount(adminDashboardDao.selectTotalEmpCount());
        dashboard.setTodayCheckedInCount(adminDashboardDao.selectTodayCheckedInCount());
        dashboard.setWaitingEmpCount(adminDashboardDao.selectWaitingEmpCount());
        dashboard.setMonthlyLeaveCount(adminDashboardDao.selectMonthlyLeaveCount(selectedMonth));

        List<AttendanceStatVO> attendanceStats =
                adminDashboardDao.selectAttendanceStats(selectedMonth);

        List<ApprovalStatVO> approvalStats =
                adminDashboardDao.selectApprovalStats(selectedMonth);

        List<DeptEmpCountVO> deptEmpCountList =
                adminDashboardDao.selectDeptEmpCountList();

        List<RecentEmpVO> recentEmpList =
                adminDashboardDao.selectRecentEmpList();
        
        List<TodayBirthdayVO> todayBirthdayList =
                adminDashboardDao.selectTodayBirthdayList();

        List<RecentNoticeVO> recentNoticeList =
                adminDashboardDao.selectRecentNoticeList();

        List<LoginStatVO> loginStatList =
                adminDashboardDao.selectLoginStatList();

        dashboard.setAttendanceStats(attendanceStats);
        dashboard.setDeptEmpCountList(deptEmpCountList);
        dashboard.setRecentEmpList(recentEmpList);
        dashboard.setTodayBirthdayList(todayBirthdayList);
        dashboard.setRecentNoticeList(recentNoticeList);
        dashboard.setLoginStatList(loginStatList);

        // 근태 차트 눈금 계산
        int attendanceMax = 0;

        for (AttendanceStatVO stat : attendanceStats) {
            if (stat.getNormalCount() > attendanceMax) attendanceMax = stat.getNormalCount();
            if (stat.getLeaveCount() > attendanceMax) attendanceMax = stat.getLeaveCount();
            if (stat.getLateCount() > attendanceMax) attendanceMax = stat.getLateCount();
            if (stat.getEarlyLeaveCount() > attendanceMax) attendanceMax = stat.getEarlyLeaveCount();
            if (stat.getLateEarlyCount() > attendanceMax) attendanceMax = stat.getLateEarlyCount();
            if (stat.getAbsentCount() > attendanceMax) attendanceMax = stat.getAbsentCount();
        }

        int attendanceStep = 5;

        if (attendanceMax <= 5) attendanceStep = 1;
        else if (attendanceMax <= 10) attendanceStep = 2;
        else if (attendanceMax <= 25) attendanceStep = 5;
        else attendanceStep = 10;

        int attendanceChartMax =
                ((attendanceMax + attendanceStep - 1) / attendanceStep) * attendanceStep;

        if (attendanceChartMax == 0) {
            attendanceChartMax = 5;
        }

        dashboard.setAttendanceChartMax(attendanceChartMax);
        dashboard.setAttendanceChart4(attendanceChartMax * 4 / 5);
        dashboard.setAttendanceChart3(attendanceChartMax * 3 / 5);
        dashboard.setAttendanceChart2(attendanceChartMax * 2 / 5);
        dashboard.setAttendanceChart1(attendanceChartMax * 1 / 5);

        // 결재 집계
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

        int approvalApprovePercent = 0;
        int approvalIngPercent = 0;
        int approvalRejectPercent = 0;
        int approvalIngEndPercent = 0;

        if (approvalTotalCount > 0) {
            approvalApprovePercent =
                    (int) Math.round((double) approvalApproveCount / approvalTotalCount * 100);

            approvalIngPercent =
                    (int) Math.round((double) approvalIngCount / approvalTotalCount * 100);

            approvalRejectPercent =
                    100 - approvalApprovePercent - approvalIngPercent;

            if (approvalRejectPercent < 0) {
                approvalRejectPercent = 0;
            }

            approvalIngEndPercent = approvalApprovePercent + approvalIngPercent;
        }

        dashboard.setApprovalApprovePercent(approvalApprovePercent);
        dashboard.setApprovalIngPercent(approvalIngPercent);
        dashboard.setApprovalRejectPercent(approvalRejectPercent);
        dashboard.setApprovalIngEndPercent(approvalIngEndPercent);
        
        //부서현황차트 최대값 계산
        int maxDeptEmpCount = 0;

        for (DeptEmpCountVO dept : deptEmpCountList) {
            if (dept.getEmpCount() > maxDeptEmpCount) {
                maxDeptEmpCount = dept.getEmpCount();
            }
        }

        dashboard.setMaxDeptEmpCount(maxDeptEmpCount);
        
        // 로그인 현황 차트 최대값 계산
        int loginChartMax = 0;

        for (LoginStatVO stat : loginStatList) {
            if (stat.getCount() > loginChartMax) {
                loginChartMax = stat.getCount();
            }
        }

        if (loginChartMax == 0) {
            loginChartMax = 1;
        }

        dashboard.setLoginChartMax(loginChartMax);
        

        return dashboard;
    }
}