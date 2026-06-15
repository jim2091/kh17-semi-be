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

    // 매일 자정 5분에 실행 (어제 정산 마감 및 제약조건 최적화 반영)
    @Scheduled(cron = "0 5 0 * * *")
    public void dailyClosing() {
        // 1단계: 어제자 미퇴근자 결근 처리 (휴가 테이블 조인 필터를 적용하여 휴가자는 결근 스킵)
        attnService.processDailyAttendance();
        System.out.println("어제자 미퇴근자 결근 마감 완료");
        
        // 2단계: 오늘 출근할 전 사원들의 베이스 공백 레코드 미리 INSERT 생성 ('출근전' 규격으로 안전하게 등록)
        attnDao.createTodayAttendance();
        System.out.println("금일 출근 대상 사원 베이스 레코드 선행 생성 완료");
    }
}