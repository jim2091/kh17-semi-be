package com.kh.semiprj.service;

import java.time.LocalDate;
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

    public Map<String, Object> getVacationInfo(String empNo) {
        return attnDao.selectVacationInfo(empNo);
    }

    public int countAttendance(AttnDto attnDto) {
        return attnDao.countAttendance(attnDto);
    }

    public List<AttnDto> getAttendanceList(AttnDto attnDto, PageVO pageVO) {
        if (attnDto.getYear() == null) attnDto.setYear(String.valueOf(LocalDate.now().getYear()));
        if (attnDto.getMonth() == null) attnDto.setMonth(String.format("%02d", LocalDate.now().getMonthValue()));
        if (attnDto.getEmpNo() == null) attnDto.setEmpNo("20260001");
        
        List<AttnDto> list = attnDao.selectListByMonth(attnDto, pageVO);
        
        for (AttnDto dto : list) {
            if (dto.getAttnInTime() != null && dto.getAttnOutTime() == null) {
                dto.setAttnRecord("결근");
            }
        }
        return list;
    }

    public int getWorkTimeSum(String empNo, String startDate, String endDate) {
        return attnDao.getWorkTimeSum(empNo, startDate, endDate);
    }

    @Transactional
    public void processDailyAttendance() {
        attnDao.updateStatusToAbsent();
    }

    public List<String> getEmployeesWithoutOutTime() {
        return attnDao.getEmployeesWithoutOutTime();
    }
}