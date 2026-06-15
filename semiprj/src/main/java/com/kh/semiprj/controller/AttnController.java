package com.kh.semiprj.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.service.AttnService;
import com.kh.semiprj.service.AdminAttnService;
import com.kh.semiprj.vo.PageVO;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/attn")
public class AttnController {

    @Autowired private AttnService attnService;
    @Autowired private AdminAttnService adminAttnService;

    @GetMapping("/status")
    @ResponseBody
    public Map<String, Object> getAttnStatus(HttpSession session) {
        String empNo = (String) session.getAttribute("loginNo");
        Map<String, Object> map = new HashMap<>();
        
        if (empNo == null) {
            map.put("status", "미출근");
            map.put("startTime", "-");
            map.put("endTime", "-");
            return map;
        }
        
        Map<String, Object> todayData = attnService.getTodayAttnDetails(empNo); 
        
        if (todayData == null || todayData.isEmpty()) {
            map.put("status", "미출근");
            map.put("startTime", "-");
            map.put("endTime", "-");
        } else {
            String dbStatus = (String) todayData.get("ATTN_STATUS");
            String inTime = (String) todayData.get("IN_TIME");
            String outTime = (String) todayData.get("OUT_TIME");

            if ("퇴근".equals(dbStatus)) {
                map.put("status", "퇴근");
            } else if ("출근중".equals(dbStatus)) {
                map.put("status", "출근상태");
            } else {
                map.put("status", "미출근");
            }
            
            map.put("startTime", inTime != null ? inTime : "-");
            map.put("endTime", outTime != null ? outTime : "-");
        }
        
        return map;
    }

    // 🛠️ 최초 진입 시 검색 조건(년/월)이 없으면 실시간 기준 '그 해, 그 달'을 자동 계산 주입
    @GetMapping("/list")
    public String list(@ModelAttribute("search") AttnDto attnDto, 
                       @ModelAttribute("pageVO") PageVO pageVO, 
                       HttpSession session, Model model) {
        String empNo = (String) session.getAttribute("loginNo");
        attnDto.setEmpNo(empNo);
        
        // 🛡️ [타입 에러 수정 완료] 
        // AttnDto의 year와 month가 String 규격인 것을 감안하여 null 및 빈 문자열("") 체크로 안전하게 변경했습니다.
        if (attnDto.getYear() == null || String.valueOf(attnDto.getYear()).trim().isEmpty() || "0".equals(String.valueOf(attnDto.getYear())) ||
            attnDto.getMonth() == null || attnDto.getMonth().trim().isEmpty()) {
            
            LocalDate now = LocalDate.now();
            
            // 숫자인 연도를 String.valueOf() 또는 "" + 숫자를 통해 문자열로 안전하게 변환하여 주입합니다.
            attnDto.setYear(String.valueOf(now.getYear())); 
            
            // 월 데이터를 오라클 규격에 맞게 "01", "02" 형태로 패딩 처리하여 포맷 바인딩
            String currentMonth = String.format("%02d", now.getMonthValue());
            attnDto.setMonth(currentMonth);
        }

        Map<String, Object> vacInfo = attnService.getVacationInfo(empNo);
        model.addAttribute("vacInfo", vacInfo);
        
        List<AttnDto> list = attnService.getAttendanceList(attnDto, pageVO);
        pageVO.setCount(attnService.countAttendance(attnDto));
        
        model.addAttribute("maxHours", adminAttnService.getActiveMaxHours());
        model.addAttribute("attnList", list);
        return "attn/list";
    }

    @GetMapping("/calculator")
    public String calculator(@RequestParam(required = false) String startDate, 
                             @RequestParam(required = false) String endDate, 
                             HttpSession session, Model model) {
        String empNo = (String) session.getAttribute("loginNo");
        if (startDate == null || endDate == null) {
            LocalDate now = LocalDate.now();
            startDate = now.withDayOfMonth(1).toString();
            endDate = now.withDayOfMonth(now.lengthOfMonth()).toString();
        }
        model.addAttribute("totalWorkTime", attnService.getWorkTimeSum(empNo, startDate, endDate));
        model.addAttribute("maxHours", adminAttnService.getActiveMaxHours());
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        return "attn/calculator";
    }

