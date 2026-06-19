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
import com.kh.semiprj.dao.LeaveDao;
import com.kh.semiprj.dao.VacDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.AppLineDto;
import com.kh.semiprj.dto.AttnDto;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.dto.EmpHistoryDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.LeaveInfoDto;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.dto.VacInfoDto;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.service.AdminAttnService;
import com.kh.semiprj.service.AdminDashboardService;
import com.kh.semiprj.service.LeaveService;
import com.kh.semiprj.service.VacService;
import com.kh.semiprj.vo.AdminDashboardVO;
import com.kh.semiprj.vo.HistoryPageVO;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
	@Autowired
	private VacService vacService;
	
	@Autowired
	private LeaveService leaveService;


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
	
	@Autowired
	private LeaveDao leaveDao; 
	
	@Autowired
	private AdminDashboardService adminDashboardService;

	@GetMapping("/register")
	public String register(Model model) {
		model.addAttribute("deptList", deptDao.selectTreeList());
		return "admin/register";
	}

	@PostMapping("/register")
	public String register(@ModelAttribute EmpDto empDto) {
		System.out.println(empDto);
	    System.out.println("hireDate = " + empDto.getEmpHireDate());
		empDao.insertFromAdmin(empDto);	
		empDao.insertDeptEmp(empDto.getEmpNo(), empDto.getEmpDept());
		return "redirect:./list";
	}

	@RequestMapping("/list")
	public String list(@ModelAttribute("pageVO") PageVO pageVO,
	        @RequestParam(required = false) String deptKeyword,
	        Model model) {

	    if("emp_dept".equals(pageVO.getColumn())) {

	        pageVO.setCount(
	            empDao.countAdminByDept(deptKeyword)
	        );

	        model.addAttribute(
	            "list",
	            empDao.selectAdminDeptByPage(
	                deptKeyword,
	                pageVO
	            )
	        );
	    }
	    else if(pageVO.isSearch()) {

	        pageVO.setCount(
	            empDao.countAdmin(pageVO)
	        );

	        model.addAttribute(
	            "list",
	            empDao.selectAdminSearchByPage(pageVO)
	        );
	    }
	    else {

	        pageVO.setCount(
	            empDao.countAdmin()
	        );

	        model.addAttribute(
	            "list",
	            empDao.selectAdminListByPage(pageVO)
	        );
	    }

	    model.addAttribute("pageUrl", "./list");
	    model.addAttribute("deptList",
	        deptDao.selectTreeList());

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
		model.addAttribute("deptList", deptDao.selectTreeList());
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
	public String waitingList(@ModelAttribute("pageVO") PageVO pageVO, Model model) {
		pageVO.setCount(
				empDao.countWaiting()
			);
	
			List<EmpDto> list =
				empDao.selectListForWaitingByPage(pageVO);
	
			model.addAttribute("list", list);
			model.addAttribute("isEmpty", list.isEmpty());
			model.addAttribute("pageUrl", "./waitingList");
			
			return "admin/waiting_list";
	}

	@RequestMapping("/vacList")
	public String list1(Model model) {
		List<VacInfoDto> vacInfoList = vacDao.selectList();
		List<Map<String, Object>> grantedList = new ArrayList<>();

		List<DeptDto> deptList = deptDao.selectTreeList();
		Map<Integer, String> deptMap = new HashMap<>();
		for (DeptDto d : deptList) {
			deptMap.put(d.getDeptId(), d.getDeptName());
		}

		if (vacInfoList != null) {
			for (VacInfoDto info : vacInfoList) {
				EmpDto emp = empDao.selectOneByDetail(info.getEmpNo());
				if (emp != null) {
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
		for (DeptDto d : deptList) {
			deptMap.put(d.getDeptId(), d.getDeptName());
		}

		for (EmpDto emp : empList) {
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
	public String vacGrantSubmit(@RequestParam("empNoList") List<String> empNoList,
			@RequestParam("vacYear") String vacYearStr, @RequestParam int vacDays, @RequestParam String vacReason) {

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
	public String vacDeleteHistoryBulkSubmit(
			@RequestParam(value = "empNoList", required = false) List<String> empNoList) {
		if (empNoList != null && !empNoList.isEmpty()) {
			vacService.deleteBulkVacationHistory(empNoList);
		}
		return "redirect:../vacList";
	}

	@GetMapping("/vac/detail")
	public String vacDetail(@RequestParam String empNo, @RequestParam int vacYear, Model model) {
		// 1. 사원 기본 정보 조회 및 전송
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		model.addAttribute("empDto", empDto);
		
		// 2. ✨ [Dao 교체 적용] 사원 번호와 함께 전달받은 연도로 특정 연차 데이터 타겟팅
		VacInfoDto vacInfoDto = vacDao.selectOneByEmpNoAndYear(empNo, vacYear); 

		model.addAttribute("vacInfoDto", vacInfoDto);

		return "admin/vac/detail";
	}
	
	@RequestMapping("/leaveList")
	public String list2(Model model) {
		List<LeaveInfoDto> leaveInfoList = leaveDao.selectList(); 
		List<Map<String, Object>> grantedList = new ArrayList<>();
		
		List<DeptDto> deptList = deptDao.selectTreeList();
		Map<Integer, String> deptMap = new HashMap<>();
		for(DeptDto d : deptList) {
			deptMap.put(d.getDeptId(), d.getDeptName());
		}
		
		if (leaveInfoList != null) {
			for(LeaveInfoDto info : leaveInfoList) {
				EmpDto emp = empDao.selectOneByDetail(info.getEmpNo());
				if(emp != null) {
					Map<String, Object> map = new HashMap<>();
					map.put("leaveNo", info.getLeaveNo());
					map.put("empNo", emp.getEmpNo());
					map.put("empName", emp.getEmpName());
					map.put("empId", emp.getEmpId());
					map.put("deptName", deptMap.get(emp.getEmpDept()));
					map.put("leaveYear", info.getLeaveYear());
					map.put("leaveTot", info.getLeaveTot());     
					map.put("leaveCnt", info.getLeaveCnt());     
					map.put("leaveUsed", info.getLeaveUsed());   
					map.put("leaveReason", info.getLeaveReason());
					grantedList.add(map);
				}
			}
		}
		
		model.addAttribute("grantedList", grantedList);
		return "admin/leave/leave_list"; 
	}

	@GetMapping("/leave/searchEmp")
	@ResponseBody
	public List<Map<String, Object>> searchEmpAjax1(@RequestParam String keyword) {
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

	@PostMapping("/leave/leaveGrant")
	public String leaveGrantSubmit(
			@RequestParam("empNoList") List<String> empNoList, 
			@RequestParam("leaveYear") String leaveYearStr, 
			@RequestParam int leaveDays, 
			@RequestParam String leaveReason) {
		
		String cleanedYear = leaveYearStr.replace("'", "").replace("\"", "").trim();
		int leaveYear = Integer.parseInt(cleanedYear); 
		
		leaveService.grantBulkLeave(empNoList, leaveYear, leaveDays, leaveReason);
		return "redirect:../leaveList";
	}

	@GetMapping("/leave/removeHistory")
	public String leaveRemoveHistory(@RequestParam(value = "empNoList", required = false) List<String> empNoList) {
		if (empNoList != null && !empNoList.isEmpty()) {
			leaveService.deleteBulkLeaveHistory(empNoList);
		}
		return "redirect:../leaveList";
	}

	@PostMapping("/leave/deleteHistoryBulk")
	public String leaveDeleteHistoryBulkSubmit(@RequestParam(value = "empNoList", required = false) List<String> empNoList) {
		if (empNoList != null && !empNoList.isEmpty()) {
			leaveService.deleteBulkLeaveHistory(empNoList);
		}
		return "redirect:../leaveList";
	}

	@GetMapping("/leave/leaveDetail")
	public String leaveDetail(@RequestParam String empNo, @RequestParam int leaveYear, Model model) {
		// 1. 사원 인적 정보 바인딩
		EmpDto empDto = empDao.selectOneByDetail(empNo);
		model.addAttribute("empDto", empDto);
		
		// 2. ✨ [개선] 연도와 사원번호 두 키값으로 조회해 옴으로써 다건 중복 반환 에러 완벽 해결
		LeaveInfoDto leaveInfoDto = leaveDao.selectOneByEmpNoAndYear(empNo, leaveYear); 
		model.addAttribute("leaveInfoDto", leaveInfoDto);
		
		return "admin/leave/leave_detail";
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
		if (empDto == null)
			throw new TargetNotfoundException("대상이 존재하지 않습니다");
		model.addAttribute("empDto", empDto);
		List<EmpHistoryDto> loginhistory = empHistoryDao.selectList(empNo, historyPageVO);
		model.addAttribute("loginhistory", loginhistory);
		int count = empHistoryDao.count(empNo, historyPageVO);
		historyPageVO.setCount(count);
		model.addAttribute("historyPageVO", historyPageVO);
		return "admin/history";
	}


	@GetMapping("/attn/manage")
	public String manage(@ModelAttribute("search") AttnDto searchDto, @ModelAttribute("pageVO") PageVO pageVO,
			Model model) {
		pageVO.setCount(adminAttnService.countAdminAttendance(searchDto));
		model.addAttribute("attnList", adminAttnService.getAdminAttendanceList(searchDto, pageVO));
		return "admin/attn/manage";
	}
	
	@GetMapping("/dashboard")
    public String dashboard(
            @RequestParam(required = false) String month,
            Model model) {

        AdminDashboardVO dashboard =
                adminDashboardService.createDashboard(month);

        model.addAttribute("dashboard", dashboard);

        return "admin/dashboard";
    }
}