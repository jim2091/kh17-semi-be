package com.kh.semiprj.service;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.kh.semiprj.dao.AttnDao;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.vo.PageVO;

@Service
public class AttnService {

    @Autowired private AttnDao attnDao;
    
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    public Map<String, Object> getVacationInfo(String empNo) { return attnDao.selectVacationInfo(empNo); }
    public List<AttnDto> getAttendanceList(AttnDto attnDto, PageVO pageVO) { return attnDao.selectListByMonth(attnDto, pageVO); }
    public int countAttendance(AttnDto attnDto) { return attnDao.countAttendance(attnDto); }
    public double getWorkTimeSum(String empNo, String startDate, String endDate) { return attnDao.getWorkTimeSum(empNo, startDate, endDate); }

    public Map<String, Object> getTodayAttnDetails(String empNo) { 
        return attnDao.selectTodayAttnDetails(empNo); 
    }

    @Deprecated
    public void updateAttendance(AttnDto attnDto) {
        // 기존 단방향 업데이트 메서드는 하위 호환성을 위해 유지하며 사용을 중단합니다.
    }

    // 🛠️ [대개조 완료] 레코드의 실시간 적재 여부에 따라 타겟 쿼리를 유연하게 스위칭합니다.
    @Transactional
    public void registerOrUpdateAttendance(AttnDto attnDto, Map<String, Object> todayData) {
        String inTimeStr = attnDto.getInTime(); 
        
        attnDto.setAttnStatus("출근중");
        attnDto.setAttnRecord("정상출근");
        
        if (inTimeStr != null && !inTimeStr.isEmpty()) {
            try {
                LocalTime inTime = LocalTime.parse(inTimeStr, TIME_FORMATTER);
                LocalTime standardTime = LocalTime.of(9, 0);

                if (inTime.isAfter(standardTime)) {
                    attnDto.setAttnRecord("지각");
                } else {
                    attnDto.setAttnRecord("정상출근");
                }
            } catch (DateTimeParseException e) {
                System.err.println("시간 가공 처리 예외 우회 핸들러 발동");
            }
        }
        
        // 🛡️ 데이터가 초기화로 날아갔거나 배치 스케줄러에서 튕겼던 계정 판별 구역
        if (todayData == null || todayData.isEmpty()) {
            attnDao.insertNewAttendance(attnDto); // ➔ 완벽하게 새 테이블 행 생성(INSERT)
        } else {
            attnDao.updateCheckIn(attnDto); // ➔ 기존 행 업데이트 수정(UPDATE)
        }
    }

    @Transactional
    public void updateCheckOut(String empNo) { attnDao.updateCheckOut(empNo); }
    @Transactional
    public void deleteAttendance(String empNo) { attnDao.deleteAttendanceByEmpNo(empNo); }
    @Transactional
    public void processDailyAttendance() { attnDao.updateStatusToAbsent(); }
    public List<String> getEmployeesWithoutOutTime() { return attnDao.getEmployeesWithoutOutTime(); }
}