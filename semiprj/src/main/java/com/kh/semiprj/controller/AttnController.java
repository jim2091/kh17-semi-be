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
        
        // 🎯 [수정] 어떤 검색 조건이 유지되고 있는지 뷰(JSP)단 스크립트에 명확하게 넘겨주기 위한 변수 설정
        String searchColumn = "all";
        if (searchDto.getDeptCode() != null && !searchDto.getDeptCode().isEmpty()) {
            searchColumn = "dept";
        } else if (searchDto.getPositionCode() != null && !searchDto.getPositionCode().isEmpty()) {
            searchColumn = "position";
        } else if (searchDto.getEmpName() != null && !searchDto.getEmpName().isEmpty()) {
            searchColumn = "name";
        }
        model.addAttribute("searchColumn", searchColumn);

        int totalAdminCount = adminAttnService.countAdminAttendanceCustom(searchDto, startDate, endDate);
        pageVO.setCount(totalAdminCount);
        
        model.addAttribute("deptList", adminAttnService.getDepartmentList()); 
        
        List<String> positionList = List.of("사원","선임","주임","대리","과장","차장","부장","이사","상무","전무","부사장","사장","부회장","회장");
        model.addAttribute("positionList", positionList);
        
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
                String currentRecord = (String) todayData.get("ATTN_RECORD");
                String existInTime = (String) todayData.get("IN_TIME");
                
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