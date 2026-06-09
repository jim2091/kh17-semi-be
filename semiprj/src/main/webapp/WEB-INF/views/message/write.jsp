<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_message.jsp"></jsp:include>

<style>
	.receiver-list{
	    border:1px solid #ccc;
	    max-height:200px;
	    overflow:auto;
	    background:white;
	}
	
	.receiver-item{
	    padding:8px;
	    cursor:pointer;
	}
	
	.receiver-item:hover{
	    background:#f5f5f5;
	}
	.receiver-wrapper{
	    position: relative;
	    width: 100%;
	}
	
	.receiver-selected-list{
	    margin-top: 10px;
	    display: flex;
	    flex-wrap: wrap;
	    gap: 8px;
	}
	
	.receiver-tag{
	    display: inline-flex;
	    align-items: center;
	    gap: 6px;
	
	    padding: 6px 12px;
	
	    border: 1px solid #d9d9d9;
	    border-radius: 999px;
	
	    background-color: #f5f7fa;
	
	    font-size: 14px;
	}
	
	.receiver-tag .delete-tag{
	    border: none;
	    background: transparent;
	    cursor: pointer;
	
	    color: #999;
	    font-size: 14px;
	    padding: 0;
	}
	
	.receiver-tag .delete-tag:hover{
	    color: #e74c3c;
	}

	/* 드롭다운을 입력창과 정확히 동일한 폭으로 */
	.receiver-list{
	    position: absolute;
	    top: 100%;
	    left: 0;
	    width: 100%;        /* ⭐ 핵심 */
	    border: 1px solid #ccc;
	    max-height: 200px;
	    overflow: auto;
	    background: white;
	    z-index: 999;
	}
</style>

<script type="text/javascript">
$(function(){
	//1. 상태 객체
	var state = {
		messageTitleValid : false,
		messageReceiverValid : false,
		messageContentValid : false,
		ok : function(){
               return Object.values(this)
                       .filter(v => typeof v === "boolean")
                       .every(v => v === true);
   		}
	};
	
	//2. 개별 입력값 검사
	//(1) 제목
	$("[name=messageTitle]").on("blur", function(){
		var title = $(this).val();
    	if(title.length > 100) {
    		title = title.substring(0,100);
            $(this).val(title);
        }
    	var valid = title.length > 0;
    	$(this).removeClass("success fail").addClass(valid ? "success" : "fail");
    	state.messageTitleValid = valid;
	});
	
	//(2) 받는이
	$("[name=receiverKeyword]").on("keyup", function(){
	    var keyword = $(this).val();
	
	    if(keyword.length < 1){
	        $(".receiver-list").empty();
	        state.messageReceiverValid = false;
	        return;
	    }
	
	    $.ajax({
	        url:"http://localhost:8080/message/searchEmp",
	        method:"get",
	        data:{ keyword:keyword },
	        success:function(response){
	            $(".receiver-list").empty();
	
	            $.each(response, function(index, emp){
	                var div = $("<div>");
	                div.addClass("receiver-item");
	                div.text(
	                    emp.empName + " (" + emp.empDept + ")"
	                );
	                div.click(function(){

	                    if($("input[name=messageReceiver][value='"+emp.empNo+"']").length){
	                        return;
	                    }

	                    var html = "";

	                    html += "<span class='receiver-tag'>";
	                    html += emp.empName;

	                    html += "<button type='button' class='delete-tag'>";
	                    html += "✕";
	                    html += "</button>";

	                    html += "<input type='hidden' ";
	                    html += "name='messageReceiver' ";
	                    html += "value='" + emp.empNo + "'>";

	                    html += "</span>";

	                    $(".receiver-selected-list").append(html);

	                    $("[name=receiverKeyword]").val("");

	                    $(".receiver-list").empty();

	                    state.messageReceiverValid = true;
	                });
	
	                $(".receiver-list").append(div);
	            });
	        }
	    });
	});
	
	//(3) 내용
    $("[name=messageContent]").on("input blur", function(){
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
    	state.messageContentValid = valid;
    });
	
	//3. 폼 검사
    $(".form-check").on("submit", function(){
    	state.messageReceiverValid = $("input[name=messageReceiver]").length > 0;
        $(this).find("input[name], textarea[name]").trigger("blur");
        return state.ok();
    });
	
	//태그 삭제
    $(".receiver-selected-list").on("click", ".delete-tag", function(){
        $(this).closest(".receiver-tag").remove();
    });
});
</script>

<form action="./write" method="post" autocomplete="off" class="form-check">
	<div class="container w-800 mt-50 mb-50">
		<!-- 페이지 제목 -->
		<div class="cell center">
			<h1 class="mt-0 mb-0">쪽지 보내기</h1>
		</div>
		
		<!-- 경고문 -->
		<div class="cell center mt-10">
			<i class="fa-solid fa-circle-exclamation fa-fade red"></i>
			타인에 대한 무분별한 비방글과 업무와 상관없는 내용들은 재제를 받을 수 있습니다.
		</div>
	
		<!-- 제목 입력창 -->
		<div class="cell mt-40">
			<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="messageTitle" value="${replyTitle}" class="field w-100">
			<div class="fail-feedback">[필수] 제목을 입력해주세요.</div>
		</div>
	
		<!-- 받는이 입력창 -->
		<div class="cell receiver-wrapper">
			<label>받는이 <i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="receiverKeyword" class="field">
			<button type="button" class="btn btn-neutral ms-10 open-search">
                <i class="fa-solid fa-user-tie"></i>
                <span>찾기</span>
            </button>
			<div class="receiver-selected-list">
			    <c:if test="${messageDto != null}">
			        <span class="receiver-tag">
			            ${messageDto.senderName}
			
			            <button type="button" class="delete-tag">
			                ✕
			            </button>
			
			            <input type="hidden"
			                   name="messageReceiver"
			                   value="${messageDto.messageSender}">
			        </span>
			    </c:if>
			</div>
            <!-- 사원 검색 모달 -->
            <jsp:include page="/WEB-INF/views/template/employee-picker.jsp"/>
            <!-- 해당 모달 JS -->
            <script src="/js/employee-picker.js"></script>
			<div class="receiver-list"></div>
			
			<div class="fail-feedback">[필수] 받는이를 입력하세요.</div>
		</div>
	
		<!-- 내용 입력창 -->
		<div class="cell">
			<label>내용 <i class="fa-solid fa-asterisk red"></i> </label>
			<textarea name="messageContent" rows="10" class="field w-100"></textarea>
			<div class="right">
			    <span>0</span> / 1000
			</div>
			<div class="fail-feedback">[필수] 내용을 입력하세요.</div>
		</div>
		
		<!-- 목록/등록 버튼 -->
		<div class="cell mt-50 right">
			<a href="./list" class="btn btn-negative">
				<i class="fa-solid fa-x"></i>
				<span>취소</span>
			</a>
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-paper-plane"></i>
				<span>보내기</span>
			</button>
		</div>
	</div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>