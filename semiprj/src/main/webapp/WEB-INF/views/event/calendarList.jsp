<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
	.event-category {
	    display: inline-flex;
	    justify-content: center;
	    min-width: 58px;
	    padding: 5px 9px;
	    border-radius: 999px;
	    background: var(--main-light);
	    color: var(--main-color);
	    font-size: 12px;
	    font-weight: 900;
	}
	.event-title{
	    font-weight:700;
	    color:#1e3a8a;
	}
	.event-content{
	    max-width:300px;
	    overflow:hidden;
	    text-overflow:ellipsis;
	    white-space:nowrap;
	}
</style>

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">
	        홈 / 일정 / 일정 목록
	    </div>
	    <h1>일정 목록</h1>
	    <p>등록된 일정을 조회하고 검색할 수 있습니다.</p>
	</div>

    <div class="gw-search-panel">
        <form action="./calendarList" method="get" class="gw-search-form"
              style="display:flex; gap:10px; flex-wrap:wrap; align-items:center;">

            <select name="sort"
                    class="gw-form-select"
                    onchange="this.form.submit();">
                <option value="event_no" ${param.sort == 'event_no' ? 'selected' : ''}>작성순</option>
                <option value="event_start1" ${param.sort == 'event_start1' ? 'selected' : ''}>일정순</option>
                <option value="event_start2" ${param.sort == 'event_start2' ? 'selected' : ''}>오래된 순</option>
            </select>

            <select name="column" class="gw-form-select">
                <option value="event_title" ${param.column == "event_title" ? "selected" : ""}>제목</option>
                <option value="event_content" ${param.column == "event_content" ? "selected" : ""}>내용</option>
            </select>

            <input type="text"
                   name="keyword"
                   value="${param.keyword}"
                   placeholder="검색어 입력"
                   class="gw-form-input">

            <button type="submit" class="gw-btn-primary">
                <i class="fa-solid fa-magnifying-glass"></i>
                검색
            </button>
        </form>
    </div>

    <div class="gw-list-panel">
    	<div class="gw-table-top">
		    <div>
		        <div class="gw-table-title">일정 목록</div>
		        <div class="gw-table-sub">
		            총 ${pageVO.count}개의 일정
		        </div>
		    </div>
		</div>
        <table class="gw-table">
            <thead>
                <tr>
                    <th style="width:25%;">일정 기간</th>
                    <th style="width:35%;">일정 제목</th>
                    <th style="width:40%;">일정 내용</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="eventDto" items="${list}">
                    <tr>
                        <td>
                        	<fmt:formatDate
	    						value="${eventDto.eventStart}"
	    						pattern="yyyy-MM-dd HH:mm"/>
                            <br>
                            ~
                            <br>
                            <fmt:formatDate
	    						value="${eventDto.eventEnd}"
	    						pattern="yyyy-MM-dd HH:mm"/>
                        </td>
                        <td style="text-align:left;">
                        	<span class="event-category">
                        		${eventDto.eventCategory}
                        	</span>
                            ${eventDto.eventTitle}
                        </td>
                        <td class="event-content" style="text-align:left;">
                            ${eventDto.eventContent}
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty list}">
                    <tr>
                        <td colspan="4" style="padding:40px;text-align:center;color:#aaa;">
			            등록된 일정이 없습니다.
			        	</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>