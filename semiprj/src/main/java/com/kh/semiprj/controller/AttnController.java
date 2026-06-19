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
            // 🛠️ ATTN_STATUS 가 아닌 개편된 ATTN_RECORD 데이터를 기반으로 정밀 필터링을 진행합니다.
            String dbRecord = (String) todayData.get("ATTN_RECORD");
            String inTime = (String) todayData.get("IN_TIME");
            String outTime = (String) todayData.get("OUT_TIME");

            if ("휴가".equals(dbRecord)) {
                map.put("status", "휴가");
            } else if ("결근".equals(dbRecord)) {
                map.put("status", "결근");
            } else if (outTime != null && !"-".equals(outTime)) {
                map.put("status", "퇴근");
            } else if (inTime != null && !"-".equals(inTime)) {
                // 💡 [핵심 교정] "출근상태"라는 모호한 고정값 대신, DB에 정직하게 기록된 '지각' 또는 '정상근무'를 그대로 내려줍니다.
                map.put("status", dbRecord); 
            } else {
                map.put("status", "미출근");
            }
            
            map.put("startTime", inTime != null ? inTime : "-");
            map.put("endTime", outTime != null ? outTime : "-");
        }
        
        return map;
    }

    @GetMapping("/list")
    public String list(@ModelAttribute("search") AttnDto attnDto, 
                       @ModelAttribute("pageVO") PageVO pageVO, 
                       HttpSession session, Model model) {
        String empNo = (String) session.getAttribute("loginNo");
        attnDto.setEmpNo(empNo);
        
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

        // 2. 🌟 [수정 추가] 휴가 정보 조회 및 바인딩 추가
        // (※ 서비스에 getLeaveInfo 같은 메서드가 구현되어 있다고 가정할 때)
        Map<String, Object> leaveInfo = attnService.getLeaveInfo(empNo); 
        model.addAttribute("leaveInfo", leaveInfo);
        
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

    // 🛠️ 중복 생성 및 휴가자 출근 오염 차단 조건 완벽 반영
    @PostMapping("/checkIn")
    @ResponseBody
    public String checkIn(@RequestParam(value="inTime", required=false) String inTime, HttpSession session) {
        String empNo = (String) session.getAttribute("loginNo");
        if (empNo == null) return "fail";
        
        try {
            Map<String, Object> todayData = attnService.getTodayAttnDetails(empNo);
            
            if (todayData != null && !todayData.isEmpty()) {
                String currentRecord = (String) todayData.get("ATTN_RECORD");
                String existInTime = (String) todayData.get("IN_TIME");
                
                // 🛡️ [방어선 강화] 이미 자정에 '휴가' 또는 '결근'이 기입되어 있거나, 출근한 이력이 있다면 클릭 전면 차단
                if ("휴가".equals(currentRecord) || "결근".equals(currentRecord) || "정상근무".equals(currentRecord) || "지각".equals(currentRecord) || (existInTime != null && !"-".equals(existInTime))) {
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