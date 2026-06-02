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
import com.kh.semiprj.dao.PdsDao;
import com.kh.semiprj.dto.PdsDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.vo.PageVO;
import com.kh.spring09.exception.TargetNotfoundException;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/pds")
public class PdsController {
	@Autowired
	private PdsDao pdsDao;
	@Autowired
	private EmpDao empDao;
	
	//등록
	@GetMapping("/write")
	public String write() {
		return "pds/write";
	}
	@PostMapping("/write")
	public String write(@ModelAttribute PdsDto pdsDto, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		String loginRole = (String)session.getAttribute("loginRole");
		
		//자료글은 관리자만 작성 가능
		if (!loginRole.equals("관리자")) {
			throw new GetOutException();
		}
		
		long pdsNo = pdsDao.sequence();
		//작성자는 사원번호가 아닌 이름으로 아니 이 경우는 관리자라고 써줘야하나?ㅇㅇ
		pdsDto.setPdsWriter(loginRole);
		pdsDto.setPdsNo(pdsNo);
		pdsDao.insert(pdsDto);
		System.out.println("test");
		return "redirect:./detail?pdsNo=" + pdsNo;
	}
	
	//목록
	@RequestMapping("/list")
	public String list(Model model, @ModelAttribute PageVO pageVO) {
		List<PdsDto> list = pdsDao.selectList(pageVO);
		int count = pdsDao.count(pageVO);
		pageVO.setCount(count);
		model.addAttribute("list", list);
		model.addAttribute("pageVO", pageVO);
		return "pds/list";
	}
	
	//수정
	@GetMapping
	public String edit(@RequestParam long pdsNo, Model model) {
		PdsDto pdsDto = pdsDao.selectOne(pdsNo);
		
		if (pdsDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다");
		model.addAttribute("pdsDto", pdsDto);
		return "pds/edit";
	}
	@PostMapping
	public String edit(@ModelAttribute PdsDto pdsDto, HttpSession session) {
		String loginRole = (String)session.getAttribute("loginRole");
		if (!loginRole.equals("관리자")) throw new GetOutException();
		
		PdsDto findPdsDto = pdsDao.selectOne(pdsDto.getPdsNo());
		if (findPdsDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다");
		pdsDao.update(pdsDto);
		
		return "redirect:./detail?pdsNo=" + pdsDto.getPdsNo();
	}
	
	//삭제
	@RequestMapping("/delete")
	public String delete(@RequestParam long pdsNo) {
		PdsDto pdsDto = pdsDao.selectOne(pdsNo);
		if(pdsDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다");
		pdsDao.delete(pdsNo);
		return "redirect:./list";
	}
	
}
