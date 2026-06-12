package com.kh.semiprj.dto;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class AttnDto {
    private Long attnId;
    private String empNo;
    private Timestamp attnWorkDate;
    private Timestamp attnInTime;    // DB 저장용
    private Timestamp attnOutTime;   // DB 저장용
    private int attnWorkTime;
    private String attnStatus;       // '출근전', '출근중', '퇴근', '결근'
    private String attnRecord;       // '미확인', '정상출근', '지각', '조퇴', '결근'

    // --- 추가: 시간 입력을 위한 필드 ---
    private String inTime;           // "HH:mm" 형태 입력용
    private String outTime;          // "HH:mm" 형태 입력용
    
    // 기존 필드들
    private String year;
    private String month;
    private Integer planWorkTime;
    private int vacTot;
    private int vacCnt;
    private String empName;
    private String deptCode;
    private String positionCode;
    private String startDate;
    private String endDate;
}