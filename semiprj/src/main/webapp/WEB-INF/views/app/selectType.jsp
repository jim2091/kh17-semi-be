<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
.select-container {
    max-width: 1100px;
    margin: 40px auto;
    padding: 0 20px;
}

.page-header {
    margin-bottom: 35px;
    border-bottom: 1px solid #e2e8f0;
    padding-bottom: 20px;
}

.page-header h1 {
    font-size: 26px;
    font-weight: 700;
    color: #1e293b;
}

.page-header p {
    font-size: 14px;
    color: #64748b;
    margin-top: 5px;
}

.card-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 25px;
}

.type-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 30px 20px;
    text-align: center;
    text-decoration: none;
    transition: all 0.25s ease-in-out;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
    display: flex;
    flex-direction: column;
    align-items: center;
}

.type-card:hover {
    transform: translateY(-5px);
    border-color: var(--main-color, #22c55e);
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.icon-wrapper {
    width: 70px;
    height: 70px;
    border-radius: 50px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 30px;
    margin-bottom: 20px;
    transition: all 0.2s;
}

/* 카드별 고유 시각 테마 배정 */
.card-vac .icon-wrapper { background: #eff6ff; color: #2563eb; }
.card-report .icon-wrapper { background: #fef2f2; color: #dc2626; }
.card-draft .icon-wrapper { background: #f0fdf4; color: #16a34a; }

.type-card h3 {
    font-size: 18px;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 10px;
}

.type-card p {
    font-size: 13px;
    color: #64748b;
    line-height: 1.5;
    margin-bottom: 20px;
    flex-grow: 1;
}

.btn-select {
    width: 100%;
    padding: 10px 0;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 600;
    background: #f1f5f9;
    color: #334155;
    transition: all 0.2s;
}

.type-card:hover .btn-select {
    background: var(--main-color, #22c55e);
    color: #ffffff;
}
</style>

<div class="select-container">
    <div class="page-header">
        <div style="font-size: 13px; color: #94a3b8; font-weight: 500; margin-bottom: 5px;">전자결재 > 기안 작성</div>
        <h1>결재 양식 선택</h1>
        <p>작성하고자 하는 결재 문서의 종류를 선택해 주세요.</p>
    </div>

    <div class="card-grid">
        <a href="/app/vacInsert" class="type-card card-vac">
            <div class="icon-wrapper">
                <i class="fa-solid fa-calendar-minus"></i>
            </div>
            <h3>휴가신청서</h3>
            <p>연차, 월차, 병가 및 기타 휴가를 신청할 때 사용하는 표준 양식입니다.</p>
            <div class="btn-select">기안문 작성</div>
        </a>

        <a href="/app/expInsert" class="type-card card-report">
            <div class="icon-wrapper">
                <i class="fa-solid fa-file-invoice-dollar"></i>
            </div>
            <h3>품의서</h3>
            <p>물품 구매, 비용 집행 등 예산 사용 승인이 필요할 때 작성하는 양식입니다.</p>
            <div class="btn-select">기안문 작성</div>
        </a>

        <a href="/app/dftInsert" class="type-card card-draft">
            <div class="icon-wrapper">
                <i class="fa-solid fa-file-lines"></i>
            </div>
            <h3>업무기안서</h3>
            <p>일반적인 업무 제안, 보고, 협조 요청을 상신할 때 사용하는 기본 양식입니다.</p>
            <div class="btn-select">기안문 작성</div>
        </a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>