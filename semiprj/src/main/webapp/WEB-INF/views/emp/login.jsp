<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"/>

<style>
.login-wrap {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    background: linear-gradient(135deg, var(--main-bg-start), var(--main-bg-end));
    align-items: flex-start;
    padding-top: 60px; /* 위 여백 조절 */
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
    margin-top: 20px;
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

.login-divider {
    color: var(--border-color);
}
</style>

<div class="login-wrap">
    <div class="login-card ">

        <!-- 로고 -->
        <div class="login-logo">
            <div class="logo-icon">
                <i class="fa-solid fa-building"></i>
            </div>
            <h1>KH 그룹웨어</h1>
            <p>업무 포털에 오신 것을 환영합니다</p>
        </div>

        <!-- 로그인 폼 -->
        <form action="./login" method="post" autocomplete="off">

            <!-- 에러 메시지 -->
            <c:if test="${param.error != null}">
                <div class="login-error">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    아이디 또는 비밀번호가 일치하지 않습니다.
                </div>
            </c:if>

            <!-- 아이디 -->
            <div class="login-field-wrap">
                <label class="login-field-label">아이디</label>
                <div class="login-field-icon">
                    <i class="fa-solid fa-user"></i>
                    <input type="text" name="empId" required
                           class="login-field"
                           placeholder="아이디를 입력하세요">
                </div>
            </div>

            <!-- 비밀번호 -->
            <div class="login-field-wrap">
                <label class="login-field-label">비밀번호</label>
                <div class="login-field-icon">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" name="empPw" required
                           class="login-field"
                           placeholder="비밀번호를 입력하세요">
                </div>
            </div>

            <!-- 로그인 버튼 -->
            <button type="submit" class="login-btn">
                <i class="fa-solid fa-right-to-bracket"></i>
                로그인
            </button>

        </form>

        <!-- 하단 링크 -->
        <div class="login-links">
            <a href="./find_id">아이디 찾기</a>
            <span class="login-divider">|</span>
            <a href="./find_pw">비밀번호 찾기</a>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"/>