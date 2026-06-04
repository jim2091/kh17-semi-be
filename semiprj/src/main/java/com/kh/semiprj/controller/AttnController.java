package com.kh.semiprj.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.semiprj.dao.AttnDao;
import com.kh.semiprj.dto.AttnDto;

@Controller
@RequestMapping("/attn")
public class AttnController {
	@Autowired
	private AttnDao attnDao;
	
	@PostMapping("/list")
	public String list(
	        @RequestParam(required = false) String workDate,
	        Model model) {

	    List<AttnDto> list;

	    if(workDate == null) {
	        list = attnDao.selectList();
	    }
	    else {
	        list = attnDao.selectByDate(workDate);
	    }

	    model.addAttribute("list", list);

	    return "attn/list";
	}
}
  
  
  
 
 