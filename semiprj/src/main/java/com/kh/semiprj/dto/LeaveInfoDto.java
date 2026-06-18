package com.kh.semiprj.dto;

import lombok.Data;

@Data
public class LeaveInfoDto {
	private int leaveNo;
	private String empNo;
	private int leaveYear;
	private int leaveTot;
	private int leaveCnt;
	private int leaveUsed;
}
