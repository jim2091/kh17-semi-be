<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"/>

<style>
/* 집에서 작업한 세련된 디자인 스타일 유지 */
.login-wrap {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    background: linear-gradient(135deg, var(--main-bg-start), var(--main-bg-end));
    align-items: flex-start;
    padding-top: 60px;
}

.login-card {
    width: 600px;
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 24px;
    box-shadow: 0 20px 60px var(--card-shadow);
    padding: 48px 40px;
}

.login-logo {
    text-align: center;
    margin-bottom: 32px;
}

.login-logo .logo-icon {
    width: 60px;
    height: 60px;
    border-radius: 18px;
    background: linear-gradient(135deg, var(--main-color), var(--main-mid));
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 26px;
    color: white;
    margin-bottom: 14px;
    box-shadow: 0 8px 20px var(--sidebar-active-shadow);
}

.login-logo h1 {
    margin: 0 0 6px;
    font-size: 22px;
    font-weight: 900;
    color: var(--card-title-color);
}

.login-logo p {
    margin: 0;
    font-size: 14px;
    color: var(--sub-text);
}

.login-field-wrap {
    margin-bottom: 16px;
}

.login-field-label {
    display: block;
    font-size: 13px;
    font-weight: 800;
    color: var(--card-title-color);
    margin-bottom: 8px;
}

.login-field {
    width: 100%;
    height: 48px;
    border: 1px solid var(--border-color);
    border-radius: 12px;
    padding: 0 16px 0 44px;
    font-size: 15px;
    background: var(--input-bg);
    color: var(--input-text);
    outline: none;
    transition: border-color .18s, box-shadow .18s;
    box-sizing: border-box;
}

.login-field:focus {
    border-color: var(--main-color);
    box-shadow: 0 0 0 3px var(--main-light);
}

.login-field-icon {
    position: relative;
}

.login-field-icon i {
    position: absolute;
    left: 16px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--sub-text);
    font-size: 15px;
}

/* 학원의 실시간 유효성 검사 에러 스타일 추가 */
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

.login-error {
    background: #fef2f2;
    border: 1px solid #fecaca;
    border-radius: 10px;
    padding: 10px 14px;
    color: var(--danger-color);
    font-size: 13px;
    font-weight: 700;
    margin-bottom: 16px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.login-btn {
    width: 100%;
    height: 50px;
    border: none;
    border-radius: 14px;
    background: linear-gradient(135deg, var(--main-color), var(--main-mid));
    color: white;
    font-size: 16px;
    font-weight: 800;
    cursor: pointer;
    box-shadow: 0 8px 18px var(--sidebar-active-shadow);
    transition: transform .18s, box-shadow .18s;
    margin-top: 8px;
}

.login-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 12px 24px var(--sidebar-active-shadow);
}

.login-links {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 24px;
    border-top: 1px solid var(--border-color);
    padding-top: 20px;
}

.login-links a {
    font-size: 13px;
    color: var(--sub-text);
    font-weight: 700;
    text-decoration: none;
    transition: color .18s;
}

.login-links a:hover {
    color: var(--main-color);
}
</style>

<div class="login-wrap">
    <div class="login-card">

        <div class="login-logo">
            <div class="logo-icon">
                <i class="fa-solid fa-building"></i>
            </div>
            <h1>KH 그룹웨어</h1>
            <p>업무 포털에 오신 것을 환영합니다</p>
        </div>

        <form id="loginForm" action="./login" method="post" autocomplete="off">

            <c:if test="${param.error != null}">
                <div class="login-error">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    아이디 또는 비밀번호가 일치하지 않습니다.
                </div>
            </c:if>

            <div class="login-field-wrap">
                <label class="login-field-label">아이디</label>
                <div class="login-field-icon">
                    <i class="fa-solid fa-user"></i>
                    <input type="text" id="empId" name="empId" required
                           class="login-field"
                           placeholder="사원 아이디(ID)">
                </div>
                <div id="idError" class="field-error-msg"></div>
            </div>

            <div class="login-field-wrap">
                <label class="login-field-label">비밀번호</label>
                <div class="login-field-icon">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" id="empPw" name="empPw" required
                           class="login-field"
                           placeholder="비밀번호(PW)">
                </div>
                <div id="pwError" class="field-error-msg"></div>
            </div>

            <button type="submit" class="login-btn">
                <i class="fa-solid fa-right-to-bracket"></i>
                로그인하기
            </button>

        </form>

        <div class="login-links">
            <a href="./find_id"><i class="fa-solid fa-magnifying-glass" style="margin-right: 4px;"></i>아이디 찾기</a>
            <span class="login-divider" style="color: var(--border-color)">|</span>
            <a href="./find_pw"><i class="fa-solid fa-key" style="margin-right: 4px;"></i>비밀번호 찾기</a>
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

<jsp:include page="/WEB-INF/views/template/footer2.jsp"/>