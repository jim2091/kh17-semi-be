package com.kh.semiprj.controller;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.EmpHistoryDao;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.EmpHistoryDto;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.vo.HistoryPageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminEmpController {
	
	@Autowired
	private EmpDao empDao;
	
	@Autowired
	private EmpHistoryDao empHistoryDao;
	
	@GetMapping("/register")
	public String register() {
		return "admin/register";
	}
	
	@PostMapping("/register")
	public String register(@ModelAttribute EmpDto empDto) {
		System.out.println(empDto);
		empDao.insertFromAdmin(empDto);
		
		return "redirect:/";
		//홈으로 리다이렉트해놓았는데, 사원목록구현후 사원목록페이지로 리다이렉트할 예정입니다
	}
	
	@RequestMapping("/list")
	public String list(@RequestParam(required = false) String column, 
						@RequestParam(required = false) String keyword, 
						Model model) {
		/* System.out.println("list 실행"); */
		List<EmpDto> list = empDao.selectListByAdmin(column, keyword);
		
		model.addAttribute("list", list);
		
		return "admin/list";
	}
	@RequestMapping("/detail")
	public String detail(@RequestParam String empNo, Model model) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		model.addAttribute("empDto", empDto);
		
		List<EmpHistoryDto> loginHistory = 
				empHistoryDao.selectList(empNo, 1, 10);
		model.addAttribute("loginHistory", loginHistory);
		
		return "admin/detail";
	}
	@GetMapping("/edit")
	public String edit(@RequestParam String empNo, Model model) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		//if(empDto == null) throw new TargetNotfoundException("대상이 존재하지 않습니다");
		model.addAttribute("empDto", empDto);
		return "admin/edit";
	}
	/*
	 * @PostMapping("/edit") public String edit(@ModelAttribute EmpDto empDto) {
	 * //EmpDto findEmpDto = empDao.selectOneByDetail(empDto.getEmpNo());
	 * //if(findEmpDto == null) throw new TargetNotfoundException("존재하지 않는 회원");
	 * if(empDto.getEmpRetiredDate() == null ) { empDto.setEmpRetiredDate(null); }
	 * 
	 * empDao.updateByMaster(empDto); return "redirect:./detail?empNo=" +
	 * empDto.getEmpNo(); }
	 */
	
	@PostMapping("/edit")
	public String edit(
		@RequestParam(required = false) String hireDateStr, 
	    @RequestParam(required = false) String retiredDateStr,
	    @ModelAttribute EmpDto empDto
	) {
		
		if(hireDateStr != null && !hireDateStr.isBlank()) {
	        empDto.setEmpHireDate(
	            Timestamp.valueOf(hireDateStr + " 00:00:00")
	        );
	    }
	    else {
	        empDto.setEmpHireDate(null);
	    }
		
	    if(retiredDateStr != null && !retiredDateStr.isBlank()) {
	        empDto.setEmpRetiredDate(
	            Timestamp.valueOf(retiredDateStr + " 00:00:00")
	        );
	    }
	    else {
	        empDto.setEmpRetiredDate(null);
	    }
	    System.out.println(empDto);

	    empDao.updateByMaster(empDto);
	    return "redirect:./detail?empNo=" + empDto.getEmpNo();
	}
	
	@RequestMapping("/useYn")
	public String useYn(@RequestParam String empNo) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		//if(empDto == null) throw new TargetNotfoundException("존재하지 않는 회원");
		System.out.println(empDto.getEmpUseYn());
		System.out.println(empDto.getEmpUseYn().equals("N"));
		
		if(empDto.getEmpUseYn().equals("N")) {
			empDao.useY(empNo);
		}
		else {
			empDao.useN(empNo);
		}
		System.out.println("현재값 = " + empDto.getEmpUseYn());
		return "redirect:./edit?empNo="+empNo;
	}
	
	
	@RequestMapping("/waitingList")
	public String waitingList(Model model) {
		
		List<EmpDto> list = empDao.selectListForWaiting();
		model.addAttribute("list", list);
		
		return "admin/waiting_list";
		
	}
	
	@RequestMapping("/approval")
	public String approval(@RequestParam String empNo) {
		
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		
		if(empDto.getEmpApprovalStatus().equals("N")) {
			empDao.useY(empNo);
		}
		else {
			empDao.useN(empNo);
		}
		
		return "redirect:./waitingList";
	}
	
	@RequestMapping("/history")
	public String history(@RequestParam String empNo, 
								@ModelAttribute HistoryPageVO historyPageVO,
								Model model) {
//		String loginNo = (String) session.getAttribute("loginNo");
//		System.out.println(empDao.selectOneByDetail(loginNo));
//		System.out.println(historyPageVO);
//		System.out.println(empNo);
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		if(empDto == null) throw new TargetNotfoundException("대상이 존재하지 않습니다");
		model.addAttribute("empDto", empDto);
		
		List<EmpHistoryDto> loginhistory = 
				empHistoryDao.selectList(empNo, historyPageVO);
//		System.out.println(loginhistory);
		
		model.addAttribute("loginhistory", loginhistory);
		int count = empHistoryDao.count(empNo, historyPageVO);
		historyPageVO.setCount(count);
		model.addAttribute("historyPageVO", historyPageVO);
		return "admin/history";
	}
	
	
	
	
	
	
	

}
