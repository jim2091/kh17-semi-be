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
    public List<AttnDto> getAttendanceList(AttnDto attnDto, PageVO pageVO) { return attnDao.getAttendanceList(attnDto, pageVO); }
    public int countAttendance(AttnDto attnDto) { return attnDao.countAttendance(attnDto); }
    public double getWorkTimeSum(String empNo, String startDate, String endDate) { return attnDao.getWorkTimeSum(empNo, startDate, endDate); }
    public Map<String, Object> getTodayAttnDetails(String empNo) { return attnDao.selectTodayAttnDetails(empNo); }

    /**
     * 🛠️ 출근 처리 로직 ('지각' 또는 '정상근무' 판별)
     */
    @Transactional
    public void registerOrUpdateAttendance(AttnDto attnDto, Map<String, Object> todayData) {
        String inTimeStr = attnDto.getInTime(); 
        LocalTime standardTime = LocalTime.of(9, 0);
        LocalTime compareTime;
        
        try {
            compareTime = (inTimeStr != null && !inTimeStr.trim().isEmpty()) 
                          ? LocalTime.parse(inTimeStr, TIME_FORMATTER) 
                          : LocalTime.now();
        } catch (DateTimeParseException e) {
            compareTime = LocalTime.now();
        }
        
        String recordResult = compareTime.isAfter(standardTime) ? "지각" : "정상근무";
        attnDto.setAttnRecord(recordResult);
        
        if (todayData == null || todayData.isEmpty() || todayData.get("ATTN_RECORD") == null) { 
            attnDao.insertNewAttendance(attnDto); 
        } else { 
            attnDao.updateCheckIn(attnDto); 
        }
    }

    /**
     * 🛠️ [업그레이드] 퇴근 처리 로직 (조퇴 및 지각-조퇴 복합 판별)
     */
    @Transactional
    public void updateCheckOut(String empNo) {
        // 1. 오늘의 기존 근태 데이터(출근 기록 등)를 먼저 가져옵니다.
        Map<String, Object> todayData = attnDao.selectTodayAttnDetails(empNo);
        
        if (todayData != null && !todayData.isEmpty()) {
            String currentRecord = (String) todayData.get("ATTN_RECORD"); // 현재 DB 상태 ('정상근무' 혹은 '지각' 등)
            
            // 2. 퇴근 기준 시간 설정 (정상 퇴근 기준: 18시 00분)
            LocalTime standardOutTime = LocalTime.of(18, 0);
            LocalTime now = LocalTime.now();
            
            // 3. 18시 이전에 퇴근 버튼을 누른 경우 (조퇴 타겟)
            if (now.isBefore(standardOutTime)) {
                if ("지각".equals(currentRecord)) {
                    // 💡 [핵심] 이미 아침에 지각을 한 상태라면 '지각-조퇴'로 문구를 누적 결합합니다.
                    attnDao.updateLeftEarlyStatus(empNo, "지각-조퇴");
                } else if ("정상근무".equals(currentRecord)) {
                    // 아침에 정상 출근했으나 일찍 가는 경우는 그냥 '조퇴'
                    attnDao.updateLeftEarlyStatus(empNo, "조퇴");
                }
            } 
            // 18시 이후 정상 퇴근인 경우 기존 '지각'이나 '정상근무' 상태가 그대로 유지되므로 별도 상태 업데이트 불필요
        }
        
        // 4. 최종적으로 퇴근 시간(OUT_TIME)과 총 근무 시간을 업데이트하는 기본 DAO 로직 실행
        attnDao.updateCheckOut(empNo); 
    }

    @Transactional
    public void deleteAttendance(String empNo) { attnDao.deleteAttendanceByEmpNo(empNo); }
    @Transactional
    public void processDailyAttendance() { attnDao.updateStatusToAbsent(); }
    public List<String> getEmployeesWithoutOutTime() { return attnDao.getEmployeesWithoutOutTime(); }
}