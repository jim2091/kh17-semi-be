package com.kh.semiprj.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.MessageDao;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.MessageDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.service.MessageService;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/message")
public class MessageController {
	@Autowired
	private MessageDao messageDao;
	@Autowired
	private EmpDao empDao;
	@Autowired
	private MessageService messageService;
	
	//1. 쪽지 등록 매핑
	@GetMapping("/write")
	public String write(Model model) {
		List<EmpDto> empList = empDao.selectListByAdmin();
		model.addAttribute("empList", empList);
		return "message/write";
	}
	@PostMapping("/write")
	public String write(@RequestParam List<String> messageReceiver, 
			@ModelAttribute MessageDto messageDto, HttpSession session) {

		String loginId = (String)session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		
		for(String receiver : messageReceiver) {
	        long messageNo = messageDao.sequence();

	        messageDto.setMessageNo(messageNo);
	        messageDto.setMessageSender(String.valueOf(empDto.getEmpNo()));
	        messageDto.setMessageReceiver(receiver);

	        messageDao.insert(messageDto);
	    }
	
		return "redirect:./writeComplete";
	}
	@RequestMapping("/writeComplete")
	public String writeComplete() {
		return "message/writeComplete";
	}
	
	//(+추가) 답장 매핑
	@GetMapping("/writeReply")
	public String writeReply(@RequestParam long messageNo, Model model) {
		MessageDto messageDto = messageDao.selectOne(messageNo);
		String title = messageDto.getMessageTitle();
		if(!title.startsWith("RE:")) {
			title = "RE: " + title;
		}
		model.addAttribute("replyTitle", title);
		model.addAttribute("messageDto", messageDto);
		return "message/write";
	}

	//2. 쪽지 목록 매핑
	//(2-1) 받은 쪽지함
	@RequestMapping("/receiveList")
	public String receiveList(Model model, HttpSession session, @ModelAttribute PageVO pageVO) {
		String loginNo = (String)session.getAttribute("loginNo");
		
		List<MessageDto> list = messageDao.selectReceiveList(loginNo, pageVO);
		
		int count = messageDao.countReceiveList(loginNo, pageVO);
		pageVO.setCount(count);
		
		model.addAttribute("list", list);
		model.addAttribute("pageVO", pageVO);
		
		return "message/receiveList";
	}
	
	//(2-2) 보낸 쪽지함
	@RequestMapping("/sendList")
	public String sendList(HttpSession session, Model model, @ModelAttribute PageVO pageVO) {
	    String loginNo = (String)session.getAttribute("loginNo");

	    List<MessageDto> list = messageDao.selectSendList(loginNo, pageVO);

	    int count = messageDao.countSendList(loginNo, pageVO);
	    pageVO.setCount(count);

	    model.addAttribute("list", list);
	    model.addAttribute("pageVO", pageVO);

	    return "message/sendList";
	}
	
	//(2-3) 전체 쪽지함
	@RequestMapping("/adminList")
	public String adminList(HttpSession session, Model model, @ModelAttribute PageVO pageVO) {
		String loginId = (String)session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		if(!"관리자".equals(empDto.getEmpLevel())) {
			throw new GetOutException("접근 권한이 없습니다.");
		}
		
		List<MessageDto> list = messageDao.selectAdminList(pageVO);
		int count = messageDao.countAdminList(pageVO);

		pageVO.setCount(count);
		
		model.addAttribute("list", list);
	    model.addAttribute("pageVO", pageVO);

	    return "message/adminList";
	}
	
	//3. 쪽지 사원 검색 매핑
	@GetMapping("/searchEmp")
	@ResponseBody
	public List<Map<String, Object>> searchEmp(@RequestParam String keyword){
		List<EmpDto> originList = empDao.searchByName(keyword);
			    
			    List<Map<String, Object>> resultList = new ArrayList<>();
			    
			    for (EmpDto emp : originList) {
			        Map<String, Object> map = new HashMap<>();
			        
			        map.put("empNo", emp.getEmpNo());
			        map.put("empName", emp.getEmpName());
			        map.put("empPosition", emp.getEmpPosition());
			        map.put("empDept", emp.getEmpDept());
			        
			        if (emp.getEmpDept() != 0) {
			            try {
			                String deptName = messageDao.selectDetpNameById(emp.getEmpDept());
			                map.put("empDeptName", deptName);
			            } catch (Exception e) {
			                map.put("empDeptName", "소속없음");
			            }
			        } else {
			            map.put("empDeptName", "소속없음");
			        }
			        
			        resultList.add(map);
			    }
		
				return resultList;
		}
	//4. 쪽지 상세 매핑
	@RequestMapping("/detail")
	public String detail(Model model, HttpSession session, 
			@RequestParam long messageNo, @RequestParam String type) {
		String loginId = (String)session.getAttribute("loginId");
	    String loginNo = (String)session.getAttribute("loginNo");
	    EmpDto empDto = empDao.selectOne(loginId);
	    MessageDto messageDto = messageService.detail(messageNo, empDto);

	    MessageDto prevMessageDto = null;
	    MessageDto nextMessageDto = null;
	    if(type.equals("receive")) {
	        prevMessageDto = messageDao.selectPreviousReceive(messageNo, loginNo);

	        nextMessageDto =
	                messageDao.selectNextReceive(
	                        messageNo, loginNo);
	    }
	    else if(type.equals("send")) {
	        prevMessageDto =
	                messageDao.selectPreviousSend(
	                        messageNo, loginNo);

	        nextMessageDto =
	                messageDao.selectNextSend(
	                        messageNo, loginNo);
	    }

	    model.addAttribute("messageDto", messageDto);
	    model.addAttribute("prevMessageDto", prevMessageDto);
	    model.addAttribute("nextMessageDto", nextMessageDto);
	    model.addAttribute("type", type);

	    return "message/detail";
	}
	
	//5. 쪽지 삭제 매핑
	@RequestMapping("/delete")
	public String delete(@RequestParam long messageNo, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
	    EmpDto empDto = empDao.selectOne(loginId);
	    messageService.delete(messageNo, empDto);
		return "redirect:./adminList";
	}
	@RequestMapping("/deleteAll")
	public String deleteAll(@RequestParam List<Long> messageNoList) {
		for(Long messageNo : messageNoList)	{
			MessageDto messageDto = messageDao.selectOne(messageNo);
			if(messageDto == null) throw new TargetNotfoundException("존재하지 않는 게시글이 포함되어있습니다");
		}
		for(Long messageNo : messageNoList)	{
			messageDao.delete(messageNo);
		}
		return "redirect:./adminList";
	}
}
