package com.kh.semiprj.vo;

import lombok.Data;

@Data
public class AttendanceStatVO {
	private String label;
	private int normalCount;
	private int lateCount;
	private int earlyLeaveCount;
	private int lateEarlyCount;
	private int leaveCount;
	private int uncheckedCount;
	private int absentCount;
}
