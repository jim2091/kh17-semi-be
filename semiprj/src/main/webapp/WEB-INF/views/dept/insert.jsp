<%@ page language="java" contentType="text/html; charset=UTF-8"

pageEncoding="UTF-8"%>


<!-- 아이콘 -->
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
<!-- 디자인을 작성하기 위한 영역 -->
<link rel="stylesheet" type="text/css" href="../css/commons.css">
<style>
	div { box-shadow: 0 0 0 1px #cccccc;}
</style>
<!-- jQuery CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="./preview.js"></script>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>



<script>

	$(function(){
		//상태 객체
		var state = {
			deptCategoryValid : false,
			deptNameValid : false,
			deptHeadIdValid : false,
			deptContentValid : true,
				ok : function() {
					return Object.values(this)
					.filter(v => typeof v === "boolean")
					.every(v => v === true);
				}
	
	};



//개별 입력창 검사

	$("[name=deptCategory]").on("input", function(){
		var regex = /^(영업|관리|감사)$/;
		var valid = regex.test($(this).val());
		$(this).removeClass("success fail").addClass(valid ? "success" : "fail");
		state.deptCategoryValid = valid;
	});

	$("[name=deptName]").on("blur", function(){
		var valid = $(this).val().length > 0;
		$(this).removeClass("success fail").addClass(valid ? "success" : "fail");
		state.deptNameValid = valid;
	});
	$("[name=deptHeadId]").on("blur", function(){
		var value = $(this).val();
		var valid = value.length > 0 && parseInt(value) > 0;
		$(this).removeClass("success fail").addClass(valid ? "success" : "fail");
		state.deptHeadIdValid = valid;
	});
	$("[name=deptContent]").on("blur", function(){
		var valid = $(this).val().length >= 0;
		$(this).removeClass("success fail").addClass(valid ? "success" : "fail");
		state.deptContentValid = valid;
	});
	//숫자 검사
	$("[inputmode=numeric]").on("input", function(){
		var regex = /[^0-9]+/g;
		var replacement = $(this).val().replace(regex, "");
		$(this).val(replacement);
	});
	//폼 검사
	$(".form-check").on("submit", function(){
			//화면 처리(이벤트 트리거)
			$(this).find("select[name]").trigger("input");
			$(this).find("input[name], textarea[name]").trigger("blur");
		return state.ok();//state.ok() 상태에 따라 전송해!
	});

	});
</script>
<form action="" method="post" autocomplete="off" class="form-check">
	<div class="container w-600 mt-50 mb-50">
		<div class="cell center">
			<h1>부서 정보 등록</h1>
		</div>
		<div class="cell">
			<label>부서카테고리 <i class="fa-solid fa-asterisk red"></i></label>
				<select name="deptCategory" class="field w-100">
					<option value="">선택하세요</option>
					<option>영업</option>
					<option>관리</option>
					<option>감사</option>
				</select>
			<div class="fail-feedback">필수 항목입니다</div>
		</div>
		<div class="cell">
			<label>부서명 <i class="fa-solid fa-asterisk red"></i></label>
				<input type="text" name="deptName" class="field w-100">
				<div class="success-feedback">올바른 형식의 이름입니다</div>
				<div class="fail-feedback">필수 입니다.</div>
		</div>
		<div class="cell">
			<label>부서장 <i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" inputmode="numeric" name="deptHeadId" class="field w-100">
			<div class="fail-feedback">필수 항목입니다!</div>
		</div>
		<div class="cell">
			<label>업무내용 <i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="deptContent" class="field w-100">
		</div>
		<div class="cell preview-area"></div>
		<div class="cell mt-50">
		<button type="submit" class="btn btn-positive w-100">등록하기</button>
		</div>
	</div>
</form>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>