package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class EmpAttachDto {
	private String empNo;
	private int attachNo;
	private Timestamp downloadTime;
}
