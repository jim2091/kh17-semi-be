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

    @GetMapping("/list")
    public String list(@ModelAttribute("search") AttnDto attnDto, 
                       @ModelAttribute("pageVO") PageVO pageVO,
                       Model model) {
        
        attnDto.setEmpNo(TEST_EMP_NO);
        
        List<AttnDto> list = attnService.getAttendanceList(attnDto, pageVO);
        int totalCount = attnService.countAttendance(attnDto);
        pageVO.setCount(totalCount);
        
        // [수정] 더미 연차 데이터 주입
        Map<String, Object> vacInfo = new HashMap<>();
        vacInfo.put("VAC_TOT", 20);
        vacInfo.put("VAC_CNT", 15);
        
        model.addAttribute("vacInfo", vacInfo); 
        model.addAttribute("attnList", list);
        
        return "attn/list";
    }

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
        
        // [수정] calculator 페이지에도 더미 데이터 주입
        Map<String, Object> vacInfo = new HashMap<>();
        vacInfo.put("VAC_TOT", 20);
        vacInfo.put("VAC_CNT", 15);
        
        model.addAttribute("vacInfo", vacInfo);
        model.addAttribute("totalWorkTime", totalWorkTime);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        
        return "attn/calculator";
    }

    @GetMapping("/calculator/data")
    @ResponseBody
    public int getCalculatorData(@RequestParam String startDate, 
                                 @RequestParam String endDate) {
        return attnService.getWorkTimeSum(TEST_EMP_NO, startDate, endDate);
    }
}