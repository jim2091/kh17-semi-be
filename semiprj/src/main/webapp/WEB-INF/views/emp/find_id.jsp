<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.find-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 70vh;
    padding: 20px;
}

.find-card {
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
    width: 100%;
    max-width: 460px;
    padding: 30px;
}

.find-header {
    text-align: center;
    margin-bottom: 25px;
}

.find-header h1 {
    font-size: 26px;
    font-weight: 800;
    margin-bottom: 10px;
    color: #1f2937;
}

.find-header p {
    font-size: 14px;
    color: #6b7280;
    line-height: 1.4;
}

.input-group {
    position: relative;
    margin-bottom: 15px;
}

.input-group i {
    position: absolute;
    left: 14px;
    top: 24px; /* 에러 메시지 공간 확보로 인한 아이콘 위치 조정 */
    transform: translateY(-50%);
    color: #9ca3af;
    font-size: 16px;
}

.find-field {
    width: 100%;
    padding: 12px 14px 12px 42px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    font-size: 15px;
    outline: none;
    transition: all 0.2s ease-in-out;
    box-sizing: border-box;
}

.find-field:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

/* 못생긴 팝업 대신 들어갈 예쁜 경고 메시지 */
.field-error-msg {
    color: #ef4444;
    font-size: 12px;
    margin-top: 4px;
    padding-left: 4px;
    text-align: left;
    min-height: 18px;
}

.find-field.is-invalid {
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

.btn-group {
    display: flex;
    gap: 10px;
    width: 100%;
}

.btn-group a, .btn-group button {
    flex: 1;
    padding: 13px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    box-sizing: border-box;
    border: none;
}

.btn-link-back {
    background-color: #f3f4f6;
    color: #4b5563;
    border: 1px solid #e5e7eb !important;
}

.btn-link-back:hover {
    background-color: #e5e7eb;
}
</style>

<div class="find-wrapper">
    <div class="find-card">
        
        <div class="find-header">
            <h1><i class="fa-solid fa-address-card" style="color: #3b82f6; margin-right: 6px;"></i>아이디 찾기</h1>
            <p>아래 정보를 입력하시면<br>인증번호를 메일로 발송해드립니다.</p>
        </div>

        <form id="findIdForm" action="./find_id" method="post" autocomplete="off">
            <!-- 이름 입력 -->
            <div class="input-group">
                <i class="fa-solid fa-user-tag"></i>
                <input type="text" id="empName" name="empName" placeholder="사원명 입력" class="find-field">
                <div id="nameError" class="field-error-msg"></div>
            </div>
            
            <!-- 이메일 입력 -->
            <div class="input-group">
                <i class="fa-solid fa-envelope"></i>
                <input type="email" id="empEmail" name="empEmail" placeholder="등록된 이메일 주소 입력" class="find-field">
                <div id="emailError" class="field-error-msg"></div>
            </div>

            <!-- 서버 에러 메시지 -->
            <div class="error-box">
                <c:if test="${param.error != null}">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right: 4px;"></i> 입력한 정보가 일치하지 않습니다.
                </c:if>
            </div>

            <div class="btn-group">
                <a href="./login" class="btn-link-back">로그인 페이지</a>
                <button type="submit" class="gw-btn-primary" style="background-color: #3b82f6; color: white;">다음 단계 <i class="fa-solid fa-chevron-right" style="font-size: 11px; margin-left: 2px;"></i></button>
            </div>
        </form>

    </div>
</div>

<script>
$(function(){
    var savedTheme = localStorage.getItem("gwTheme") || "theme-blue";
    $("body").addClass(savedTheme);

    // 폼 전송 이벤트 제어
    $("#findIdForm").submit(function(e) {
        let isValid = true;
        const empName = $("#empName").val().trim();
        const empEmail = $("#empEmail").val().trim();

        if (empName === "") {
            $("#empName").addClass("is-invalid");
            $("#nameError").text("사원명을 입력해 주세요.");
            isValid = false;
        }

        if (empEmail === "") {
            $("#empEmail").addClass("is-invalid");
            $("#emailError").text("이메일 주소를 입력해 주세요.");
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault(); // 전송 막기
        }
    });

    // 사용자가 입력 칸에 타이핑을 시작하면 실시간으로 에러 삭제
    $(".find-field").on("input", function() {
        if ($(this).val().trim() !== "") {
            $(this).removeClass("is-invalid");
            $(this).next(".field-error-msg").text("");
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>