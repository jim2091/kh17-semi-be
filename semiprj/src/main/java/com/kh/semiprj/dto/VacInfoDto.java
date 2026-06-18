package com.kh.semiprj.dto;

import lombok.Data;

@Data
public class VacInfoDto {
	private int vacNo;
	private String empNo;
	private int vacYear;
	private int vacTot;
	private int vacCnt;
	private int vacUsed;
	private String vacReason;
}
