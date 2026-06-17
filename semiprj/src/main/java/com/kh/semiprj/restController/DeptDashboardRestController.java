package com.kh.semiprj.restController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.DeptDashboardDao;
import com.kh.semiprj.vo.AttendanceStatVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/rest/dept/manager")
public class DeptDashboardRestController {

    private final DeptDashboardDao deptDashboardDao;

    @GetMapping("/attendance")
    public Map<String, Object> attendance(
            @RequestParam String deptId,
            @RequestParam String month,
            @RequestParam(defaultValue = "month") String attnMode) {

        List<AttendanceStatVO> stats =
                deptDashboardDao.selectAttendanceStats(deptId, month, attnMode);

        int max = 0;

        for (AttendanceStatVO stat : stats) {
            if (stat.getNormalCount() > max) max = stat.getNormalCount();
            if (stat.getLeaveCount() > max) max = stat.getLeaveCount();
            if (stat.getLateCount() > max) max = stat.getLateCount();
            if (stat.getEarlyLeaveCount() > max) max = stat.getEarlyLeaveCount();
            if (stat.getLateEarlyCount() > max) max = stat.getLateEarlyCount();
            if (stat.getAbsentCount() > max) max = stat.getAbsentCount();
        }

        int step = 5;

        if (max <= 5) step = 1;
        else if (max <= 10) step = 2;
        else if (max <= 25) step = 5;
        else step = 10;

        int chartMax = ((max + step - 1) / step) * step;

        if (chartMax == 0) {
            chartMax = 5;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("stats", stats);
        result.put("chartMax", chartMax);
        result.put("chart4", chartMax * 4 / 5);
        result.put("chart3", chartMax * 3 / 5);
        result.put("chart2", chartMax * 2 / 5);
        result.put("chart1", chartMax * 1 / 5);
        result.put("attnMode", attnMode);

        return result;
    }
}
