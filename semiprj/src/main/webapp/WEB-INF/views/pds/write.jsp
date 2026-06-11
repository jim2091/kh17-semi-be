<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>


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

                <input type="text" name="pdsTitle" class="gw-form-input full">

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

    var savedTheme = localStorage.getItem("gwTheme");

    if(savedTheme){
        $("body").addClass(savedTheme);
    }
    else{
        $("body").addClass("theme-blue");
    }

    $(".theme-btn").click(function(){
        $(".theme-popup").toggle();
    });

    $(".theme-item").click(function(){
        var theme = $(this).data("theme");

        $("body")
            .removeClass("theme-blue theme-green theme-purple theme-dark")
            .addClass(theme);

        localStorage.setItem("gwTheme", theme);

        $(".theme-popup").hide();
    });

    $("#summernote").summernote({
        lang : "ko-KR",
        height : 400,
        callbacks : {
            onKeyup : function(){
                var text = $(this)
                    .summernote("code")
                    .replace(/<[^>]*>/g, "")
                    .trim();

                $(".text-length span").text(text.length);
            }
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

        if(title.length > 100) {
            title = title.substring(0, 100);
            $(this).val(title);
        }

        var valid = title.length > 0;

        if(!valid){
            $(this).addClass("fail");
        }
        else{
            $(this).removeClass("fail");
        }

        state.pdsTitleValid = valid;
    });

    $(".form-check").on("submit", function(){
        $(this).find("input[name]").trigger("blur");

        checkPdsContent();

        return state.ok();
    });

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

});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>