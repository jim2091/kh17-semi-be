package com.kh.semiprj.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kh.semiprj.dao.AttnDao;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.vo.PageVO;

@Service
public class AdminAttnService {
    @Autowired private AttnDao attnDao;

    public List<AttnDto> getAdminAttendanceList(AttnDto searchDto, PageVO pageVO) {
        return attnDao.selectAdminList(searchDto, pageVO);
    }
    
    public int countAdminAttendance(AttnDto searchDto) {
        return attnDao.countAdminAttendance(searchDto);
    }
}