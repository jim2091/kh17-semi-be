<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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
    width:600px;
    margin:80px auto;
}
.calendar-header{
    display:flex;
    align-items:center;
    gap:10px;
    margin-bottom:15px;
}

.current-month{
    font-size:20px;
    font-weight:bold;
    min-width:120px;
    text-align:center;
}


.modal-icon{
    width:90px;
    height:90px;
    margin:0 auto 24px;
    border-radius:50%;
    background:#eff6ff;
    color:#2563eb;
    display:flex;
    align-items:center;
    justify-content:center;
}

.modal .modal-content,
.detail-modal .modal-content{
    width: 700px;
    max-width: 90vw;
    padding: 35px 40px;
    border-radius: 24px;
    background: #fff;
    box-shadow: 0 10px 40px rgba(15,23,42,.12);
}
.detail-header{
    margin-bottom:30px;
    text-align:center;
}

.detail-header h2{
    margin:0;
    font-size:32px;
    font-weight:800;
    color:#0f172a;
}

.detail-header p{
    margin-top:8px;
    color:#64748b;
    font-size:14px;
}
.detail-item{
    margin-bottom:18px;
}

.detail-item label{
    display:block;

    margin-bottom:8px;

    font-size:14px;
    font-weight:700;

    color:#334155;
}
.detail-item input,
.detail-item textarea,
.detail-item select{
    width:100%;
    border:1px solid #dbe3ee;

    border-radius:14px;

    padding:13px 16px;

    background:#f8fafc;

    transition:.2s;
}
.detail-row{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:16px;
}
.color-picker{
    display:flex;
    align-items:center;
    gap:12px;
    margin-top:8px;
}

.color-picker input[type=radio]{
    display:none;
}

.color-circle{
    width:24px;
    height:24px;
    border-radius:50%;
    display:inline-block;
    cursor:pointer;
    border:2px solid transparent;
    transition:0.2s;
}

