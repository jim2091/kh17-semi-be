package com.kh.semiprj.service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.semiprj.dao.AppDao;
import com.kh.semiprj.dao.LeaveDao;   // VacDao -> LeaveDao
import com.kh.semiprj.dao.VacAppDao;
import com.kh.semiprj.dto.LeaveHistoryDto; // VacHistoryDto -> LeaveHistoryDto
import com.kh.semiprj.dto.VacAppDto;

@Service
public class LeaveService {
	
	@Autowired
	private AppDao appDao;
	
	@Autowired
	private VacAppDao vacAppDao;
	
	@Autowired
	private LeaveDao leaveDao;
	
	// [추가] 대량 휴가 이력 및 정보 삭제
	@Transactional
	public void deleteBulkLeaveHistory(List<String> empNoList) {
		if (empNoList == null || empNoList.isEmpty()) return;
		
		for(String empNo : empNoList) {
			leaveDao.deleteHistoryByEmpNo(empNo); 
			leaveDao.deleteLeaveInfoByEmpNo(empNo);
		}
	}

	// [추가] 대량 휴가 부여
	@Transactional
	public void grantBulkLeave(List<String> empNoList, int leaveYear, int leaveDays, String leaveReason) {
		for(String empNo : empNoList) {
			leaveDao.insertOrUpdateLeave(empNo, leaveYear, leaveDays, leaveReason);
		}
	}

	// [추가] 단건 휴가 부여
	@Transactional
	public void grantLeave(String empNo, int leaveYear, int leaveDays, String leaveReason) {
		leaveDao.insertOrUpdateLeave(empNo, leaveYear, leaveDays, leaveReason);
	}
	
	// [신청 시점] 공통 결재 및 휴가신청서 마스터 저장
	@Transactional
	public void registerLeave(VacAppDto vacAppDto) { // registerVacation -> registerLeave
		if (vacAppDto == null) return;
		appDao.insert(vacAppDto);
		vacAppDao.insertVacApp(vacAppDto);
	}

	// [최종 승인 완료 시점] 주말 제외 적재 후 휴가 차감 구동 마스터 스위치
	@Transactional(rollbackFor = Exception.class) 
	public void approveLeaveSuccess(int appId, String empNo) { // approveVacationSuccess -> approveLeaveSuccess

		// 1. 단건 휴가 기안서 마스터 정보 조회
		VacAppDto vacAppDto = vacAppDao.selectVacOne(appId);
		if (vacAppDto == null) return;

		// 💡 [의도 반영] 오직 '휴가' 또는 '연차' 타입만 승인 로직을 타도록 프로젝트 사정에 맞게 조율하세요.
		// (기존 의도대로 "휴가" 문자열만 필터링하도록 유지했습니다.)
		if (!"휴가".equals(vacAppDto.getVacType())) {
			return; 
		}

		// 💡 복사본(current)을 루프에 돌려 안전하게 원본 데이터 및 연도(Year) 유실을 방어
		LocalDate start = LocalDate.parse(vacAppDto.getVacStartDate().substring(0, 10));
		LocalDate end = LocalDate.parse(vacAppDto.getVacEndDate().substring(0, 10));
		int currentYear = start.getYear(); 

		LocalDate current = start;
		// 2. 시작일부터 종료일까지 하루씩 증폭 루프 가동
		while (!current.isAfter(end)) {
			DayOfWeek dayOfWeek = current.getDayOfWeek();

			// 토요일과 일요일이 아닐 때만(실질 영업 평일일 때만) 이력 누적
			if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
				LeaveHistoryDto histDto = new LeaveHistoryDto();
				histDto.setAppId(appId);
				histDto.setLeaveDate(current.toString()); 

				// 호출 시점마다 leave_history_seq로 인서트 수행
				leaveDao.insertLeaveHistory(histDto);
			}
			current = current.plusDays(1); // 다음 날짜로 이동
		}

		// 3. 실질 적재된 평일 휴가 차감 일수 산정
		int actualLeaveDays = leaveDao.countLeaveDaysFromHistory(appId);

		// 4. 최종 누적 차감 일수가 유효하면 배정 휴가 마스터 정보 최종 차감 연산 집행
		if (actualLeaveDays > 0) {
			// leave_info 테이블 휴가 잔여량 최종 갱신
			leaveDao.decreaseLeaveCount(empNo, currentYear, actualLeaveDays);

			System.out.println("✔ [휴가 자동 차감 완료] 사번: " + empNo + " | 반영연도: " + currentYear + " | 차감일수: "
					+ actualLeaveDays + "일");
		}
	}
}