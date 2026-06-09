package com.kh.semiprj.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import java.util.List;
import com.kh.semiprj.service.AttnService;

@Component
public class AttnScheduler {

    @Autowired
    private AttnService attnService;

    // 매일 자정 5분에 실행 (어제 미퇴근자 결근 처리)
    @Scheduled(cron = "0 5 0 * * *")
    public void dailyClosing() {
        attnService.processDailyAttendance();
        System.out.println("어제자 미퇴근자 결근 처리 완료");
    }

    // 매일 저녁 7시에 실행 (오늘 퇴근 미기록자 확인용)
    @Scheduled(cron = "0 0 19 * * *")
    public void dailyReminder() {
        List<String> list = attnService.getEmployeesWithoutOutTime();
        System.out.println("금일 퇴근 미기록자 점검 완료. 대상자 수: " + list.size());
    }
}