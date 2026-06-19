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
import com.kh.semiprj.service.VacService;
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
	@Autowired
	private AppLineDao appLineDao;
	@Autowired
	private VacService vacService;

	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		String empNo = appDao.selectEmpNoById(loginId);

		AppDto appDto = appDao.selectOneById(appId);
		if (appDto == null) return "redirect:./list";

		// 1. 기존의 순수 결재선 데이터(부서 코드가 숫자인 상태) 조회
		List<AppLineDto> lineList = appLineDao.selectByAppId(appId);

		// 💡 [컨트롤러 조립부] 루프를 돌며 코드를 한글 부서명으로 치환
		for (AppLineDto line : lineList) {
			String deptCode = line.getEmpDept(); // 기존 테이블에 저장된 숫자 코드 추출
			String deptName = appDao.selectDeptNameByCode(deptCode); // 새로 만든 메서드로 이름 조회
			line.setEmpDept(deptName); // 한글 부서명으로 데이터 덮어쓰기
		}

		AppLineDto myTurn = null;
		for (AppLineDto line : lineList) {
			if (line.getAppAppId().equals(empNo) && line.getAppLineStatus().equals("진행중")) {
				myTurn = line;
				break;
			}
		}

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

		model.addAttribute("appDto", appDto);
		model.addAttribute("lineList", lineList); // 가공 완료된 리스트 전송
		model.addAttribute("myTurn", myTurn);
		return "appr/detail";
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
	public String vacInsert(@ModelAttribute VacAppDto vacAppDto, 
			@RequestParam String approver1,
			@RequestParam(required = false) String approver2, 
			@RequestParam(required = false) String approver3,
			HttpSession session, RedirectAttributes redirectAttributes) {

		System.out.println("====== [1. 진입 완료] vacInsert POST 매핑 시작 ======");

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null) return "redirect:./vacInsert";

		// 중복 결재자 체크 로직 (기존 유지)
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

		// 기본값 및 기발행 시퀀스 바인딩
		vacAppDto.setAppReqId(empNo);
		vacAppDto.setAppType("휴가신청서");
		vacAppDto.setAppStatus("처리중");
		int nextAppId = appDao.sequence();
		vacAppDto.setAppId(nextAppId);

		// [중요 디버깅] 화면에서 데이터가 제대로 넘어왔는지 값 검증 추적
		System.out.println("-> [발행된 문서번호] appId = " + nextAppId);
		System.out.println("-> [JSP 수신값 확인] 시작일 = " + vacAppDto.getVacStartDate());
		System.out.println("-> [JSP 수신값 확인] 종료일 = " + vacAppDto.getVacEndDate());
		System.out.println("-> [JSP 수신값 확인] 휴가구분 = " + vacAppDto.getVacType());

		try {
			// 비즈니스 로직 및 트랜잭션 파이프라인 가동
			vacService.registerVacation(vacAppDto);
			// 결재선 등록 (기존 유지)
			for (int i = 0; i < approvers.size(); i++) {
				AppLineDto line = new AppLineDto();
				line.setAppId(nextAppId);
				line.setAppAppId(approvers.get(i));
				line.setAppLineOrder(i + 1);
				line.setAppLineType("휴가신청서");
				appLineDao.insert(line);
			}

			appLineDao.activateFirst(nextAppId);

		} catch (Exception e) {
			// 어디서 에러가 터졌는지 추적 장치 세분화
			e.printStackTrace(); // 전체 스택 트레이스 출력
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
	public String list(
			HttpSession session,
			@ModelAttribute PageVO pageVO,
			// 기안자 제외, 나머지 2개 필터만 깔끔하게 접수
			@RequestParam(required = false) String searchAppType,
			@RequestParam(required = false) String searchAppStatus,
			Model model) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) return "redirect:/login";
		
		String empNo = appDao.selectEmpNoById(loginId);
		String empName = appDao.selectEmpNameById(loginId);
		
		model.addAttribute("empName", empName);
		model.addAttribute("currentTab", "app");

		// 1. 내 문서함 필터 기준 카운트 및 페이징 바인딩
		int totalCount = appDao.countMyListByFilter(empNo, searchAppType, searchAppStatus);
		pageVO.setCount(totalCount);

		// 2. 동적 중첩 쿼리 실행
		List<AppDto> list = appDao.selectMyListByFilter(pageVO, empNo, searchAppType, searchAppStatus);
		
		model.addAttribute("list", list);
		model.addAttribute("pageVO", pageVO);
		
		// 3. JSP 상태 복원용 속성 바인딩
		model.addAttribute("searchAppType", searchAppType);
		model.addAttribute("searchAppStatus", searchAppStatus);
		
		// 페이징 클릭 시 풀림 방지 파라미터 캐싱
		String searchParams = "searchAppType=" + (searchAppType != null ? searchAppType : "") 
							+ "&searchAppStatus=" + (searchAppStatus != null ? searchAppStatus : "");
		model.addAttribute("searchParams", searchParams);

		return "/app/list";
	}

	// 사이드바 용 필터링(걸러내기)
//	@GetMapping("/myNoneList")
//	public String myNoneAppr(HttpSession session, Model model) {
//		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
//		model.addAttribute("list", appDao.selectMyNoneList(empNo));
//		return "/app/list";
//	}
//
//	@GetMapping("/myAppr")
//	public String myAppr(HttpSession session, Model model) {
//		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
//		model.addAttribute("list", appDao.selectMyApprList(empNo));
//		return "/app/list";
//	}
//
//	@GetMapping("/myIng")
//	public String myIng(HttpSession session, Model model) {
//		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
//		model.addAttribute("list", appDao.selectMyIngList(empNo));
//		return "/app/list";
//	}
//
//	@GetMapping("/myRej")
//	public String myRej(HttpSession session, Model model) {
//		String empNo = appDao.selectEmpNoById((String) session.getAttribute("loginId"));
//		model.addAttribute("list", appDao.selectMyRejList(empNo));
//		return "/app/list";
//	}
//
//	@GetMapping("/myList")
//	public String myList(HttpSession session, Model model) {
//		String loginId = (String) session.getAttribute("loginId");
//		String empNo = appDao.selectEmpNoById(loginId);
//		model.addAttribute("list", appDao.selectMyList(empNo));
//		return "/app/list";
//	}

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
