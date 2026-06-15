package com.kh.semiprj.restController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.BoardDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.ReplyDao;
import com.kh.semiprj.dto.BoardDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.ReplyDto;
import com.kh.semiprj.exception.GetOutException;
import com.kh.semiprj.service.NotificationService;
import com.kh.semiprj.vo.PageVO;
import com.kh.semiprj.vo.ReplyVO;

import jakarta.servlet.http.HttpSession;

//@CrossOrigin
@RestController
@RequestMapping("/rest/reply")
public class ReplyRestController {
	@Autowired 
	private ReplyDao replyDao;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private EmpDao empDao;
	@Autowired
	private NotificationService notificationService;
	
	//댓글 등록 매핑
	@PostMapping("/write")
	public void write(@ModelAttribute ReplyDto replyDto, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		long replyNo = replyDao.sequence();
		replyDto.setReplyNo(replyNo);
		replyDto.setReplyWriter(empDto.getEmpNo());
		if(replyDto.getReplyParent() != null) {
		    if(!replyDao.canWriteChildReply(replyDto.getReplyParent())) {
		        throw new GetOutException();
		    }
		}
		if(replyDto.getReplyContent() != null
			    && replyDto.getReplyContent().length() > 500) {
			    throw new RuntimeException("댓글은 500자 이하만 작성 가능합니다.");
			}
		replyDao.insert(replyDto);
		boardDao.updateBoardReplycount(replyDto.getReplyOrigin());
		//알림 생성
		BoardDto originBoardDto = boardDao.selectOne(replyDto.getReplyOrigin());
		String receiver = originBoardDto.getBoardWriter();
		notificationService.notifyComment(receiver, replyDto.getReplyOrigin());
	}
	
	//댓글 목록 매핑
	@PostMapping("/list")
	public List<ReplyVO> list(@RequestParam long replyOrigin, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		BoardDto boardDto = boardDao.selectOne(replyOrigin);
		EmpDto empDto = empDao.selectOne(loginId);
		List<ReplyDto> originList = replyDao.selectList(replyOrigin);
		List<ReplyVO> newList = new ArrayList<>();
		boolean admin = empDto != null && "관리자".equals(empDto.getEmpLevel());
		//- 게시글 유형이 익명일 경우 댓글 작성자 이름을 익명 처리
		boolean anonymous = "익명".equals(boardDto.getBoardType());
		Map<String, Integer> anonymousMap = new HashMap<>();
		int anonymousSequence = 1;
		
		for(ReplyDto replyDto : originList) {
			boolean writer = boardDto.getBoardWriter() != null
					&& boardDto.getBoardWriter().equals(replyDto.getReplyWriter());
			boolean owner = empDto != null && String.valueOf(empDto.getEmpNo()).equals(replyDto.getReplyWriter());
			String displayName;
			if(anonymous) {
				String writerNo = replyDto.getReplyWriter();
				if(!anonymousMap.containsKey(writerNo)) {
		            anonymousMap.put(writerNo, anonymousSequence++);
		        }
		        displayName = "익명" + anonymousMap.get(writerNo);
		    }
		    else {
		        displayName = replyDto.getEmpName();
		    }
			newList.add(ReplyVO.builder()
						.replyNo(replyDto.getReplyNo())
						.replyWriter(replyDto.getReplyWriter())
						.empName(displayName)
						.replyContent(replyDto.getReplyContent())
						.replyParent(replyDto.getReplyParent())
						.replyOrigin(replyDto.getReplyOrigin())
						.replyWtime(replyDto.getReplyWtime())
						.replyEtime(replyDto.getReplyEtime())
						.writer(writer)
						.owner(owner)
						.admin(admin)
					.build());
		}
		return newList;
	}
	
	//댓글 삭제 매핑
	@PostMapping("/delete")
	public void delete(@RequestParam long replyNo, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
	    EmpDto empDto = empDao.selectOne(loginId);
	    ReplyDto replyDto = replyDao.selectOne(replyNo);
	    if(replyDto == null) {
	        throw new GetOutException();
	    }
	    boolean owner = String.valueOf(empDto.getEmpNo()).equals(replyDto.getReplyWriter());
	    boolean admin = "관리자".equals(empDto.getEmpLevel());
	    if(!(owner || admin)) {
	    	throw new GetOutException();
	    }
	    
	    replyDao.delete(replyNo);
	    boardDao.updateBoardReplycount(replyDto.getReplyOrigin());
	}
	
	//댓글 수정 매핑
	@PostMapping("/edit")
	public void edit(@ModelAttribute ReplyDto replyDto, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
	    EmpDto empDto = empDao.selectOne(loginId);
	    ReplyDto findReplyDto = replyDao.selectOne(replyDto.getReplyNo());
	    if(findReplyDto == null) {
	        throw new GetOutException();
	    }
	    boolean owner = String.valueOf(empDto.getEmpNo()).equals(findReplyDto.getReplyWriter());
	    boolean admin = "관리자".equals(empDto.getEmpLevel());
	    if(!(owner || admin)) {
	    	throw new GetOutException();
	    }
		replyDao.update(replyDto);
	}
}
