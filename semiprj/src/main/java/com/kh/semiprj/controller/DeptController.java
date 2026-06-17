	package com.kh.semiprj.controller;

import java.io.IOException;
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

import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dao.MessageDao;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.exception.WhoAreYouException;
import com.kh.semiprj.service.DeptDashboardService;
import com.kh.semiprj.vo.ManagerDashboardVO;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/dept")
public class DeptController {
	@Autowired
	private DeptDao deptDao;
	@Autowired
	private EmpDao empDao;
	@Autowired
	private MessageDao messageDao;
	@Autowired
	private DeptDashboardService deptDashboardService;
	

	//목록 및 검색(페이징처리된것)
	@RequestMapping("/list")
	public String list(@ModelAttribute PageVO pageVO, Model model) {
		
		pageVO.setSize(10); 
		int count = deptDao.count(pageVO);
		pageVO.setCount(count);
		model.addAttribute("pageVO",pageVO);
	    
		//목록 조회
		List<DeptDto> list = deptDao.selectList(pageVO);
		model.addAttribute("list",list);
		
		return "dept/list";
	}
	
	//목록 (조직도)
	@RequestMapping("/listTree")
	public String listTree(Model model) {
		
		
		List<DeptDto> list = deptDao.selectTreeList();
		model.addAttribute("list",list);
		
		return "dept/listTree";
	}
	
	// 등록 
	@GetMapping("/insert")
	public String insert(HttpSession session, Model model ) {
		String loginRole = (String)session.getAttribute("loginRole");
		if(loginRole == null || !loginRole.equals("관리자")){
			throw new WhoAreYouException("관리자 권한이 필요한 기능입니다.");
		}
		
		List<DeptDto> deptList = deptDao.selectTreeList();
		model.addAttribute("deptList",deptList);
		
		return "dept/insert";
	}
		
		
	@PostMapping("/insert")
	public String insert(@ModelAttribute DeptDto deptDto,
						@RequestParam(value="messageReceiver", required=false) String deptHeadId)
	                     throws IllegalStateException, IOException {
		// 부서 번호 시퀀스 생성 및 인서트 작업 진행
	    int deptId = deptDao.sequence();
	    if (deptHeadId != null) {
	        deptDto.setDeptHeadId(deptHeadId);
	    }
	    deptDto.setDeptId(deptId);
	    deptDao.insert(deptDto);
		
		return "redirect:./insertComplete";
	}
	
	@RequestMapping("/insertComplete")
	public String insertComplete() {
		return "dept/insertComplete";
	}
	
	//상세
	@RequestMapping("/detail")
	public String detail(@RequestParam int deptId, Model model) {
		DeptDto deptDto = deptDao.selectOne(deptId);
		if(deptDto == null) {
			throw new TargetNotfoundException("존재하지 않는 부서 정보");
		}
		model.addAttribute("deptDto",deptDto);
		
		if(deptDto.getParentDeptId() != 0) {
			DeptDto parentDeptDto = deptDao.selectOne(deptDto.getParentDeptId());
			model.addAttribute("parentDeptDto",parentDeptDto);	
		}
		
		EmpDto empDto = empDao.selectOneDeptHeadId(deptDto.getDeptHeadId());//부서장 이름 출력
		model.addAttribute("empDto",empDto);

		List<EmpDto> memberList = deptDao.selectListByDeptRecursive(deptId);//직원 목록 출력
		model.addAttribute("memberList", memberList);

		List<DeptDto> childDeptList = deptDao.selectChildDept(deptId);//하위부서 출력
		model.addAttribute("childDeptList",childDeptList);

		List<DeptDto> allDeptList = deptDao.selectTreeList(); //전체 출력
		model.addAttribute("list", allDeptList);
		
		
		return "dept/detail";
	}
	
	
	
	//수정
	@GetMapping("/edit")
	public String edit(@RequestParam int deptId, Model model, HttpSession session) {
		String loginRole = (String)session.getAttribute("loginRole");
		if(loginRole == null || !loginRole.equals("관리자")) {
			throw new WhoAreYouException("관리자 권한이 필요합니다.");
		}
		
		DeptDto deptDto = deptDao.selectOne(deptId);
		if(deptDto == null) throw new TargetNotfoundException("존재하지 않은 부서");
		model.addAttribute("deptDto",deptDto);
		
		List<DeptDto> deptList = deptDao.selectAvailableParents(deptId);
	    model.addAttribute("deptList", deptList);
		
		List<DeptDto> deptListTree = deptDao.selectTreeList();
		model.addAttribute("deptListTree", deptListTree);
		
		return "dept/edit";
	}
	
	@PostMapping("/edit")
	public String edit(@ModelAttribute DeptDto deptDto,
						@RequestParam(value="messageReceiver", required=false) 
						String deptHeadId,HttpSession session) {
		String loginRole = (String) session.getAttribute("loginRole");
		if(loginRole == null|| !loginRole.equals("관리자")) {
			throw new WhoAreYouException("관리자권한이 필요한 기능입니다.");
		}
		
		deptDto.setDeptHeadId(deptHeadId);
		deptDao.update(deptDto);
		return "redirect:./detail?deptId="+deptDto.getDeptId();
	}
	
	//활성화 토글
	@RequestMapping("/block")
	public String block(@RequestParam int deptId, HttpSession session) {
		String loginRole = (String) session.getAttribute("loginRole");
		if(loginRole == null || !loginRole.equals("관리자")) {
			throw new WhoAreYouException("관리자 권한이 필요합니다.");
		}		
		DeptDto deptDto = deptDao.selectOne(deptId);
		if(deptDto == null) {	
			throw new TargetNotfoundException("존재하지 않는 부서입니다.");
		}
			
		String current = deptDto.getDeptYn();
		String future = current.equals("Y") ? "N" : "Y";
		deptDto.setDeptYn(future);
		deptDao.updateDeptYn(deptDto);
		
		return "redirect:./detail?deptId="+deptId;
	}
	//사원찾기
	@GetMapping("/searchEmp")
	@ResponseBody
	public List<Map<String, Object>> searchEmp(@RequestParam String keyword){
		List<EmpDto> originList = empDao.searchByName(keyword);
	    
	    List<Map<String, Object>> resultList = new ArrayList<>();
	    
	    for (EmpDto emp : originList) {
	        Map<String, Object> map = new HashMap<>();
	        
	        map.put("empNo", emp.getEmpNo());
	        map.put("empName", emp.getEmpName());
	        map.put("empPosition", emp.getEmpPosition());
	        map.put("empDept", emp.getEmpDept());
	        
	        if (emp.getEmpDept() != 0) {
	            try {
	                String deptName = messageDao.selectDetpNameById(emp.getEmpDept());
	                map.put("empDeptName", deptName);
	            } catch (Exception e) {
	                map.put("empDeptName", "소속없음");
	            }
	        } else {
	            map.put("empDeptName", "소속없음");
	        }
	        
	        resultList.add(map);
	    }

		return resultList;
	}
		
	@GetMapping("/manager")
	public String managerDashboard(HttpSession session, Model model, 
						@RequestParam(required=false) String deptId, 
						@RequestParam(required=false) String month) {
		String loginId = (String) session.getAttribute("loginId");
		EmpDto empDto = empDao.selectOne(loginId);
		ManagerDashboardVO dashboard = deptDashboardService.createDashboard(empDto.getEmpNo(), deptId, month);
		
		if (dashboard == null) {
			return "redirect:/";
		}
		
		model.addAttribute("dashboard", dashboard);
		
		return "dept/manager";
	}
}