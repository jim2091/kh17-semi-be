<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<script>
	$(function(){
		
		//숫자만 입력가능, 입력시 다음 칸으로 이동
		$(".number-wrapper").on("input", function() {
			var value = $(this).val();
			value = value.replace(/[^0-9]/g, "");
			$(this).val(value);
			
			if(value.length === 1){
				$(this).next(".number-wrapper").focus();
			}
		});
		//백스페이스 눌렀을때 뒤로가기
		$(".number-wrapper").on("keydown", function(e) {

		    if(e.keyCode == 8 && $(this).val() == "") {
		        $(this).prev(".number-wrapper").focus();
		    }
		});
		
		//인증번호 다시 보내기
		$(".btn-cert-send").on("click", function(){
			$(".number-wrapper").val("").first().focus();
			var memberEmail = "${sessionScope.findIdEmail}";
			$.ajax({
				url: "http://localhost:8080/rest/cert/send",
				method: "post",
				data: { certEmail : memberEmail },
				success: function() {
					window.alert("인증 메일이 발송되었습니다")
				},
				error: function(){
					window.alert("이메일 발송에 실패했습니다. \n잠시 후 다시 시도해주세요")
				},
				beforeSend: function () {
                    $(".btn-cert-send").find("span").text("인증메일 발송중");
                    $(".btn-cert-send").find("i").removeClass("fa-envelope")
                        .addClass("fa-spinner fa-spin");
                    $(".btn-cert-send").prop("disabled", true);
                },
                complete: function () {//성공/실패 관계없이 끝나면 실행되는 함수 (디자인 변화를 제거)
                    $(".btn-cert-send").find("span").text("인증메일 보내기");
                    $(".btn-cert-send").find("i").removeClass("fa-spinner fa-spin")
                        .addClass("fa-envelope");
                    $(".btn-cert-send").prop("disabled", false);
                }
			});
		})
	});
</script>

<div class="container w-600 mt-20 mb-20">
    <div class="cell center">
        <h1>아이디 찾기</h1>
    </div>
    <form action="./cert_id" method="post" autocomplete="off">
	<div class="flex-area flex-center mt-40">
		<input type="text" inputmode="numeric" name="num1" class="number-wrapper" maxlength="1">
		<input type="text" inputmode="numeric" name="num2" class="number-wrapper" maxlength="1">
		<input type="text" inputmode="numeric" name="num3" class="number-wrapper" maxlength="1">
		<input type="text" inputmode="numeric" name="num4" class="number-wrapper" maxlength="1">
		<input type="text" inputmode="numeric" name="num5" class="number-wrapper" maxlength="1">
		<input type="text" inputmode="numeric" name="num6" class="number-wrapper" maxlength="1">
	</div>
	<div class="cell red center" style="min-height: 1.5em">
		<c:if test="${param.error != null}">
            인증번호가 일치하지 않거나 인증 시간을 초과했습니다
        </c:if>
	</div>
	<div class="cell right">
    	<button type="button" class="btn btn-neutral btn-cert-send">
            <i class="fa-solid fa-envelope"></i>
            <span>인증메일 다시 보내기</span>
        </button>
        <button type="submit" class="btn btn-positive">다음</button>
    </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>