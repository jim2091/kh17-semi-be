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
		model.addAttribute("deptList",deptDao.selectTreeList());
		return "admin/edit";
	}

	@PostMapping("/edit")
	public String edit(
	        @RequestParam(required = false) String hireDateStr,
	        @RequestParam(required = false) String retiredDateStr, 
	        @RequestParam(required = false) String birthDateStr,
	        @ModelAttribute EmpDto empDto) {
	    
	    if (hireDateStr != null && !hireDateStr.trim().isEmpty()) {
	        empDto.setEmpHireDate(Timestamp.valueOf(hireDateStr.trim() + " 00:00:00"));
	    } else {
	        empDto.setEmpHireDate(null);
	    }
	    
	    if (retiredDateStr != null && !retiredDateStr.trim().isEmpty()) {
	        empDto.setEmpRetiredDate(Timestamp.valueOf(retiredDateStr.trim() + " 00:00:00"));
	    } else {
	        empDto.setEmpRetiredDate(null);
	    }

	    if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
	        empDto.setEmpBirth(birthDateStr.trim());
	    }

	    empDao.deleteDeptEmp(empDto.getEmpNo());
	    empDao.insertDeptEmp(empDto.getEmpNo(), empDto.getEmpDept());
	    empDao.updateByMaster(empDto);
	    
	    return "redirect:./detail?empNo=" + empDto.getEmpNo();
	}

	@RequestMapping("/useYn")
	public String useYn(@RequestParam String empNo) {
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		if (empDto != null) {
	        String currentStatus = empDto.getEmpUseYn(); // 'Y' 또는 'N'
	        
	        if ("Y".equals(currentStatus)) {
	            // 현재 활성(Y) 상태라면 비활성화(N) 메서드 호출
	            empDao.useN(empNo);
	        } else {
	            // 현재 비활성(N) 상태라면 활성화(Y) 메서드 호출
	            empDao.useY(empNo);
	        }
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

	@RequestMapping("/vacList")
	public String list1(Model model) {
		List<VacInfoDto> vacInfoList = vacDao.selectList(); 
		List<Map<String, Object>> grantedList = new ArrayList<>();
		
		List<DeptDto> deptList = deptDao.selectTreeList();
		Map<Integer, String> deptMap = new HashMap<>();
		for(DeptDto d : deptList) {
			deptMap.put(d.getDeptId(), d.getDeptName());
		}
		
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
					map.put("vacTot", info.getVacTot());     
					map.put("vacCnt", info.getVacCnt());     
					map.put("vacUsed", info.getVacUsed());   
					map.put("vacReason", info.getVacReason());
					grantedList.add(map);
				}
			}
		}
		
		model.addAttribute("grantedList", grantedList);
		return "admin/vac/vac_list"; 
	}

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

	@PostMapping("/vac/grant")
	public String vacGrantSubmit(
			@RequestParam("empNoList") List<String> empNoList, 
			@RequestParam("vacYear") String vacYearStr, 
			@RequestParam int vacDays, 
			@RequestParam String vacReason) {
		
		String cleanedYear = vacYearStr.replace("'", "").replace("\"", "").trim();
		int vacYear = Integer.parseInt(cleanedYear); 
		
		vacService.grantBulkVacation(empNoList, vacYear, vacDays, vacReason);
		return "redirect:../vacList";
	}

	@GetMapping("/vac/removeHistory")
	public String vacRemoveHistory(@RequestParam(value = "empNoList", required = false) List<String> empNoList) {
		if (empNoList != null && !empNoList.isEmpty()) {
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

	// 🎯 [충돌 해결 완료] 다중 조건 검색 필터링 매개변수 및 페이징 파라미터 온전하게 결합
	@RequestMapping("/app/list")
	public String appList(
			HttpSession session, 
			@ModelAttribute PageVO pageVO, 
			@RequestParam(required = false) String searchEmpName,
			@RequestParam(required = false) String searchAppType,
			@RequestParam(required = false) String searchAppStatus,
			Model model) {
		
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null) {
			return "redirect:/login";
		}
		
		int totalCount = appDao.countAll(searchEmpName, searchAppType, searchAppStatus);
		pageVO.setCount(totalCount); 

		// 원격(origin/main)의 필터링 조건 포함 리스트 조회 연동
		List<AppDto> list = appDao.selectAllList(pageVO, searchEmpName, searchAppType, searchAppStatus);
		
		model.addAttribute("list", list);
		model.addAttribute("pageVO", pageVO); 
		
		model.addAttribute("searchEmpName", searchEmpName);
		model.addAttribute("searchAppType", searchAppType);
		model.addAttribute("searchAppStatus", searchAppStatus);
		
		String searchParams = "searchEmpName=" + (searchEmpName != null ? searchEmpName : "") 
							+ "&searchAppType=" + (searchAppType != null ? searchAppType : "") 
							+ "&searchAppStatus=" + (searchAppStatus != null ? searchAppStatus : "");
		model.addAttribute("searchParams", searchParams);

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

	    if (appDto.getAppType() == null) {
	        return "admin/app/detail";
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
	    return "app/detail";
	}

	@GetMapping("/attn/manage")
	public String manage(@ModelAttribute("search") AttnDto searchDto, @ModelAttribute("pageVO") PageVO pageVO, Model model) {
		pageVO.setCount(adminAttnService.countAdminAttendance(searchDto));
		model.addAttribute("attnList", adminAttnService.getAdminAttendanceList(searchDto, pageVO));
		return "admin/attn/manage";
	}
}