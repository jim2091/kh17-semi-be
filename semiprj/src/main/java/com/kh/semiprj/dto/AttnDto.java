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
    
    // 💡 기존 int에서 double로 변경 (NUMBER(4,2) 데이터 유실 방지)
    private double attnWorkTime;     
    
    private String attnStatus;       // '출근전', '출근중', '퇴근', '결근'
    private String attnRecord;       // '미확인', '정상출근', '지각', '조퇴', '결근'

    // --- 시간 입력을 위한 필드 ---
    private String inTime;           // "HH:mm" 형태 입력용
    private String outTime;          // "HH:mm" 형태 입력용
    
    // 기존 검색 및 통계용 필드들
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

    // 🛠️ [진짜 가상 Getter 구현 구역]
    // 별도의 필드 선언 없이, 이 가상 Getter만 있으면 JSP에서 ${dto.convertedWorkTime}으로 바로 꺼내 쓸 수 있습니다.
    // 어떤 리스트 조회 메서드를 통하든 무조건 2시간 30분 -> 2.30h 형식으로 자동 필터링됩니다.
    public String getConvertedWorkTime() {
        if (this.attnWorkTime <= 0) {
            return "-";
        }
        int hours = (int) this.attnWorkTime; // 정수부 (시간)
        // 소수점 아래 자리에 60분을 곱하고 반올림하여 '분' 계산
        int minutes = (int) Math.round((this.attnWorkTime - hours) * 60); 
        
        return String.format("%d.%02dh", hours, minutes);
    }
}