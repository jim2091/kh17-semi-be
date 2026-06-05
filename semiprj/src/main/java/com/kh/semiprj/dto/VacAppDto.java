package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class VacAppDto {
private int appId;
private Timestamp vacStartDate;
private Timestamp vacEndDate;
private String vacType;
}
