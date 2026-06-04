package com.kh.semiprj.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.service.AttnService;
import com.kh.semiprj.vo.PageVO;

@Controller
@RequestMapping("/attn")
public class AttnController {

    @Autowired
    private AttnService attnService;

    @GetMapping("/list")
    public String list(@ModelAttribute AttnDto attnDto, 
                       @ModelAttribute PageVO pageVO, 
                       Model model) {
        
        // 1. 전체 개수 조회 후 PageVO에 설정
        int totalCount = attnService.countAttendance(attnDto);
        pageVO.setCount(totalCount);
        
        // 2. 서비스 호출 (DTO와 PageVO 전달)
        List<AttnDto> list = attnService.getAttendanceList(attnDto, pageVO);

        // 3. 모델 데이터 전달
        model.addAttribute("attnList", list);
        model.addAttribute("pageVO", pageVO);
        model.addAttribute("search", attnDto);

        return "attn/list";
    }
}