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

    // 🛠️ [방어선 3] 맵 구조가 완벽히 잡혀 들어왔더라도 ATTN_STATUS의 실제 기입 유무를 한 번 더 체크하여 확실히 분기
    @Transactional
    public void registerOrUpdateAttendance(AttnDto attnDto, Map<String, Object> todayData) {
        String inTimeStr = attnDto.getInTime(); 
        
        // 1. 시간 비교부터 먼저 합니다.
        LocalTime standardTime = LocalTime.of(9, 0);
        LocalTime compareTime = (inTimeStr != null && !inTimeStr.trim().isEmpty()) ? LocalTime.parse(inTimeStr, TIME_FORMATTER) : LocalTime.now();
        
        // 2. 9시 넘었으면 "지각" 마킹, 안 넘었으면 "정상근무" 마킹
        String recordResult = compareTime.isAfter(standardTime) ? "지각" : "정상근무";
        attnDto.setAttnRecord(recordResult);
        
        // 3. ✨ [핵심 교정] 지각이면 상태(Status)도 "지각"으로 저장하고, 정상이면 "출근중"으로 저장한다!
        if("지각".equals(recordResult)) {
            attnDto.setAttnStatus("지각");
        } else {
            attnDto.setAttnStatus("출근중");
        }
        
        // 4. 이제 안전하게 DB로 보냅니다.
        if (todayData == null || todayData.isEmpty() || todayData.get("ATTN_STATUS") == null) { 
            attnDao.insertNewAttendance(attnDto); 
        } else { 
            attnDao.updateCheckIn(attnDto); 
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