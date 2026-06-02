package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class EmpHistoryDto {
	private int empHistoryNo;
	private String empHistoryOrigin;
	private Timestamp empHistoryTime;
	private String empHistoryAddress;
	private String empHistoryAgent;

}
