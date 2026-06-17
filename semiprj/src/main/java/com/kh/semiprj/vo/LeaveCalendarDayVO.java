package com.kh.semiprj.vo;

import lombok.Data;

@Data
public class LeaveCalendarDayVO {
	private String date;      // 2026-06-16
    private int day;          // 16
    private boolean currentMonth;
    private int leaveCount;   // 해당 날짜 휴가자 수
}
