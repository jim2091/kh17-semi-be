package com.kh.semiprj.dto;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class AttnDto {
    private Long attnId;
    private String empNo;
    private Timestamp attnWorkDate;
    private Timestamp attnInTime;
    private Timestamp attnOutTime;
    private int attnWorkTime;
    private String attnStatus;
    private String attnRecord;

    private String year;
    private String month;
    private Integer planWorkTime;
    private int vacTot;
    private int vacCnt;

    private String empName;
    private String deptCode;      // 매핑: EMP_DEPT
    private String positionCode;  // 매핑: EMP_POSITION
    private String startDate;
    private String endDate;
}