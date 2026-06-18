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

	// [신청 시점] 공통 결재 및 휴가신청서 마스터 저장
	@Transactional
	public void registerVacation(VacAppDto vacAppDto) {
		if (vacAppDto == null)
			return;
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);
	}

	// [최종 승인 완료 시점] 주말 제외 적재 후 연차 차감 구동 마스터 스위치
	@Transactional(rollbackFor = Exception.class) // 중간에 에러 터지면 깨끗하게 원상복구(롤백) 시키는 안전장치
	public void approveVacationSuccess(int appId, String empNo) {

		// 1. 단건 휴가 기안서 마스터 정보 조회
		VacAppDto vacAppDto = vacAppDao.selectVacOne(appId);

		// [방어 코드] 문서가 존재하지 않거나, 종류가 '연차'가 아니라면 즉각 탈출 처리
		if (vacAppDto == null || !"연차".equals(vacAppDto.getVacType())) {
			return;
		}

		LocalDate start = LocalDate.parse(vacAppDto.getVacStartDate());
		LocalDate end = LocalDate.parse(vacAppDto.getVacEndDate());

		// 2. 시작일부터 종료일까지 하루씩 증폭 루프 가동
		while (!start.isAfter(end)) {
			DayOfWeek dayOfWeek = start.getDayOfWeek();

			// 토요일과 일요일이 아닐 때만(실질 영업 평일일 때만) 이력 누적
			if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
				VacHistoryDto histDto = new VacHistoryDto();
				histDto.setAppId(appId);
				histDto.setVacDate(start.toString());

				// 💡 [개정] 자바가 번호를 주지 않아도, 호출 시점마다 DAO가 시퀀스로 겹치지 않게 인서트합니다.
				vacDao.insertVacHistory(histDto);
			}
			start = start.plusDays(1); // 다음 날짜로 이동
		}

		// 3. 실질 적재된 평일 연차 차감 일수 산정
		int actualVacationDays = vacDao.countVacationDaysFromHistory(appId);

		// 4. 최종 누적 차감 일수가 유효하면 배정 연차 마스터 정보 최종 차감 연산 집행
		if (actualVacationDays > 0) {
			LocalDate startDateForYear = LocalDate.parse(vacAppDto.getVacStartDate());
			int currentYear = startDateForYear.getYear();

			// vac_info 테이블 연차 마진 최종 갱신
			vacDao.decreaseVacationCount(empNo, currentYear, actualVacationDays);

			System.out.println("✔ [연차 자동 차감 완료] 사번: " + empNo + " | 반영연도: " + currentYear + " | 차감일수: "
					+ actualVacationDays + "일");
		}
	}
}