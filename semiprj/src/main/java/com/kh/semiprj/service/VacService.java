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

	// [신청 시점] 공통 결재 및 휴가신청서 마스터만 저장
	@Transactional
	public void registerVacation(VacAppDto vacAppDto) {
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);
	}

	// [최종 승인 완료 시점] 진짜로 vac_history에 저장한 뒤 그 개수만큼 vac_info를 깎는 마스터 스위치
	@Transactional(rollbackFor = Exception.class) // 에러 발생 시 데이터가 꼬이지 않도록 전체 롤백 방어
	public void approveVacationSuccess(int appId, String empNo) {
		
		// 1. 단건 조회
		VacAppDto vacAppDto = vacAppDao.selectVacOne(appId); 
		
		// [방어 코드] 문서가 없거나 '연차'가 아니라면 즉시 종료
		if (vacAppDto == null || !"연차".equals(vacAppDto.getVacType())) {
			return;
		}

		LocalDate start = LocalDate.parse(vacAppDto.getVacStartDate());
		LocalDate end = LocalDate.parse(vacAppDto.getVacEndDate());
		
		// 3. 시작일부터 종료일까지 하루씩 증가하며 주말을 제외하고 vac_history에 밀어 넣기
		while (!start.isAfter(end)) {
			DayOfWeek dayOfWeek = start.getDayOfWeek();
			
			// 토요일과 일요일이 아닐 때만(평일일 때만) 이력 인입
			if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
				VacHistoryDto histDto = new VacHistoryDto();
				histDto.setAppId(appId);
				histDto.setVacDate(start.toString());
				
				vacDao.insertVacHistory(histDto); // vac_history에 실시간 INSERT 실행
			}
			start = start.plusDays(1);
		}
		
		
		int actualVacationDays = vacDao.countVacationDaysFromHistory(appId);
		
		// 5. 계산된 실제 평일 연차 소진 일수가 존재하면 vac_info 테이블 최종 차감 갱신 수행
		if (actualVacationDays > 0) {
			LocalDate startDateForYear = LocalDate.parse(vacAppDto.getVacStartDate());
			int currentYear = startDateForYear.getYear(); 
			vacDao.decreaseVacationCount(empNo, currentYear, actualVacationDays);
			
			System.out.println("✔ [연차 원격 차감 성공] 사번: " + empNo + " | 차감 연도: " + currentYear + " | 일수: " + actualVacationDays + "일");
		}
	}
}