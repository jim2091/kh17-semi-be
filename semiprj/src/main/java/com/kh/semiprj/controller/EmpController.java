package com.kh.semiprj.controller;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.kh.semiprj.dao.CertDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.EmpHistoryDao;
import com.kh.semiprj.dto.CertDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.EmpHistoryDto;
import com.kh.semiprj.service.EmailService;
import com.kh.semiprj.vo.CertNumVo;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.service.AttachService;
import com.kh.semiprj.vo.HistoryPageVO;

import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/emp")
public class EmpController {
	
	@Autowired
	private EmpDao empDao;
	@Autowired
	private EmpHistoryDao empHistoryDao;
	@Autowired
	private EmailService emailService;
	@Autowired
	private CertDao certDao;
	@Autowired
	private AttachService attachService;

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
		if (findEmpDto.getEmpLevel().equals("관리자")) {
			session.setAttribute("masterToggle", true);
		}
		return "redirect:/";
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		session.removeAttribute("loginId");
		session.removeAttribute("loginLevel");
		session.removeAttribute("loginNo");
		
		return "redirect:/";
	}
	
	@GetMapping("/find_id")
	public String find_id() {
		return "emp/find_id";
	}
	@PostMapping("/find_id")
	public String find_id(@ModelAttribute EmpDto empDto, HttpSession session) throws MessagingException, IOException {
		EmpDto findEmpDto = empDao.selectOneforFindId(empDto.getEmpEmail(), empDto.getEmpName());
		if (findEmpDto == null) {
			return "redirect:./find_id?error";
		}
		//비활성화된 사원? 퇴사한 사원? 어떻게 처리할지 사원파트 다 하시면 확인
		emailService.sendCertNumber(empDto.getEmpEmail());
		
		session.setAttribute("findIdEmail", empDto.getEmpEmail());
		
		return "redirect:./cert_id";
	}
	
	@GetMapping("/cert_id")
	public String cert_id() {
		return "emp/cert_id";
	}
	@PostMapping("/cert_id")
	public String cert_id(@ModelAttribute CertNumVo certNumVo, HttpSession session,
							RedirectAttributes redirectAttributes) {
		String certEmail = (String) session.getAttribute("findIdEmail");
		CertDto findCertDto = certDao.selectOne(certEmail);
		
		if(findCertDto == null) return "redirect:./cert_id?error";
		
		boolean valid = certNumVo.concat().equals(findCertDto.getCertNumber());

		if(!valid) return "redirect:./cert_id?error";
		
		LocalDateTime current = LocalDateTime.now();
		LocalDateTime sent = findCertDto.getCertTime().toLocalDateTime();
		Duration duration = Duration.between(sent, current);
		if(duration.toMinutes() > 10) return "redirect:./cert_id?error";
		if(findCertDto.isComplete()) return "redirect:./cert_id?error";
		
		certDao.update(certEmail);
		session.removeAttribute("findIdEmail");
		
		String findId = empDao.selectIdByEmail(certEmail);
		//다음 페이지에 넘겨주고 자동 삭제되는 세션?
		redirectAttributes.addFlashAttribute("findId", findId);
		
		return "redirect:./find_id_complete";
	}
	
	@RequestMapping("/find_id_complete")
	public String find_id_complete() {
		return "emp/find_id_complete";
	}
	
	@GetMapping("/find_pw")
	public String find_pw() {
		return "emp/find_pw";
	}
	@PostMapping("/find_pw")
	public String find_pw(@ModelAttribute EmpDto empDto, HttpSession session) throws MessagingException, IOException {
		EmpDto findEmpDto = empDao.selectOneforFindId(empDto.getEmpEmail(), empDto.getEmpName());
		if (findEmpDto == null) {
			return "redirect:./find_pw?error";
		}
		//비활성화된 사원? 퇴사한 사원? 어떻게 처리할지 사원파트 다 하시면 확인
		emailService.sendCertNumber(empDto.getEmpEmail());
		
		session.setAttribute("findPwEmail", empDto.getEmpEmail());
		
		return "redirect:./cert_pw";
	}
	
	@GetMapping("/cert_pw")
	public String cert_pw() {
		return "emp/cert_pw";
	}
	@PostMapping("/cert_pw")
	public String cert_pw(@ModelAttribute CertNumVo certNumVo, HttpSession session,
							RedirectAttributes redirectAttributes) {
		String certEmail = (String) session.getAttribute("findPwEmail");
		CertDto findCertDto = certDao.selectOne(certEmail);
		
		if(findCertDto == null) return "redirect:./cert_pw?error";
		
		boolean valid = certNumVo.concat().equals(findCertDto.getCertNumber());

		if(!valid) return "redirect:./cert_pw?error";
		
		LocalDateTime current = LocalDateTime.now();
		LocalDateTime sent = findCertDto.getCertTime().toLocalDateTime();
		Duration duration = Duration.between(sent, current);
		if(duration.toMinutes() > 10) return "redirect:./cert_pw?error";
		if(findCertDto.isComplete()) return "redirect:./cert_pw?error";
		
		certDao.update(certEmail);
		session.removeAttribute("findPwEmail");
		
		String findId = empDao.selectIdByEmail(certEmail);
		//다음 페이지에 넘겨주고 자동 삭제되는 세션?
		redirectAttributes.addFlashAttribute("empId", findId);
		
		return "redirect:./change_pw";
	}
	
	@GetMapping("/change_pw")
	public String change_pw() {
		return "emp/change_pw";
	}
	
	@PostMapping("/change_pw")
	public String change_pw(@ModelAttribute EmpDto empDto) {
		empDao.updateEmpPw(empDto);
		return "redirect:./change_pw_complete";
	}
	
	@RequestMapping("/change_pw_complete")
	public String change_pw_complete() {
		return "emp/change_pw_complete";
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
		List<EmpDto> list = empDao.selectListByUser(column, keyword);
		
		model.addAttribute("list", list);
		
		return "emp/list";
	}
	@RequestMapping("/detail")
	public String detail(@RequestParam String empNo, Model model) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		
		if(empDto == null) {
			throw new TargetNotfoundException("존재하지 않는 사원");
		}
		
		model.addAttribute("empDto", empDto);
		
		
		return "emp/detail";
	}
	
	@GetMapping("/edit")
	public String edit(@RequestParam String empNo, Model model) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		if(empDto == null) throw new TargetNotfoundException("대상이 존재하지 않습니다");
		model.addAttribute("empDto", empDto);
