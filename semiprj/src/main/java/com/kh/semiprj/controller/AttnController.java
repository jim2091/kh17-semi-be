package com.kh.semiprj.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
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
        
        // 이미 있는 checkTodayStatus를 호출 (결과가 "출근" 이거나 "미출근" 등일 것임)
        String status = attnService.checkTodayStatus(empNo); 
        
        Map<String, Object> map = new java.util.HashMap<>();
        map.put("status", "출근상태".equals(status) ? "출근상태" : "미출근");
        // 시간 정보가 DB에서 바로 안 온다면 일단 "-"로 표시합니다
        map.put("startTime", "출근상태".equals(status) ? "09:00" : "-"); 
        map.put("endTime", "-");
        
        return map;
    }
    @GetMapping("/list")
    public String list(@ModelAttribute("search") AttnDto attnDto, 
                       @ModelAttribute("pageVO") PageVO pageVO, 
                       HttpSession session, Model model) {
        String empNo = (String) session.getAttribute("loginNo");
        attnDto.setEmpNo(empNo);
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
    public int getCalculatorData(@RequestParam String startDate, 
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
    public String checkIn(HttpSession session) {
        String empNo = (String) session.getAttribute("loginNo");
        if (empNo == null) return "fail";
        try {
            AttnDto dto = new AttnDto();
            dto.setEmpNo(empNo);
            attnService.insertAttendance(dto); 
            return "success";
        } catch (Exception e) { e.printStackTrace(); return "fail"; }
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