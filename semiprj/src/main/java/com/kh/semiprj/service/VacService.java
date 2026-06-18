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

	@Transactional
	public void registerVacation(VacAppDto vacAppDto) {
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);
	}

	@Transactional
	public void approveVacationSuccess(int appId, String empNo) {
		VacAppDto vacAppDto = vacAppDao.selectVacOne(appId);
		if (vacAppDto == null || !"연차".equals(vacAppDto.getVacType())) {
			return;
		}

		LocalDate start = LocalDate.parse(vacAppDto.getVacStartDate());
		LocalDate end = LocalDate.parse(vacAppDto.getVacEndDate());
		int vacationYear = start.getYear(); 

		int actualVacationDays = 0;
		while (!start.isAfter(end)) {
			DayOfWeek dayOfWeek = start.getDayOfWeek();

			if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
				VacHistoryDto histDto = new VacHistoryDto();
				
				// [핵심 수정] 루프가 돌 때마다 오라클 시퀀스에서 중복 없는 새 번호를 매번 뽑아옵니다.
				int nextHistNo = vacDao.sequence(); 
				
				histDto.setVacHistNo(nextHistNo); // 새로 뽑은 안전한 번호 주입
				histDto.setAppId(appId);
				histDto.setVacDate(start.toString());
				
				vacDao.insertVacHistory(histDto);
				actualVacationDays++;
			}
			start = start.plusDays(1);
		}

		if (actualVacationDays > 0) {
			vacDao.decreaseVacationCount(empNo, vacationYear, actualVacationDays);
		}
	}
	
}