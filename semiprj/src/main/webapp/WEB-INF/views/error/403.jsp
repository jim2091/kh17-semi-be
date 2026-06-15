<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/template/header2.jsp"/>
    
<style>
	.error-panel{
	    max-width:700px;
	    margin:50px auto;
	    padding:60px 40px;
	    background:white;
	    border:1px solid #e5e7eb;
	    border-radius:16px;
	    text-align:center;
	}
	
	.error-icon{
	    width:90px;
	    height:90px;
	    margin:0 auto 24px;
	    border-radius:50%;
	    background:#fff7ed;
	    color:#f97316;
	    display:flex;
	    align-items:center;
	    justify-content:center;
	}
	
	.error-title{
	    font-size:28px;
	    font-weight:700;
	    color:#111827;
	    margin-bottom:12px;
	}
	
	.error-desc{
		font-size:15px;
	    color:#6b7280;
	    line-height:1.7;
	    margin-bottom:32px;
	}
	
	.error-actions{
	    margin-top:40px;
	    display:flex;
	    justify-content:center;
	    gap:12px;
	}
</style>

<div class="error-panel">
	<div class="error-icon">
		<i class="fa-solid fa-user-slash fa-2x"></i>
	</div>
	
	<div class="error-title">
		접근이 제한되었습니다.
	</div>
	<div class="error-desc">
		해당 기능은 이용하실 수 없습니다.
	</div>
	
	<div class="error-actions">
		<a href="javascript:history.back();" class="gw-btn-primary">
		    <span>이전 페이지</span>
		</a>
		<a href="/" class="gw-btn-outline">
		    <span>홈으로 이동</span>
		</a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>