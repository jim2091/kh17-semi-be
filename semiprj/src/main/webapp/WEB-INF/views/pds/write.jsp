<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<script type="text/javascript">

$(function(){
	
	var state = {
		pdsTitleValid : false,
		pdsContentValid : false,
		ok : function(){
			return Object.values(this)
					.filter(v => typeof v === "boolean")
					.every(v => v === true);
		}
	};
	
	$("name=pdsTitle").on("blur", function(){
		var title = $(this).val();
		if(title.length > 100) {
			title = title.substring(0, 100)
			$(this).val(title);
		}
		var valid = title.length > 0;
		$(this).removeClass("success fail").addClass(valid ? "success" : "fail");
		state.pdsTitleValid = valid;
	});
	$("name=pdsContent").on("blur", function(){
		var content = $(this).val();
		if(content.length > 100) {
			content = content.substring(0, 1000)
			$(this).val(content);
		}
		var valid = content.length > 0;
		$(this).removeClass("success fail").addClass(valid ? "success" : "fail");
		state.pdsContentValid = valid;
	});
    $(".form-check").on("submit", function(){
        $(this).find("input[name], textarea[name]").trigger("blur");
        return state.ok();
    });
	
})

</script>

<form action="./write" method="post" enctype="multipart/form-data" autocomplete="off"  class="form-check">

	<div class="container w-800 mt-50 mb-50">
		<!-- 페이지 제목 -->
		<div class="cell">
			<h1 class="mt-0 mb-0">답변 글 작성</h1>
		</div>
		
		<!-- 경고문 -->
		<div class="cell">
			<i class="fa-solid fa-circle-exclamation red"></i>
			타인에 대한 무분별한 비방글은 경고 없이 삭제될 수 있습니다.
		</div>
	
		<!-- 제목 입력창 -->
		<div class="cell mt-40">
			<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="pdsTitle" required class="field w-100">
			<div class="fail-feedback">[필수] 제목을 입력해주세요.</div>
		</div>
		
		<!-- 내용 입력창 -->
		<div class="cell">
			<label>내용 <i class="fa-solid fa-asterisk red"></i> </label>
			<textarea name="pdsContent" rows="10" required class="field w-100"></textarea>
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