    @GetMapping("/calculator/data")
    @ResponseBody
    public double getCalculatorData(@RequestParam String startDate, 
                                    @RequestParam String endDate, 
                                    HttpSession session) {
        String empNo = (String) session.getAttribute("loginNo");
        return attnService.getWorkTimeSum(empNo, startDate, endDate);
    }

    @GetMapping("/admin/list")
    public String adminList(@ModelAttribute("search") AttnDto searchDto,
                            @RequestParam(value = "page", defaultValue = "1") int page,
                            @RequestParam(value = "size", defaultValue = "10") int size,
                            @RequestParam(required = false) String startDate,
                            @RequestParam(required = false) String endDate,
                            Model model) {
        if (startDate == null || startDate.isEmpty()) {
            LocalDate now = LocalDate.now();
            startDate = now.withDayOfMonth(1).toString();
            endDate = now.withDayOfMonth(now.lengthOfMonth()).toString();
        }
        PageVO pageVO = new PageVO();
        pageVO.setPage(page);
        pageVO.setSize(size);
        pageVO.setCount(adminAttnService.countAdminAttendanceCustom(searchDto, startDate, endDate));
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("pageVO", pageVO);
        model.addAttribute("attnList", adminAttnService.getAdminAttendanceListCustom(searchDto, pageVO, startDate, endDate));
        model.addAttribute("empList", adminAttnService.getAllEmployees());
        return "admin/attn/list";
    }

    @GetMapping("/admin/manage")
    public String adminManage(Model model) {
        model.addAttribute("workSystemList", adminAttnService.getWorkSystemList());
        return "admin/attn/manage";
    }

    @PostMapping("/admin/manage")
    public String adminManageUpdate(@RequestParam(value="work_code", required=false) String workCode) {
        if(workCode != null && !workCode.trim().isEmpty()) {
            adminAttnService.updateActiveWorkSystem(workCode);
        }
        return "redirect:/attn/admin/manage";
    }

    @PostMapping("/checkIn")
    @ResponseBody
    public String checkIn(@RequestParam(value="inTime", required=false) String inTime, HttpSession session) {
        String empNo = (String) session.getAttribute("loginNo");
        if (empNo == null) return "fail";
        
        try {
            Map<String, Object> todayData = attnService.getTodayAttnDetails(empNo);
            
            if (todayData != null && !todayData.isEmpty()) {
                String currentStatus = (String) todayData.get("ATTN_STATUS");
                if ("출근중".equals(currentStatus) || "퇴근".equals(currentStatus)) {
                    return "already"; 
                }
            }
            
            AttnDto dto = new AttnDto();
            dto.setEmpNo(empNo);
            dto.setInTime(inTime); 
            
            attnService.registerOrUpdateAttendance(dto, todayData); 
            return "success";
        } catch (Exception e) { 
            e.printStackTrace(); 
            return "fail"; 
        }
    }

    @PostMapping("/checkOut")
    @ResponseBody
    public String checkOut(HttpSession session) {
        String empNo = (String) session.getAttribute("loginNo");
        if (empNo == null) return "fail";
        try {
            attnService.updateCheckOut(empNo);
            return "success";
        } catch (Exception e) { e.printStackTrace(); return "fail"; }
    }

    @PostMapping("/clearAttn")
    @ResponseBody
    public String clearAttn(HttpSession session) {
        String empNo = (String) session.getAttribute("loginNo");
        if (empNo == null) return "fail";
        try {
            attnService.deleteAttendance(empNo);
            return "success";
        } catch (Exception e) { e.printStackTrace(); return "fail"; }
    }
}