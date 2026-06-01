package com.kh.semiprj.dto;

import java.sql.Timestamp;

import lombok.Data;

//전자결재

@Data
public class AppDto {
private int appId;
private String appReqId;
private String appTitle;
private String appContent;
private String appType;
private Timestamp appDate;
private String appStatus;
private String appSaveYn;
}
