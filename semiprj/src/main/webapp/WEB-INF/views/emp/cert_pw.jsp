<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.page-wrap {
    min-height: calc(100vh - 76px);
    background: linear-gradient(180deg, var(--main-bg-start) 0%, var(--main-bg-end) 100%);
    display: flex;
    align-items: flex-start;
    justify-content: center;
    padding: 40px 16px 60px;
}

.cert-card {
    width: 100%;
    max-width: 560px;
    background: var(--card-bg);
    border: 1px solid var(--card-border);
    border-radius: 20px;
    box-shadow: 0 8px 32px var(--card-shadow);
    overflow: hidden;
}

.cert-card-header {
    background: linear-gradient(135deg, var(--main-color), var(--main-mid));
    padding: 32px 36px 28px;
    color: #fff;
}

.cert-card-header .gw-breadcrumb {
    font-size: 12px;
    font-weight: 700;
    opacity: 0.75;
    letter-spacing: 0.03em;
    margin-bottom: 10px;
    color: #bfdbfe;
}

.cert-card-header h1 {
    font-size: 24px;
    font-weight: 900;
    letter-spacing: -0.03em;
    margin-bottom: 6px;
    color: #fff;
}

.cert-card-header p {
    font-size: 14px;
    color: #bfdbfe;
    font-weight: 500;
}

.cert-card-body {
    padding: 32px 36px 36px;
}

.cert-email-row {
    display: flex;
    align-items: center;
    gap: 10px;
    background: var(--main-light);
    border: 1px solid var(--main-soft);
    border-radius: 12px;
    padding: 12px 16px;
    margin-bottom: 28px;
    color: var(--main-color);
    font-size: 14px;
    font-weight: 700;
}

.cert-label {
    display: block;
    color: var(--card-title-color);
    font-size: 15px;
    font-weight: 900;
    margin-bottom: 14px;
}

.cert-label span {
    color: var(--danger-color);
}

.number-row {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    margin-bottom: 10px;
}

.number-wrapper {
    width: 56px;
    height: 64px;
    border: 1.5px solid var(--border-color);
    border-radius: 14px;
    background: var(--input-bg);
    color: var(--input-text);
    font-size: 28px;
    font-weight: 900;
    text-align: center;
    outline: none;
    transition: border-color .18s, box-shadow .18s;
    caret-color: var(--main-color);
}

.number-wrapper:focus {
    border-color: var(--main-color);
    box-shadow: 0 0 0 3px var(--main-light);
}

.number-wrapper.filled {
    border-color: var(--main-color);
    background: var(--main-light);
    color: var(--main-color);
}

.cert-sep {
    font-size: 22px;
    font-weight: 900;
    color: var(--muted-text);
    padding-bottom: 6px;
    user-select: none;
}

.error-row {
    min-height: 24px;
    margin-bottom: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    font-size: 13px;
    font-weight: 700;
    color: var(--danger-color);
}

.error-row.hidden {
    opacity: 0;
}

.resend-row {
    display: flex;
    justify-content: center;
    margin-top: 18px;
}

.cert-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    padding-top: 20px;
    border-top: 1px solid var(--border-color);
    margin-top: 24px;
}
</style>

<div class="page-wrap">
    <div class="cert-card">

        <div class="cert-card-header">
            <div class="gw-breadcrumb">홈 > 비밀번호 찾기 > 인증번호 확인</div>
            <h1>인증번호 확인</h1>
            <p>이메일로 발송된 6자리 인증번호를 입력해주세요</p>
        </div>

        <div class="cert-card-body">

            <div class="cert-email-row">
                <i class="fa-solid fa-envelope"></i>
                ${sessionScope.findPwEmail} 으로 인증메일이 발송되었습니다
            </div>

            <label class="cert-label">인증번호 <span>*</span></label>

            <form action="./cert_pw" method="post" autocomplete="off">
                <div class="number-row">
                    <input type="text" inputmode="numeric" name="num1" class="number-wrapper" maxlength="1">
                    <input type="text" inputmode="numeric" name="num2" class="number-wrapper" maxlength="1">
                    <input type="text" inputmode="numeric" name="num3" class="number-wrapper" maxlength="1">
                    <div class="cert-sep">—</div>
                    <input type="text" inputmode="numeric" name="num4" class="number-wrapper" maxlength="1">
                    <input type="text" inputmode="numeric" name="num5" class="number-wrapper" maxlength="1">
                    <input type="text" inputmode="numeric" name="num6" class="number-wrapper" maxlength="1">
                </div>

                <div class="error-row <c:if test="${param.error == null}">hidden</c:if>" id="errorRow">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <c:choose>
                        <c:when test="${param.error != null}">
                            인증번호가 일치하지 않거나 인증 시간을 초과했습니다
                        </c:when>
                        <c:otherwise>
                            인증번호 6자리를 모두 입력해주세요
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="resend-row">
                    <button type="button" class="gw-btn-outline btn-cert-send">
                        <i class="fa-solid fa-envelope"></i>
                        <span>인증메일 다시 보내기</span>
                    </button>
                </div>

                <div class="cert-actions">
                    <a href="/emp/findPw" class="gw-btn-outline">
                        <i class="fa-solid fa-arrow-left"></i>
                        이전으로
                    </a>
                    <button type="submit" class="gw-btn-primary">
                        <i class="fa-solid fa-check"></i>
                        확인
                    </button>
                </div>
            </form>

        </div>
    </div>
</div>

<script>
$(function(){

    $(".number-wrapper").first().focus();

    $(".number-wrapper").on("input", function() {
        var value = $(this).val();
        value = value.replace(/[^0-9]/g, "");
        $(this).val(value);

        if (value.length === 1) {
            $(this).addClass("filled");
            $(this).next(".number-wrapper").focus();
        } else {
            $(this).removeClass("filled");
        }
    });

    $(".number-wrapper").on("keydown", function(e) {
        if (e.keyCode == 8 && $(this).val() == "") {
            var prev = $(this).prevAll(".number-wrapper").first();
            prev.val("").removeClass("filled").focus();
        }
    });

    $("form").on("submit", function(e) {
        var allFilled = true;
        $(".number-wrapper").each(function() {
            if ($(this).val() === "") {
                allFilled = false;
                return false;
            }
        });

        if (!allFilled) {
            e.preventDefault();
            $("#errorRow")
                .removeClass("hidden")
                .html('<i class="fa-solid fa-circle-exclamation"></i> 인증번호 6자리를 모두 입력해주세요');
        }
    });

    $(".btn-cert-send").on("click", function(){
        $(".number-wrapper").val("").removeClass("filled").first().focus();
        $("#errorRow").addClass("hidden");

        var memberEmail = "${sessionScope.findPwEmail}";
        $.ajax({
            url: "http://localhost:8080/rest/cert/send",
            method: "post",
            data: { certEmail: memberEmail },
            success: function() {
                window.alert("인증 메일이 발송되었습니다");
            },
            error: function() {
                window.alert("이메일 발송에 실패했습니다.\n잠시 후 다시 시도해주세요");
            },
            beforeSend: function() {
                $(".btn-cert-send span").text("인증메일 발송중");
                $(".btn-cert-send i").removeClass("fa-envelope").addClass("fa-spinner fa-spin");
                $(".btn-cert-send").prop("disabled", true);
            },
            complete: function() {
                $(".btn-cert-send span").text("인증메일 다시 보내기");
                $(".btn-cert-send i").removeClass("fa-spinner fa-spin").addClass("fa-envelope");
                $(".btn-cert-send").prop("disabled", false);
            }
        });
    });
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>