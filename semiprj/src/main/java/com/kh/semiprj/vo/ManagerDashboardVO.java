package com.kh.semiprj.vo;

import java.util.List;

import lombok.Data;

@Data
public class ManagerDashboardVO {
	//얘네는 attn_record 읽는게 아니라 시간으로 계산 
	private int memberCount;
	
	private String managedDeptId;
	private String selectedDeptId;
	private String selectedMonth;
	
	private List<ManagedDeptVO> managedDeptList;
	
	private int checkedInCount;
	private int workingNowCount;
	
	private int normalCount;
	private int lateCount;
	private int earlyLeaveCount;
	private int lateEarlyCount;
	private int leaveCount;
	private int uncheckedCount;
	
	private int approvalTotalCount;
	private int approvalApproveCount;
	private int approvalRejectCount;
	private int approvalIngCount;
	
	private List<AttendanceStatVO> attendanceStats;
	private List<ApprovalStatVO> approvalStats;
	private List<LeaveCalendarVO> leaveList;
	private List<DeptMemberStatusVO> memberList;
	
	private int monthlyLeaveCount;
	
	private double attendanceRate;
	
}
