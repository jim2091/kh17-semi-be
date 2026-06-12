<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home2.jsp"></jsp:include>

<style>
/* 근태 페이지 전체 레이아웃 정렬 - 디자인 시스템 프레임 유지 */
.attn-width {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
}

/* 원형 그래프 테마 컬러 커스텀 보정 */
.circle-graph {
    width: 240px; 
    height: 240px; 
    border-radius: 50%;
    /* 배경색을 시스템 기본 회색에서 메인 테마 강조 컬러로 동적 반영 */
    background: conic-gradient(var(--main-color) calc(var(--percent) * 1%), var(--card-border) 0);
    display: flex; 
    align-items: center; 
    justify-content: center;
    transition: background 0.3s ease;
    box-shadow: 0 4px 12px rgba(0,0,0,0.03);
}

.inner-circle {
    width: 190px; 
    height: 190px; 
    border-radius: 50%; 
    background: #ffffff;
    display: flex; 
    flex-direction: column; 
    align-items: center; 
    justify-content: center;
    font-size: 14px;
    color: var(--sub-text);
}

.inner-circle span {
    font-weight: 800; 
    font-size: 32px;
    color: var(--main-color);
    line-height: 1.2;
}

/* 계산기 결과 정보 카드 카드 */
.calc-info-card {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 18px 24px;
    border: 1px solid var(--card-border);
    border-radius: 12px;
    background: #ffffff;
    min-width: 280px;
}

.calc-info-card i {
    font-size: 24px;
}

.calc-info-card .card-content {
    display: flex;
    flex-direction: column;
}

.calc-info-card .card-label {
    font-size: 13px;
    color: var(--sub-text);
    margin-bottom: 2px;
}

.calc-info-card .card-value {
    font-size: 20px;
    font-weight: 700;
}
</style>

<!-- 상단 헤드 영역 디자인 일치화 -->
<div class="gw-page-head attn-width">
    <div class="gw-breadcrumb">홈 / 근태관리 / 근태기록 계산기</div>
    <h1>근태 기록 계산기</h1>
    <p>지정한 설정 기간 내 평일(근무일) 기준 총 기준 시간 대비 본인의 근무 달성률을 시각적으로 확인합니다.</p>
</div>

<!-- 검색 패널 내 날짜 선택 디자인 일치화 -->
<div class="gw-search-panel attn-width">
    <form id="calcForm" onsubmit="return false;" class="gw-search-form" style="gap: 10px;">
        <i class="fa-solid fa-calendar-week" style="color: var(--sub-text); margin-right: 4px;"></i>
        <input type="date" id="startDate" value="${startDate}" class="gw-form-select" style="width: 160px;" onchange="fetchData()">
        <span style="color: var(--sub-text); font-weight: bold;">~</span>
        <input type="date" id="endDate" value="${endDate}" class="gw-form-select" style="width: 160px;" onchange="fetchData()">
    </form>
</div>

<!-- 리스트 패널 레이아웃 적용 및 대시보드 구조 정렬 -->
<div class="gw-list-panel attn-width" style="padding: 40px;">
    <div style="display: flex; gap: 60px; align-items: center; flex-wrap: wrap;">
        
        <!-- 원형 차트 영역 -->
        <div class="circle-graph" id="workGraph" style="--percent: 0;">
            <div class="inner-circle">
                <span id="totalTime">${empty totalWorkTime ? 0 : totalWorkTime}</span>
                <span>누적 근무시간</span>
            </div>
        </div>

        <!-- 우측 텍스트 정보 스코어 보드 박스 -->
        <div style="display: flex; flex-direction: column; gap: 16px;">
            
            <div class="calc-info-card">
                <i class="fa-solid fa-business-time" style="color: var(--main-color);"></i>
                <div class="card-content">
                    <span class="card-label">기간 내 누적 근무시간</span>
                    <span class="card-value"><strong id="totalWorkTimeDisplay" style="color: var(--main-color);">${empty totalWorkTime ? 0 : totalWorkTime}</strong> 시간</span>
                </div>
            </div>

            <div class="calc-info-card">
                <i class="fa-solid fa-umbrella-beach" style="color: var(--warning-color);"></i>
                <div class="card-content">
                    <span class="card-label">현재 잔여 연차일수</span>
                    <span class="card-value"><strong style="color: var(--warning-color);">${empty vacInfo ? 0 : vacInfo.VAC_CNT}</strong> 일</span>
                </div>
            </div>
            
        </div>
    </div>

    <!-- 하단 하이라이트 문구 안내 영역 -->
    <div style="margin-top: 40px; padding-top: 20px; border-top: 1px dashed var(--card-border); font-size: 13px; line-height: 1.6; color: var(--sub-text);">
        <i class="fa-solid fa-circle-info" style="margin-right: 4px; color: var(--main-color);"></i> 
        근무제 기준: <strong>주 ${empty maxHours ? 40 : maxHours}시간</strong> (일 평일 기준 8시간 기본 계산)<br>
        <i class="fa-solid fa-chart-pie" style="margin-right: 4px; color: var(--main-color);"></i> 
        현재 설정된 평일(월~금) 기준 총 소요 기준 시간: <span id="infoMaxHours" style="font-weight: bold; color: #111;">0</span>시간 대비 현재 달성률을 나타냅니다.
    </div>
</div>

<script>
    const WEEKLY_MAX_HOURS = ${empty maxHours ? 40 : maxHours};

    window.onload = function() {
        calculateAndGraph(${empty totalWorkTime ? 0 : totalWorkTime});
    };

    function fetchData() {
        const startStr = document.getElementById("startDate").value;
        const endStr = document.getElementById("endDate").value;
        if(!startStr || !endStr) return;

        fetch('/attn/calculator/data?startDate=' + startStr + '&endDate=' + endStr)
        .then(response => response.json())
        .then(data => {
            document.getElementById("totalTime").innerText = data;
            document.getElementById("totalWorkTimeDisplay").innerText = data;
            calculateAndGraph(data);
        })
        .catch(error => console.error("오류:", error));
    }

    function calculateAndGraph(currentHours) {
        const start = new Date(document.getElementById("startDate").value);
        const end = new Date(document.getElementById("endDate").value);
        
        // 1. 평일(월~금) 일수 계산
        let weekdays = 0;
        let cur = new Date(start);
        while (cur <= end) {
            const day = cur.getDay(); // 0:일, 6:토
            if (day !== 0 && day !== 6) weekdays++;
            cur.setDate(cur.getDate() + 1);
        }
        
        // 2. 기준 시간 계산 (주 5일 기준, 하루 8시간 = 주 40시간 가정)
        const dailyStandard = WEEKLY_MAX_HOURS / 5;
        const dynamicMaxHours = weekdays * dailyStandard;
        
        // 3. UI 업데이트
        document.getElementById("infoMaxHours").innerText = dynamicMaxHours.toFixed(1);
        
        // 4. 그래프 퍼센트 계산
        let percent = (currentHours / dynamicMaxHours) * 100;
        if (percent > 100) percent = 100;
        if (percent < 0 || dynamicMaxHours === 0) percent = 0;
        
        document.getElementById("workGraph").style.setProperty('--percent', percent);
    }
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>