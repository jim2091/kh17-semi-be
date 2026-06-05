<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<style>
	.field ~ .success-feedback {
	    color: #0984e3;
	    display: none;
	}
	.field ~ .fail-feedback {
	    color: #d63031;
	    display: none;
	}
	.field.success ~ .success-feedback {
	    display: block;
	}
	.field.fail ~ .fail-feedback {
	    display: block;
	}
	.field {
	    background-size: 1em;
	    background-repeat: no-repeat;
	    background-position-x: right 0.5em;
	    background-position-y: center;
	    padding-right: 2em;
	}
	select.field {
	    background-position-x: right 1em;
	}
	.field.success {
	    background-image: url("https://cdn.jsdelivr.net/gh/honglahyun/cdn/valid.png");
	    border-color: #0984e3;
	}
	.field.fail {
	    background-image: url("https://cdn.jsdelivr.net/gh/honglahyun/cdn/invalid.png");
	    border-color: #d63031;
	}
	.radio-wrapper {
    	border: none !important;
    	background-image: none !important;
    	padding-right: 0;
	}
</style>

<script type="text/javascript">
$(function(){
    //1. 상태 객체
    var state = {
   		boardTitleValid : false,
   		boardHeadValid : false,
   		boardTypeValid : false,
   		boardContentValid : false,
   		ok : function(){
               return Object.values(this)
                       .filter(v => typeof v === "boolean")
                       .every(v => v === true);
   		}
    };
    
    //2. 개별 입력값 검사
    //(1) 제목
    $("[name=boardTitle]").on("blur", function(){
    	var title = $(this).val();
    	if(title.length > 100) {
    		title = title.substring(0,100);
            $(this).val(title);
        }
    	var valid = title.length > 0;
    	$(this).removeClass("success fail").addClass(valid ? "success" : "fail");
    	console.log("sadf")
    	state.boardTitleValid = valid;
    });
    
    //(2) 종류
    $("[name=boardHead]").on("input", function(){
    	var regex = /^(공지|자유|정보|질문)$/;
    	var valid = regex.test($(this).val()) && $(this).val() !== "";
        $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
        state.boardHeadValid = valid;
    });
    
    //(3) 유형
    $("input[name=boardType]").on("input", function(){
    	var valid = $("input[name=boardType]:checked").length > 0;
    	$(".radio-wrapper").removeClass("success fail").addClass(valid ? "success" : "fail");
    	state.boardTypeValid = valid;
    });
    
    //(4) 내용
    $("[name=boardContent]").on("input blur", function(){
    	var size = $(this).val().length;
    	if(size > 1000) {
    		var origin = $(this).val();
            var cut = origin.substring(0, 1000);
            $(this).val(cut);
            size = 1000;
        }
    	var span = $(this).next(".right").children("span");
        span.text(size);
        span.toggleClass("red", size >= 1000);
    	var valid = size > 0;
    	$(this).removeClass("success fail").addClass(valid ? "success" : "fail");
    	state.boardContentValid = valid;
    });
    
    //3. 폼 검사
    $(".form-check").on("submit", function(){
        $(this).find("select[name]").trigger("input");
        $(this).find("input[name], textarea[name]").trigger("blur");
        state.boardTypeValid = $("input[name=boardType]:checked").length > 0;
        return state.ok();
    });
});
</script>

<form action="./write" method="post" enctype="multipart/form-data" autocomplete="off"  class="form-check">
	<!-- 답변 글/신규 글 계산 -->
	<c:if test="${param.boardParent != null}">
		<input type="hidden" name="boardParent" value="${param.boardParent}">
	</c:if>

	<div class="container w-800 mt-50 mb-50">
		<!-- 페이지 제목 -->
		<div class="cell center">
			<c:if test="${param.boardParent == null}">
				<h1 class="mt-0 mb-0">신규 글 작성</h1>
			</c:if>
			<c:if test="${param.boardParent != null}">
				<h1 class="mt-0 mb-0">답변 글 작성</h1>
			</c:if>
		</div>
		
		<!-- 경고문 -->
		<div class="cell center mt-10">
			<i class="fa-solid fa-circle-exclamation fa-fade red"></i>
			타인에 대한 무분별한 비방글은 경고 없이 삭제될 수 있습니다.
		</div>
	
		<!-- 제목 입력창 -->
		<div class="cell mt-40">
			<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="boardTitle" class="field w-100">
			<div class="fail-feedback">[필수] 제목을 입력해주세요.</div>
		</div>
		
		<!-- 종류 드롭박스 -->
		<div class="cell">
			<label>종류 <i class="fa-solid fa-asterisk red"></i></label>
			<select name="boardHead" class="field w-100">
				<option value="">-- 선택하세요 --</option>
				<!-- (*) 공지는 관리자에게만 보임 -->
				<c:if test="${sessionScope.loginRole == '관리자'}">
					<option>공지</option>
				</c:if>
				<option>자유</option>
				<option>정보</option>	
				<option>질문</option>		
			</select>
			<div class="fail-feedback">[필수] 종류를 선택하세요.</div>
		</div>
		
		<!-- 유형 체크박스 -->
		<div class="cell">
			<label>유형 <i class="fa-solid fa-asterisk red"></i></label>
			<div class="field radio-wrapper">
	            <label>
	                <input type="radio" name="boardType" value="비밀"> <span>비밀</span>
				</label>
				<label>
	                <input type="radio" name="boardType" value="익명"> <span>익명</span>
				</label>
				<label>
	                <input type="radio" name="boardType" value="일반" checked> <span>일반</span>
	            </label>
            </div>
			<div class="fail-feedback">[필수] 유형을 선택하세요.</div>
		</div>
		
		<!-- 내용 입력창 -->
		<div class="cell">
			<label>내용 <i class="fa-solid fa-asterisk red"></i> </label>
			<textarea name="boardContent" rows="10" class="field w-100"></textarea>
			<div class="right">
                <span>0</span> / 1000
            </div>
            <div class="fail-feedback">[필수] 내용을 입력하세요.</div>
		</div>
	
		<!-- 목록/등록 버튼 -->
		<div class="cell mt-50 right">
			<a href="./list" class="btn btn-neutral">
				<i class="fa-solid fa-list"></i>
				<span>목록으로</span>
			</a>
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-floppy-disk"></i>
				<span>등록하기</span>
			</button>
		</div>
	</div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>