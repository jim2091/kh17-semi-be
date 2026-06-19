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

    // 🎯 [추가] JSP 부서 검색창을 채우기 위해 전체 부서 목록을 가져오는 서비스 메서드
    public List<Map<String, Object>> getDepartmentList() { 
        // 💡 만약 AttnDao에 구현된 부서 조회 명칭이 다르다면 해당 메서드명으로 변경해 주세요.
        // 예: attnDao.selectDeptList() 등
        return attnDao.selectDepartmentList(); 
    }

    public List<Map<String, String>> getAllEmployees() { 
        return attnDao.selectAllEmployees(); 
    }

    public List<AttnDto> getAdminAttendanceList(AttnDto s, PageVO p) { 
        return attnDao.selectAdminList(s, p); 
    }

    public int countAdminAttendance(AttnDto s) { 
        return attnDao.countAdminAttendance(s); 
    }
    
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