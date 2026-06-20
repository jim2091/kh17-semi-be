<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* ===== 상단 영역: 그리드 안정성 확보 및 높이 대칭화 ===== */
.mypage-layout {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 30px;
    margin-top: 20px;
}

/* 좌측 사이드바 프로필 카드 (우측 높이를 채우되 내부 뭉개짐 방지) */
.profile-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 35px 24px 32px 24px;
    text-align: center;
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.02);
    
    /* 높이를 100%로 설정하여 우측 영역 크기에 맞춤과 동시에 레이아웃 유연성 확보 */
    height: 100%; 
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
}

.profile-avatar-wrap {
    position: relative;
    width: 130px;
    height: 130px;
    margin: 0 auto 20px auto;
    flex-shrink: 0;
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
    flex-shrink: 0;
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
    align-self: center;
    flex-shrink: 0;
}

.profile-position {
    color: #64748b;
    font-size: 14px;
    font-weight: 500;
    flex-shrink: 0;
}

.profile-divider {
    width: 100%;
    border: none;
    border-top: 1px solid #f1f5f9;
    margin: 24px 0;
    flex-shrink: 0;
}

/* 좌측 상태 리스트 & 배지 스타일 (하단 배치 안착) */
.profile-status-list {
    margin-top: auto; /* 우측 높이로 인해 늘어난 빈 공간을 밀어내어 하단 고정 */
    width: 100%;
    flex-shrink: 0;
}

.profile-status-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    font-size: 14px;
    color: #334155;
    font-weight: 500;
}

.profile-status-item:last-child {
    margin-bottom: 0;
}

.profile-status-item i {
    margin-right: 8px;
    color: #475569;
    font-size: 15px;
}

.emp-badge {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    font-size: 12px;
    font-weight: 700;
    padding: 4px 12px;
    border-radius: 999px;
}

.emp-badge-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: currentColor;
    flex-shrink: 0;
}

