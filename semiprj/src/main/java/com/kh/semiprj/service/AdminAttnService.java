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
public class AdminAttnService {
    @Autowired private AttnDao attnDao;

    public List<Map<String, String>> getAllEmployees() { return attnDao.selectAllEmployees(); }
    
    // 컨트롤러가 호출하는 이름과 일치하도록 모든 메서드 구현
    public List<AttnDto> getAdminAttendanceList(AttnDto s, PageVO p) { return attnDao.selectAdminList(s, p); }
    public int countAdminAttendance(AttnDto s) { return attnDao.countAdminAttendance(s); }
    
    public List<AttnDto> getAdminAttendanceListCustom(AttnDto s, PageVO p, String st, String en) { return attnDao.selectAdminListCustom(s, p, st, en); }
    public int countAdminAttendanceCustom(AttnDto s, String st, String en) { return attnDao.countAdminAttendanceCustom(s, st, en); }
    
    public List<Map<String, Object>> getWorkSystemList() { return attnDao.selectWorkSystemList(); }
    public int getActiveMaxHours() { return attnDao.selectActiveMaxHours(); }
    
    @Transactional
    public void updateActiveWorkSystem(String workCode) {
        attnDao.updateAllWorkSystemDisable();
        attnDao.updateWorkSystemEnable(workCode);
    }
}