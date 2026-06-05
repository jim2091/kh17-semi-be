package com.kh.semiprj.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.kh.semiprj.service.AttnService;

@Component // 스프링이 이 클래스를 자동으로 빈(Bean)으로 등록하게 합니다.
public class AttnScheduler {

    @Autowired
    private AttnService attnService;

    // 매일 자정 5분에 실행 (어제 미퇴근자 결근 처리)
    @Scheduled(cron = "0 5 0 * * *")
    public void dailyClosing() {
        attnService.processDailyAttendance();
    }

    // 매일 저녁 7시에 실행 (오늘 퇴근 미기록자 확인용)
    @Scheduled(cron = "0 0 19 * * *")
    public void dailyReminder() {
        attnService.getEmployeesWithoutOutTime();
        System.out.println("퇴근 미기록자 점검 완료");
    }
}