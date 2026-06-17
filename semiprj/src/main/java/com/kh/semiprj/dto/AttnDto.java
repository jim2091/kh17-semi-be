package com.kh.semiprj.dto;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class AttnDto {
    private Long attnId;
    private String empNo;
    private Timestamp attnWorkDate;
    private Timestamp attnInTime;    // DB 저장용 (출근시간)
    private Timestamp attnOutTime;   // DB 저장용 (퇴근시간)
    private double attnWorkTime;     // 총 근무시간
    
    // ✨ attn_status를 삭제하고 attn_record 하나로 통합 관리합니다.
    // 도메인: '미확인', '정상근무', '지각', '조퇴', '결근', '휴가'
    private String attnRecord;       

    private String inTime;           // 화면 입력용 ("HH:mm")
    private String outTime;          // 화면 입력용 ("HH:mm")
    
    private String year;
    private String month;
    private Integer planWorkTime;
    private int vacTot;
    private int vacCnt;
    private String empName;
    private String deptCode;
    private String deptName;
    private String positionCode;
    private String startDate;
    private String endDate;
    private String vacReason;

    public String getConvertedWorkTime() {
        if (this.attnWorkTime <= 0) {
            return "-";
        }
        int hours = (int) this.attnWorkTime; 
        int minutes = (int) Math.round((this.attnWorkTime - hours) * 60); 
        
        return String.format("%d.%02dh", hours, minutes);
    }
}