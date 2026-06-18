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

	@Transactional
	public void deleteBulkVacationHistory(List<String> empNoList) {
		if (empNoList == null || empNoList.isEmpty()) return;
		
		for(String empNo : empNoList) {
			vacDao.deleteHistoryByEmpNo(empNo); 
			
			vacDao.deleteVacInfoByEmpNo(empNo);
		}
	}

	@Transactional
	public void grantBulkVacation(List<String> empNoList, int vacYear, int vacDays, String vacReason) {
		for(String empNo : empNoList) {
			vacDao.insertOrUpdateVacation(empNo, vacYear, vacDays, vacReason);
		}
	}

	@Transactional
	public void grantVacation(String empNo, int vacYear, int vacDays, String vacReason) {
		vacDao.insertOrUpdateVacation(empNo, vacYear, vacDays, vacReason);
	}

	@Transactional
	public void registerVacation(VacAppDto vacAppDto) {
		if (vacAppDto == null)
			return;
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);
	}

	@Transactional(rollbackFor = Exception.class) 
	public void approveVacationSuccess(int appId, String empNo) {
		
		// 1. 단건 조회
		VacAppDto vacAppDto = vacAppDao.selectVacOne(appId); 
		
		// [방어 코드] 문서가 없거나 '연차'가 아니라면 즉시 종료

		if (vacAppDto == null || !"연차".equals(vacAppDto.getVacType())) {
			return;
		}
		
		LocalDate start = LocalDate.parse(vacAppDto.getVacStartDate());
		LocalDate end = LocalDate.parse(vacAppDto.getVacEndDate());
		
		while (!start.isAfter(end)) {
			DayOfWeek dayOfWeek = start.getDayOfWeek();

			if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
				VacHistoryDto histDto = new VacHistoryDto();
				histDto.setAppId(appId);
				histDto.setVacDate(start.toString());

				vacDao.insertVacHistory(histDto);
			}
			start = start.plusDays(1); 
		}
		
		int actualVacationDays = vacDao.countVacationDaysFromHistory(appId);
		
		if (actualVacationDays > 0) {
			LocalDate startDateForYear = LocalDate.parse(vacAppDto.getVacStartDate());
			int currentYear = startDateForYear.getYear();

			vacDao.decreaseVacationCount(empNo, currentYear, actualVacationDays);

			System.out.println("✔ [연차 자동 차감 완료] 사번: " + empNo + " | 반영연도: " + currentYear + " | 차감일수: "
					+ actualVacationDays + "일");
		}
	}
}