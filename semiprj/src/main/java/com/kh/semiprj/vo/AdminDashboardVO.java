package com.kh.semiprj.vo;

import java.util.List;

import lombok.Data;

@Data
public class AdminDashboardVO {
    // 상단 요약 카드
    private int totalEmpCount;
    private int todayCheckedInCount;
    private int waitingEmpCount;
    private int monthlyLeaveCount;

    // 결재 요약
    private int approvalTotalCount;
    private int approvalApproveCount;
    private int approvalIngCount;
    private int approvalRejectCount;

    private int approvalApprovePercent;
    private int approvalIngPercent;
    private int approvalRejectPercent;
    private int approvalIngEndPercent;

    // 근태 차트
    private List<AttendanceStatVO> attendanceStats;
    private int attendanceChartMax;
    private int attendanceChart4;
    private int attendanceChart3;
    private int attendanceChart2;
    private int attendanceChart1;

    // 부서 현황
    private List<DeptEmpCountVO> deptEmpCountList;

    // 최근 가입 직원
    private List<RecentEmpVO> recentEmpList;

    // 선택 월
    private String selectedMonth;
    
    // 오늘 생일자
    private List<TodayBirthdayVO> todayBirthdayList;

    // 최근 공지사항
    private List<RecentNoticeVO> recentNoticeList;

    // 최근 로그인 통계
    private List<LoginStatVO> loginStatList;
    
    // 부서 현황 차트 최대값
    private int maxDeptEmpCount;
    
    // 최근 로그인 현황 차트 최대값
    private int loginChartMax;
}