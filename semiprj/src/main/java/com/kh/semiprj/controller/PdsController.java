package com.kh.semiprj.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kh.semiprj.dao.AttachDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.PdsDao;
import com.kh.semiprj.dto.AttachDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.PdsDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.service.AttachService;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/pds")
public class PdsController {
	@Autowired
	private PdsDao pdsDao;
	@Autowired
	private EmpDao empDao;
	@Autowired
	private AttachService attachService;
	@Autowired
	private AttachDao attachDao;
	
	//등록
	@GetMapping("/write")
	public String write() {
		return "pds/write";
	}
	@PostMapping("/write")
	public String write(@ModelAttribute PdsDto pdsDto, HttpSession session, 
						@RequestParam(value = "attach") List<MultipartFile> attachList) throws IllegalStateException, IOException {
		String loginId = (String)session.getAttribute("loginId");
		String loginRole = (String)session.getAttribute("loginRole");
		
		EmpDto empDto = empDao.selectOne(loginId);
		
		//자료글은 관리자만 작성 가능
		if (!loginRole.equals("관리자")) {
			throw new GetOutException();
		}
		
		int pdsNo = pdsDao.sequence();

		pdsDto.setPdsWriter(empDto.getEmpNo());
		pdsDto.setPdsNo(pdsNo);
		pdsDao.insert(pdsDto);
		
		for (MultipartFile attach : attachList) {
			if (!attach.isEmpty()) {
				int attachNo = attachService.save(attach);
				pdsDao.connect(pdsNo, attachNo);
			}
		}
		
		return "redirect:./detail?pdsNo=" + pdsNo;
	}
	//상세
	@RequestMapping("/detail")
	public String detail(@RequestParam int pdsNo, Model model) {
		PdsDto pdsDto = pdsDao.selectOne(pdsNo);
		if (pdsDto == null) throw new TargetNotfoundException("존재하지 않는 게시글");
		String empName = empDao.selectNamebyNo(pdsDto.getPdsWriter());
	
		if(empName != null) {
			pdsDto.setEmpName(empName);
		}
		else {
			pdsDto.setEmpName("(퇴사한 사용자)");
		}
		
		model.addAttribute("pdsDto", pdsDto);
		model.addAttribute("prevPdsDto", pdsDao.selectPreviousOne(pdsNo));
		model.addAttribute("nextPdsDto", pdsDao.selectNextOne(pdsNo));
		
		List<AttachDto> attachList = pdsDao.searchFiles(pdsNo);
		model.addAttribute("attachList", attachList);
		return "pds/detail";
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
	@GetMapping("/edit")
	public String edit(@RequestParam int pdsNo, Model model) {
		PdsDto pdsDto = pdsDao.selectOne(pdsNo);
		
		if (pdsDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다");
		
		List<AttachDto> attachList = pdsDao.searchFiles(pdsNo);
		
		model.addAttribute("pdsDto", pdsDto);
		model.addAttribute("attachList", attachList);
		
		return "pds/edit";
	}
	@PostMapping("/edit")
	public String edit(@ModelAttribute PdsDto pdsDto, HttpSession session, 
					@RequestParam(required = false) List<Integer> deleteAttachNoList, 
					@RequestParam MultipartFile[] attach) throws IllegalStateException, IOException {
		String loginRole = (String)session.getAttribute("loginRole");
		if (!loginRole.equals("관리자")) throw new GetOutException();
		
		PdsDto findPdsDto = pdsDao.selectOne(pdsDto.getPdsNo());
		if (findPdsDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다");
		
		pdsDao.update(pdsDto);
		
		if (deleteAttachNoList != null) {
			for(int attachNo : deleteAttachNoList) {
				pdsDao.disconnect(pdsDto.getPdsNo(), attachNo);
				attachService.delete(attachNo);
			}
		}
		
		for(MultipartFile file : attach) {
			if(file.isEmpty()) continue;
			
			int attachNo = attachService.save(file);
			pdsDao.connect(pdsDto.getPdsNo(), attachNo);
		}
		
		return "redirect:./detail?pdsNo=" + pdsDto.getPdsNo();
	}
	
	//삭제
	@RequestMapping("/delete")
	public String delete(@RequestParam int pdsNo) {
		PdsDto pdsDto = pdsDao.selectOne(pdsNo);
		if(pdsDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다");
		pdsDao.delete(pdsNo);
		return "redirect:./list";
	}
	@RequestMapping("/deleteAll")
	public String deleteAll(@RequestParam(required=false) List<Integer> pdsNoList) {
		if (pdsNoList == null || pdsNoList.isEmpty()) {
			return "redirect:./list";
		}
		
		for(Integer pdsNo : pdsNoList)	{
			PdsDto pdsDto = pdsDao.selectOne(pdsNo);
			if(pdsDto == null) throw new TargetNotfoundException("존재하지 않는 게시글이 포함되어있습니다");
		}
		
		for(Integer pdsNo : pdsNoList)	{
			pdsDao.delete(pdsNo);
		}

		return "redirect:./list";
	}
}
