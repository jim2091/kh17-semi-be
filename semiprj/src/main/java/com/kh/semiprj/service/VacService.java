package com.kh.semiprj.service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.VacAppDao;
import com.kh.semiprj.dao.VacDao;
import com.kh.semiprj.dto.VacAppDto;
import com.kh.semiprj.dto.VacHistoryDto;

@Service
public class VacService {

	@Autowired
	private AppDao appDao;

	@Autowired
	private VacAppDao vacAppDao;

	@Autowired
	private VacDao vacDao;

	// ==========================================
	// 🎯 [수정 완료] 체크한 대상의 휴가 날짜 이력과 연차 보유 현황 행을 전부 실시간 삭제
	// ==========================================
	@Transactional
	public void deleteBulkVacationHistory(List<String> empNoList) {
		if (empNoList == null || empNoList.isEmpty()) return;
		
		for(String empNo : empNoList) {
			// 1. 하위 휴가 상세 일자 삭제 (문법 오류 났던 쿼리 수정본 실행)
			vacDao.deleteHistoryByEmpNo(empNo); 
			
			// 2. 메인 화면에 뿌려지는 연차 관리대장(vac_info)의 데이터 행을 삭제!
			vacDao.deleteVacInfoByEmpNo(empNo);
		}
	}

	// ==========================================
	// 다수 사원 연차 일괄 지급 트랜잭션 처리
	// ==========================================
	@Transactional
	public void grantBulkVacation(List<String> empNoList, int vacYear, int vacDays, String vacReason) {
		for(String empNo : empNoList) {
			vacDao.insertOrUpdateVacation(empNo, vacYear, vacDays, vacReason);
		}
	}

	// ==========================================
	// 관리자가 사원에게 연차를 직접 지급
	// ==========================================
	@Transactional
	public void grantVacation(String empNo, int vacYear, int vacDays, String vacReason) {
		vacDao.insertOrUpdateVacation(empNo, vacYear, vacDays, vacReason);
	}

	// ==========================================
	// 사원이 휴가 신청서를 작성할 때 시점
	// ==========================================
	@Transactional
	public void registerVacation(VacAppDto vacAppDto) {
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);
	}

	// ==========================================
	// 결재가 최종 승인되어 실제로 연차를 차감하는 시점
	// ==========================================
	@Transactional
	public void approveVacationSuccess(int appId, String empNo) {
		
		VacAppDto vacAppDto = vacAppDao.selectOne(appId); 
		
		if (vacAppDto == null || !"연차".equals(vacAppDto.getVacType())) {
			return; 
		}
		
		LocalDate start = LocalDate.parse(vacAppDto.getVacStartDate());
		LocalDate end = LocalDate.parse(vacAppDto.getVacEndDate());
		
		int actualVacationDays = 0;
		
		while (!start.isAfter(end)) {
			DayOfWeek dayOfWeek = start.getDayOfWeek();
			
			if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
				
				VacHistoryDto histDto = new VacHistoryDto();
				histDto.setAppId(appId);
				histDto.setVacDate(start.toString());
				
				vacDao.insertVacHistory(histDto);
				
				actualVacationDays++;
			}
			start = start.plusDays(1);
		}
		
		if (actualVacationDays > 0) {
			int currentYear = LocalDate.now().getYear();
			vacDao.decreaseVacationCount(empNo, currentYear, actualVacationDays);
		}
	}
}