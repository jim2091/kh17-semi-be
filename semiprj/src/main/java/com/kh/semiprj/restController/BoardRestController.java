package com.kh.semiprj.restController;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.kh.semiprj.dao.BoardDao;
import com.kh.semiprj.dao.BoardLikeDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.BoardDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.service.NotificationService;
import com.kh.semiprj.vo.LikeVO;

import jakarta.servlet.http.HttpSession;

//@CrossOrigin
@RestController
@RequestMapping("/rest/board")
public class BoardRestController {
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private BoardLikeDao boardLikeDao;
	@Autowired
	private EmpDao empDao;
	@Autowired
	private NotificationService notificationService;
	
	//(1) 최초 접속 시 좋아요 여부와 현재 글의 좋아요 개수를 구해주는 매핑
	@PostMapping("/like-check")
	public LikeVO likeCheck(@RequestParam long boardNo, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
	    EmpDto empDto = empDao.selectOne(loginId);
	    String empNo = empDto.getEmpNo();
	    boolean action = boardLikeDao.check(empNo, boardNo);
		int count = boardLikeDao.count(boardNo);
		return LikeVO.builder().action(action).count(count).build();
	}
	
	//(2) 좋아요 클릭 시 좋아요 토글 처리와 결과적으로 만들어진 좋아요 개수를 구해주는 매핑
	@PostMapping("/like-action")
	public LikeVO likeAction(@RequestParam long boardNo, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		String empNo = empDto.getEmpNo();
		boolean current = boardLikeDao.check(empNo, boardNo);
		if(current) {//좋아요 설정한 적이 있으면
			boardLikeDao.delete(empNo, boardNo);//좋아요 해제
		}
		else {
			boardLikeDao.insert(empNo, boardNo);//좋아요 설정
			//알림 생성
			BoardDto boardDto = boardDao.selectOne(boardNo);
			String receiver = boardDto.getBoardWriter();
			notificationService.notifyLike(receiver, boardNo);
		}
		int count = boardLikeDao.count(boardNo);
		
		//게시글 테이블 좋아요 개수를 최신화
		boardDao.updateBoardLikecount(boardNo);
		
		//return Map.of("action", !current ,"count", count);
		return LikeVO.builder().action(!current).count(count).build();
	}
}
