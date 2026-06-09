<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_event.jsp"></jsp:include>

  
    <link rel="stylesheet" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css" />
    <link rel="stylesheet" href="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.css" />
    <link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />
<style>
	.modal, .detail-modal{
    display:none;

    position:fixed;
    top:0;
    left:0;

    width:100%;
    height:100%;

    background-color:rgba(0,0,0,0.4);

    z-index:9999;
}

.modal-content{
    width:500px;

    background:white;

    margin:100px auto;
    padding:20px;
}
</style>
<div class="container w-80">

    <h2><i class="fa-solid fa-calendar"></i> 일정 관리 시스템</h2>
    <div id="calendar" style="height: 700px;"></div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.min.js"></script>

    <script src="https://uicdn.toast.com/tui.time-picker/latest/tui-time-picker.min.js"></script>
    <script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.min.js"></script>

    <script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>


    
    <script>
    const Calendar = tui.Calendar;
    let currentEventNo = null;
    
    
    // 1. 캘린더 인스턴스 생성
    const calendar = new Calendar('#calendar', {
        defaultView: 'month', 
        useFormPopup: false,   
        useDetailPopup: false  
    });
    function formatDate(date){

        if (!date || !(date instanceof Date) || isNaN(date.getTime())) {
            return "";
        }

        const y = date.getFullYear();
        const m = String(date.getMonth()+1).padStart(2,'0');
        const d = String(date.getDate()).padStart(2,'0');
        const h = String(date.getHours()).padStart(2,'0');
        const min = String(date.getMinutes()).padStart(2,'0');

        return y + "-" + m + "-" + d + "T" + h + ":" + min;
    }
    
    calendar.on('selectDateTime', function(e){
    	const start = formatDate(e.start);
    	//console.log("new start =", start);

    	$("[name=eventStart]").val(start);

        //$("[name=eventStart]").val(formatDate(e.start));

        $("[name=eventEnd]").val(formatDate(e.end));
        

        $(".modal").show();
    });
    
    
    
    // 2. [조회] 페이지가 로드되자마자 스프링에서 데이터를 받아와 달력에 뿌리기
    $(document).ready(function() {
        $.ajax({
            url: '/event/api/events', // 스프링 부트에서 만들 조회 API 주소
            type: 'GET',
            dataType: 'json',
            success: function(data) {
            	
            	 const events = data.map(function(item){
            	        return {
            	            id: item.eventNo,
            	            calendarId: item.eventCategory,
            	            title: item.eventTitle,
            	            category: item.eventOption,
            	            start: item.eventStart,
            	            end: item.eventEnd,
            	            
            	            raw : {
            	                content : item.eventContent
            	            }
            	            
            	        };
            	    });


            	    calendar.createEvents(events);
            	
            },
            error: function(xhr, status, error) {
                console.error("일정 조회 실패:", error);
            }
        });
    });
   
    calendar.on('clickEvent', function(e){
        currentEventNo = e.event.id;

        $(".detail-title").val(e.event.title);
        $(".detail-content").val(e.event.raw.content);
        
        const start = formatDate(e.event.start.toDate());

        $(".detail-start").val(start);
        
        
        const end = formatDate(e.event.start.toDate());
            
        $(".detail-end").val(end);
        
        $(".detail-category").val(e.event.calendarId);
        


        $(".detail-modal").show();
    });
   
	$(function(){
		
	$(".detail-close-btn").click(function(){
	    $(".detail-modal").hide();
	});
    $(".close-btn").click(function(){
        $(".modal").hide();
    });
    $(".save-btn").click(function(){

        const data = {
            eventTitle : $("[name=eventTitle]").val(),
            eventContent : $("[name=eventContent]").val(),
            eventCategory : $("[name=eventCategory]").val(),
            eventStart : $("[name=eventStart]").val(),
            eventEnd : $("[name=eventEnd]").val(),
            eventOption : "time",
            eventOrigin : "${sessionScope.loginNo}"
        };

        $.ajax({
            url : "/event/rest/event",
            type : "post",
            contentType : "application/json",
            data : JSON.stringify(data),

            success : function(response){
                alert("등록 완료");
                
                calendar.createEvents([
                    {
                        id : response.eventNo,
                        title : data.eventTitle,
                        category : "time",
                        start : data.eventStart,
                        end : data.eventEnd, 
                        
                        raw : {
                            content : data.eventContent
                        }
                        
                    }
                ]);
                $(".modal").hide();
            }
        });
    });
    
    $(".edit-btn").click(function(){
        

        const data = {
            eventNo : currentEventNo,
            eventTitle : $(".detail-title").val(),
            eventContent : $(".detail-content").val(),
            
                
            
            eventStart : $(".detail-start").val(),
            eventEnd : $(".detail-end").val(),
            
            eventCategory : $(".detail-category").val(), 
            eventOption : "time"
        };
        console.log("start=", $(".detail-start").val());
        console.log("end=", $(".detail-end").val());

        $.ajax({
            url : "/event/rest/event",
            type : "put",
            contentType : "application/json",
            data : JSON.stringify(data),

            success : function(){
                alert("수정 완료");

                location.reload();
            },
            error: function(xhr, status, error) {
                console.error("수정 실패:", error);
                alert("수정 중 오류가 발생했습니다.");
            }
        });
    });
    
    $(".delete-btn").click(function(){

        if(!confirm("정말 삭제하시겠습니까?")){
            return;
        }

        $.ajax({
            url : "/event/rest/event",
            type : "delete",
            data : {
                eventNo : currentEventNo
            },

            success : function(){
                alert("삭제 완료");
                location.reload();
            },

            error : function(){
                alert("삭제 실패");
            }
        });
    });
	});
    
    
            
    </script>
    </div>
<div class="container modal">
    <div class="modal-content">

        <h3>일정 등록</h3>

        <div class="cell">
            <label>일정 제목</label>
            <input type="text" name="eventTitle" class="field w-100">
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>

        <div class="cell">
            <label>일정 내용</label>
            <textarea name="eventContent" class="field w-100"></textarea>
        </div>

        <div class="cell">
            <label>시작일시</label>
            <input type="datetime-local" name="eventStart" class="field w-100">
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>

        <div class="cell">
            <label>종료일시</label>
            <input type="datetime-local" name="eventEnd" class="field w-100">
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>

        <div class="cell">
            <label>일정 분류</label>
            <select name="eventCategory" class="field w-100">
                <option value="개인일정">개인일정</option>
                <option value="사내일정">사내일정</option>
            </select>
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>

        <button type="submit" class="btn btn-positive save-btn">저장</button>
        <button type="button" class="btn btn-neutral close-btn">닫기</button>

    </div>
</div>

<div class="container detail-modal">
    <div class="modal-content">

        <h3>일정 상세정보</h3>

        <div class="cell">
            <label>제목</label>
            <input type="text" class="field w-100 detail-title">
        </div>

        <div class="cell">
            <label>내용</label>
            <textarea class="field w-100 detail-content"></textarea>
        </div>

        <div class="cell">
            <label>시작일시</label>
            <input type="datetime-local" class="field w-100 detail-start">
        </div>

        <div class="cell">
            <label>종료일시</label>
            <input type="datetime-local" class="field w-100 detail-end">
        </div>

        <div class="cell">
            <label>분류</label>
            <input type="text" class="field w-100 detail-category">
        </div>

		<button type="button" class="btn btn-positive edit-btn">
    		수정
		</button>
		<button type="button" class="btn btn-negative delete-btn">
    		삭제
		</button>
        <button type="button" class="btn btn-neutral detail-close-btn">
            닫기
        </button>

    </div>
</div>






<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>