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
	// 🎯 체크한 대상의 휴가 날짜 이력과 연차 보유 현황 행을 전부 실시간 삭제
	// ==========================================
	@Transactional
	public void deleteBulkVacationHistory(List<String> empNoList) {
		if (empNoList == null || empNoList.isEmpty()) return;
		
		for(String empNo : empNoList) {
			// 1. 하위 휴가 상세 일자 삭제
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
	// [신청 시점] 공통 결재 및 휴가신청서 마스터만 저장
	// ==========================================
	@Transactional
	public void registerVacation(VacAppDto vacAppDto) {
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);
	}

	// ==========================================
	// [최종 승인 완료 시점] 진짜로 vac_history에 저장한 뒤 그 개수만큼 vac_info를 깎는 마스터 스위치
	// ==========================================
	@Transactional(rollbackFor = Exception.class) // 에러 발생 시 데이터가 꼬이지 않도록 전체 롤백 방어
	public void approveVacationSuccess(int appId, String empNo) {
		
		// 1. 단건 조회 (더 정확한 데이터 검증용 쿼리 반영)
		VacAppDto vacAppDto = vacAppDao.selectVacOne(appId); 
		
		// [방어 코드] 문서가 없거나 '연차'가 아니라면 즉시 종료
		if (vacAppDto == null || !"연차".equals(vacAppDto.getVacType())) {
			return;
		}
		
		LocalDate start = LocalDate.parse(vacAppDto.getVacStartDate());
		LocalDate end = LocalDate.parse(vacAppDto.getVacEndDate());
		
		// 2. 시작일부터 종료일까지 하루씩 증가하며 주말을 제외하고 vac_history에 밀어 넣기
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
		
		// 3. 계산된 실제 평일 연차 소진 일수를 DB 이력 기준으로 정확하게 카운트
		int actualVacationDays = vacDao.countVacationDaysFromHistory(appId);
		
		// 4. 소진 일수가 존재하면 vac_info 테이블 최종 차감 갱신 수행 (신청서 시작일 기준 연도 산출 보정 반영)
		if (actualVacationDays > 0) {
			LocalDate startDateForYear = LocalDate.parse(vacAppDto.getVacStartDate());
			int currentYear = startDateForYear.getYear(); 
			
			vacDao.decreaseVacationCount(empNo, currentYear, actualVacationDays);
			
			System.out.println("✔ [연차 원격 차감 성공] 사번: " + empNo + " | 차감 연도: " + currentYear + " | 일수: " + actualVacationDays + "일");
		}
	}
}