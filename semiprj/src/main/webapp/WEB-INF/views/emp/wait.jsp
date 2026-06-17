<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.wait-container {
    max-width: 700px;
    margin: 60px auto;
}

.wait-card {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 24px;
    padding: 50px;
    text-align: center;
    box-shadow: 0 10px 30px rgba(15,23,42,0.05);
}

.wait-icon {
    width: 90px;
    height: 90px;
    margin: 0 auto 24px;
    border-radius: 50%;
    background: #eef4ff;
    color: #2563eb;
    font-size: 38px;

    display: flex;
    align-items: center;
    justify-content: center;
}

.wait-card h2 {
    font-size: 28px;
    margin-bottom: 15px;
    color: #111827;
}

.wait-desc {
    color: #6b7280;
    line-height: 1.7;
    margin-bottom: 35px;
}

.wait-check-list {
    display: flex;
    flex-direction: column;
    gap: 14px;
    margin-bottom: 35px;
}

.wait-check {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;

    padding: 14px;
    border-radius: 12px;
    font-weight: 600;
}

.wait-check.success {
    background: #ecfdf5;
    color: #059669;
}

.wait-check.pending {
    background: #fff7ed;
    color: #ea580c;
}

.wait-message {
    color: #64748b;
    margin-bottom: 25px;
}
</style>

<div class="gw-page-head" style="width:700px; margin:0 auto;">
    <div class="gw-breadcrumb">홈 / 계정 승인 대기</div>
    <h1>계정 승인 대기</h1>
    <p>${loginUser.empName} 님의 계정은 현재 승인 대기 상태입니다.</p>
</div>

<div class="wait-container">
    <div class="wait-card">
        <div class="wait-icon">
            <i class="fa-solid fa-user-clock"></i>
        </div>
        
        <h2>계정 승인 대기중</h2>

        <p class="wait-desc">
            정보 입력 및 이메일 인증이 완료되었습니다.<br>
            관리자의 승인 후 그룹웨어를 이용할 수 있습니다.
        </p>

        <div class="wait-check-list">

            <div class="wait-check success">
                <i class="fa-solid fa-circle-check"></i>
                정보 입력 완료
            </div>

            <div class="wait-check success">
                <i class="fa-solid fa-circle-check"></i>
                이메일 인증 완료
            </div>

            <div class="wait-check pending">
                <i class="fa-solid fa-hourglass-half"></i>
                관리자 승인 대기
            </div>

        </div>

        <div class="wait-message">
            승인 후 모든 그룹웨어 서비스를 이용할 수 있습니다.
        </div>

        <div class="wait-buttons">
            <a href="${pageContext.request.contextPath}/emp/logout"
               class="gw-btn-negative">
                로그아웃
            </a>
        </div>

    </div>

</div>