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

    // 🎯 [수정] 매주 월요일부터 금요일 자정(00시) 5분에만 실행 (토, 일 제외)
    // 크론식 마지막 필드: 1-5 (월-금) 또는 MON-FRI
    @Scheduled(cron = "0 5 0 * * MON-FRI")
    public void dailyClosing() {
        // 1단계: 어제자(평일) 미퇴근 사원들 중 결근 대상자 선별 및 일괄 '결근' 처리
        attnService.processDailyAttendance();
        System.out.println("어제자 미퇴근자 결근 마감 완료");
        
        // 2단계: 금일(평일) 출근할 사원 베이스 레코드 생성
        attnDao.createTodayAttendance();
        System.out.println("금일 출근 대상 사원 베이스 레코드 선행 생성 완료 (연차 자동 연동 반영)");
    }
}