package com.kh.semiprj.service;

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

    // 근태 목록 관련
    public Map<String, Object> getVacationInfo(String empNo) {
        return attnDao.selectVacationInfo(empNo);
    }

    public List<AttnDto> getAttendanceList(AttnDto attnDto, PageVO pageVO) {
        return attnDao.selectListByMonth(attnDto, pageVO);
    }

    public int countAttendance(AttnDto attnDto) {
        return attnDao.countAttendance(attnDto);
    }

    public int getWorkTimeSum(String empNo, String startDate, String endDate) {
        return attnDao.getWorkTimeSum(empNo, startDate, endDate);
    }

    public String checkTodayStatus(String empNo) {
        return attnDao.checkTodayStatus(empNo);
    }

    // 출퇴근 처리
    @Transactional
    public void insertAttendance(AttnDto attnDto) {
        attnDao.insertCheckIn(attnDto);
    }

    @Transactional
    public void updateCheckOut(String empNo) {
        attnDao.updateCheckOut(empNo);
    }

    @Transactional
    public void deleteAttendance(String empNo) {
        attnDao.deleteAttendanceByEmpNo(empNo);
    }

    // 스케줄러용 메서드 (오류 해결 핵심)
    @Transactional
    public void processDailyAttendance() {
        attnDao.updateStatusToAbsent();
    }

    public List<String> getEmployeesWithoutOutTime() {
        return attnDao.getEmployeesWithoutOutTime();
    }
}