<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.text-length {
    color: var(--sub-text);
    font-size: 13px;
    font-weight: 700;
    margin-left: auto;
}
.text-length.warning {
    color: #ff9800;
}

.text-length.danger {
    color: var(--danger-color);
}
</style>

<script type="text/javascript">
$(function(){
	//(+) 입력창 summernote 적용
	var restoring = false;
	var lastCode = "";
	$('#summernote').summernote({
	    lang : 'ko-KR',
	    height : 400,
	    callbacks : {
	    	onImageUpload : function(files){
	            uploadImage(files[0]);
	        },
	        onChange : function(contents){
	        	updateLength();
                if (restoring) return;
                
                var text = $("<div>").html(contents).text();
                
                var length = text.length;

                $(".text-length span").text(length);

                $(".text-length")
                    .removeClass("warning danger");

                if(length >= 950){
                    $(".text-length").addClass("danger");
                }
                else if(length >= 800){
                    $(".text-length").addClass("warning");
                }
                
                if(text.length <= 1000){
                	lastCode = contents;
                	$(".text-length span").text(text.length);
                	checkBoardContent();
                }
                else{
                	restoring = true;
                	$("#summernote").summernote("code", lastCode);
                	restoring = false;
                	
                	$(".text-length span").text(
                		$("<div>").html(lastCode).text().length		
                	);
                }
            },
            
            onPaste : function(e) {
            	var currentCode = $("#summernote").summernote("code");
            	var currentText = $("<div>").html(currentCode).text();
            	
            	var pasteText = "";
            	
            	if(e.originalEvent.clipboardData) {
            		pasteText = e.originalEvent.clipboardData.getData("text");
            	}
            	
            	if(currentText.length + pasteText.length > 1000) {
            		e.preventDefault();
            		alert("내용은 1000자 이하로 입력할 수 있습니다.");
            	}
            }
	    }
	});
	
	//업로드 함수(AJAX 전송)
	function uploadImage(file){
	    var formData = new FormData();
	    formData.append("attach", file);
	    $.ajax({
	        url : "${pageContext.request.contextPath}/rest/board/image",
	        type : "post",
	        data : formData,
	        processData : false,
	        contentType : false,

	        success : function(response){
	            $("#summernote").summernote(
	                "insertImage",
	                response.url
	            );
	        }
	    });
	}
	
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
    	state.boardTitleValid = valid;
    });
    
    //(2) 종류
    $("[name=boardHead]").on("input", function(){
    	var regex = /^(공지|자유|정보|질문)$/;
    	var valid = regex.test($(this).val());
        $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
        state.boardHeadValid = valid;
    });
    
    //(3) 유형
    $("input[name=boardType]").on("input", function(){
    	var valid = $("input[name=boardType]:checked").length > 0;
        state.boardTypeValid = valid;
    });
    
    //(4) 내용
    $("[name=boardContent]").on("input blur", function(){
    	var content = $('#summernote').summernote('code');
    	var valid = content.length > 0;
		if(!valid){
			$(this).addClass("fail");
		} 
		else{
			$(this).removeClass("fail");
		}
		state.boardContentValid = valid;
    });
    
    //3. 폼 검사
    $(".form-check").on("submit", function(){
        $(this).find("select[name]").trigger("input");
        $(this).find("input[name], textarea[name]").trigger("blur");
        state.boardTypeValid = $("input[name=boardType]:checked").length > 0;
        checkBoardContent();
        return state.ok();
    });
    
  //기존 text-area와 달라 별도로 검사 및 피드백
    function checkBoardContent(){
	    var code = $("#summernote").summernote("code");
	    var text = $("<div>").html(code).text().trim();

	    var valid = text.length > 0 && text.length <= 1000;
	    
	    $("#summernote").removeClass("fail");

        if(!valid){
            $("#summernote").addClass("fail");
        }

	    state.boardContentValid = valid;
	    return valid;
	}
  
    function updateLength() {
        var text = $("<div>")
            .html($("#summernote").summernote("code"))
            .text()
            .trim();

        var length = text.length;

        $(".text-length span").text(length);

        $(".text-length")
            .removeClass("warning danger");

        if(length >= 950){
            $(".text-length").addClass("danger");
        }
        else if(length >= 800){
            $(".text-length").addClass("warning");
        }
    }
    
	// 수정 페이지 진입 시 기존 값 검증
    $("[name=boardTitle]").trigger("blur");
    $("[name=boardContent]").trigger("blur");
    $("[name=boardHead]").trigger("input");
    $("input[name=boardType]:checked").trigger("input");
 	// 기존 글자 수 표시
    updateLength();
});
</script>

	<form action="./edit" method="post" enctype="multipart/form-data"
    	 	autocomplete="off"  class="form-check">
    	 	
	<div class="gw-page-head pds-width">
        <div class="gw-breadcrumb">홈 / 게시판 / 글 수정</div>
			<h1>기존 글 수정</h1>
			<p>타인에 대한 무분별한 비방글은 예고 없이 삭제될 수 있습니다.</p>
    	</div>
 
    	 	<input type="hidden" name="boardNo" value="${boardDto.boardNo}">

			<div class="gw-form-panel pds-width">
	            <div class="gw-form-row">
	                <label class="gw-form-label">
	                    제목 <span class="required">*</span>
	                </label>
					<input type="text" name="boardTitle" class="gw-form-input full" value="${boardDto.boardTitle}">
	                <div class="fail-feedback">[필수] 제목을 입력해주세요.</div>
	            </div>
				
				<div class="gw-form-row">
	                <label class="gw-form-label">
	                    종류 <span class="required">*</span>
	                </label>
	                <select name="boardHead" class="gw-form-select">
						<option value="">-- 선택하세요 --</option>
						<c:if test="${sessionScope.loginRole == '관리자'}">
							<option ${boardDto.boardHead == '공지' ? 'selected' : ''}>공지</option>
						</c:if>
						<option ${boardDto.boardHead == '자유' ? 'selected' : ''}>자유</option>
						<option ${boardDto.boardHead == '정보' ? 'selected' : ''}>정보</option>	
						<option ${boardDto.boardHead == '질문' ? 'selected' : ''}>질문</option>		
					</select>
					<div class="fail-feedback">[필수] 종류를 선택하세요.</div>
				</div>
				
				<div class="gw-form-row">
	                <label class="gw-form-label">
	                    유형 <span class="required">*</span>
	                </label>
		                <div class="field radio-wrapper">
			            <label>
			                <input type="radio" name="boardType" value="비밀"
			                	${boardDto.boardType == '비밀' ? 'checked' : ''}> 
			                <span>비밀</span>
						</label>
						<label>
			                <input type="radio" name="boardType" value="익명"
			                	${boardDto.boardType == '익명' ? 'checked' : ''}> 
			                <span>익명</span>
						</label>
						<label>
			                <input type="radio" name="boardType" value="일반"
			                	${boardDto.boardType == '일반' ? 'checked' : ''}> 
			                <span>일반</span>
			            </label>
		            </div>
					<div class="fail-feedback">[필수] 유형을 선택하세요.</div>
				</div>
				
				<div class="gw-form-row">
	                <label class="gw-form-label">
	                    내용 <span class="required">*</span>
	                </label>
					<textarea id="summernote" name="boardContent" class="text-editor">${boardDto.boardContent}</textarea>
					<div class="editor-bottom-row">
	                    <span class="fail-feedback">[필수] 내용을 입력하세요.</span>
		                <div class="text-length">
		                    <span>0</span> / 1000
		                </div>
		            </div>
				</div> 
				
				<div class="gw-form-actions">
	                <a href="./list" class="gw-btn-outline">
	                    <i class="fa-solid fa-list"></i>
	                    <span>목록으로</span>
	                </a>
	
	                <button type="submit" class="gw-btn-primary">
	                    <i class="fa-solid fa-floppy-disk"></i>
	                    <span>등록하기</span>
	                </button>
	            </div>
			</div>
		</form>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>