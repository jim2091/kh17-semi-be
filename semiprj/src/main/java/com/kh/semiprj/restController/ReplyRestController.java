package com.kh.semiprj.restController;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.BoardDao;
import com.kh.semiprj.dao.ReplyDao;
import com.kh.semiprj.dto.BoardDto;
import com.kh.semiprj.dto.ReplyDto;
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
	
	//댓글 등록 매핑
	@PostMapping("/write")
	public void write(@ModelAttribute ReplyDto replyDto, HttpSession session) {
		long replyNo = replyDao.sequence();
		String loginId = (String)session.getAttribute("loginId");
		replyDto.setReplyNo(replyNo);
		replyDto.setReplyWriter(loginId);
		replyDao.insert(replyDto);
	}
	
	//댓글 목록 매핑
	@PostMapping("/list")
	public List<ReplyVO> list(@RequestParam long replyOrigin, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		BoardDto boardDto = boardDao.selectOne(replyOrigin);
		List<ReplyDto> originList = replyDao.selectList(replyOrigin);
		List<ReplyVO> newList = new ArrayList<>();
		for(ReplyDto replyDto : originList) {
			boolean writer = boardDto.getBoardWriter() != null
					&& boardDto.getBoardWriter().equals(replyDto.getReplyWriter());
			boolean owner = loginId != null && loginId.equals(replyDto.getReplyWriter());
			newList.add(ReplyVO.builder()
						.replyNo(replyDto.getReplyNo())
						.replyWriter(replyDto.getReplyWriter())
						.replyContent(replyDto.getReplyContent())
						.replyOrigin(replyDto.getReplyOrigin())
						.replyWtime(replyDto.getReplyWtime())
						.replyEtime(replyDto.getReplyEtime())
						.writer(writer)
						.owner(owner)
					.build());
		}
		return newList;
	}
	
	//댓글 삭제 매핑
	@PostMapping("/delete")
	public void delete(@RequestParam long replyNo) {
		replyDao.delete(replyNo);
	}
	
	//댓글 수정 매핑
	@PostMapping("/edit")
	public void edit(@ModelAttribute ReplyDto replyDto) {
		replyDao.update(replyDto);
	}
}
