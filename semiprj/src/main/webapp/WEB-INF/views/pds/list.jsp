<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

	<div class="gw-page-head">
        <div class="gw-breadcrumb">홈 / 게시판 / 자료실</div>
        <h1>자료실</h1>
        <p>필요한 자료를 찾지 못한 경우 관리자에게 문의하세요</p>
    </div>

    <div class="gw-search-panel">
        <form action="./list" method="get" class="gw-search-form">
            <select name="column" class="gw-form-select">
                <option value="pds_title" ${param.column == 'pds_title' ? 'selected':''}>제목</option>
                <option value="title_content" ${param.column == 'title_content' ? 'selected':''}>제목+내용</option>
                <option value="pds_writer" ${param.column == 'pds_writer' ? 'selected':''}>작성자</option>
            </select>

            <input type="text" name="keyword" class="gw-form-input"
                   placeholder="검색어를 입력하세요." value="${param.keyword}">

            <button type="submit" class="gw-btn-primary">
                <i class="fa-solid fa-magnifying-glass"></i>
                <span>검색</span>
            </button>
        </form>
    </div>

    <form action="./deleteAll" method="post">
        <div class="gw-list-panel">

            <div class="gw-table-top">
                <div>
                    <div class="gw-table-title">자료 목록</div>
                    <div class="gw-table-sub">
                        ${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개의 글
                    </div>
                </div>

                <div class="gw-table-actions">
                    <c:if test="${sessionScope.loginRole == '관리자'}">
                        <a href="./write" class="gw-btn-outline">
                            <i class="fa-solid fa-pencil"></i>
                            <span>글쓰기</span>
                        </a>
                        <button type="submit" class="gw-btn-danger">
                            <i class="fa-regular fa-trash-can"></i>
                            <span>삭제하기</span>
                        </button>
                    </c:if>
                </div>
            </div>

            <table class="gw-table pds-table">
                <thead>
                    <tr>
                        <c:if test="${sessionScope.loginRole == '관리자'}">
                            <th class="gw-check-col">
                                <input type="checkbox" class="check-all">
                            </th>
                        </c:if>
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>조회수</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="pdsDto" items="${list}">
                        <tr>
                            <c:if test="${sessionScope.loginRole == '관리자'}">
                                <td class="gw-check-col">
                                    <input type="checkbox" name="pdsNoList" value="${pdsDto.pdsNo}">
                                </td>
                            </c:if>

                            <td>${pdsDto.pdsNo}</td>

                            <td class="gw-title-cell">
                                <a href="./detail?pdsNo=${pdsDto.pdsNo}&page=${pageVO.page}&${pageVO.searchParams}"
                                   class="gw-table-link">
                                    ${pdsDto.pdsTitle}
                                </a>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${pdsDto.pdsWriter == null}">
                                        <span class="gw-muted">(탈퇴한 사용자)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="/emp/detail?empNo=${pdsDto.pdsWriter}" class="gw-table-link">
                                            ${pdsDto.empName}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>${pdsDto.getPdsWtimeString()}</td>
                            <td>${pdsDto.pdsReadcount}</td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty list}">
                        <tr>
                            <td colspan="${sessionScope.loginRole == '관리자' ? 6 : 5}" class="gw-table-empty">
                                조회된 자료가 없습니다.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <div class="gw-pagination">
                <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
            </div>

        </div>
    </form>

</div>

<script>
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

    $(".check-all").change(function(){
        $("input[name=pdsNoList]").prop("checked", this.checked);
    });

    $("input[name=pdsNoList]").change(function(){
        $(".check-all").prop("checked",
            $("input[name=pdsNoList]").length == $("input[name=pdsNoList]:checked").length
        );
    });
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>