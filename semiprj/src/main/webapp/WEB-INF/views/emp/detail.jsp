<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* ===== image.jpg 기반 마이페이지/정보조회 레이아웃 완벽 동기화 ===== */
.mypage-layout {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 30px;
    align-items: start;
    margin-top: 20px;
}

/* 좌측 사이드바 프로필 카드 */
.profile-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 35px 24px 24px 24px;
    text-align: center;
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.02);
}

.profile-avatar-wrap {
    position: relative;
    width: 130px;
    height: 130px;
    margin: 0 auto 20px auto;
}

.profile-avatar-wrap img {
    width: 130px;
    height: 130px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid #e2e8f0;
    background: #f8fafc;
}

.profile-name {
    font-size: 22px;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 8px;
}

.profile-no {
    display: inline-block;
    padding: 3px 12px;
    border-radius: 999px;
    background: #eff6ff;
    color: #2563eb;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 8px;
}

.profile-position {
    color: #64748b;
    font-size: 14px;
    font-weight: 500;
}

.profile-divider {
    border: none;
    border-top: 1px solid #f1f5f9;
    margin: 24px 0;
}

/* 좌측 상태 리스트 & 배지 */
.profile-status-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    font-size: 14px;
    color: #334155;
    font-weight: 500;
}

.profile-status-item i {
    margin-right: 8px;
    color: #1e293b;
    font-size: 15px;
}

.status-badge {
    padding: 4px 12px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
}

.status-badge.success {
    background: #fee2e2; /* 이미지 기준 미인증인 붉은 계열 톤 매칭 가능 */
    color: #ef4444;
}

.status-badge.verified {
    background: #dcfce7;
    color: #15803d;
}

.status-badge.waiting {
    background: #fef3c7;
    color: #d97706;
}

.profile-notice {
    font-size: 12px;
    color: #94a3b8;
    line-height: 1.6;
    margin-top: 20px;
}

/* 우측 상세 정보 판넬 */
.info-content-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 32px;
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.02);
}

.section-title {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 18px;
    font-weight: 700;
    color: #2563eb;
    margin-bottom: 24px;
}

/* 테이블 서식 (image.jpg 조회 전용 텍스트 스타일 변환) */
.info-table {
    width: 100%;
    border-collapse: collapse;
}

.info-table tr {
    border-bottom: 1px solid #f1f5f9;
}

.info-table tr:last-child {
    border-bottom: none;
}

.info-table th {
    width: 150px;
    text-align: left;
    padding: 18px 12px;
    font-size: 14px;
    font-weight: 700;
    color: #334155;
}

.info-table td {
    padding: 18px 12px;
    font-size: 14px;
    color: #1e293b;
    font-weight: 500;
}

/* 하단 버튼 바 */
.bottom-btn-row {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-top: 35px;
    margin-bottom: 50px;
}
</style>

<div class="pds-width">

    <!-- 페이지 헤더 -->
    <div class="gw-page-head">
        <div class="gw-breadcrumb">홈 &gt; 직원목록 &gt; 직원정보</div>
        <h1>직원 상세정보</h1>
        <p>직원의 상세 프로필을 볼 수 있습니다.</p>
    </div>

    <!-- 2열 그리드 레이아웃 구조 시작 -->
    <div class="mypage-layout">
        
        <!-- [좌측 영역] 프로필 요약 카드 -->
        <div class="profile-card">
            <div class="profile-avatar-wrap">
                <img src="/emp/profile?empNo=${empDto.empNo}" alt="${empDto.empName} 프로필 사진">
            </div>
            
            <div class="profile-name">${empDto.empName} 님</div>
            <div class="profile-no"># ${empDto.empNo}</div>
            <div class="profile-position">${empDto.empPosition} <span>|</span> ${deptDto.deptName}</div>
            
            <hr class="profile-divider">
            
            <div class="profile-status-list">
                <!-- 이메일 인증 상태 -->
                <div class="profile-status-item">
                    <span><i class="fa-regular fa-envelope"></i>이메일 인증</span>
                    <c:choose>
                        <c:when test="${empDto.empEmailVerified == 'Y'}">
                            <span class="status-badge verified">인증완료</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge success" style="background:#fee2e2; color:#dc2626;">미인증</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- 계정 상태 -->
                <div class="profile-status-item">
                    <span><i class="fa-solid fa-lock"></i>계정 상태</span>
                    <c:choose>
                        <c:when test="${empDto.empApprovalStatus == 'Y'}">
                            <span class="status-badge verified">승인완료</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge waiting">승인대기중</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <p class="profile-notice">
                관리자 승인 후<br>
                모든 서비스를 이용할 수 있습니다.
            </p>
        </div>

        <!-- [우측 영역] 상세 정보 라인 테이블 -->
        <div class="info-content-card">
            
            <!-- 타이틀 서식 -->
            <div class="section-title">
                <i class="fa-regular fa-user"></i> 기본 정보
            </div>
            
            <table class="info-table">
                <tbody>
                    <tr>
                        <th>사원아이디</th>
                        <td>${empDto.empId}</td>
                    </tr>
                    <tr>
                        <th>부서</th>
                        <td>${deptDto.deptName}</td>
                    </tr>
                    <tr>
                        <th>직위</th>
                        <td>${empDto.empPosition}</td>
                    </tr>
                    <tr>
                        <th>담당사수</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty empDto.empMentor}">
                                    ${empDto.empMentor}
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #cbd5e1;">-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>생년월일</th>
                        <td>${empDto.empBirth}</td>
                    </tr>
                    <tr>
                        <th>입사일</th>
                        <td>
                            <fmt:formatDate value="${empDto.empHireDate}" pattern="yyyy-MM-dd"/>
                        </td>
                    </tr>
                </tbody>
            </table>
            
        </div>
        
    </div><!-- /mypage-layout -->

    <!-- 하단 버튼 영역 -->
    <div class="bottom-btn-row">
        <c:if test="${sessionScope.loginNo == empDto.empNo}">
            <a href="./edit?empNo=${empDto.empNo}" class="gw-btn-primary">
                <i class="fa-solid fa-user-pen"></i>내정보 수정
            </a>
        </c:if>

        <a href="./list" class="gw-btn-outline">
            <i class="fa-solid fa-list"></i>목록으로
        </a>
        <a href="javascript:history.back();" class="gw-btn-outline">
            <i class="fa-solid fa-arrow-left"></i>뒤로가기
        </a>
    </div>

</div><!-- /pds-width -->

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>