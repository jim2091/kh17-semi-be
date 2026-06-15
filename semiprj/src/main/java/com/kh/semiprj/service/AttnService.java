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
    
    // 💡 DTO의 가상 Getter 덕분에 서비스 코드가 복잡해질 필요가 없습니다.
    public List<AttnDto> getAttendanceList(AttnDto attnDto, PageVO pageVO) { 
        return attnDao.getAttendanceList(attnDto, pageVO); 
    }
    
    public int countAttendance(AttnDto attnDto) { return attnDao.countAttendance(attnDto); }
    public double getWorkTimeSum(String empNo, String startDate, String endDate) { return attnDao.getWorkTimeSum(empNo, startDate, endDate); }

    public Map<String, Object> getTodayAttnDetails(String empNo) { 
        return attnDao.selectTodayAttnDetails(empNo); 
    }

    @Transactional
    public void registerOrUpdateAttendance(AttnDto attnDto, Map<String, Object> todayData) {
        String inTimeStr = attnDto.getInTime(); 
        attnDto.setAttnStatus("출근중");
        
        LocalTime standardTime = LocalTime.of(9, 0);
        LocalTime compareTime = null;

        if (inTimeStr != null && !inTimeStr.trim().isEmpty()) {
            try {
                compareTime = LocalTime.parse(inTimeStr, TIME_FORMATTER);
            } catch (DateTimeParseException e) {
                compareTime = LocalTime.now();
            }
        } else {
            compareTime = LocalTime.now(); 
        }

        if (compareTime.isAfter(standardTime)) {
            attnDto.setAttnRecord("지각");
        } else {
            attnDto.setAttnRecord("정상출근");
        }
        
        if (todayData == null || todayData.isEmpty()) {
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