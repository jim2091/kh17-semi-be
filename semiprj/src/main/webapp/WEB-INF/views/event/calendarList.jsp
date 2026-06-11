<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>


<div class="gw-page-head">
    <div class="gw-breadcrumb">
        일정 > 일정 목록
    </div>

    <h1>일정 목록</h1>
    <p>등록된 일정을 조회하고 검색할 수 있습니다.</p>
</div>

<div class="container w-80">

    <div class="gw-list-panel">

        <form action="./calendarList" method="get"
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

    <div class="gw-list-panel mt-20">

        <table class="gw-table">
            <thead>
                <tr>
                    <th width="100">번호</th>
                    <th width="280">시간</th>
                    <th width="250">분류 / 제목</th>
                    <th>내용</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="eventDto" items="${list}">
                    <tr>
                        <td>${eventDto.eventNo}</td>
                        <td>
                            ${eventDto.eventStart}
                            <br>
                            ~
                            <br>
                            ${eventDto.eventEnd}
                        </td>
                        <td>
                            ${eventDto.eventTitle}
                        </td>
                        <td style="text-align:left;">
                            ${eventDto.eventContent}
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty list}">
                    <tr>
                        <td colspan="4" class="center">
                            등록된 일정이 없습니다.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

    </div>

</div>










<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>