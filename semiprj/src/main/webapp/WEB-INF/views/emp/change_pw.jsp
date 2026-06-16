<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
	.password-panel{
	    max-width:700px;
	    margin:80px auto;
	    padding:60px 40px;
	    background:white;
	    border:1px solid #e5e7eb;
	    border-radius:16px;
	    text-align:center;
	}
	
	.password-icon{
	    width:90px;
	    height:90px;
	    margin:0 auto 24px;
	    border-radius:50%;
	    background:#edf4ff;
	    color:var(--main-color);
	    display:flex;
	    align-items:center;
	    justify-content:center;
	}
	
	.password-title{
	    font-size:28px;
	    font-weight:700;
	    color:#111827;
	    margin-bottom:12px;
	}
	
	.password-desc{
		font-size:15px;
	    color:#6b7280;
	    line-height:1.7;
	    margin-bottom:32px;
	}
	
	.password-actions{
	    margin-top:40px;
	    display:flex;
	    justify-content:center;
	    gap:12px;
	}
	.password-guide{
	    background:#f8fafc;
	    border:1px solid #e5e7eb;
	    border-radius:12px;
	
	    padding:16px;
	    margin-top:24px;
	
	    text-align:left;
	
	    color:#6b7280;
	    font-size:14px;
	    line-height:1.8;
	}
	.input-group{
	    text-align:left;
	    margin-bottom:20px;
	}
	
	.input-group label{
	    display:block;
	    margin-bottom:8px;
	    font-size:14px;
	    font-weight:700;
	    color:#374151;
	}
</style>

<script>
    $(function () {
        var state = {
            empPwValid: false,
            empPwCheckValid: false,
            ok: function () {
                return Object.values(this)
                    .filter(v => typeof v === "boolean")
                    .every(v => v === true);
            }
        };

        //항목 검사
        $("[name=empPw], [name=empPwCheck]").on("blur", function () {
            //[1] 비밀번호 검사
            var regex = /^(?=.*?[A-Z]+)(?=.*?[a-z]+)(?=.*?[0-9]+)(?=.*?[!@#$]+)[A-Za-z0-9!@#$]{8,16}$/;
            state.empPwValid = regex.test($("[name=empPw]").val());
            $("[name=empPw]").removeClass("fail")
            if(!state.empPwValid) $("[name=empPw]").addClass("fail")

            //[2] 비밀번호 확인 검사
            state.empPwCheckValid = $("[name=empPw]").val().length > 0 &&
                $("[name=empPw]").val() == $("[name=empPwCheck]").val();
            $("[name=empPwCheck]").removeClass("fail")
            if(!state.empPwCheckValid) $("[name=empPwCheck]").addClass("fail")
        });
        
        //폼검사
        $(".form-check").on("submit", function () {
            $(this).find("input[name]").trigger("blur");
            return state.ok();
        });

    });

</script>

<div class="password-panel">
	<div class="password-icon">
		<i class="fa-solid fa-key fa-2x"></i>
	</div>

	<div class="password-title">
		비밀번호 변경이 필요합니다
	</div>
	<div class="password-desc mb-30">
		마지막 비밀번호 변경 후 30일이 경과했습니다.<br>
    	계정 보안을 위해 새로운 비밀번호를 설정해주세요.
	</div>
	
    <form action="./change_pw" method="post" autocomplete="off" class="form-check">
    	<input type="hidden" name="empId" value="${empId}">
		<div class="input-group">
			<label>새 비밀번호</label>
			<input type="password" name="empPw" class="gw-form-input field2 w-100">
	        <div class="fail-feedback">
	            <i class="fa-solid fa-circle-exclamation"></i> 사용 불가능한 비밀번호입니다.
	        </div>
		</div>
		
		<div class="input-group">
			<label>비밀번호 확인</label>
			<input type="password" name="empPwCheck" class="gw-form-input field2 w-100">
			<div class="fail-feedback">
				<i class="fa-solid fa-circle-exclamation"></i> 비밀번호를 입력하지 않았거나 비밀번호가 일치하지 않습니다.
			</div>
		</div>
		
		<div class="password-guide">
		    <div>✓ 8~16자</div>
		    <div>✓ 영문 대문자 포함</div>
		    <div>✓ 영문 소문자 포함</div>
		    <div>✓ 숫자 포함</div>
		    <div>✓ 특수문자 포함 (!@#$)</div>
		</div>
		
		<div class="password-actions">
			<a href="/" class="gw-btn-outline">다음에 변경하기</a>
	        <button type="submit" class="gw-btn-primary">비밀번호 변경</button>
	    </div>
    </form>
</div>


<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>