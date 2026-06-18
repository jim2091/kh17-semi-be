package com.kh.semiprj.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.AppLineDao;
import com.kh.semiprj.dto.AppDto;
import com.kh.semiprj.dto.AppLineDto;
import com.kh.semiprj.dto.DftAppDto;
import com.kh.semiprj.dto.ExpAppDto;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.service.VacService;

import jakarta.servlet.http.HttpSession;

//결재자를 통제하는 컨트롤러
@Controller
@RequestMapping("/appr")
public class ApprController {
	@Autowired
	private AppDao appDao;
	@Autowired
	private AppLineDao appLineDao;
	@Autowired
	private VacService vacService;

	// 결재자가 보는 리스트
	@RequestMapping("/list")
	public String list(HttpSession session, Model model) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		String empNo = appDao.selectEmpNoById(loginId);
		List<AppLineDto> list = appLineDao.selectMyApprList(empNo);

		// appDto 목록도 같이 조회
		List<AppDto> appList = new ArrayList<>();
		for (AppLineDto line : list) {
			AppDto appDto = appDao.selectOneById(line.getAppId());
			appList.add(appDto);
		}

		model.addAttribute("list", list);
		model.addAttribute("appList", appList);
		model.addAttribute("currentTab", "appr");
		return "/appr/list";
	}

	// 승인 처리 컨트롤러 매핑 교정
		@PostMapping("/approve")
		public String approve(@RequestParam int appLineId, @RequestParam int appId, @RequestParam int currentOrder,
				HttpSession session) {
			
			String loginId = (String) session.getAttribute("loginId");
			if (loginId == null) {
				return "redirect:/login"; 
			}
			
			String empNo = appDao.selectEmpNoById(loginId);
			AppLineDto line = appLineDao.selectOne(appLineId);
			
			// [방어 코드] 본인 결재선이 아니면 즉시 차단
			if (line == null || !line.getAppAppId().equals(empNo)) {
				return "redirect:./list";
			}

			// 현재 결재선 승인 처리
			appLineDao.approve(appLineId);

			// 다음 결재권자 유무 업데이트 및 카운트 채취
			int nextCount = appLineDao.updateNextApprover(appId, currentOrder);
			if (nextCount > 0) {
				appDao.updateAppStatus(appId, "처리중");
			} else {
				// ➔ 차례가 더 없으므로 최종 문서 승인 종결 처리
				appDao.updateAppStatus(appId, "승인");
				
				// 💡 [교정 핵심] 결재 마스터 테이블에서 해당 문서의 종류(Type)를 추출합니다.
				// (참고: appDao에 selectAppTypeById 같은 메서드가 없다면 쿼리로 app_type을 꺼내와야 합니다.)
				String appType = appDao.selectAppTypeById(appId); 
				
				// 💡 오직 '휴가신청서' 도메인일 때만 주말 제외 및 연차 자동 차감 프로세스를 연동합니다.
				if ("휴가신청서".equals(appType)) {
					String requesterEmpNo = appDao.selectEmpNoByAppId(appId);
					vacService.approveVacationSuccess(appId, requesterEmpNo);
				} else {
					System.out.println("✔ [일반 문서 승인 완료] 문서유형: " + appType + " | 연차 연동 없이 최종 종결 처리");
				}
			}
			return "redirect:./detail?appId=" + appId;
		}

		// 반려 (기존 로직 유지 및 안전 방어선 보강)
		@PostMapping("/reject")
		public String reject(@RequestParam int appLineId, @RequestParam int appId, @RequestParam String appLineRej,
				HttpSession session) {
			String loginId = (String) session.getAttribute("loginId");
			if (loginId == null) {
				return "redirect:/login";
			}
			
			String empNo = appDao.selectEmpNoById(loginId);
			AppLineDto line = appLineDao.selectOne(appLineId);
			
			if (line == null || !line.getAppAppId().equals(empNo)) {
				return "redirect:./list";
			}

			appLineDao.reject(appLineId, appLineRej);
			appDao.updateAppStatus(appId, "반려");
			return "redirect:./detail?appId=" + appId;
		}
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int appId, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		String empNo = appDao.selectEmpNoById(loginId);

		AppDto appDto = appDao.selectOneById(appId);
		if (appDto == null)
			return "redirect:./list";

		List<AppLineDto> lineList = appLineDao.selectByAppId(appId);

		// 내 차례인지 확인
		AppLineDto myTurn = null;
		for (AppLineDto line : lineList) {
			if (line.getAppAppId().equals(empNo) && line.getAppLineStatus().equals("진행중")) {
				myTurn = line;
				break;
			}
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

		model.addAttribute("appDto", appDto);
		model.addAttribute("lineList", lineList);
		model.addAttribute("myTurn", myTurn);
		return "appr/detail";
	}

}
