package com.kh.semiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.spring09.vo.PageVO;

//전자결재
@Controller
@RequestMapping("/app")
public class AppController {
	@Autowired
	private AppDao appDao;
	
	
	//목록
	@RequestMapping("/list")
	public String list(@ModelAttribute PageVO pageVO,Model model) {
		List<AppDto>list = appDao.selectList(pageVO);
		model.addAttribute("list", list);
		
		
		return "/app/list";
	}
	
	//상세
	//수정(결재 or 반려)
	
}
