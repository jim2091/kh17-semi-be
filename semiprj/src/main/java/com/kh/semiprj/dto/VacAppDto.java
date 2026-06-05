package com.kh.semiprj.dto;

import lombok.Data;

@Data
public class VacAppDto {

    private int appId;          // 공통 PK, 외래키 연결 기준
    private String appReqId;
    private String appTitle;
    private String appContent;
    private String appType;
    private String appDate;
    private String appStatus;
    private String appSaveYn;

    private String vacStartDate;
    private String vacEndDate;
    private String vacType;
}