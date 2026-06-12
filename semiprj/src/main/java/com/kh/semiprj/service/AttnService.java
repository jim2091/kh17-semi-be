package com.kh.semiprj.service;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
    
    // 시간 입력을 위한 포맷터 (HH:mm 형태)
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    // 근태 목록 관련 메서드들
    public Map<String, Object> getVacationInfo(String empNo) { return attnDao.selectVacationInfo(empNo); }
    public List<AttnDto> getAttendanceList(AttnDto attnDto, PageVO pageVO) { return attnDao.selectListByMonth(attnDto, pageVO); }
    public int countAttendance(AttnDto attnDto) { return attnDao.countAttendance(attnDto); }
    public int getWorkTimeSum(String empNo, String startDate, String endDate) { return attnDao.getWorkTimeSum(empNo, startDate, endDate); }
    public String checkTodayStatus(String empNo) { return attnDao.checkTodayStatus(empNo); }

    // 지각 로직이 반영된 출근 처리
    @Transactional
    public void insertAttendance(AttnDto attnDto) {
        String inTimeStr = attnDto.getInTime(); 
        
        if (inTimeStr != null && !inTimeStr.isEmpty()) {
            try {
                // 1. 입력받은 시간 문자열 파싱
                LocalTime inTime = LocalTime.parse(inTimeStr, TIME_FORMATTER);
                LocalTime standardTime = LocalTime.of(9, 0); // 09:00 기준

                // 2. 결과 기록(record) 판별
                if (inTime.isAfter(standardTime)) {
                    attnDto.setAttnRecord("지각");
                } else {
                    attnDto.setAttnRecord("정상출근");
                }
                
                // 3. 상태(status) 설정
                attnDto.setAttnStatus("출근중");
                
                // 4. Timestamp 변환 (오늘 날짜와 입력받은 시간을 조합)
                LocalDateTime localDateTime = LocalDateTime.of(LocalDate.now(), inTime);
                attnDto.setAttnInTime(Timestamp.valueOf(localDateTime));
                
            } catch (DateTimeParseException e) {
                // 시간 형식이 잘못되었을 경우 로그 출력 및 기본값 처리 가능
                System.err.println("시간 파싱 오류: " + inTimeStr);
            }
        }
        
        // DAO의 insert 문 호출
        attnDao.insertCheckIn(attnDto);
    }

    @Transactional
    public void updateCheckOut(String empNo) { attnDao.updateCheckOut(empNo); }
    @Transactional
    public void deleteAttendance(String empNo) { attnDao.deleteAttendanceByEmpNo(empNo); }
    @Transactional
    public void processDailyAttendance() { attnDao.updateStatusToAbsent(); }
    public List<String> getEmployeesWithoutOutTime() { return attnDao.getEmployeesWithoutOutTime(); }
}