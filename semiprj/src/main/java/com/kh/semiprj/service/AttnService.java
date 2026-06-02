package com.kh.semiprj.service;

import java.time.LocalTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.semiprj.dao.AttnDao;

@Service
public class AttnService {

    @Autowired
    private AttnDao attnDao;

    private final LocalTime STANDARD_TIME = LocalTime.of(9, 0);

    // 출근 판정
    public String getAttendanceStatus(LocalTime attnInTime) {

        if (attnInTime == null) {
            return "결근";
        }

        if (attnInTime.isAfter(STANDARD_TIME)) {
            return "지각";
        }

        return "정상출근";
    }

    // 상태까지 포함한 구조 (추천)
    public String getStatus(LocalTime inTime, LocalTime outTime) {

        if (inTime == null && outTime == null) {
            return "출근전";
        }

        if (inTime != null && outTime == null) {
            return "출근중";
        }

        return "퇴근";
    }
}