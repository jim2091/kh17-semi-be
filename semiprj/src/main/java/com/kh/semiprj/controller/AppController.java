package com.kh.semiprj.controller;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

//전자결재
@Controller
@RequestMapping("/app")
public class AppController {
	@Autowired
	private AppDao appDao;
	
	
	//목록
	@RequestMapping("/list")
	public String list(@ModelAttribute PageVO pageVO, Model model, HttpSession session) {
		//로그인 된 사원정보 가져오기
		String loginId = (String)session.getAttribute("loginId");
		AppDto appDto = appDao.selectOne(loginId);
		
		//목록조회(자기것만)
		List<AppDto>list = appDao.selectMyList(loginId);
		model.addAttribute("list", list);
		return "/app/list";
	}
	
	
	//상세
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		AppDto appDto = appDao.selectOne(loginId);
		appDao.selectOne(loginId);
		model.addAttribute("appDto", appDto);
		return "app/detail";
	}
	
	//수정(결재 or 반려)
	@PostMapping("/edit")
    public String edit(@RequestParam int appId, 
                       @RequestParam String appStatus, 
                       HttpSession session, 
                       RedirectAttributes attr) {
		
        
    
    
            return "redirect:/app/list";
        }
    }
	

