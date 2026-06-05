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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.DftAppDao;
import com.kh.semiprj.dao.ExpAppDao;
import com.kh.semiprj.dao.VacAppDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

//전자결재
@Controller
@RequestMapping("/app")
public class AppController {
	@Autowired
	private AppDao appDao;
	@Autowired
	private VacAppDao vacAppDao;
	@Autowired
	private DftAppDao dftAppDao;
	@Autowired
	private ExpAppDao expAppDao;

	// 목록
	@RequestMapping("/list")
	public String list(@ModelAttribute PageVO pageVO, Model model, HttpSession session) {
		// 로그인 된 사원정보 가져오기
		String loginId = (String) session.getAttribute("loginId");
		AppDto appDto = appDao.selectOne(loginId);

		// 목록조회(자기것만)
		List<AppDto> list = appDao.selectMyList(loginId);
		model.addAttribute("list", list);
		return "/app/list";
	}

	// 상세
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		AppDto appDto = appDao.selectOne(loginId);
		appDao.selectOne(loginId);
		model.addAttribute("appDto", appDto);
		return "app/detail";
	}

	// 수정(결재 or 반려)
	@PostMapping("/edit")
	public String edit(@RequestParam int appId, @RequestParam String appStatus, HttpSession session,
			RedirectAttributes attr) {

		return "redirect:/app/list";
	}

//	@GetMapping("/insert")
//	public String insert(HttpSession session, Model model) {
//	    Object sessionEmpNo = session.getAttribute("loginEmpNo");
//	    model.addAttribute("empNo", sessionEmpNo);
//	    return "/app/insert";
//	}

	@GetMapping("/insert")
	public String insert(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		String empName = appDao.selectEmpNameById(loginId);
		model.addAttribute("empName", empName);

		return "/app/insert";
	}

	@PostMapping("/insert")
	public String insert(@ModelAttribute AppDto appDto, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";
		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:/app/insert";
		appDto.setAppReqId(empNo);
		int nextAppId = appDao.sequence();
		appDto.setAppId(nextAppId);
		try {
			appDao.insert(appDto);
		} catch (Exception e) {
			return "redirect:/app/insert";
		}

		return "redirect:./insertComplete";
	}

	@RequestMapping("/insertComplete")
	public String insertComplete(HttpSession session) {
		return "/app/insertComplete";
	}

	@GetMapping("/vacInsert")
	public String vacInsert(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		String empName = appDao.selectEmpNameById(loginId);
		model.addAttribute("empName", empName);

		return "/app/vacInsert";
	}

	@PostMapping("/vacInsert")
	public String vacInsert(@ModelAttribute VacAppDto vacAppDto, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:./vacInsert";

		vacAppDto.setAppReqId(empNo);
		vacAppDto.setAppType("휴가신청서");

		int nextAppId = appDao.sequence();
		vacAppDto.setAppId(nextAppId);
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);

		return "redirect:./insertComplete";
	}

	// 품의서
	@GetMapping("/expInsert")
	public String expInsert(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		String empName = appDao.selectEmpNameById(loginId);
		model.addAttribute("empName", empName);
		return "/app/expInsert";
	}

	@PostMapping("/expInsert")
	public String expInsert(@ModelAttribute ExpAppDto expAppDto, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:./expInsert";

		expAppDto.setAppReqId(empNo);
		expAppDto.setAppType("품의서");

		int nextAppId = appDao.sequence();
		expAppDto.setAppId(nextAppId);

		appDao.insert(expAppDto);
		expAppDao.insertExpApp(expAppDto);

		return "redirect:./insertComplete";
	}

	// 업무기안서
	@GetMapping("/dftInsert")
	public String dftInsert(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		String empName = appDao.selectEmpNameById(loginId);
		model.addAttribute("empName", empName);
		return "/app/dftInsert";
	}

	@PostMapping("/dftInsert")
	public String dftInsert(@ModelAttribute DftAppDto dftAppDto, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:./dftInsert";

		dftAppDto.setAppReqId(empNo);
		dftAppDto.setAppType("업무기안서");

		int nextAppId = appDao.sequence();
		dftAppDto.setAppId(nextAppId);

		appDao.insert(dftAppDto);
		dftAppDao.insertDftApp(dftAppDto);

		return "redirect:./insertComplete";
	}

}