//		System.out.println(empDto);
		return "emp/edit";
	}
	
	@PostMapping("/edit") 
	public String edit(@ModelAttribute EmpDto empDto, 
				@RequestParam MultipartFile attach) throws IllegalStateException, IOException {
	    EmpDto findEmpDto = empDao.selectOneByDetail(empDto.getEmpNo());
	    if(findEmpDto == null) throw new TargetNotfoundException("존재하지 않는 회원");
	    
	  
	    empDao.updateByUser(empDto); 
	    
	    String empNo = empDto.getEmpNo();
	    
	    if(!attach.isEmpty()) {
	    	try {
				int attachNo = empDao.searchProfile(empNo);
				attachService.delete(attachNo);
			}catch(Exception e) {
				 e.printStackTrace();
			}
	    	
			int attachNo = attachService.save(attach);
			empDao.connect(empNo, attachNo);
		}
	    
	    return "redirect:./mypage"; 
	}
	 
	
	
	@GetMapping("/password")
	public String password() {
		return "emp/password";
	}
	
	@PostMapping("/password")
	public String password(@RequestParam String originPw, @RequestParam String changePw, 
									HttpSession session) {
		if(originPw.equals(changePw)) return "redirect:./password?error";
		
		String loginId = (String) session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		
		if(!empDto.getEmpPw().equals(originPw)) {
			return "redirect:./password?error";
		}
		empDto.setEmpPw(changePw);
		empDao.updateEmpPw(empDto);
		return "redirect:./mypage";	
	}
	@RequestMapping("/profile")
	public String profile(@RequestParam String empNo) {
		try {
			int attachNo = empDao.searchProfile(empNo);
//			System.out.println("attachNo = " + attachNo);
			return "redirect:/download/modern?attachNo=" + attachNo;
		}
		catch(Exception e ){
			e.printStackTrace();
			return "redirect:/images/no_image.png";
		}
	}
	@RequestMapping("/history")
	public String history(HttpSession session, 
								@ModelAttribute HistoryPageVO historyPageVO,
								Model model) {
		String loginNo = (String) session.getAttribute("loginNo");
//		System.out.println(empDao.selectOneByDetail(loginNo));
//		System.out.println(historyPageVO);
		EmpDto empDto = empDao.selectOneByDetail(loginNo);
		if(empDto == null) throw new TargetNotfoundException("대상이 존재하지 않습니다");
		model.addAttribute("empDto", empDto);
		
		List<EmpHistoryDto> loginhistory = 
				empHistoryDao.selectList(loginNo, historyPageVO);
//		System.out.println(loginhistory);
		model.addAttribute("loginhistory", loginhistory);
		int count = empHistoryDao.count(loginNo, historyPageVO);
		historyPageVO.setCount(count);
		model.addAttribute("historyPageVO", historyPageVO);
		return "emp/history";
	}
	

	
	
}