.blue{ background:#60A5FA; }
.green{ background:#6FCF97; }
.purple{ background:#B197FC; }
.orange{ background:#F6B26B; }
.red{ background:#F28B82; }
.gray{ background:#A0AEC0; }

.color-picker input[type=radio]:checked + .color-circle{
    transform:scale(1.2);
    border:3px solid #222;
}
</style>

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">
	        홈 / 일정 / 캘린더
	    </div>
	    <h1>캘린더</h1>
	    <p>개인 일정과 사내 일정을 등록하고 관리할 수 있습니다.</p>
	</div>

	<div class="gw-list-panel">
	    <div style="
	        display:flex;
	        align-items:center;
	        justify-content:center;
	        gap:10px;
	        flex-wrap:wrap;
	    ">

	        <button type="button" class="gw-btn-outline btn-prev">
	            <i class="fa-solid fa-caret-left"></i>
	        </button>
	
	        <span class="current-month"
	              style="
	                font-size:22px;
	                font-weight:700;
	                min-width:140px;
	                text-align:center;
	              ">
	        </span>
	
	        <button type="button" class="gw-btn-outline btn-next">
	            <i class="fa-solid fa-caret-right"></i>
	        </button>
	
	        <button type="button" class="gw-btn-primary btn-today">
	            오늘
	        </button>
	    </div>
	</div>
		
	<div class="gw-list-panel">
	    <div id="calendar" style="height:700px;"></div>
	</div>
    
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
    
    function updateMonth() {
        const date = calendar.getDate();
        $(".current-month").text(
            date.getFullYear() + "년 " +
            (date.getMonth() + 1) + "월"
        );
    }

    updateMonth();
    
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
            	            backgroundColor : item.eventColor,
            	            borderColor : item.eventColor,
            	            
            	            raw : {
            	                content : item.eventContent,
            	                color : item.eventColor,
            	                empName : item.empName,
            	                deptName : item.deptName
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
        $(".detail-writer").text(e.event.raw.empName);
        $(".detail-dept").text(e.event.raw.deptName);
        
        const start = formatDate(e.event.start.toDate());
        $(".detail-start").val(start);

        const end = formatDate(e.event.end.toDate());
        $(".detail-end").val(end);
        
        $(".detail-category").val(e.event.calendarId);
        
        $("input[name='eventColor'][value='" +
        		e.event.raw.color +
        		"']").prop("checked", true);
       
        $(".detail-modal").show();
    });
   
	$(function(){
		$(".btn-prev").click(function(){
		    calendar.prev();
		    updateMonth();
		});

		$(".btn-next").click(function(){
		    calendar.next();
		    updateMonth();
		});

		$(".btn-today").click(function(){
		    calendar.today();
		    updateMonth();
		});

	$(".detail-close-btn").click(function(){
	    $(".detail-modal").hide();
	});
	
    $(".close-btn").click(function(){
        $(".modal").hide();
        calendar.unselect();
    });
    
    $(".save-btn").click(function(){
        const data = {
            eventTitle : $("[name=eventTitle]").val(),
            eventContent : $("[name=eventContent]").val(),
            eventCategory : $("[name=eventCategory]").val(),
            eventStart : $("[name=eventStart]").val(),
            eventEnd : $("[name=eventEnd]").val(),
            eventOption : "time",
            eventOrigin : "${sessionScope.loginNo}",
            eventColor : $("[name=eventColor]:checked").val(),
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
                        backgroundColor : data.eventColor,
                        borderColor : data.eventColor,
                        
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
            eventOption : "time",
            eventColor :
                $("input[name='eventColor']:checked").val()
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
    $(".modal").click(function(e){
        if($(e.target).hasClass("modal")){
            $(".modal").hide();
            calendar.unselect();
        }
    });
	});
    
    
            
    </script>
    
<div class="modal">
	<div class="gw-list-panel modal-content">
		<div class="modal-icon">
			<i class="fa-regular fa-calendar-check fa-2x"></i>
		</div>
		
		<div class="detail-header">
			<div>
				<h2>일정 등록</h2>
		        <p>새로운 일정을 등록할 수 있습니다.</p>
		    </div>
		</div>

        <div class="detail-item">
            <label>일정 제목</label>
            <input type="text" name="eventTitle" class="gw-form-input field">
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>

        <div class="detail-item">
            <label>일정 내용</label>
            <textarea name="eventContent" class="gw-form-input field"></textarea>
        </div>

		<div class="detail-row">
	        <div class="detail-item">
	            <label>시작 일시</label>
	            <input type="datetime-local" name="eventStart" class="gw-form-input field">
	            <div class="success-feedback"></div>
	            <div class="fail-feedback"></div>
	        </div>
	
	        <div class="detail-item">
	            <label>종료 일시</label>
	            <input type="datetime-local" name="eventEnd" class="gw-form-input field">
	            <div class="success-feedback"></div>
	            <div class="fail-feedback"></div>
	        </div>
		</div>

        <div class="detail-item">
            <label>일정 분류</label>
            <select name="eventCategory" class="gw-form-input field">
                <option value="개인일정">개인일정</option>
                <option value="부서일정">부서일정</option>
                <c:if test="${sessionScope.empLevel == '관리자'}">
				    <option value="사내일정">사내일정</option>
				</c:if>
            </select>
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>
        
        <div class="detail-item">
		    <label>일정 색상</label>
			<div class="color-picker">
			    <label>
			        <input type="radio" name="eventColor" value="#3B82F6" checked>
			        <span class="color-circle blue"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value="#22C55E">
			        <span class="color-circle green"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value="#8B5CF6">
			        <span class="color-circle purple"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value="#F97316">
			        <span class="color-circle orange"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value="#EF4444">
			        <span class="color-circle red"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value="#6B7280">
			        <span class="color-circle gray"></span>
			    </label>
			</div>
		</div>

        <div style="
		    display:flex;
		    justify-content:center;
		    gap:10px;
		    margin-top:30px;
		">
		
		    <button type="button" class="gw-btn-primary save-btn">
		    	<i class="fa-regular fa-floppy-disk"></i>
		        저장
		    </button>
		
		    <button type="button" class="gw-btn-outline close-btn">
				<i class="fa-solid fa-xmark"></i>
		        닫기
		    </button>
		</div>
    </div>
</div>

<div class="detail-modal">
	<div class="gw-list-panel modal-content">
		<div class="modal-icon">
			<i class="fa-regular fa-calendar-check fa-2x"></i>
		</div>
       
		<div class="detail-header">
			<div>
				<h2>일정 상세정보</h2>
		        <p>등록된 일정 정보를 확인하거나 수정할 수 있습니다.</p>
		    </div>
		</div>

        <div class="detail-item">
			<label>일정 제목</label>
            <input type="text" class="gw-form-input field detail-title">
        </div>

        <div class="detail-item">
			<label>일정 내용</label>
            <textarea class="gw-form-input field detail-content" rows="4"></textarea>
        </div>
		
		<div class="detail-row">
	        <div class="detail-item">
	            <label>시작 일시</label>
	            <input type="datetime-local" class="gw-form-input field detail-start">
	        </div>
	
	        <div class="detail-item">
	            <label>종료 일시</label>
	            <input type="datetime-local" class="gw-form-input field detail-end">
	        </div>
	    </div>

        <div class="detail-item">
        	<label>일정 분류</label>
            <select class="gw-form-select detail-category">
                <option value="개인일정">개인일정</option>
                <option value="부서일정">부서일정</option>
                <c:if test="${sessionScope.empLevel == '관리자'}">
				    <option value="사내일정">사내일정</option>
				</c:if>
            </select>
        </div>
        
        <div class="detail-item">
		    <label>일정 색상</label>
			<div class="color-picker">
			    <label>
			        <input type="radio" name="eventColor" value="#60A5FA" checked>
			        <span class="color-circle blue"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value="#6FCF97">
			        <span class="color-circle green"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value=#B197FC>
			        <span class="color-circle purple"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value="#F6B26B">
			        <span class="color-circle orange"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value="#F28B82">
			        <span class="color-circle red"></span>
			    </label>
			
			    <label>
			        <input type="radio" name="eventColor" value="#A0AEC0">
			        <span class="color-circle gray"></span>
			    </label>
			</div>
		</div>

		<div style="
		    display:flex;
		    justify-content:center;
		    gap:10px;
		    margin-top:30px;
		    flex-wrap:wrap;
		">
		
		    <button type="button"
		            class="gw-btn-primary edit-btn">
		        <i class="fa-solid fa-pen"></i>
		        수정
		    </button>
		
		    <button type="button"
		            class="gw-btn-danger delete-btn">
		        <i class="fa-solid fa-trash"></i>
		        삭제
		    </button>
		
		    <button type="button"
		            class="gw-btn-outline detail-close-btn">
		        <i class="fa-solid fa-xmark"></i>
		        닫기
		    </button>
		</div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>