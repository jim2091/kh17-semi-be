package com.kh.semiprj.service;

import java.time.DayOfWeek;
import java.time.LocalDate;

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

	// [신청 시점] 공통 결재 및 휴가신청서 마스터만 저장 (역할 분리)
	@Transactional
	public void registerVacation(VacAppDto vacAppDto) {
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);
	}

	// [최종 승인 완료 시점] 이 메서드가 호출되어야 진짜로 vac_history에 데이터가 저장됩니다.
	@Transactional
	public void approveVacationSuccess(int appId, String empNo) {
		
		// 1. 결재문서 번호(appId)로 vac_app에 저장되어 있던 시작일, 종료일, 휴가구분을 단건 조회합니다.
		VacAppDto vacAppDto = vacAppDao.selectOne(appId); 
		
		// [방어 코드] 문서가 존재하지 않거나, 휴가 구분이 '연차'가 아니라면 상세 일자 등록 및 차감 없이 즉시 종료합니다.
		if (vacAppDto == null || !"연차".equals(vacAppDto.getVacType())) {
			return; 
		}
		
		// 2. 문자열 날짜를 LocalDate 객체로 변환하여 루프 준비
		LocalDate start = LocalDate.parse(vacAppDto.getVacStartDate());
		LocalDate end = LocalDate.parse(vacAppDto.getVacEndDate());
		
		int actualVacationDays = 0;
		
		// 3. 시작일부터 종료일까지 하루씩 증가하며 주말을 제외하고 vac_history에 밀어 넣기
		while (!start.isAfter(end)) {
			DayOfWeek dayOfWeek = start.getDayOfWeek();
			
			// 토요일과 일요일이 아닐 때만(평일일 때만) 실제 이력에 인입
			if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
				
				VacHistoryDto histDto = new VacHistoryDto();
				histDto.setAppId(appId);
				histDto.setVacDate(start.toString()); // "2026-06-16" 형태 문자열 생성
				
				vacDao.insertVacHistory(histDto); // vac_history에 실시간 INSERT
				
				actualVacationDays++; // 실제 소진 연차 일수 카운트업
			}
			start = start.plusDays(1); // 다음 날로 전진
		}
		
		// 4. 계산된 실제 평일 연차 소진 일수가 존재하면 vac_info 테이블 최종 차감 갱신
		if (actualVacationDays > 0) {
			int currentYear = LocalDate.now().getYear(); // 현재 시스템 연도 추출 (2026)
			vacDao.decreaseVacationCount(empNo, currentYear, actualVacationDays);
		}
	}
}
