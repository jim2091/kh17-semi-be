package com.kh.semiprj.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.semiprj.dto.AppLineDto;
import com.kh.semiprj.service.AppLineService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/approval")
@RequiredArgsConstructor
public class AppLineController {

    private final AppLineService appLineService;

    // 내 결재 목록 화면
    @GetMapping("/list")
    public String list(Model model, HttpSession session) {
        String loginId = (String) session.getAttribute("loginId");
        List<AppLineDto> myList = appLineService.getMyApprList(loginId);
        model.addAttribute("myList", myList);
        return "approval/list";
    }

    // 결재 상세 화면
    @GetMapping("/detail/{appId}")
    public String detail(@PathVariable int appId,
                         Model model, HttpSession session) {

        String loginId = (String) session.getAttribute("loginId");
        List<AppLineDto> lineList = appLineService.getAppLineList(appId);

        // 현재 본인 차례인 appLineId 찾기
        AppLineDto myTurn = lineList.stream()
            .filter(l -> "진행중".equals(l.getAppLineStatus())
                      && l.getAppAppId().equals(loginId))
            .findFirst()
            .orElse(null);

        model.addAttribute("lineList", lineList);
        model.addAttribute("myTurn", myTurn);   // null이면 버튼 미표시
        model.addAttribute("appId", appId);
        return "approval/detail";
    }

    // 승인 (Ajax)
    @PostMapping("/approve")
    @ResponseBody
    public Map<String, Object> approve(
            @RequestParam int appLineId,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        String loginId = (String) session.getAttribute("loginId");

        try {
            String status = appLineService.approve(appLineId, loginId);
            result.put("success", true);
            result.put("status", status);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 반려 (Ajax)
    @PostMapping("/reject")
    @ResponseBody
    public Map<String, Object> reject(
            @RequestParam int    appLineId,
            @RequestParam String rejectReason,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        String loginId = (String) session.getAttribute("loginId");

        try {
            appLineService.reject(appLineId, loginId, rejectReason);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
}