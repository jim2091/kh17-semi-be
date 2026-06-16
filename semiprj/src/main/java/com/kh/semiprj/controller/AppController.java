package com.kh.semiprj.controller;

import java.util.ArrayList;
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
		String loginId = (String) session.getAttribute("loginId");
		String empNo = appDao.selectEmpNoById(loginId);

		AppDto appDto = appDao.selectOneById(appId);
		if (appDto == null)
			return "redirect:./list";

		List<AppLineDto> lineList = appLineDao.selectByAppId(appId);
		model.addAttribute("appDto", appDto);
		model.addAttribute("lineList", lineList);
		model.addAttribute("loginEmpNo", empNo);

		// 문서 종류에 따라 추가 정보 조회
		if ("휴가신청서".equals(appDto.getAppType())) {
			VacAppDto vacAppDto = appDao.selectVacByAppId(appId);
			model.addAttribute("vacAppDto", vacAppDto);
		} else if ("품의서".equals(appDto.getAppType())) {
			ExpAppDto expAppDto = appDao.selectExpByAppId(appId);
			model.addAttribute("expAppDto", expAppDto);
		} else if ("업무기안서".equals(appDto.getAppType())) {
			DftAppDto dftAppDto = appDao.selectDftByAppId(appId);
			model.addAttribute("dftAppDto", dftAppDto);
		}

		return "app/detail";
	}

	// 수정(결재 or 반려)
	@PostMapping("/edit")
	public String edit(@RequestParam int appId, @RequestParam String appStatus, HttpSession session,
			RedirectAttributes attr) {
		return "redirect:/app/list";
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
			HttpSession session, RedirectAttributes redirectAttributes) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:./vacInsert";

		// 중복 결재자 체크
		List<String> approvers = new ArrayList<>();
		approvers.add(approver1);
		if (approver2 != null && !approver2.isEmpty()) {
			if (approvers.contains(approver2)) {
				redirectAttributes.addFlashAttribute("errorMsg", "중복된 결재자가 있습니다.");
				return "redirect:./vacInsert";
			}
			approvers.add(approver2);
		}
		if (approver3 != null && !approver3.isEmpty()) {
			if (approvers.contains(approver3)) {
				redirectAttributes.addFlashAttribute("errorMsg", "중복된 결재자가 있습니다.");
				return "redirect:./vacInsert";
			}
			approvers.add(approver3);
		}

		vacAppDto.setAppReqId(empNo);
		vacAppDto.setAppType("휴가신청서");
		vacAppDto.setAppStatus("처리중");
		int nextAppId = appDao.sequence();
		vacAppDto.setAppId(nextAppId);

		try {
			appDao.insert(vacAppDto);
			vacAppDao.insertVacApp(vacAppDto);

			// 결재선 등록
			for (int i = 0; i < approvers.size(); i++) {
				AppLineDto line = new AppLineDto();
				line.setAppId(nextAppId);
				line.setAppAppId(approvers.get(i));
				line.setAppLineOrder(i + 1);
				line.setAppLineType("휴가신청서");
				appLineDao.insert(line);
			}

			// 첫 번째 결재자 진행중으로 활성화
			appLineDao.activateFirst(nextAppId);

		} catch (Exception e) {
			System.out.println("====== DB INSERT 에러 발생 ======");
			e.printStackTrace();
			return "redirect:./vacInsert";
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
			HttpSession session, RedirectAttributes redirectAttributes) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:./expInsert";

		// 중복 결재자 체크
		List<String> approvers = new ArrayList<>();
		approvers.add(approver1);
		if (approver2 != null && !approver2.isEmpty()) {
			if (approvers.contains(approver2)) {
				redirectAttributes.addFlashAttribute("errorMsg", "중복된 결재자가 있습니다.");
				return "redirect:./expInsert";
			}
			approvers.add(approver2);
		}
		if (approver3 != null && !approver3.isEmpty()) {
			if (approvers.contains(approver3)) {
				redirectAttributes.addFlashAttribute("errorMsg", "중복된 결재자가 있습니다.");
				return "redirect:./expInsert";
			}
			approvers.add(approver3);
		}

		expAppDto.setAppReqId(empNo);
		expAppDto.setAppType("품의서");
		expAppDto.setAppStatus("처리중"); // 대기 → 처리중으로 수정
		int nextAppId = appDao.sequence();
		expAppDto.setAppId(nextAppId);

		try {
			appDao.insert(expAppDto);
			expAppDao.insertExpApp(expAppDto);

			// 결재선 등록
			for (int i = 0; i < approvers.size(); i++) {
				AppLineDto line = new AppLineDto();
				line.setAppId(nextAppId);
				line.setAppAppId(approvers.get(i));
				line.setAppLineOrder(i + 1);
				line.setAppLineType("품의서");
				appLineDao.insert(line);
			}

			// 첫 번째 결재자 진행중으로 활성화
			appLineDao.activateFirst(nextAppId);

		} catch (Exception e) {
			System.out.println("====== DB INSERT 에러 발생 ======");
			e.printStackTrace();
			return "redirect:./expInsert";
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
	public String dftInsert(@ModelAttribute DftAppDto dftAppDto, @RequestParam String approver1,
			@RequestParam(required = false) String approver2, @RequestParam(required = false) String approver3,
			HttpSession session, RedirectAttributes redirectAttributes) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null)
			return "redirect:./dftInsert";

		// 중복 결재자 체크
		List<String> approvers = new ArrayList<>();
		approvers.add(approver1);
		if (approver2 != null && !approver2.isEmpty()) {
			if (approvers.contains(approver2)) {
				redirectAttributes.addFlashAttribute("errorMsg", "중복된 결재자가 있습니다.");
				return "redirect:./dftInsert";
			}
			approvers.add(approver2);
		}
		if (approver3 != null && !approver3.isEmpty()) {
			if (approvers.contains(approver3)) {
				redirectAttributes.addFlashAttribute("errorMsg", "중복된 결재자가 있습니다.");
				return "redirect:./dftInsert";
			}
			approvers.add(approver3);
		}

		dftAppDto.setAppReqId(empNo);
		dftAppDto.setAppType("업무기안서");
		dftAppDto.setAppStatus("처리중"); // 대기 → 처리중으로 수정
		int nextAppId = appDao.sequence();
		dftAppDto.setAppId(nextAppId);

		try {
			appDao.insert(dftAppDto);
			dftAppDao.insertDftApp(dftAppDto);

			// 결재선 등록
			for (int i = 0; i < approvers.size(); i++) {
				AppLineDto line = new AppLineDto();
				line.setAppId(nextAppId);
				line.setAppAppId(approvers.get(i));
				line.setAppLineOrder(i + 1);
				line.setAppLineType("업무기안서");
				appLineDao.insert(line);
			}

			// 첫 번째 결재자 진행중으로 활성화
			appLineDao.activateFirst(nextAppId);

		} catch (Exception e) {
			System.out.println("====== DB INSERT 에러 발생 ======");
			e.printStackTrace();
			return "redirect:./dftInsert";
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
		model.addAttribute("currentTab", "app");

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

//	//picker 용 매핑
//	@GetMapping("/searchApprover")
//	@ResponseBody
//	public List<Map<String, Object>> searchApprover(
//	        @RequestParam String keyword,
//	        @RequestParam(required = false) List<String> excludes) {
//	    return appDao.searchApproverForPicker(keyword, excludes);
//	}

	@GetMapping("/searchApprover")
	@ResponseBody
	public List<Map<String, Object>> searchApprover(@RequestParam String keyword,
	        @RequestParam(required = false) List<String> excludes, HttpSession session) {

	    // 본인 제외
	    String loginId = (String) session.getAttribute("loginId");
	    String empNo = appDao.selectEmpNoById(loginId);
	    if (excludes == null) excludes = new ArrayList<>();
	    if (!excludes.contains(empNo)) excludes.add(empNo);

	    List<Map<String, Object>> approverList = appDao.searchApproverForPicker(keyword, excludes);
	    if (approverList == null || approverList.isEmpty()) return approverList;

	    for (Map<String, Object> map : approverList) {
	        String deptId = (String) map.get("empDept");
	        if (deptId != null && !deptId.isEmpty()) {
	            try {
	                String deptName = appDao.selectDeptNameById(Integer.parseInt(deptId));
	                if (deptName != null) map.put("empDept", deptName);
	            } catch (NumberFormatException e) {
	                map.put("empDept", "소속없음");
	            }
	        }
	    }

	    return approverList;
	}

}
