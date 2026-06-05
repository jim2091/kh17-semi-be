package com.kh.semiprj.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.service.AttnService;
import com.kh.semiprj.vo.PageVO;

@Controller
@RequestMapping("/attn")
public class AttnController {

    @Autowired
    private AttnService attnService;
    
    private final String TEST_EMP_NO = "20260001";

    @GetMapping("/list")
    public String list(@ModelAttribute("search") AttnDto attnDto, 
                       @ModelAttribute("pageVO") PageVO pageVO,    
                       Model model) {
        List<AttnDto> list = attnService.getAttendanceList(attnDto, pageVO);
        int totalCount = attnService.countAttendance(attnDto);
        pageVO.setCount(totalCount);
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