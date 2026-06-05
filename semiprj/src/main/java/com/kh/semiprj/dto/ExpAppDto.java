package com.kh.semiprj.dto;

import lombok.Data;

@Data
public class ExpAppDto {
    // AppDto 공통 항목
    private int appId;
    private String appReqId;
    private String appTitle;
    private String appContent;
    private String appType;
    private String appDate;
    private String appStatus;
    private String appSaveYn;

    // exp_app 추가 항목
    private String expDate;
    private int expPrice;
    private String expHistory;
    private String expHow;
    private String expPurpose;
}