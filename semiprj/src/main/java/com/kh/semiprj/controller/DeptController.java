	package com.kh.semiprj.controller;

import java.io.IOException;
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

import com.kh.semiprj.dao.DeptDao;
import com.kh.semiprj.dao.EmpDao;
import com.kh.semiprj.dto.DeptDto;
import com.kh.semiprj.dto.EmpDto;
import com.kh.semiprj.exception.TargetNotfoundException;
import com.kh.semiprj.exception.WhoAreYouException;
import com.kh.semiprj.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/dept")
public class DeptController {
	@Autowired
	private DeptDao deptDao;
	@Autowired
	private EmpDao empDao;

	//목록 및 검색(페이징처리된것)
	@RequestMapping("/list")
	public String list(@ModelAttribute PageVO pageVO, Model model) {
		
		pageVO.setSize(10); 
		int count = deptDao.count(pageVO);
		pageVO.setCount(count);
	    
		//목록 조회
		List<DeptDto> list = deptDao.selectList(pageVO);
		
		//모델에 첨부
		model.addAttribute("list",list);
		model.addAttribute("pageVO",pageVO);
		
		return "dept/list";
	}
	
	//목록 (조직도)
	@RequestMapping("/listTree")
	public String listTree(Model model) {
		
		
		List<DeptDto> list = deptDao.selectTreeList();
		model.addAttribute("list",list);
		
		return "dept/listTree";
	}
	
	//등록
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
	public String insert(@ModelAttribute DeptDto deptDto) throws IllegalStateException, IOException {
		
		int deptId = deptDao.sequence();
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
		
		if(deptDto.getParentDeptId() != 0) {
			DeptDto parentDeptDto = deptDao.selectOne(deptDto.getParentDeptId());
			model.addAttribute("parentDeptDto",parentDeptDto);	
		}
		
		EmpDto empDto = empDao.selectOneDeptHeadId(deptDto.getDeptHeadId());//부서장 이름을 불러오기위해
		List<EmpDto> memberList = deptDao.selectListByDeptRecursive(deptId);
		List<DeptDto> childDeptList = deptDao.selectChildDept(deptId);
		
	    model.addAttribute("childDeptList",childDeptList);
	    model.addAttribute("memberList", memberList);
		model.addAttribute("deptDto",deptDto);
		
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
		
		List<DeptDto> deptList = deptDao.selectTreeList();
		model.addAttribute("deptList", deptList);
		return "dept/edit";
	}
	
	@PostMapping("/edit")
	public String edit(@ModelAttribute DeptDto deptDto,HttpSession session) {
		String loginRole = (String) session.getAttribute("loginRole");
		if(loginRole == null|| !loginRole.equals("관리자")) {
			throw new WhoAreYouException("관리자권한이 필요한 기능입니다.");
		}
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
	public List<EmpDto> searchEmp(@RequestParam String keyword){
	    return empDao.searchByName(keyword);
	}
		
	
}