.emp-badge.active   { background: #dcfce7; color: #15803d; }
.emp-badge.inactive { background: #fee2e2; color: #dc2626; }
.emp-badge.admin    { background: #f3e8ff; color: #7e22ce; }
.emp-badge.staff    { background: #e0f2fe; color: #0369a1; }

/* 우측 상세 정보 콘텐츠 패널 */
.info-content-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 32px;
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.02);
    box-sizing: border-box;
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

/* 테이블 구조 */
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
    padding: 16px 12px;
    font-size: 14px;
    font-weight: 700;
    color: #475569;
}

.info-table td {
    padding: 16px 12px;
    font-size: 14px;
    color: #1e293b;
    font-weight: 500;
}

.info-table td.link {
    color: #2563eb;
    font-weight: 600;
}

/* ===== 하단 영역: 원본 복구 및 안전성 확보 ===== */
.agent-cell {
    max-width: 350px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.emp-time-badge {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    font-size: 13px;
    color: var(--main-color, #2563eb);
    font-weight: 600;
}

.security-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20px;
    background: white;
    border: 1px solid #e8eefc;
    border-radius: 16px;
}

.security-icon {
    width: 50px;
    height: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 50%;
    background: #edf4ff;
    color: var(--main-color);
    font-size: 20px;
}

.security-content {
    flex: 1;
    margin-left: 15px;
}

.security-title {
    font-size: 14px;
    color: #6b7280;
}

.security-value {
    margin-top: 4px;
    font-size: 17px;
    font-weight: 600;
    color: #111827;
}

.center {
    text-align: center;
}
</style>

<div class="pds-width">

    <!-- 페이지 헤더 -->
    <div class="gw-page-head">
        <div class="gw-breadcrumb">관리자 &gt; 사원관리</div>
        <h1>사원 상세정보</h1>
        <p>[ ${empDto.empName} ] 사원의 상세 프로필 정보입니다.</p>
    </div>

    <!-- [상단] 2열 그리드 레이아웃 구조 -->
    <div class="mypage-layout">
        
        <!-- 좌측 영역: 프로필 카드 패널 (우측 높이에 맞춰서 늘어남) -->
        <div class="profile-card">
            <div class="profile-avatar-wrap">
                <img src="/emp/profile?empNo=${empDto.empNo}" alt="${empDto.empName} 프로필 사진">
            </div>
            
            <div class="profile-name">${empDto.empName}</div>
            <div class="profile-no"># ${empDto.empNo}</div>
            <div class="profile-position">${empDto.empPosition} <span>|</span> ${deptDto.deptName}</div>
            
            <hr class="profile-divider">
            
            <!-- 계정 상태창들이 카드가 늘어났을 때 깨지지 않고 하단에 예쁘게 고정됩니다 -->
            <div class="profile-status-list">
                <div class="profile-status-item">
                    <span><i class="fa-solid fa-shield-halved"></i>계정 권한</span>
                    <c:choose>
                        <c:when test="${empDto.empLevel eq '관리자'}">
                            <span class="emp-badge admin">${empDto.empLevel}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="emp-badge staff">${empDto.empLevel}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="profile-status-item">
                    <span><i class="fa-solid fa-toggle-on"></i>활성 여부</span>
                    <c:choose>
                        <c:when test="${empDto.empUseYn eq 'Y'}">
                            <span class="emp-badge active">
                                <span class="emp-badge-dot"></span>활성
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="emp-badge inactive">
                                <span class="emp-badge-dot"></span>비활성
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- 우측 영역: 상세 사원 정보 라인 테이블 패널 (여기가 기준 높이가 됨) -->
        <div class="info-content-card">
            <div class="section-title">
                <i class="fa-regular fa-id-card"></i> 상세 사원 정보
            </div>
            
            <table class="info-table">
                <tbody>
                    <tr>
                        <th>사원실명 / 번호</th>
                        <td>${empDto.empName} (${empDto.empNo})</td>
                    </tr>
                    <tr>
                        <th>부서 / 직위</th>
                        <td>${deptDto.deptName} · ${empDto.empPosition}</td>
                    </tr>
                    <tr>
                        <th>사원아이디</th>
                        <td>${empDto.empId}</td>
                    </tr>
                    <tr>
                        <th>담당사수</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty empDto.empMentor}">
                                    ${empDto.empMentor}
                                </c:when>
                                <c:otherwise>
                                    <span style="color:#cbd5e1;">-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>이메일 주소</th>
                        <td class="link">${empDto.empEmail}</td>
                    </tr>
                    <tr>
                        <th>연락처</th>
                        <td>${empDto.empContact}</td>
                    </tr>
                    <tr>
                        <th>생년월일</th>
                        <td>${empDto.empBirth}</td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td>[${empDto.empPost}] ${empDto.empAddress1} ${empDto.empAddress2}</td>
                    </tr>
                    <tr>
                        <th>입사일자</th>
                        <td><fmt:formatDate value="${empDto.empHireDate}" pattern="yyyy-MM-dd"/></td>
                    </tr>
                    <tr>
                        <th>퇴사일자</th>
                        <td>
                            <c:choose>
                                <c:when test="${not empty empDto.empRetiredDate}">
                                    <span class="emp-badge inactive"><fmt:formatDate value="${empDto.empRetiredDate}" pattern="yyyy-MM-dd"/></span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:#94a3b8;">-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>시스템 등록일</th>
                        <td><fmt:formatDate value="${empDto.empCreateAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    </tr>
                </tbody>
            </table>
        </div>
        
    </div><!-- /mypage-layout 끝 -->


    <!-- [하단] 최근 로그인 이력 (전체 너비 정상 출력) -->
    <div class="gw-card mt-50">
        <div style="display:flex; justify-content:space-between; align-items:center;">
            <div class="gw-table-title">최근 로그인 이력</div>
            <a href="./history?empNo=${empDto.empNo}" class="gw-btn-outline">
                더보기<i class="fa-solid fa-caret-right"></i>
            </a>
        </div>
        
        <table class="gw-table gw-list-panel mt-10">
            <thead>
                <tr>
                    <th style="width:220px;">일시</th>
                    <th style="width:180px;">접속주소</th>
                    <th>에이전트</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty loginHistory}">
                        <c:forEach var="empHistoryDto" items="${loginHistory}">
                            <tr>
                                <td>
                                    <span class="emp-time-badge">
                                        <i class="fa-regular fa-clock"></i>
                                        ${empHistoryDto.empHistoryTime}
                                    </span>
                                </td>
                                <td>${empHistoryDto.empHistoryAddress}</td>
                                <td class="agent-cell" style="color:#666;">${empHistoryDto.empHistoryAgent}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="3" style="text-align:center; padding: 30px 0; color:#999;">
                                <i class="fa-solid fa-clock-rotate-left" style="font-size:20px; margin-bottom:8px; display:block;"></i>
                                로그인 이력이 없습니다.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>


    <!-- [하단] 비밀번호 변경일 카드 (전체 너비 정상 출력) -->
    <div class="security-card mt-50">
        <div class="security-icon">
            <i class="fa-solid fa-lock"></i>
        </div>
        
        <div class="security-content">
            <div class="security-title">비밀번호 변경일</div>
            <div class="security-value">${empDto.empPwChange}</div>
        </div>
    </div>


    <!-- [최하단] 제어 버튼 -->
    <div class="center mt-50 mb-50">
        <a href="./edit?empNo=${empDto.empNo}" class="gw-btn-primary">
            <i class="fa-solid fa-user-pen"></i>사원정보 수정
        </a>
        <a href="./list" class="gw-btn-outline">
            <i class="fa-solid fa-list"></i>목록으로
        </a>
        <a href="javascript:history.back();" class="gw-btn-outline">
            <i class="fa-solid fa-arrow-left"></i>뒤로가기
        </a>
    </div>

</div><!-- /pds-width -->

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>