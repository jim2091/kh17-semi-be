<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<!-- 에디터 아래 글자수 표기 위치 때문에 여기서만 이렇게 적용 -->
<style>
.fail-feedback {
    display: inline-block;
    visibility: hidden;
}
.gw-form-input.fail ~ .fail-feedback,
.text-editor.fail ~ .editor-bottom-row .fail-feedback {
    visibility: visible;
}
</style>

    <div class="gw-page-head pds-width">
        <div class="gw-breadcrumb">홈 / 자료실 / 글쓰기</div>
        <h1>자료 등록</h1>
        <p>사내 업무 자료를 작성하고 파일을 첨부할 수 있습니다.</p>
    </div>

    <form action="./write" method="post" enctype="multipart/form-data"
          autocomplete="off" class="form-check">

        <div class="gw-form-panel pds-width">

            <div class="gw-form-row">
                <label class="gw-form-label">
                    제목 <span class="required">*</span>
                </label>

                <input type="text" name="pdsTitle" class="gw-form-input full" maxlength="100">

                <div class="fail-feedback">[필수] 제목을 입력해주세요.</div>
            </div>

            <div class="gw-form-row">
                <label class="gw-form-label">
                    내용 <span class="required">*</span>
                </label>
                
                <textarea id="summernote" name="pdsContent" class="text-editor"></textarea>
				
                <div class="editor-bottom-row">
                    <span class="fail-feedback">[필수] 내용을 입력하세요.</span>

	                <span class="text-length">
	                    <span>0</span> / 1000
	                </span>
	            </div>
                
            </div>

            <div class="gw-form-row">
                <label class="gw-form-label">파일 첨부</label>
				
				<div class="gw-file-box">
					<label for="attach" class="gw-file-btn">
						<i class="fa-solid fa-paperclip"></i>
						<span>파일 선택</span>
					</label>
				</div>
				
				<span class="gw-file-name">선택된 파일 없음</span>

                <input type="file" id="attach" name="attach" class="gw-file-input" multiple
                    accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.hwp,.hwpx,.zip">
			</div>				
			<div class="gw-form-help">
                PDF, Office 문서, HWP, ZIP 파일을 첨부할 수 있습니다.
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

</div>

<script type="text/javascript">
$(function(){
	
  	//1000글자 이상 입력 막기
	//기존 subString방법 : 서식이 전부 깨짐
	//1000글자 이상일 때 삭제,이동 관련 키 말고 막기 : onChange로 못막음 onKeydown으로 막아야하는데
	//한글의 경우 한글 입력 조합(IME)때문에 안막힘
	//최종적으로 입력을 계속 저장하다가 1000글자 초과 입력시 이전상태로 복구하는 방식 채택
	//이 경우 1000글자 넘어갈 시 커서 맨앞으로감. 이것도 해결하면 또 뭐하나 더하고 하는 방식이라 일단 여기까지
    var restoring = false;
    $("#summernote").summernote({
        lang : "ko-KR",
        height : 400,
        callbacks : {
            onChange : function(contents){
                if (restoring) return;
                
                var text = $("<div>").html(contents).text();
                
                if(text.length <= 1000){
                	lastCode = contents;
                	$(".text-length span").text(text.length);
                	checkPdsContent();
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
            	
            },
            
			onImageUpload : function(files){
				for(var i = 0; i < files.length; i++){
					uploadImage(files[i]);
				}
			},
		



        }
    });
    
    $("#attach").change(function(){
        var files = this.files;

        if(files.length === 0){
            $(".gw-file-name").text("선택된 파일 없음");
        }
        else if(files.length === 1){
            $(".gw-file-name").text(files[0].name);
        }
        else{
            $(".gw-file-name").text(files[0].name + " 외 " + (files.length - 1) + "개");
        }
    });
    
    var state = {
        pdsTitleValid : false,
        pdsContentValid : false,
        ok : function(){
            return Object.values(this)
                .filter(function(v){
                    return typeof v === "boolean";
                })
                .every(function(v){
                    return v === true;
                });
        }
    };

    $("[name=pdsTitle]").on("blur", function(){
        var title = $(this).val();

        var valid = title.length > 0;

        $(this).toggleClass("fail", !valid);
        state.pdsTitleValid = valid;
        
    });

    $(".form-check").on("submit", function(){
        $(this).find("input[name]").trigger("blur");

        checkPdsContent();

        return state.ok();
    });
	
    //함수들
    
    function checkPdsContent(){
        var code = $("#summernote").summernote("code");
        var text = $("<div>").html(code).text().trim();

        var valid = text.length > 0;

        $("#summernote").removeClass("fail");

        if(!valid){
            $("#summernote").addClass("fail");
        }

        state.pdsContentValid = valid;

        return valid;
    }
    
    function uploadImage(file){
    	//파일은 객체이기 때문에 data로 보낼때 폼을 객체로 만든 formData안에 넣어서 보내야함
    	var formData = new FormData();
    	formData.append("attach", file);
    	
    	$.ajax({
    		url : "/rest/attach/upload",
    		type : "post",
    		data : formData,
    		//파일 업로드시 거의 항상 붙는 설정
    		processData : false,//jQuery가 FormData를 문자열로 바꾸지 않도록
    		contentType : false,//브라우저가 자동으로 multipart/form-data 헤더를 설정하도록
    		
    		success : function(attachNo){
				var imageUrl = "/download/image?attachNo=" + attachNo;
				$("#summernote").summernote("insertImage", imageUrl);
    		},
    		error : function(){
    			alert("이미지 업로드 실패")
    		}
    	});
    	
    }
    <%--
    //1000글자 넘으면 자르기
    //순수 텍스트로 만들어버리기 때문에 서식 등이 사라짐
    
    function limitSummernoteText(){
    	var code = $("#summernote").summernote("code");
    	var text = $("<div>").html(code).text();
    	
    	if (text.length > 1000) {
    		var cut = text.substring(0, 1000);
    		
    		$("#summernote").summernote("code", cut);
    	}
    	
    	$(".text-length span").text(
    		Math.min(text.length, 1000)		
    	);
    }
    --%>

});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>