<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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

		<div class="container w-500 mt-20 mb-20">
		    <div class="cell">
		        <h1>새 비밀번호를 입력해주세요</h1>
		    </div>
		    <form action="./change_pw" method="post" autocomplete="off">
		    	<input type="hidden" name="empId" value="${empId}">
				<div class="cell">
					<input type="password" name="empPw" class="field2 w-100">
			        <div class="fail-feedback">
			            <div>사용 불가능한 비밀번호입니다</div>
			        </div>
				</div>
				<div class="cell">
					<input type="password" name="empPwCheck" class="field2 w-100">
					<div class="fail-feedback">비밀번호를 입력하지 않았거나 비밀번호가 일치하지 않습니다</div>
				</div>
				<div class="cell">
					<div>영문 대소문자, 특수문자를 모두 사용하여 8~16자로 설정해주세요</div>
				</div>
				<div class="cell right">
			        <button type="submit" class="btn btn-positive">확인</button>
			    </div>
		    </form>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>