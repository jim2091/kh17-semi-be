package com.kh.semiprj.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.semiprj.dao.AppLineDao;
import com.kh.semiprj.dto.AppLineDto;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AppLineService {

    private final AppLineDao appLineDao;

    // 승인 처리
    @Transactional
    public String approve(int appLineId, String loginId) {

        // 1. 단건 조회로 본인 확인
        AppLineDto current = appLineDao.selectOne(appLineId);

        if (current == null) {
            throw new IllegalStateException("결재 정보를 찾을 수 없습니다.");
        }
        if (!current.getAppAppId().equals(loginId)) {
            throw new IllegalStateException("본인 결재 차례가 아닙니다.");
        }

        // 2. 승인 처리
        appLineDao.approve(appLineId);

        // 3. 다음 결재자 진행중으로 변경 (없으면 0 반환)
        int updated = appLineDao.updateNextApprover(
                          current.getAppId(), current.getAppLineOrder());

        if (updated == 0) {
            return "완료"; // 마지막 결재자였음
        }
        return "진행중";
    }

    // 반려 처리
    @Transactional
    public void reject(int appLineId, String loginId, String reason) {

        AppLineDto current = appLineDao.selectOne(appLineId);

        if (current == null) {
            throw new IllegalStateException("결재 정보를 찾을 수 없습니다.");
        }
        if (!current.getAppAppId().equals(loginId)) {
            throw new IllegalStateException("본인 결재 차례가 아닙니다.");
        }

        appLineDao.reject(appLineId, reason);
    }

    // 결재선 목록 조회
    public List<AppLineDto> getAppLineList(int appId) {
        return appLineDao.selectByAppId(appId);
    }

    // 내 결재 목록
    public List<AppLineDto> getMyApprList(String empNo) {
        return appLineDao.selectMyApprList(empNo);
    }
}