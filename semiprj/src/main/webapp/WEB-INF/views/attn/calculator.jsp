<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/attn_side_home.jsp"></jsp:include>

<style>
    /* 원형 그래프 스타일 */
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
        <h1 style="margin: 0; font-size: 28px;">근태 기록</h1>
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
                <span id="totalTime">${totalWorkTime}</span> 시간
            </div>
        </div>

        <div style="display: flex; flex-direction: column; gap: 20px;">
            <div style="padding: 15px 30px; border: 1px solid #ddd; border-radius: 8px; font-size: 18px;">
                누적 근무시간 : <strong id="totalWorkTimeDisplay" style="color: #d32f2f;">${totalWorkTime}</strong> 시간
            </div>
            <div style="padding: 15px 30px; border: 1px solid #ddd; border-radius: 8px; font-size: 18px;">
                잔여 연차일수: <strong style="color: #2e7d32;">${empty vacInfo ? 0 : vacInfo.VAC_CNT}</strong> 일
            </div>
        </div>
    </div>

    <div style="margin-top: 50px; font-weight: bold; color: #555;">
        * 주 52시간 근무제 기준 (현재 수치는 52시간 대비 달성률입니다.)
    </div>
</div>

<script>
// 페이지 로드 시 그래프 초기화
window.onload = function() {
    updateGraph(${totalWorkTime});
};

function fetchData() {
    const start = document.getElementById("startDate").value;
    const end = document.getElementById("endDate").value;
    
    fetch('/attn/calculator/data?startDate=' + start + '&endDate=' + end)
        .then(response => response.json())
        .then(data => {
            // 1. 그래프 안의 숫자 변경
            document.getElementById("totalTime").innerText = data;
            // 2. 바깥의 '누적 근무시간' 텍스트 변경
            document.getElementById("totalWorkTimeDisplay").innerText = data;
            // 3. 그래프 모양 변경
            updateGraph(data);
        })
        .catch(error => console.error("오류:", error));
}

function updateGraph(hours) {
    let percent = (hours / 52) * 100;
    if (percent > 100) percent = 100;
    document.getElementById("workGraph").style.setProperty('--percent', percent);
}
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>