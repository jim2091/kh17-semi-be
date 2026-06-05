package com.kh.semiprj.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	@RequestMapping("/")
	public String home() {
		return "/home";
	}
    @PostMapping("/menu/toggle")
    @ResponseBody
    public void toggle(
            @RequestParam boolean managerToggle,
            HttpSession session) {

        session.setAttribute("managerToggle", managerToggle);
    }
}