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

    // 🛠️ [방어 코드 강화] 사용자 근태 리스트 출력 구역
    @GetMapping("/list")
    public String list(@ModelAttribute("search") AttnDto attnDto, 
                       @ModelAttribute("pageVO") PageVO pageVO, 
                       HttpSession session, Model model) {
        String empNo = (String) session.getAttribute("loginNo");
        attnDto.setEmpNo(empNo);
        
        // PageVO의 기본값 안전화 보장 (혹시 모를 파라미터 유실 차단)
        if (pageVO.getPage() <= 0) pageVO.setPage(1);
        if (pageVO.getSize() <= 0) pageVO.setSize(10);
        
        if (attnDto.getYear() == null || String.valueOf(attnDto.getYear()).trim().isEmpty() || "0".equals(String.valueOf(attnDto.getYear())) ||
            attnDto.getMonth() == null || attnDto.getMonth().trim().isEmpty()) {
            
            LocalDate now = LocalDate.now();
            attnDto.setYear(String.valueOf(now.getYear())); 
            String currentMonth = String.format("%02d", now.getMonthValue());
            attnDto.setMonth(currentMonth);
        }

        Map<String, Object> vacInfo = attnService.getVacationInfo(empNo);
        model.addAttribute("vacInfo", vacInfo);
        
        // 전체 카운트를 먼저 세팅해야 PageVO가 내부적으로 올바른 rownum 연산을 수행합니다.
        int totalCount = attnService.countAttendance(attnDto);
        pageVO.setCount(totalCount);
        
        List<AttnDto> list = attnService.getAttendanceList(attnDto, pageVO);
        
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

    // 🛠️ [구조 정돈] 관리자 근태 목록 조회 시 PageVO 커맨드 객체 매핑 통일화
    @GetMapping("/admin/list")
    public String adminList(@ModelAttribute("search") AttnDto searchDto,
                            @ModelAttribute("pageVO") PageVO pageVO,
                            @RequestParam(required = false) String startDate,
                            @RequestParam(required = false) String endDate,
                            Model model) {
        if (startDate == null || startDate.isEmpty()) {
            LocalDate now = LocalDate.now();
            startDate = now.withDayOfMonth(1).toString();
            endDate = now.withDayOfMonth(now.lengthOfMonth()).toString();
        }
        
        if (pageVO.getPage() <= 0) pageVO.setPage(1);
        if (pageVO.getSize() <= 0) pageVO.setSize(10);
        
        int totalAdminCount = adminAttnService.countAdminAttendanceCustom(searchDto, startDate, endDate);
        pageVO.setCount(totalAdminCount);
        
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