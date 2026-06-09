<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/attn_side_home.jsp"></jsp:include>

<style>
    .circle-graph {
        width: 250px; height: 250px; border-radius: 50%;
        background: conic-gradient(#d32f2f calc(var(--percent) * 1%), #eee 0);
        display: flex; align-items: center; justify-content: center;
        transition: background 0.5s ease;
    }
    .inner-circle {
        width: 200px; height: 200px; border-radius: 50%; background: white;
        display: flex; flex-direction: column; align-items: center; justify-content: center;
        font-weight: bold; font-size: 20px;
    }
</style>

<div class="attn-content-body" style="flex-grow: 1; padding: 40px; font-family: 'Malgun Gothic', sans-serif;">
    <div style="border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 30px;">
        <h1 style="margin: 0; font-size: 28px;">근태 기록 계산기</h1>
    </div>

    <div style="margin-bottom: 40px; display: flex; align-items: center; gap: 10px;">
        <input type="date" id="startDate" value="${startDate}" onchange="fetchData()"
               style="padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
        <span>~</span>
        <input type="date" id="endDate" value="${endDate}" onchange="fetchData()"
               style="padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
    </div>

    <div style="display: flex; gap: 50px; align-items: center;">
        <div class="circle-graph" id="workGraph" style="--percent: 0;">
            <div class="inner-circle">
                <span id="totalTime">${empty totalWorkTime ? 0 : totalWorkTime}</span> 시간
            </div>
        </div>

        <div style="display: flex; flex-direction: column; gap: 20px;">
            <div style="padding: 15px 30px; border: 1px solid #ddd; border-radius: 8px; font-size: 18px;">
                누적 근무시간 : <strong id="totalWorkTimeDisplay" style="color: #d32f2f;">${empty totalWorkTime ? 0 : totalWorkTime}</strong> 시간
            </div>
            <div style="padding: 15px 30px; border: 1px solid #ddd; border-radius: 8px; font-size: 18px;">
                잔여 연차일수: <strong style="color: #2e7d32;">${empty vacInfo ? 0 : vacInfo.VAC_CNT}</strong> 일
            </div>
        </div>
    </div>

    <div style="margin-top: 50px; font-weight: bold; color: #555;">
        * 근무제 기준: 주 ${empty maxHours ? 40 : maxHours}시간 (일 8시간 기준)
        <br>
        * 현재 설정 기간(평일 기준) 총 기준 시간: <span id="infoMaxHours">0</span>시간 대비 달성률
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
        // 만약 주 52시간제라면 하루 10.4시간으로 계산됩니다.
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

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>