<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.event-title-row{
    display:flex;
    align-items:center;
    gap:12px;
    margin-top:10px;
}

.event-title-row h1{
    margin:0;
    font-size:32px;
    font-weight:700;
    color:#0f172a;
}

.event-category{
    display:inline-flex;
    align-items:center;

    padding:6px 12px;

    border-radius:999px;

    font-size:13px;
    font-weight:600;

    background:#f3e8ff;
    color:#7c3aed;
}
.event-category.personal{
    background:#eef4ff;
    color:#5b8def;
}

.event-category.department{
    background:#eafaf1;
    color:#27ae60;
}

.event-category.company{
    background:#fff3e8;
    color:#f2994a;
}
</style>

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 / 일정 / 상세보기</div>
	    <div class="event-title-row">
		    <span class="event-category
				<c:choose>
				    <c:when test="${eventDto.eventCategory eq '개인일정'}">
				        personal
				    </c:when>
				    <c:when test="${eventDto.eventCategory eq '부서일정'}">
				        department
				    </c:when>
				    <c:otherwise>
				        company
				    </c:otherwise>
				</c:choose>">
				    ${eventDto.eventCategory}
				</span>
		    <h1>${eventDto.eventTitle}</h1>
		</div>
	</div>
	
	<div class="gw-form-panel">
		<div class="gw-detail-info">
			<div class="gw-detail-meta">
			<span>
				<i class="fa-regular fa-user"></i>
				<span class="gw-muted">등록자</span>&nbsp;&nbsp;:&nbsp;
				${eventDto.empName}
			</span>
			</div>
		</div>
		<div class="gw-detail-info">
			<div class="gw-detail-meta">
			<span>
				<i class="fa-regular fa-calendar"></i>
				<span class="gw-muted">기간</span>&nbsp;&nbsp;:&nbsp;
				<fmt:formatDate value="${eventDto.eventStart}" pattern="yyyy-MM-dd HH:mm"/>
				&nbsp;~&nbsp;
				<fmt:formatDate value="${eventDto.eventEnd}" pattern="yyyy-MM-dd HH:mm"/>
			</span>
			</div>
		</div>
	
	<div class="gw-form-row">
		<label class="gw-form-label">내용</label>
        <div class="gw-content-box">
            <pre>${eventDto.eventContent}</pre>
        </div>
    </div>
    
    <div class="gw-form-actions">
	    <a href="./calendarList" class="gw-btn-outline">
	    	<i class="fa-solid fa-list"></i>목록으로
	    </a>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>