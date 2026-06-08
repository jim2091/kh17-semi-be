package com.kh.semiprj.dto;


import lombok.Data;

@Data
public class AppLineDto {
    private int appLineId;
    private int appId;
    private String appAppId;       // 결재자 사번
    private int appLineOrder;      // 결재 순서
    private String appLineType;    // 문서 종류
    private String appLineStatus;  // 대기 / 진행중 / 완료 / 반려
    private String appLineDate;    // 결재일
    private String appLineRej;     // 반려 사유

    private String empName;        // 결재자 이름
    private String empDept;        // 결재자 부서
    private String empPosition;    // 결재자 직위
}