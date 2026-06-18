package com.kh.semiprj.controller;

import java.sql.Timestamp;
import java.util.HashMap;
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

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.AppLineDao;
import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.EmpHistoryDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.AppLineDto;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.EmpHistoryDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.service.AdminAttnService;
import com.kh.semiprj.vo.HistoryPageVO;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private EmpDao empDao;
	
	@Autowired
	private DeptDao deptDao;

	@Autowired
	private EmpHistoryDao empHistoryDao;

	@Autowired
	private AppDao appDao;
	
	@Autowired
	private AppLineDao appLineDao;

	@Autowired
	private AdminAttnService adminAttnService;

	@GetMapping("/register")
	public String register(Model model) {
		//부서 목록 전체 가져오기 위한
		model.addAttribute("deptList",deptDao.selectTreeList());
		return "admin/register";
	}

	@PostMapping("/register")
	public String register(@ModelAttribute EmpDto empDto) {
//		System.out.println(empDto);		
		empDao.insertFromAdmin(empDto);	
		empDao.insertDeptEmp(empDto.getEmpNo(), empDto.getEmpDept());

		return "redirect:./list";
		// 홈으로 리다이렉트해놓았는데, 사원목록구현후 사원목록페이지로 리다이렉트할 예정입니다
	}

	@RequestMapping("/list")
	public String list(@RequestParam(required = false) String column, 
						@RequestParam(required = false) String keyword, 
						@RequestParam(required = false) String deptKeyword,
			Model model) {
		/* System.out.println("list 실행"); */
//		List<EmpDto> list = empDao.selectListByAdmin(column, keyword);
		
		List<EmpDto> list;
		
		if("emp_dept".equals(column)) {
	        list = empDao.selectListByAdminByDept(deptKeyword);
	    }
	    else {
	        list = empDao.selectListByAdmin(column, keyword);
	    }

		model.addAttribute("list", list);
		for(EmpDto empDto : list){
		    DeptDto deptDto = deptDao.selectOne(empDto.getEmpDept());
		    model.addAttribute("deptDto", deptDto);
		}
		model.addAttribute("deptList",deptDao.selectTreeList());
		
		return "admin/list";
	}

	@RequestMapping("/detail")
	public String detail(@RequestParam String empNo, Model model) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		model.addAttribute("empDto", empDto);
		
		int deptNo = empDto.getEmpDept();

		DeptDto deptDto = deptDao.selectOne(deptNo);
		model.addAttribute("deptDto", deptDto);
		

		List<EmpHistoryDto> loginHistory = empHistoryDao.selectList(empNo, 1, 10);
		model.addAttribute("loginHistory", loginHistory);

		return "admin/detail";
	}

	@GetMapping("/edit")
	public String edit(@RequestParam String empNo, Model model) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		// if(empDto == null) throw new TargetNotfoundException("대상이 존재하지 않습니다");
		model.addAttribute("empDto", empDto);
		model.addAttribute("deptList",deptDao.selectTreeList());
		return "admin/edit";
	}
	/*
	 * @PostMapping("/edit") public String edit(@ModelAttribute EmpDto empDto) {
	 * //EmpDto findEmpDto = empDao.selectOneByDetail(empDto.getEmpNo());
	 * //if(findEmpDto == null) throw new TargetNotfoundException("존재하지 않는 회원");
	 * if(empDto.getEmpRetiredDate() == null ) { empDto.setEmpRetiredDate(null); }
	 * 
	 * empDao.updateByMaster(empDto); return "redirect:./detail?empNo=" +
	 * empDto.getEmpNo(); }
	 */

	@PostMapping("/edit")
	public String edit(@RequestParam(required = false) String hireDateStr,
			@RequestParam(required = false) String retiredDateStr, @ModelAttribute EmpDto empDto) {

		if (hireDateStr != null && !hireDateStr.isBlank()) {
			empDto.setEmpHireDate(Timestamp.valueOf(hireDateStr + " 00:00:00"));
		} else {
			empDto.setEmpHireDate(null);
		}

		if (retiredDateStr != null && !retiredDateStr.isBlank()) {
			empDto.setEmpRetiredDate(Timestamp.valueOf(retiredDateStr + " 00:00:00"));
		} else {
			empDto.setEmpRetiredDate(null);
		}
		empDao.deleteDeptEmp(empDto.getEmpNo());
		empDao.insertDeptEmp(empDto.getEmpNo(), empDto.getEmpDept());
		empDao.updateByMaster(empDto);
		return "redirect:./detail?empNo=" + empDto.getEmpNo();
	}

	@RequestMapping("/useYn")
	public String useYn(@RequestParam String empNo) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		// if(empDto == null) throw new TargetNotfoundException("존재하지 않는 회원");
		System.out.println(empDto.getEmpUseYn());
		System.out.println(empDto.getEmpUseYn().equals("N"));

		if (empDto.getEmpUseYn().equals("N")) {
			empDao.useY(empNo);
		} else {
			empDao.useN(empNo);
		}
		System.out.println("현재값 = " + empDto.getEmpUseYn());
		return "redirect:./edit?empNo=" + empNo;
	}

	@RequestMapping("/waitingList")
	public String waitingList(Model model) {

		List<EmpDto> list = empDao.selectListForWaiting();

		if (list == null || list.isEmpty()) {
			model.addAttribute("isEmpty", true);
		} else {
			model.addAttribute("isEmpty", false);
			model.addAttribute("list", list);
		}
//		model.addAttribute("list", list);
		return "admin/waiting_list";
	}
	@RequestMapping("/vacList")
	public String list1(@RequestParam(required = false) String column, 
						@RequestParam(required = false) String keyword, 
						@RequestParam(required = false) String deptKeyword,
						Model model) {
		
		List<EmpDto> list;
		
		if("emp_dept".equals(column)) {
	        list = empDao.selectListByAdminByDept(deptKeyword);
	    }
	    else {
	        list = empDao.selectListByAdmin(column, keyword);
	    }
		model.addAttribute("list", list);

		// 부서 전체 목록을 가져와서 Map으로 변환
		List<DeptDto> deptList = deptDao.selectTreeList();
		Map<Integer, DeptDto> deptMap = new HashMap<>();
		for(DeptDto deptDto : deptList) {
			deptMap.put(deptDto.getDeptId(), deptDto);
		}
		model.addAttribute("deptMap", deptMap);

		// ================= [이 부분을 수정했습니다] =================
		// 기존: "admin/vac_list" -> 변경: "admin/vac/vac_list"
		return "admin/vac/vac_list"; 
	}

	@RequestMapping("/approval")
	public String approval(@RequestParam String empNo) {

		EmpDto empDto = empDao.selectOneByDetail(empNo);

		if (empDto.getEmpApprovalStatus().equals("N")) {
			empDao.useY(empNo);
		} else {
			empDao.useN(empNo);
		}

		return "redirect:./waitingList";
	}

	@RequestMapping("/history")
	public String history(@RequestParam String empNo, @ModelAttribute HistoryPageVO historyPageVO, Model model) {
//		String loginNo = (String) session.getAttribute("loginNo");
//		System.out.println(empDao.selectOneByDetail(loginNo));
//		System.out.println(historyPageVO);
//		System.out.println(empNo);
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		if (empDto == null)
			throw new TargetNotfoundException("대상이 존재하지 않습니다");
		model.addAttribute("empDto", empDto);

		List<EmpHistoryDto> loginhistory = empHistoryDao.selectList(empNo, historyPageVO);
//		System.out.println(loginhistory);

		model.addAttribute("loginhistory", loginhistory);
		int count = empHistoryDao.count(empNo, historyPageVO);
		historyPageVO.setCount(count);
		model.addAttribute("historyPageVO", historyPageVO);
		return "admin/history";
	}

	// 전자결재 관리자 접근
		@RequestMapping("/app/list")
		public String appList(HttpSession session, @ModelAttribute PageVO pageVO, Model model) {
			String loginId = (String) session.getAttribute("loginId");
			if (loginId == null)
				return "redirect:/login";
			int totalCount = appDao.countAll(pageVO);
			pageVO.setCount(totalCount);

			List<AppDto> list = appDao.selectAllList(pageVO);
			model.addAttribute("list", list);
			model.addAttribute("pageVO", pageVO); // JSP 페이징 바 출력용 추가
			return "/admin/app/list";
		}
	// 상세
	@RequestMapping("/app/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
	    // [예외 처리] 세션 비어있을 경우 예외 처리 추가 (로그인하지 않은 유저 차단)
	    String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null) {
	        return "redirect:/login";
	    }

	    // [예외 처리] DAO 의존성 주입 실패 방어
	    if (appDao == null || appLineDao == null) {
	        return "redirect:/error";
	    }

	    String empNo = appDao.selectEmpNoById(loginId);
	    AppDto appDto = appDao.selectOneById(appId);
	    if (appDto == null) {
	        // [수정] 절대 경로를 명시하여 리다이렉트 위치 오류 방지
	        return "redirect:/app/list";
	    }

	    List<AppLineDto> lineList = appLineDao.selectByAppId(appId);
	    model.addAttribute("appDto", appDto);
	    model.addAttribute("lineList", lineList);
	    model.addAttribute("loginEmpNo", empNo);

	    // [예외 처리] 문서 종류(AppType)가 Null인 경우를 대비한 equals 위치 변경
	    if (appDto.getAppType() == null) {
	        return "app/detail";
	    }

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
	// 근태관리 관리자 접근
	@GetMapping("/attn/manage")
	public String manage(@ModelAttribute("search") AttnDto searchDto, @ModelAttribute("pageVO") PageVO pageVO,
			Model model) {
		pageVO.setCount(adminAttnService.countAdminAttendance(searchDto));
		model.addAttribute("attnList", adminAttnService.getAdminAttendanceList(searchDto, pageVO));
		return "admin/attn/manage";
	}
	
	

}