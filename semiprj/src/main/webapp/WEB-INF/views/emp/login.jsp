<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* 대시보드 카드 감성을 로그인 폼에 그대로 주입 */
.login-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 70vh;
    padding: 20px;
}

.login-card {
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
    width: 100%;
    max-width: 420px;
    padding: 30px;
}

.login-header {
    text-align: center;
    margin-bottom: 30px;
}

.login-header h1 {
    font-size: 28px;
    font-weight: 800;
    margin-bottom: 8px;
    color: #1f2937;
}

.login-header p {
    font-size: 14px;
    color: #6b7280;
}

.input-group {
    position: relative;
    margin-bottom: 15px; /* 에러 메시지 간격 최적화 */
}

.input-group i {
    position: absolute;
    left: 14px;
    top: 24px; /* 에러 메시지 공간 확보로 인한 아이콘 중심 위치 고정 */
    transform: translateY(-50%);
    color: #9ca3af;
    font-size: 16px;
}

.login-field {
    width: 100%;
    padding: 12px 14px 12px 42px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    font-size: 15px;
    outline: none;
    transition: all 0.2s ease-in-out;
    box-sizing: border-box;
}

/* 포커스 시 대시보드 테마 컬러와 연동될 수 있도록 유도 */
.login-field:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

/* 커스텀 경고 메시지 스타일 */
.field-error-msg {
    color: #ef4444;
    font-size: 12px;
    margin-top: 4px;
    padding-left: 4px;
    text-align: left;
    min-height: 18px;
}

.login-field.is-invalid {
    border-color: #ef4444 !important;
    box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.15) !important;
}

.error-box {
    min-height: 24px;
    color: #ef4444;
    font-size: 14px;
    text-align: center;
    margin-bottom: 15px;
    font-weight: 500;
}

.login-links {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 25px;
    border-top: 1px solid #f3f4f6;
    padding-top: 20px;
    text-align: center;
}

.login-link-item {
    font-size: 13px;
    color: #6b7280;
    text-decoration: none;
    transition: color 0.2s;
}

.login-link-item:hover {
    color: #3b82f6;
    text-decoration: underline;
}
</style>

<div class="login-wrapper">
    <div class="login-card">
        
        <div class="login-header">
            <h1>WELCOME</h1>
            <p>KH 그룹웨어</p>
        </div>

        <form id="loginForm" action="./login" method="post" autocomplete="off">
            <div class="input-group">
                <i class="fa-solid fa-user"></i>
                <input type="text" id="empId" name="empId" placeholder="사원 아이디(ID)" class="login-field">
                <div id="idError" class="field-error-msg"></div>
            </div>
            
            <div class="input-group">
                <i class="fa-solid fa-lock"></i>
                <input type="password" id="empPw" name="empPw" placeholder="비밀번호(PW)" class="login-field">
                <div id="pwError" class="field-error-msg"></div>
            </div>

            <div class="error-box">
                <c:if test="${param.error != null}">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right: 4px;"></i> 입력한 정보가 일치하지 않습니다.
                </c:if>
            </div>

            <button type="submit" class="gw-btn-primary" 
                    style="width: 100%; padding: 14px; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; border: none; background-color: #3b82f6; color: white;">
                로그인하기
            </button>
        </form>

        <div class="login-links">
            <a href="./find_id" class="login-link-item">
                <i class="fa-solid fa-magnifying-glass" style="margin-right: 4px;"></i> 아이디가 기억나지 않으십니까?
            </a>
            <a href="./find_pw" class="login-link-item">
                <i class="fa-solid fa-key" style="margin-right: 4px;"></i> 비밀번호가 기억나지 않으십니까?
            </a>
        </div>

    </div>
</div>

<script>
$(function(){
    // 대시보드 메인 홈의 테마 동기화 유지
    var savedTheme = localStorage.getItem("gwTheme") || "theme-blue";
    $("body").addClass(savedTheme);

    // 폼 전송 시 프론트엔드 유효성 검사 진행
    $("#loginForm").submit(function(e) {
        let isValid = true;
        const empId = $("#empId").val().trim();
        const empPw = $("#empPw").val().trim();

        // 아이디 누락 체크
        if (empId === "") {
            $("#empId").addClass("is-invalid");
            $("#idError").text("아이디를 입력해 주세요.");
            isValid = false;
        }

        // 비밀번호 누락 체크
        if (empPw === "") {
            $("#empPw").addClass("is-invalid");
            $("#pwError").text("비밀번호를 입력해 주세요.");
            isValid = false;
        }

        // 유효하지 않으면 서버 서브밋 전송 블로킹
        if (!isValid) {
            e.preventDefault();
        }
    });

    // 사용자가 값을 입력하기 시작하면 경고 스타일과 문구를 즉시 지워주는 인터랙션
    $(".login-field").on("input", function() {
        if ($(this).val().trim() !== "") {
            $(this).removeClass("is-invalid");
            $(this).next(".field-error-msg").text("");
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>