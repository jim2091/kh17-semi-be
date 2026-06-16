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
	private VacDao vacDao; // vac_info 및 vac_history 제어용 DAO

	@Transactional
	public void registerVacation(VacAppDto vacAppDto) {
		// 1. 최상위 공통 결재 문서 인입
		appDao.insert(vacAppDto);
		
		// 2. 휴가신청서 마스터 서브 인입
		vacAppDao.insertVacApp(vacAppDto);
		
		// 3. 날짜 연산을 위한 세팅
		LocalDate start = LocalDate.parse(vacAppDto.getVacStartDate());
		LocalDate end = LocalDate.parse(vacAppDto.getVacEndDate());
		
		// [핵심] 실제 연차 소진 일수(주말을 제외한 평일 수)를 저장할 카운트 변수
		int actualVacationDays = 0;
		
		// 시작일이 종료일보다 작거나 같을 때까지 하루씩 증가하며 루프
		while (!start.isAfter(end)) {
			DayOfWeek dayOfWeek = start.getDayOfWeek();
			
			// 토요일과 일요일이 아닐 때만(=평일일 때만) 수행
			if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
				
				// 3-1. 상세 일자 기록 매핑 (vac_history)
				VacHistoryDto histDto = new VacHistoryDto();
				histDto.setAppId(vacAppDto.getAppId());
				histDto.setVacDate(start.toString());
				vacDao.insertVacHistory(histDto);
				
				// 3-2. [실제 소진 일수 카운트 업] 평일이므로 1일 증가
				actualVacationDays++;
			}
			
			start = start.plusDays(1); // 다음 날로 이동
		}
		
		// 4. [연차 잔여 개수 최종 차감 프로세스]
		// 기안자의 사원번호(empNo)와 현재 연도(Year) 정보를 추출합니다.
		String empNo = vacAppDto.getAppReqId();
		int currentYear = LocalDate.now().getYear(); 
		
		// [방어 코드] 계산된 평일 휴가 일수가 1일 이상일 때만 차감 로직 가동
		if (actualVacationDays > 0) {
			// vacDao에 아래 차감 쿼리 메서드를 만들어서 연동하시면 됩니다.
			vacDao.decreaseVacationCount(empNo, currentYear, actualVacationDays);
		}
	}
}
