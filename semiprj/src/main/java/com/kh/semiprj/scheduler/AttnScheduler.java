package com.kh.semiprj.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import java.util.List;
import com.kh.semiprj.dao.AttnDao; // 💡 직접 Dao 호출 처리를 위한 임포트 추가
import com.kh.semiprj.service.AttnService;

@Component
public class AttnScheduler {

    @Autowired private AttnService attnService;
    @Autowired private AttnDao attnDao; // 💡 금일 데이터 선행 생성용 주입

    // 매일 자정 5분에 실행 (어제 정산 마감 & 오늘 새벽 출근 준비 일괄 처리)
    @Scheduled(cron = "0 5 0 * * *")
    public void dailyClosing() {
        // 1단계: 어제자 미퇴근자 결근 처리 (기존 로직 수행)
        attnService.processDailyAttendance();
        System.out.println("어제자 미퇴근자 결근 마감 완료");
        
        // 2단계: 오늘 출근할 전 사원들의 베이스 공백 레코드 미리 INSERT 생성
        attnDao.createTodayAttendance();
        System.out.println("금일 출근 대상 사원 베이스 레코드 선행 생성 완료");
    }

}