package com.kh.semiprj.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.kh.semiprj.dao.AttnDao; 
import com.kh.semiprj.service.AttnService;

@Component
public class AttnScheduler {

    @Autowired private AttnService attnService;
    @Autowired private AttnDao attnDao; 

    // 매일 자정(00시) 5분에 실행
    @Scheduled(cron = "0 5 0 * * *")
    public void dailyClosing() {
        // 1단계: 어제자 미퇴근 사원들 중 결근 대상자 선별 및 일괄 '결근' 처리
        attnService.processDailyAttendance();
        System.out.println("어제자 미퇴근자 결근 마감 완료");
        
        // 2단계: 금일 출근할 사원 베이스 레코드 생성
        // (내부 수정을 통해 휴가자는 자정에 미리 '휴가' 낙인이 찍힌 채로 인서트됩니다.)
        attnDao.createTodayAttendance();
        System.out.println("금일 출근 대상 사원 베이스 레코드 선행 생성 완료 (연차 자동 연동 반영)");
    }
}