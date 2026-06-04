package com.kh.semiprj.service;



import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.semiprj.dao.AttnDao;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.vo.PageVO;



@Service
public class AttnService {

    @Autowired
    private AttnDao attnDao;

    public int countAttendance(AttnDto attnDto) {
        return attnDao.countAttendance(attnDto);
    }

    public List<AttnDto> getAttendanceList(AttnDto attnDto, PageVO pageVO) {
        // 기본값 처리
        if (attnDto.getYear() == null) attnDto.setYear(String.valueOf(LocalDate.now().getYear()));
        if (attnDto.getMonth() == null) attnDto.setMonth(String.format("%02d", LocalDate.now().getMonthValue()));
        if (attnDto.getEmpNo() == null) attnDto.setEmpNo("20260001");

        List<AttnDto> list = attnDao.selectListByMonth(attnDto, pageVO);

        // 비즈니스 로직
        for (AttnDto dto : list) {
            if (dto.getAttnInTime() != null && dto.getAttnOutTime() == null) {
                dto.setAttnRecord("결근");
            }
        }
        return list;
    }
}