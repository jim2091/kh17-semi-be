package com.kh.semiprj.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.semiprj.dao.BoardDao;
import com.kh.semiprj.dao.BoardReadDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.ReplyDao;
import com.kh.semiprj.dto.BoardDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.ReplyDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class BoardController {
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private EmpDao empDao;
	@Autowired
	private BoardReadDao boardReadDao;
	@Autowired
	private ReplyDao replyDao;
	
	//1. 게시글 등록 매핑
	@GetMapping("/write")
	public String write() {
		return "board/write";
	}
	@PostMapping("/write") 
	public String write(@ModelAttribute BoardDto boardDto, HttpSession session){
		//(1) 작성자 아이디 추출
		String loginId = (String)session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		//(2) 게시글 종류가 '공지'라면 작성자가 '관리자'인지 확인
		if(boardDto.getBoardHead() != null && boardDto.getBoardHead().equals("공지")) {
			String loginRole = (String) session.getAttribute("loginRole");
			if(!loginRole.equals("관리자")) {
				throw new GetOutException();
			}
		}
		//(3) 게시글 번호 생성
		long boardNo = boardDao.sequence();
		//(4) 새글/답글 계산하고 글 등록
	    boardDto.setBoardWriter(empDto.getEmpNo());
	    boardDto.setBoardNo(boardNo);  
	    if(boardDto.getBoardParent() == null) {
	    	boardDto.setBoardGroup(boardNo);
	    }
	    else {
	    	BoardDto findBoardDto = boardDao.selectOne(boardDto.getBoardParent());
	    	boardDto.setBoardGroup(findBoardDto.getBoardGroup());
	    	boardDto.setBoardDepth(findBoardDto.getBoardDepth()+1);
	    }
	    boardDao.insert(boardDto);
	    //(5) 등록한 게시글 상세 페이지로 리다이렉트
		return "redirect:./detail?boardNo=" + boardNo;
	}
	
	//2. 게시글 목록 매핑
	@RequestMapping("/list")
	public String list(Model model, @ModelAttribute PageVO pageVO) {
		//(1) 목록 조회
		List<BoardDto> noticeList = boardDao.selectNoticeList();
		for(BoardDto boardDto : noticeList) {
			EmpDto empDto = empDao.selectOneByDetail(boardDto.getBoardWriter());
			if(empDto != null) {
				boardDto.setEmpName(empDto.getEmpName());
			}
			else {
				boardDto.setEmpName("(퇴사한 사용자)");
			}
		}
		List<BoardDto> boardList = boardDao.selectList(pageVO);
		for(BoardDto boardDto : boardList) {
			EmpDto empDto = empDao.selectOneByDetail(boardDto.getBoardWriter());
			if(empDto != null) {
				boardDto.setEmpName(empDto.getEmpName());
			}
			else {
				boardDto.setEmpName("(퇴사한 사용자)");
			}
		}
		List<BoardDto> list = new ArrayList<>();
		list.addAll(noticeList);
		list.addAll(boardList);
		//(2) 전체 개수 조회
		int count = boardDao.count(pageVO);
		pageVO.setCount(count);
		//(3) 화면 전달
		model.addAttribute("list", list);
		model.addAttribute("noticeCount", noticeList.size());
		model.addAttribute("pageVO", pageVO);
		return "board/list";
	}
	
	//(+추가) 내가 쓴 글 게시글 목록
	@RequestMapping("/my")
	public String my(HttpSession session, Model model, @ModelAttribute PageVO pageVO) {
		String loninNo = (String) session.getAttribute("loginNo");
		List<BoardDto> list = boardDao.selectMyList(loninNo, pageVO);
		int count = boardDao.countMyList(loninNo);
		pageVO.setCount(count);
		model.addAttribute("list", list);
		model.addAttribute("pageVO", pageVO);

		return "board/my";
	}
	
	//(+추가) 내가 쓴 댓글 목록
	@RequestMapping("/myReply")
	public String myReply(HttpSession session, Model model, @ModelAttribute PageVO pageVO) {
		String loginNo = (String)session.getAttribute("loginNo");
		List<ReplyDto> list = replyDao.selectMyList(loginNo, pageVO);
		int count =replyDao.countMyList(loginNo);
		pageVO.setCount(count);
		model.addAttribute("list", list);
		model.addAttribute("pageVO", pageVO);

		return "board/myReply";
	}
	
	//3. 게시글 상세 매핑
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam long boardNo, HttpSession session) {
		boardDao.updateBoardReadcount(boardNo);
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다.");
		
		if("비밀".equals(boardDto.getBoardType())) {
			String loginRole = (String)session.getAttribute("loginRole");
			String loginId = (String)session.getAttribute("loginId");
			EmpDto loginEmpDto = empDao.selectOne(loginId);
			boolean isAdmin = "관리자".equals(loginRole);
			boolean isWriter = loginEmpDto.getEmpNo().equals(boardDto.getBoardWriter());
			if(!isAdmin && !isWriter) {
				throw new GetOutException();
			}
		}
		EmpDto empDto = empDao.selectOneByDetail(boardDto.getBoardWriter());
		if(empDto != null) {
			boardDto.setEmpName(empDto.getEmpName());
			boardDto.setEmpId(empDto.getEmpId());
		}
		else {
			boardDto.setEmpName("(퇴사한 사용자)");
		}
		model.addAttribute("boardDto", boardDto);
		
		//이전 글과 다음 글을 조회하여 첨부
		model.addAttribute("prevBoardDto", boardDao.selectPreviousOne(boardNo));
		model.addAttribute("nextBoardDto", boardDao.selectNextOne(boardNo));
		
		return "board/detail";
	}
	
	//4. 게시글 수정 매핑
	@GetMapping("/edit")
	public String edit(@RequestParam long boardNo, Model model) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		//(1) 존재하는 게시글인지 확인하고 예외 처리
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다.");
		model.addAttribute("boardDto", boardDto);
		return "board/edit";
	}
	@PostMapping("/edit")
	public String edit(@ModelAttribute BoardDto boardDto, HttpSession session) {
		//(2) 게시글 종류가 '공지'라면 작성자가 '관리자'인지 확인
		if(boardDto.getBoardHead() != null && boardDto.getBoardHead().equals("공지")) {
			String loginRole = (String) session.getAttribute("loginRole");
			if(!loginRole.equals("관리자")) {
				throw new GetOutException();
			}
		}
	    BoardDto findBoardDto = boardDao.selectOne(boardDto.getBoardNo());
	    if(findBoardDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다.");
		boardDao.update(boardDto);
		//(3) 수정한 게시글 상세 페이지로 리다이렉트
		return "redirect:./detail?boardNo=" + boardDto.getBoardNo();
	}
	
	//5. 게시글 삭제 매핑
	@RequestMapping("/delete")
	public String delete(@RequestParam long boardNo) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 게시글입니다.");
		boardDao.delete(boardNo);
		return "redirect:./list";
	}
}
