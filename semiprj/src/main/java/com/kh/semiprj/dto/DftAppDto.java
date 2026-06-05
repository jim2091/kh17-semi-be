package com.kh.semiprj.dto;

import java.sql.Timestamp;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class DftAppDto {
	private int appId;
	private String dftDate;
}
