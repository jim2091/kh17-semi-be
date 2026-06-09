<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_board_pds.jsp"></jsp:include>

<style>
/* 
    summernote의 경우 기존과 상이해 피드백 디자인별도로 수행
*/

.text-editor ~ div > .fail-feedback {
    color: #d63031;
    visibility: hidden;
}

.text-editor.fail ~ div > .fail-feedback {
    visibility: visible;
}


</style>

<script type="text/javascript">

$(function(){
	//입력창 summernote 적용
	$('#summernote').summernote({
	
	    lang : 'ko-KR',
	    height : 400,
	
	    callbacks : {
	
	        onKeyup : function(){
	
	            var text = $(this)
	                .summernote('code')
	                .replace(/<[^>]*>/g, '')
	                .trim();
	
	            $(".text-length span")
	                .text(text.length);
	        }
	    }
	
	});
	
	var state = {
		pdsTitleValid : false,
		pdsContentValid : false,
		ok : function(){
			return Object.values(this)
					.filter(v => typeof v === "boolean")
					.every(v => v === true);
		}
	};
	
	$("[name=pdsTitle]").on("blur", function(){
		var title = $(this).val();
		if(title.length > 100) {
			title = title.substring(0, 100)
			$(this).val(title);
		}
		var valid = title.length > 0;
		
		if(!valid){
			$(this).addClass("fail");
		} else{
			$(this).removeClass("fail");
		}
		state.pdsTitleValid = valid;
	});
	$("[name=pdsContent]").on("blur", function(){
		var content = $('#summernote').summernote('code');
        
		var valid = content.length > 0;
		if(!valid){
			$(this).addClass("fail");
		} else{
			$(this).removeClass("fail");
		}
		state.pdsContentValid = valid;
	});

	$(".form-check").on("submit", function(){
        $(this).find("input[name]").trigger("blur");
        
        checkPdsContent();
        
        return state.ok();
    });
	
	//기존 text-area와 달라 별도로 검사 및 피드백
	function checkPdsContent(){
	    var code = $("#summernote").summernote("code");
	    var text = $("<div>").html(code).text().trim();

	    var valid = text.length > 0;
		console.log(valid);
	    $("#summernote").removeClass("fail");

	    if(!valid){
	        $("#summernote").addClass("fail");
	    }

	    state.pdsContentValid = valid;
	    return valid;
	}
	
	
});

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
			<input type="text" name="pdsTitle" class="field w-100">
			<div class="fail-feedback">[필수] 제목을 입력해주세요.</div>
		</div>
		
		<!-- 내용 입력창 -->
		<div class="cell">
			<label>내용 <i class="fa-solid fa-asterisk red"></i> </label>
			<textarea id="summernote" name="pdsContent" class="text-editor"></textarea>
			<div class="justify">
			    <span class="fail-feedback">[필수] 내용을 입력하세요.</span>
			    <span class="text-length">
			        <span>0</span> / 1000
			    </span>
			</div>

		</div>
		<div class="cell">
            <label>파일 첨부</label>
            <input type="file" name="attach" class="field w-100" multiple
            	accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.hwp,.hwpx,.zip">
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