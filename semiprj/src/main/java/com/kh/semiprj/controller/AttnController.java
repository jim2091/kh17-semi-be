package com.kh.semiprj.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.service.AttnService;
import com.kh.semiprj.vo.PageVO;

@Controller
@RequestMapping("/attn")
public class AttnController {

    @Autowired private AttnService attnService;
    
    private final String TEST_EMP_NO = "20260001";

    // 1. 직원용 근태 목록
    @GetMapping("/list")
    public String list(@ModelAttribute("search") AttnDto attnDto, 
                       @ModelAttribute("pageVO") PageVO pageVO,
                       Model model) {
        
        attnDto.setEmpNo(TEST_EMP_NO);
        
        List<AttnDto> list = attnService.getAttendanceList(attnDto, pageVO);
        int totalCount = attnService.countAttendance(attnDto);
        pageVO.setCount(totalCount);
        
        Map<String, Object> vacInfo = new HashMap<>();
        vacInfo.put("VAC_TOT", 20);
        vacInfo.put("VAC_CNT", 15);
        
        model.addAttribute("vacInfo", vacInfo); 
        model.addAttribute("attnList", list);
        
        return "attn/list";
    }

    // 2. 직원용 근무시간 계산기
    @GetMapping("/calculator")
    public String calculator(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            Model model) {

        if (startDate == null || endDate == null) {
            LocalDate now = LocalDate.now();
            startDate = now.withDayOfMonth(1).toString();
            endDate = now.withDayOfMonth(now.lengthOfMonth()).toString();
        }
        
        int totalWorkTime = attnService.getWorkTimeSum(TEST_EMP_NO, startDate, endDate);
        
        Map<String, Object> vacInfo = new HashMap<>();
        vacInfo.put("VAC_TOT", 20);
        vacInfo.put("VAC_CNT", 15);
        
        model.addAttribute("vacInfo", vacInfo);
        model.addAttribute("totalWorkTime", totalWorkTime);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        
        return "attn/calculator";
    }

    // 3. 직원용 비동기 계산기 데이터
    @GetMapping("/calculator/data")
    @ResponseBody
    public int getCalculatorData(@RequestParam String startDate, 
                                 @RequestParam String endDate) {
        return attnService.getWorkTimeSum(TEST_EMP_NO, startDate, endDate);
    }

    // ==========================================================
    // [추가] 관리자 근태 조회 기능 통합 (경로 앞에 /를 붙여서 절대경로 맵핑)
    // ==========================================================
    @GetMapping("/admin/attn/list")
    public String adminList(@ModelAttribute("search") AttnDto searchDto,
                            @ModelAttribute("pageVO") PageVO pageVO,
                            Model model) {
        
        // 관리자 전체 근태 기록 수 카운트 후 페이징 적용
        int totalCount = attnService.countAdminAttendance(searchDto);
        pageVO.setCount(totalCount);
        
        // 관리자용 페이징/검색 목록 조회
        List<AttnDto> list = attnService.getAdminAttendanceList(searchDto, pageVO);
        
        model.addAttribute("attnList", list);
        
        // /WEB-INF/views/admin/attn/list.jsp 호출
        return "admin/attn/list";
    }
}