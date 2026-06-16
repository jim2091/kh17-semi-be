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
    
    private double attnWorkTime;     
    
    private String attnStatus;       // '출근전', '출근중', '퇴근', '결근'
    // ✨ [주석 수정] '미확인' 제거 및 NULL 가능 명시
    private String attnRecord;       // NULL(기본값), '정상출근', '지각', '조퇴', '결근', '휴가'

    private String inTime;           // "HH:mm" 형태 입력용
    private String outTime;          // "HH:mm" 형태 입력용
    
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

    public String getConvertedWorkTime() {
        if (this.attnWorkTime <= 0) {
            return "-";
        }
        int hours = (int) this.attnWorkTime; 
        int minutes = (int) Math.round((this.attnWorkTime - hours) * 60); 
        
        return String.format("%d.%02dh", hours, minutes);
    }
}