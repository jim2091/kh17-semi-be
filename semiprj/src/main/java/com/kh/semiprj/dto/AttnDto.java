package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class AttnDto {
	private long attnId;
	private Timestamp attnWorkDate;
	private Timestamp attnInTime;
	private Timestamp attnOutTime;
	private double attnWorkTime;
	private String attnStatus;
	private String attnRecord; 
	
}
