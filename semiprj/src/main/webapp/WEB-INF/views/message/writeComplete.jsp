<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.success-panel{
    max-width:700px;
    margin:50px auto;

    padding:60px 40px;

    background:white;

    border:1px solid #e5e7eb;
    border-radius:16px;

    text-align:center;
}

.success-icon{
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

.success-title{
    font-size:28px;
    font-weight:700;
    color:#111827;
    margin-bottom:12px;
}

.success-desc{
    font-size:15px;
    color:#6b7280;
    line-height:1.7;
    margin-bottom:32px;
}

.success-actions{
    display:flex;
    justify-content:center;
    gap:12px;
}
</style>

	<div class="success-panel">
	    <div class="success-icon">
	        <i class="fa-solid fa-circle-check fa-2x"></i>
	    </div>
	
	    <div class="success-title">
	        쪽지를 성공적으로 보냈습니다!
	    </div>
	    <div class="success-desc">
	        수신자에게 쪽지가 정상적으로 전달되었습니다.<br>
	        잠시 후 받은 쪽지함으로 이동합니다.
	    </div>
	
	    <div class="success-actions">
	        <a href="./write" class="gw-btn-primary">
	            <span>추가로 보내기</span>
	        </a>
	    </div>
	</div>
	
<script>
setTimeout(function(){
    location.href="./receiveList";
}, 3000);
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>