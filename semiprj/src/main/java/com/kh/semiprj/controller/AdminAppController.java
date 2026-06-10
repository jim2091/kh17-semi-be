package com.kh.semiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dto.AppDto;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminAppController {

    @Autowired
    private AppDao appDao;

    @RequestMapping("/app/list")
    public String appList(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login";

        String empLevel = (String) session.getAttribute("empLevel");
        if (!"관리자".equals(empLevel)) return "redirect:/app/list"; // 관리자 아니면 차단

        List<AppDto> list = appDao.selectAllList();
        model.addAttribute("list", list);
        return "/admin/app/list";
    }
}