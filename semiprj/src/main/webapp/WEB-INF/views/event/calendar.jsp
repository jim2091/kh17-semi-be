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
    
    // 1. 캘린더 인스턴스 생성
    const calendar = new Calendar('#calendar', {
        defaultView: 'month', 
        useFormPopup: false,   
        useDetailPopup: false  
    });
    function formatDate(date){
        const y = date.getFullYear();
        const m = String(date.getMonth()+1).padStart(2,'0');
        const d = String(date.getDate()).padStart(2,'0');
        const h = String(date.getHours()).padStart(2,'0');
        const min = String(date.getMinutes()).padStart(2,'0');

        return `${y}-${m}-${d}T${h}:${min}`;
    }
    
    calendar.on('selectDateTime', function(e){

        $("[name=eventStart]").val(
            formatDate(e.start)
        );

        $("[name=eventEnd]").val(
        		formatDate(e.end)
        );

        $(".modal").show();
    });
    
    calendar.on('clickEvent', function(e){

        $(".detail-title").val(e.event.title);
        $(".detail-content").val(e.event.raw.content);
        $(".detail-start").val(
        		e.event.start
            );

        $(".detail-end").val(
        		e.event.end
        );
        $(".detail-category").val(e.event.calendarId);
        
        console.log(e.event.start);
        console.log(e.event.end);

        $(".detail-modal").show();
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
            <input type="text" class="field w-100 detail-title" readonly>
        </div>

        <div class="cell">
            <label>내용</label>
            <textarea class="field w-100 detail-content" readonly></textarea>
        </div>

        <div class="cell">
            <label>시작일시</label>
            <input type="text" class="field w-100 detail-start" readonly>
        </div>

        <div class="cell">
            <label>종료일시</label>
            <input type="text" class="field w-100 detail-end" readonly>
        </div>

        <div class="cell">
            <label>분류</label>
            <input type="text" class="field w-100 detail-category" readonly>
        </div>

        <button type="button" class="btn btn-neutral detail-close-btn">
            닫기
        </button>

    </div>
</div>






<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>