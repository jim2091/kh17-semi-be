package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class AppLineDto {
private int appLineId;
private int appId;
private int appAppId;
private int appLineOrder;
private String appLineType;
private String appLineStatus;
private Timestamp appLineDate;
private String appLineRej;
}
