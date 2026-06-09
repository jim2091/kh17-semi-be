package com.kh.semiprj.service;

import java.util.HashMap;
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

    public List<Map<String, String>> getAllEmployees() { 
        return attnDao.selectAllEmployees(); 
    }

    // [추가됨] 오류를 일으키던 메서드 1
    public List<AttnDto> getAdminAttendanceList(AttnDto s, PageVO p) { 
        return attnDao.selectAdminList(s, p); 
    }

    // [추가됨] 오류를 일으키던 메서드 2
    public int countAdminAttendance(AttnDto s) { 
        return attnDao.countAdminAttendance(s); 
    }
    
    // [기존 유지] 페이징 계산을 위해 count를 서비스에서 자동 주입
    public List<AttnDto> getAdminAttendanceListCustom(AttnDto s, PageVO p, String st, String en) {
        int count = attnDao.countAdminAttendanceCustom(s, st, en);
        p.setCount(count); 
        return attnDao.selectAdminListCustom(s, p, st, en);
    }

    public int countAdminAttendanceCustom(AttnDto s, String st, String en) { 
        return attnDao.countAdminAttendanceCustom(s, st, en); 
    }
    
    public Map<String, Map<String, Object>> getAllVacationMap() {
        List<Map<String, Object>> list = attnDao.selectAllVacations();
        Map<String, Map<String, Object>> map = new HashMap<>();
        for (Map<String, Object> item : list) {
            String empNo = (String) item.get("EMP_NO");
            if (empNo != null) map.put(empNo, item);
        }
        return map;
    }
    
    public List<Map<String, Object>> getWorkSystemList() { return attnDao.selectWorkSystemList(); }
    public int getActiveMaxHours() { return attnDao.selectActiveMaxHours(); }
    
    @Transactional
    public void updateActiveWorkSystem(String workCode) {
        attnDao.updateAllWorkSystemDisable();
        attnDao.updateWorkSystemEnable(workCode);
    }
}