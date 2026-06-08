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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.AppLineDao;
import com.kh.semiprj.dao.DftAppDao;
import com.kh.semiprj.dao.ExpAppDao;
import com.kh.semiprj.dao.VacAppDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.AppLineDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;

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
	@Autowired
	private AppLineDao appLineDao;

	// 상세
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
		AppDto appDto = appDao.selectOneById(appId);
		if (appDto == null)
			return "redirect:./list";

		List<AppLineDto> lineList = appLineDao.selectByAppId(appId);

		// loginEmpNo 추가!
		String loginId = (String) session.getAttribute("loginId");
		String empNo = appDao.selectEmpNoById(loginId);

		model.addAttribute("appDto", appDto);
		model.addAttribute("lineList", lineList);
		model.addAttribute("loginEmpNo", empNo);

		return "app/detail";
	}

	// 수정(결재 or 반려)
	@PostMapping("/edit")
	public String edit(@RequestParam int appId, @RequestParam String appStatus, HttpSession session,
			RedirectAttributes attr) {

		return "redirect:/app/list";
	}

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
		if (loginId == null)
			return "redirect:/login";
		String empName = appDao.selectEmpNameById(loginId);
		model.addAttribute("empName", empName);
		model.addAttribute("empList", appDao.selectAllEmp());
		return "/app/vacInsert";
	}

	@PostMapping("/vacInsert")
	public String vacInsert(@ModelAttribute VacAppDto vacAppDto, @RequestParam String approver1,
			@RequestParam(required = false) String approver2, @RequestParam(required = false) String approver3,
			HttpSession session) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";
		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:./vacInsert";

		vacAppDto.setAppReqId(empNo);
		vacAppDto.setAppType("휴가신청서");
		vacAppDto.setAppStatus("대기");
		int nextAppId = appDao.sequence();
		vacAppDto.setAppId(nextAppId);
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);

		// 결재자 1 (필수)
		AppLineDto line1 = new AppLineDto();
		line1.setAppId(nextAppId);
		line1.setAppAppId(approver1);
		line1.setAppLineOrder(1);
		line1.setAppLineType("휴가신청서");
		line1.setAppLineStatus("대기");
		appLineDao.insertAppr(line1); // ← insertAppr 사용!

		// 결재자 2 (선택)
		if (approver2 != null && !approver2.isEmpty()) {
			AppLineDto line2 = new AppLineDto();
			line2.setAppId(nextAppId);
			line2.setAppAppId(approver2);
			line2.setAppLineOrder(2);
			line2.setAppLineType("휴가신청서");
			line2.setAppLineStatus("대기");
			appLineDao.insertAppr(line2); // ← insertAppr 사용!
		}

		// 결재자 3 (선택)
		if (approver3 != null && !approver3.isEmpty()) {
			AppLineDto line3 = new AppLineDto();
			line3.setAppId(nextAppId);
			line3.setAppAppId(approver3);
			line3.setAppLineOrder(3);
			line3.setAppLineType("휴가신청서");
			line3.setAppLineStatus("대기");
			appLineDao.insertAppr(line3); // ← insertAppr 사용!
		}

		return "redirect:./insertComplete";
	}

	@GetMapping("/expInsert")
	public String expInsert(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";
		String empName = appDao.selectEmpNameById(loginId);
		model.addAttribute("empName", empName);
		model.addAttribute("empList", appDao.selectAllEmp());
		return "/app/expInsert";
	}

	@PostMapping("/expInsert")
	public String expInsert(@ModelAttribute ExpAppDto expAppDto, @RequestParam String approver1,
			@RequestParam(required = false) String approver2, @RequestParam(required = false) String approver3,
			HttpSession session) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";
		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:./expInsert";

		expAppDto.setAppReqId(empNo);
		expAppDto.setAppType("품의서");
		expAppDto.setAppStatus("대기");
		int nextAppId = appDao.sequence();
		expAppDto.setAppId(nextAppId);
		appDao.insert(expAppDto);
		expAppDao.insertExpApp(expAppDto);

		// 결재자 1 (필수) → 대기
		AppLineDto line1 = new AppLineDto();
		line1.setAppId(nextAppId);
		line1.setAppAppId(approver1);
		line1.setAppLineOrder(1);
		line1.setAppLineType("품의서");
		appLineDao.insert(line1);

		// 결재자 2 (선택) → 대기
		if (approver2 != null && !approver2.isEmpty()) {
			AppLineDto line2 = new AppLineDto();
			line2.setAppId(nextAppId);
			line2.setAppAppId(approver2);
			line2.setAppLineOrder(2);
			line2.setAppLineType("품의서");
			appLineDao.insert(line2);
		}

		// 결재자 3 (선택) → 대기
		if (approver3 != null && !approver3.isEmpty()) {
			AppLineDto line3 = new AppLineDto();
			line3.setAppId(nextAppId);
			line3.setAppAppId(approver3);
			line3.setAppLineOrder(3);
			line3.setAppLineType("품의서");
			appLineDao.insert(line3);
		}

		return "redirect:./insertComplete";
	}


	@GetMapping("/dftInsert")
	public String dftInsert(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";
		String empName = appDao.selectEmpNameById(loginId);
		model.addAttribute("empName", empName);
		model.addAttribute("empList", appDao.selectAllEmp());
		return "/app/dftInsert";
	}

	@PostMapping("/dftInsert")
	public String expInsert(@ModelAttribute DftAppDto dftAppDto, @RequestParam String approver1,
			@RequestParam(required = false) String approver2, @RequestParam(required = false) String approver3,
			HttpSession session) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";
		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:./dftInsert";

		dftAppDto.setAppReqId(empNo);
		dftAppDto.setAppType("업무기안서");
		dftAppDto.setAppStatus("대기");
		int nextAppId = appDao.sequence();
		dftAppDto.setAppId(nextAppId);
		appDao.insert(dftAppDto);
		dftAppDao.insertDftApp(dftAppDto);

		// 결재자 1 (필수) → 대기
		AppLineDto line1 = new AppLineDto();
		line1.setAppId(nextAppId);
		line1.setAppAppId(approver1);
		line1.setAppLineOrder(1);
		line1.setAppLineType("업무기안서");
		appLineDao.insert(line1);

		// 결재자 2 (선택) → 대기
		if (approver2 != null && !approver2.isEmpty()) {
			AppLineDto line2 = new AppLineDto();
			line2.setAppId(nextAppId);
			line2.setAppAppId(approver2);
			line2.setAppLineOrder(2);
			line2.setAppLineType("업무기안서");
			appLineDao.insert(line2);
		}

		// 결재자 3 (선택) → 대기
		if (approver3 != null && !approver3.isEmpty()) {
			AppLineDto line3 = new AppLineDto();
			line3.setAppId(nextAppId);
			line3.setAppAppId(approver3);
			line3.setAppLineOrder(3);
			line3.setAppLineType("업무기안서");
			appLineDao.insert(line3);
		}

		return "redirect:./insertComplete";
	}

	@RequestMapping("/list")
	public String list(@RequestParam(required = false) String appType, @RequestParam(required = false) String column,
			@RequestParam(required = false) String keyword, HttpSession session, Model model) {

		String loginId = (String) session.getAttribute("loginId");
		String empNo = appDao.selectEmpNoById(loginId);
		String empName = appDao.selectEmpNameById(loginId);
		model.addAttribute("empName", empName);

		List<AppDto> list;

		if (keyword != null && !keyword.isEmpty() && column != null) {
			list = appDao.searchList(empNo, column, keyword);
		} else if (appType != null && !appType.isEmpty()) {
			list = appDao.selectMyListByType(empNo, appType);
		} else {
			list = appDao.selectMyList(empNo);
		}
		model.addAttribute("list", list);
		return "/app/list";
	}

	// 사이드바 용 필터링(걸러내기)
	@GetMapping("/myNoneList")
	public String myNoneAppr(HttpSession session, Model model) {
		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
		model.addAttribute("list", appDao.selectMyNoneList(empNo));
		return "/app/list";
	}

	@GetMapping("/myAppr")
	public String myAppr(HttpSession session, Model model) {
		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
		model.addAttribute("list", appDao.selectMyApprList(empNo));
		return "/app/list";
	}

	@GetMapping("/myIng")
	public String myIng(HttpSession session, Model model) {
		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
		model.addAttribute("list", appDao.selectMyIngList(empNo));
		return "/app/list";
	}

	@GetMapping("/myRej")
	public String myRej(HttpSession session, Model model) {
		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
		model.addAttribute("list", appDao.selectMyRejList(empNo));
		return "/app/list";
	}

	@GetMapping("/myList")
	public String myList(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		String empNo = appDao.selectEmpNoById(loginId);
		model.addAttribute("list", appDao.selectMyList(empNo));
		return "/app/list";
	}

}
