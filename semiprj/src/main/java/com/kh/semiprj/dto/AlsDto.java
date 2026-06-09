package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class AlsDto {
	private int alsId; 
	private int alsOrder; 
	private String alsRegId; 
	private String alsApprId; 
	private Timestamp alsCreateDate; 
}
