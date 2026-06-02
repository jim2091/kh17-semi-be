package com.kh.semiprj.controller;

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

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/emp")
public class EmpController {
	
	@Autowired
	private EmpDao empDao;
	
	@Autowired
	private EmpHistoryDao empHistoryDao;

	@GetMapping("/login")
	public String login() {
		return "emp/login";
	}
	
	@PostMapping("/login")
	public String login(@ModelAttribute EmpDto empDto,
						HttpSession session, HttpServletRequest request) {
		//[1] 사용자가 입력한 아이디가 DB에 존재하는지
		EmpDto findEmpDto = empDao.selectOne(empDto.getEmpId());
		if (findEmpDto == null) {
			return "redirect:./login?error";
		}
		//[2] 비밀번호를 비교
		boolean isPasswordValid = empDto.getEmpPw().equals(findEmpDto.getEmpPw());
		
		if (!isPasswordValid) {
			return "redirect:./login?error";
		}
		//로그인 이력 생성
		EmpHistoryDto empHistoryDto = new EmpHistoryDto();
		//정보 입력
		empHistoryDto.setEmpHistoryOrigin(findEmpDto.getEmpNo());
		empHistoryDto.setEmpHistoryAddress(request.getRemoteAddr());
		empHistoryDto.setEmpHistoryAgent(request.getHeader("User-Agent"));
		empHistoryDao.insert(empHistoryDto);
		
		//session에 로그인 되었음을 표시
		session.setAttribute("loginId", findEmpDto.getEmpId());
		session.setAttribute("loginRole", findEmpDto.getEmpLevel());
		session.setAttribute("loginNo", findEmpDto.getEmpNo());
		
		return "redirect:/";
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		session.removeAttribute("loginId");
		session.removeAttribute("loginLevel");
		session.removeAttribute("loginNo");
		
		return "redirect:/";
	}
	
	@RequestMapping("/mypage")
	public String mypage(HttpSession session, Model model) {
		String loginNo = (String) session.getAttribute("loginNo"); //다운캐스팅
		
//		System.out.println(loginNo);
		EmpDto empDto = empDao.selectOneByDetail(loginNo);
//		System.out.println(empDto);
		model.addAttribute("empDto", empDto);
		List<EmpHistoryDto> loginHistory = 
								empHistoryDao.selectList(loginNo, 1, 10);
		model.addAttribute("loginHistory", loginHistory);
//		System.out.println(loginHistory);
		return "emp/mypage";
	}
	@RequestMapping("/list")
	public String list(@RequestParam(required = false) String column, 
						@RequestParam(required = false) String keyword, 
						Model model) {
		/* System.out.println("list 실행"); */
		List<EmpDto> list = empDao.selectList(column, keyword);
		
		model.addAttribute("list", list);
		
		return "emp/list";
	}
	@RequestMapping("/detail")
	public String detail(@RequestParam String empNo, Model model) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		model.addAttribute("empDto", empDto);
		
		
		return "emp/detail";
	}
	
	@GetMapping("/edit")
	public String edit(@RequestParam String empNo, Model model) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		//if(empDto == null) throw new TargetNotfoundException("대상이 존재하지 않습니다");
		model.addAttribute("empDto", empDto);
		return "emp/edit";
	}
	
	@PostMapping("/edit") 
	public String edit(@ModelAttribute EmpDto empDto) {
	    //EmpDto findEmpDto = empDao.selectOneByDetail(empDto.getEmpNo());
	    //if(findEmpDto == null) throw new TargetNotfoundException("존재하지 않는 회원");
	    
	  
	    empDao.updateByUser(empDto); 
	    
	    return "redirect:./detail?empNo=" + empDto.getEmpNo(); 
	}
	 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
