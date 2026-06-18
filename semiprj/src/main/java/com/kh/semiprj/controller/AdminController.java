package com.kh.semiprj.controller;

import java.sql.Timestamp;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.AppLineDao;
import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.EmpHistoryDao;
import com.kh.semiprj.dao.VacDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.AppLineDto;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.EmpHistoryDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.dto.VacInfoDto; 
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.service.AdminAttnService;
import com.kh.semiprj.service.VacService;
import com.kh.semiprj.vo.HistoryPageVO;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
	@Autowired
	private VacService vacService;

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
	
	@Autowired
	private VacDao vacDao; 

	@GetMapping("/register")
	public String register(Model model) {
		model.addAttribute("deptList",deptDao.selectTreeList());
		return "admin/register";
	}

	@PostMapping("/register")
	public String register(@ModelAttribute EmpDto empDto) {
		empDao.insertFromAdmin(empDto);	
		empDao.insertDeptEmp(empDto.getEmpNo(), empDto.getEmpDept());
		return "redirect:./list";
	}

	@RequestMapping("/list")
	public String list(@RequestParam(required = false) String column, 
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
		model.addAttribute("empDto", empDto);
		return "admin/edit";
	}

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
		if (empDto.getEmpUseYn().equals("N")) {
			empDao.useY(empNo);
		} else {
			empDao.useN(empNo);
		}
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
		return "admin/waiting_list";
	}

	// =========================================================================
	// 💡 [변경 및 확정] 임시 세션을 지우고, DB(vac_info)에 실존하는 데이터만 바인딩
	// =========================================================================
	@RequestMapping("/vacList")
	public String list1(Model model) {
		// 1. DB 연차 정보 테이블(vac_info) 전체를 가져옵니다 (데이터가 없으면 자동으로 빈 목록 처리됨)
		List<VacInfoDto> vacInfoList = vacDao.selectList(); 
		List<Map<String, Object>> grantedList = new ArrayList<>();
		
		// 부서 아이디 - 부서명 캐싱용 맵 생성
		List<DeptDto> deptList = deptDao.selectTreeList();
		Map<Integer, String> deptMap = new HashMap<>();
		for(DeptDto d : deptList) {
			deptMap.put(d.getDeptId(), d.getDeptName());
		}
		
		// 2. 루프를 돌며 각 연차의 대상자(사원) 정보와 결합하여 정보 패키징
		if (vacInfoList != null) {
			for(VacInfoDto info : vacInfoList) {
				EmpDto emp = empDao.selectOneByDetail(info.getEmpNo());
				if(emp != null) {
					Map<String, Object> map = new HashMap<>();
					map.put("vacNo", info.getVacNo());
					map.put("empNo", emp.getEmpNo());
					map.put("empName", emp.getEmpName());
					map.put("empId", emp.getEmpId());
					map.put("deptName", deptMap.get(emp.getEmpDept()));
					map.put("vacYear", info.getVacYear());
					map.put("vacTot", info.getVacTot());     // DB 컬럼명 vac_tot 매핑
					map.put("vacCnt", info.getVacCnt());     // DB 컬럼명 vac_cnt 매핑
					map.put("vacUsed", info.getVacUsed());   // DB 컬럼명 vac_used 매핑
					map.put("vacReason", info.getVacReason());
					grantedList.add(map);
				}
			}
		}
		
		model.addAttribute("grantedList", grantedList);
		return "admin/vac/vac_list"; 
	}

	// 🔎 모달창 내 비동기 사원명 검색을 처리할 Ajax API 라우터
	@GetMapping("/vac/searchEmp")
	@ResponseBody
	public List<Map<String, Object>> searchEmpAjax(@RequestParam String keyword) {
		List<EmpDto> empList = empDao.selectListByAdmin("emp_name", keyword);
		List<Map<String, Object>> resultList = new ArrayList<>();
		
		List<DeptDto> deptList = deptDao.selectTreeList();
		Map<Integer, String> deptMap = new HashMap<>();
		for(DeptDto d : deptList) {
			deptMap.put(d.getDeptId(), d.getDeptName());
		}
		
		for(EmpDto emp : empList) {
			Map<String, Object> map = new HashMap<>();
			map.put("empNo", emp.getEmpNo());
			map.put("empName", emp.getEmpName());
			map.put("empId", emp.getEmpId());
			map.put("deptName", deptMap.get(emp.getEmpDept()));
			resultList.add(map);
		}
		return resultList;
	}

	// =========================================================================
	// 💡 [변경 및 확정] 모달창 지급 시 세션 누적 제거하고 오직 DB에만 실시간 저장
	// =========================================================================
	@PostMapping("/vac/grant")
	public String vacGrantSubmit(
			@RequestParam String empNo,
			@RequestParam int vacYear,
			@RequestParam int vacDays, // 파라미터 수신 유지
			@RequestParam String vacReason) {
		
		// DB에 실제 연차 지급/업데이트 쿼리 반영 (Dao 내부에서 vac_tot와 vac_cnt에 대입됨)
		vacDao.insertOrUpdateVacation(empNo, vacYear, vacDays, vacReason);
		
		return "redirect:../vacList";
	}

	// 💡 [변경 및 확정] 체크박스로 선택된 사원 연차 내역을 실제 DB에서 삭제 처리
	@GetMapping("/vac/removeHistory")
	public String vacRemoveHistory(@RequestParam(value = "empNoList", required = false) List<String> empNoList) {
		if (empNoList != null && !empNoList.isEmpty()) {
			// 서비스 레이어를 통해 vac_info 테이블 및 하위 이력 일괄 삭제 처리 연계
			vacService.deleteBulkVacationHistory(empNoList);
		}
		return "redirect:../vacList";
	}

	@PostMapping("/vac/deleteHistoryBulk")
	public String vacDeleteHistoryBulkSubmit(@RequestParam(value = "empNoList", required = false) List<String> empNoList) {
		if (empNoList != null && !empNoList.isEmpty()) {
			vacService.deleteBulkVacationHistory(empNoList);
		}
		return "redirect:../vacList";
	}

	@GetMapping("/vac/detail")
	public String vacDetail(@RequestParam String empNo, Model model) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		model.addAttribute("empDto", empDto);
		
		VacInfoDto vacInfoDto = vacDao.selectOneByEmpNo(empNo); 
		model.addAttribute("vacInfoDto", vacInfoDto);
		
		return "admin/vac/detail";
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
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		if (empDto == null) throw new TargetNotfoundException("대상이 존재하지 않습니다");
		model.addAttribute("empDto", empDto);
		List<EmpHistoryDto> loginhistory = empHistoryDao.selectList(empNo, historyPageVO);
		model.addAttribute("loginhistory", loginhistory);
		int count = empHistoryDao.count(empNo, historyPageVO);
		historyPageVO.setCount(count);
		model.addAttribute("historyPageVO", historyPageVO);
		return "admin/history";
	}

	@RequestMapping("/app/list")
	public String appList(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) return "redirect:/login";
		String empLevel = (String) session.getAttribute("empLevel");
		if (!"관리자".equals(empLevel)) return "redirect:/app/list";
		List<AppDto> list = appDao.selectAllList();
		model.addAttribute("list", list);
		return "/admin/app/list";
	}

	@RequestMapping("/app/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
	    String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null) return "redirect:/login";
	    if (appDao == null || appLineDao == null) return "redirect:/error";
	    String empNo = appDao.selectEmpNoById(loginId);
	    AppDto appDto = appDao.selectOneById(appId);
	    if (appDto == null) return "redirect:/app/list";
	    List<AppLineDto> lineList = appLineDao.selectByAppId(appId);
	    model.addAttribute("appDto", appDto);
	    model.addAttribute("lineList", lineList);
	    model.addAttribute("loginEmpNo", empNo);
	    if (appDto.getAppType() == null) return "app/detail";
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

	@GetMapping("/attn/manage")
	public String manage(@ModelAttribute("search") AttnDto searchDto, @ModelAttribute("pageVO") PageVO pageVO, Model model) {
		pageVO.setCount(adminAttnService.countAdminAttendance(searchDto));
		model.addAttribute("attnList", adminAttnService.getAdminAttendanceList(searchDto, pageVO));
		return "admin/attn/manage";
	}
}