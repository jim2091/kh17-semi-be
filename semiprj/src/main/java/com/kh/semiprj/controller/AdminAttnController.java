package com.kh.semiprj.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.service.AdminAttnService;
import com.kh.semiprj.vo.PageVO;

@Controller
@RequestMapping("/admin/attn")
public class AdminAttnController {
    @Autowired private AdminAttnService adminAttnService;

    @GetMapping("/manage")
    public String manage(@ModelAttribute("search") AttnDto searchDto,
                         @ModelAttribute("pageVO") PageVO pageVO,
                         Model model) {
        pageVO.setCount(adminAttnService.countAdminAttendance(searchDto));
        model.addAttribute("attnList", adminAttnService.getAdminAttendanceList(searchDto, pageVO));
        return "admin/attn/manage";
    }
}