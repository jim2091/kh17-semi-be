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
import com.kh.semiprj.dto.AttachDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.service.NotificationService;
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
	@Autowired
	private NotificationService notificationService;

	@RequestMapping("/bothList") 
	public String bothList(
			HttpSession session, 
			@ModelAttribute("pageVO") PageVO pageVO, 
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(required = false) String searchEmpName, 
			@RequestParam(required = false) String searchAppType,
			@RequestParam(required = false) String searchAppStatus, 
			Model model) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login"; 
		}

		if (page <= 0) page = 1;
		pageVO.setPage(page);
		pageVO.setSize(10); 

		int totalCount = appDao.countAll(searchEmpName, searchAppType, searchAppStatus);
		pageVO.setCount(totalCount); 
		List<AppDto> list = appDao.selectAllList(pageVO, searchEmpName, searchAppType, searchAppStatus);

		model.addAttribute("list", list);
		model.addAttribute("pageVO", pageVO); 

		model.addAttribute("searchEmpName", searchEmpName);
		model.addAttribute("searchAppType", searchAppType);
		model.addAttribute("searchAppStatus", searchAppStatus);

		String searchParams = "searchEmpName=" + (searchEmpName != null ? searchEmpName.trim() : "") 
				+ "&searchAppType=" + (searchAppType != null ? searchAppType.trim() : "") 
				+ "&searchAppStatus=" + (searchAppStatus != null ? searchAppStatus.trim() : "");
		model.addAttribute("searchParams", searchParams);

		return "/app/bothList"; 
	}
	
	
	

	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam(value = "appId", required = false, defaultValue = "0") int appId,
			HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login";
		}

		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null) {
			return "redirect:/login";
		}

		AppDto appDto = appDao.selectOneById(appId);
		if (appDto == null) {
			return "redirect:/app/list";
		}

		List<AppLineDto> lineList = appLineDao.selectByAppId(appId);

		if (lineList != null) {
			for (AppLineDto line : lineList) {
				String deptCode = line.getEmpDept();
				if (deptCode != null) {
					String deptName = appDao.selectDeptNameByCode(deptCode);
					line.setEmpDept(deptName);
				}
			}
		}

		AppLineDto myTurn = null;
		if (lineList != null) {
			for (AppLineDto line : lineList) {
				if (line.getAppAppId() != null && line.getAppAppId().equals(empNo)
						&& "진행중".equals(line.getAppLineStatus())) {
					myTurn = line;
					break;
				}
			}
		}

		List<AttachDto> attachList = appDao.searchFiles(appId);
		model.addAttribute("attachList", attachList);

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
		model.addAttribute("lineList", lineList);
		model.addAttribute("myTurn", myTurn);

		return "app/detail";
	}
	
	
	
	

	// 수정(결재 or 반려)
	@PostMapping("/edit")
	public String edit(@RequestParam int appId, @RequestParam String appStatus, HttpSession session,
			RedirectAttributes attr) {
		return "redirect:/app/list";
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


	@PostMapping("/vacInsert")
	public String vacInsert(@ModelAttribute VacAppDto vacAppDto, @RequestParam String approver1,
			@RequestParam(required = false) String approver2, @RequestParam(required = false) String approver3,
			@RequestParam(value = "attachNo", required = false) List<Integer> attachNoList, HttpSession session,
			RedirectAttributes redirectAttributes) {

		System.out.println("\n========================================================");
		System.out.println("🚀 [디버깅] vacInsert POST 트랜잭션 검증 시퀀스 기동");
		System.out.println("========================================================");

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			System.out.println("❌ [탈락 예외] 세션 무효화 (loginId가 존재하지 않음)");
			return "redirect:/login";
		}

		String empNo = appDao.selectEmpNoById(loginId);
		if (empNo == null) {
			System.out.println("❌ [탈락 예외] 사번 맵핑 실패 (loginId에 매칭되는 emp_no 없음)");
			return "redirect:./vacInsert";
		}
		System.out.println("▶ [스캔 완료] 현재 기안 사번(empNo): " + empNo);

		// 중복 결재자 체크 로직 (기존 유지)
		List<String> approvers = new ArrayList<>();
		approvers.add(approver1);
		if (approver2 != null && !approver2.isEmpty()) {
			if (approvers.contains(approver2)) {
				redirectAttributes.addFlashAttribute("errorMsg", "중복된 결재자가 있습니다.");
				System.out.println("❌ [탈락 0선] 결재선 내부 중복 사원 식별됨");
				return "redirect:./vacInsert";
			}
			approvers.add(approver2);
		}
		if (approver3 != null && !approver3.isEmpty()) {
			if (approvers.contains(approver3)) {
				redirectAttributes.addFlashAttribute("errorMsg", "중복된 결재자가 있습니다.");
				System.out.println("❌ [탈락 0선] 결재선 내부 중복 사원 식별됨");
				return "redirect:./vacInsert";
			}
			approvers.add(approver3);
		}

		int intEmpNo = Integer.parseInt(empNo); 
		String startStr = vacAppDto.getVacStartDate();
		String endStr = vacAppDto.getVacEndDate();
		String vacType = vacAppDto.getVacType(); 

		System.out.println("▶ [신청 정보] 기간: " + startStr + " ~ " + endStr + " | 분류: " + vacType);

		// 🔒 [1선 바리케이드] 동일 날짜 기간 중복 겹침 정밀 검사
		int duplicateCount = appDao.countOverlappedVacation(intEmpNo, startStr, endStr);
		System.out.println("▶ [검증 1선] 오라클 DB 내 중복 기간 문서 검출 건수: " + duplicateCount + "건");
		
		if (duplicateCount > 0) {
			redirectAttributes.addFlashAttribute("errorMsg", "중복 기안 차단: 선택하신 기간에 이미 승인되었거나 처리 중인 휴가 신청서가 존재합니다.");
			System.out.println("❌ [최종 차단] 1선 가두리 탈락 ➔ 기간 겹침 무결성 위반");
			return "redirect:./vacInsert";
		}

		// 🔒 [2선 바리케이드] vacType별 실시간 잔여 수량 한도 검사
		try {
			java.time.LocalDate startDate = java.time.LocalDate.parse(startStr);
			java.time.LocalDate endDate = java.time.LocalDate.parse(endStr);
			int reqVacDays = (int) java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;

			int availableDays = 0;
			String assetName = "";

			if ("연차".equals(vacType)) {
				availableDays = appDao.getLeftAnnualLeaveCount(intEmpNo); 
				assetName = "잔여 연차(vac_cnt)";
			} 
			else if ("휴가".equals(vacType)) {
				availableDays = appDao.getLeftSpecialLeaveCount(intEmpNo); 
				assetName = "잔여 특별휴가(leave_cnt)";
			} 
			else if ("병가".equals(vacType)) {
				availableDays = 999; 
				assetName = "병가 무제한 권한";
			}

			System.out.println("▶ [검증 2선] 신청 일수: " + reqVacDays + "일 | DB 보유 자산[" + assetName + "]: " + availableDays + "일");

			if (reqVacDays > availableDays) {
				redirectAttributes.addFlashAttribute("errorMsg", 
					"수량 한도 초과: 신청하신 " + vacType + " 일수(" + reqVacDays + "일)가 "
					+ "잔여 한도(" + availableDays + "일)를 초과했습니다.");
				System.out.println("❌ [최종 차단] 2선 가두리 탈락 ➔ 실시간 수량 한도 바닥남");
				return "redirect:./vacInsert";
			}
			
		} catch (Exception e) {
			System.out.println("❌ [시스템 예외 터짐] 날짜 파싱 혹은 DB 컬럼 Null 예외 발생");
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("errorMsg", "시스템 오류: 날짜 정밀 연산 및 자산 대조 과정에서 파싱 결함이 발생했습니다.");
			return "redirect:./vacInsert";
		}

		System.out.println("⭕ [통과 완료] 모든 무결성 방어벽 통과 ➔ 오라클 데이터 최종 영구 적재 프로세스 진입");

		// 기본값 및 기발행 시퀀스 바인딩
		vacAppDto.setAppReqId(empNo);
		vacAppDto.setAppType("휴가신청서");
		vacAppDto.setAppStatus("처리중");
		int nextAppId = appDao.sequence();
		vacAppDto.setAppId(nextAppId);

		try {
			vacService.registerVacation(vacAppDto);

			if (attachNoList != null && !attachNoList.isEmpty()) {
				for (Integer attachNo : attachNoList) {
					if (attachNo != null && attachNo > 0) {
						appDao.insertAppFile(nextAppId, attachNo);
					}
				}
			}

			// 결재선 등록
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
			System.out.println("❌ [트랜잭션 롤백] 서비스 적재 중 인프라 SQL 예외 발생");
			e.printStackTrace();
			return "redirect:./vacInsert";
		}
		
		for (int i = 0; i < approvers.size(); i++) {
			if (approvers.get(i) != null) {
				notificationService.notifyAppWaiting(approvers.get(i), nextAppId);
			}
		}

		System.out.println("==== ✨ [성공 마감] vacInsert 시퀀스 최종 종결 완료 ====\n");
		return "redirect:./insertComplete";
	}

	@PostMapping("/expInsert")
	public String expInsert(@ModelAttribute ExpAppDto expAppDto, @RequestParam String approver1,
			@RequestParam(required = false) String approver2, @RequestParam(required = false) String approver3,
			// 💡 [추가] 비동기로 수집된 attachNo 리스트 파라미터 수신
			@RequestParam(value = "attachNo", required = false) List<Integer> attachNoList, HttpSession session,
			RedirectAttributes redirectAttributes) {

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
		expAppDto.setAppStatus("처리중");
		int nextAppId = appDao.sequence();
		expAppDto.setAppId(nextAppId);

		try {
			appDao.insert(expAppDto);
			expAppDao.insertExpApp(expAppDto);

			// 💡 [추가] 품의서 첨부파일 매핑 테이블 등록
			if (attachNoList != null && !attachNoList.isEmpty()) {
				for (Integer attachNo : attachNoList) {
					if (attachNo != null && attachNo > 0) {
						appDao.insertAppFile(nextAppId, attachNo);
					}
				}
			}

			// 결재선 등록
			for (int i = 0; i < approvers.size(); i++) {
				AppLineDto line = new AppLineDto();
				line.setAppId(nextAppId);
				line.setAppAppId(approvers.get(i));
				line.setAppLineOrder(i + 1);
				line.setAppLineType("품의서");
				appLineDao.insert(line);
			}

			appLineDao.activateFirst(nextAppId);

		} catch (Exception e) {
			System.out.println("====== DB INSERT 에러 발생 ======");
			e.printStackTrace();
			return "redirect:./expInsert";
		}
		
		for (int i = 0; i < approvers.size(); i++) {
			if (approvers.get(i) != null) {
				notificationService.notifyAppWaiting(approvers.get(i), nextAppId);
			}
		}
		
		return "redirect:./insertComplete";
	}

	@PostMapping("/dftInsert")
	public String dftInsert(@ModelAttribute DftAppDto dftAppDto, @RequestParam String approver1,
			@RequestParam(required = false) String approver2, @RequestParam(required = false) String approver3,
			// 💡 [추가] 비동기로 수집된 attachNo 리스트 파라미터 수신
			@RequestParam(value = "attachNo", required = false) List<Integer> attachNoList, HttpSession session,
			RedirectAttributes redirectAttributes) {

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
		dftAppDto.setAppStatus("처리중");
		int nextAppId = appDao.sequence();
		dftAppDto.setAppId(nextAppId);

		try {
			appDao.insert(dftAppDto);
			dftAppDao.insertDftApp(dftAppDto);

			// 💡 [추가] 업무기안서 첨부파일 매핑 테이블 등록
			if (attachNoList != null && !attachNoList.isEmpty()) {
				for (Integer attachNo : attachNoList) {
					if (attachNo != null && attachNo > 0) {
						appDao.insertAppFile(nextAppId, attachNo);
					}
				}
			}

			// 결재선 등록
			for (int i = 0; i < approvers.size(); i++) {
				AppLineDto line = new AppLineDto();
				line.setAppId(nextAppId);
				line.setAppAppId(approvers.get(i));
				line.setAppLineOrder(i + 1);
				line.setAppLineType("업무기안서");
				appLineDao.insert(line);
			}

			appLineDao.activateFirst(nextAppId);

		} catch (Exception e) {
			System.out.println("====== DB INSERT 에러 발생 ======");
			e.printStackTrace();
			return "redirect:./dftInsert";
		}
		
		for (int i = 0; i < approvers.size(); i++) {
			if (approvers.get(i) != null) {
				notificationService.notifyAppWaiting(approvers.get(i), nextAppId);
			}
		}
		
		return "redirect:./insertComplete";
	}
	
	
	
	

	@RequestMapping("/insertComplete")
	public String insertComplete(HttpSession session) {
		return "/app/insertComplete";
	}

	@RequestMapping("/list")
	public String list(HttpSession session, @ModelAttribute PageVO pageVO,
			@RequestParam(required = false) String searchAppType,
			@RequestParam(required = false) String searchAppStatus, Model model) {

		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		String empName = appDao.selectEmpNameById(loginId);

		model.addAttribute("empName", empName);
		model.addAttribute("currentTab", "app"); // 기안 문서함 탭 유지

		// 💡 [결함 진압] JSP 드롭다운 값(완료/진행중)을 오라클 DB 실물 적재 값(승인/처리중)으로 치환
		String dbSearchStatus = searchAppStatus;
		if ("완료".equals(searchAppStatus)) {
			dbSearchStatus = "승인";
		} else if ("진행중".equals(searchAppStatus)) {
			dbSearchStatus = "처리중";
		}

		// 1. 💡 보정된 dbSearchStatus 변수를 던져서 필터 기준 카운트 연산 및 페이징 바인딩
		int totalCount = appDao.countMyListByFilter(empNo, searchAppType, dbSearchStatus);
		pageVO.setCount(totalCount);

		// 2. 💡 보정된 dbSearchStatus 변수로 오라클 동적 중첩 쿼리 실행
		List<AppDto> list = appDao.selectMyListByFilter(pageVO, empNo, searchAppType, dbSearchStatus);

		model.addAttribute("list", list);
		model.addAttribute("pageVO", pageVO);

		// 3. JSP 상태 복원용 속성 바인딩 (화면 select 박스 인덱스는 유지해야 하므로 기존 파라미터 그대로 바인딩)
		model.addAttribute("searchAppType", searchAppType);
		model.addAttribute("searchAppStatus", searchAppStatus);

		// 페이징 클릭 시 풀림 방지 파라미터 캐싱선 유지
		String searchParams = "searchAppType=" + (searchAppType != null ? searchAppType : "") + "&searchAppStatus="
				+ (searchAppStatus != null ? searchAppStatus : "");
		model.addAttribute("searchParams", searchParams);

		return "/app/list"; // 원본 기안 문서함 경로 정상 리턴
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

	// 💡 picker 용 매핑 (성공하신 app_line 후처리 알고리즘 100% 이식)
		@GetMapping("/searchApprover")
		@ResponseBody
		public List<Map<String, Object>> searchApprover(
				@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
				@RequestParam(required = false) List<String> excludes, 
				HttpSession session) {

			// 1. 본인 제외 방어선 유지
			String loginId = (String) session.getAttribute("loginId");
			String empNo = appDao.selectEmpNoById(loginId);
			if (excludes == null) {
				excludes = new ArrayList<>();
			}
			if (empNo != null && !excludes.contains(empNo)) {
				excludes.add(empNo);
			}

			// 2. 기본 픽커 사원 리스트 조회
			List<Map<String, Object>> approverList = appDao.searchApproverForPicker(keyword, excludes);
			if (approverList == null || approverList.isEmpty()) {
				return approverList;
			}

			// 3. 💡 [성공 공식 이식] 루프를 돌며 부서 코드를 한글 부서명으로 변환하여 치환
			for (Map<String, Object> map : approverList) {
				String deptCode = (String) map.get("empDept"); // Map에서 기존 부서 코드(또는 ID) 추출
				
				if (deptCode != null && !deptCode.trim().isEmpty()) {
					// 성공하셨던 app_line의 DAO 메서드를 그대로 활용하여 한글명 조회
					String deptName = appDao.selectDeptNameByCode(deptCode.trim()); 
					
					if (deptName != null && !deptName.trim().isEmpty()) {
						map.put("empDept", deptName.trim()); // 한글 부서명으로 덮어쓰기
					} else {
						map.put("empDept", "소속없음");
					}
				} else {
					map.put("empDept", "소속없음");
				}
			}

			return approverList;
		}

}
