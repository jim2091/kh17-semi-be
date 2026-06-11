<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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
<div style="padding:30px;">
       <%-- 탭 네비게이션 --%>
    <div style="display:flex; gap:0; margin-bottom:24px; border-bottom:2px solid var(--main-color);">
        <a href="/app/list"
           style="padding:12px 28px; text-decoration:none; font-size:14px; font-weight:600;
                  background:var(--main-color); color:white; border-radius:8px 8px 0 0;">
             기안 문서함
        </a>
        <a href="/appr/list"
           style="padding:12px 28px; text-decoration:none; font-size:14px; font-weight:600;
                  background:#f8f9fa; color:#888; border-radius:8px 8px 0 0;">
             결재 문서함
        </a>
    </div>

        <%-- 문서 작성 버튼 그룹 --%>
        <div style="display:flex; gap:8px;">
            <a href="./vacInsert"
               style="padding:8px 16px; background:var(--main-color); color:white;
                      border-radius:6px; text-decoration:none; font-size:13px;">
                + 휴가신청서
            </a>
            <a href="./expInsert"
               style="padding:8px 16px; background:var(--main-color); color:white;
                      border-radius:6px; text-decoration:none; font-size:13px;">
                + 품의서
            </a>
            <a href="./dftInsert"
               style="padding:8px 16px; background:var(--main-color); color:white;
                      border-radius:6px; text-decoration:none; font-size:13px;">
                + 업무기안서
            </a>
        </div>
    </div>

    <%-- 검색 영역 --%>
    <div style="background:white; border-radius:10px; padding:16px 20px;
                box-shadow:0 1px 4px rgba(0,0,0,0.08); margin-bottom:16px;">
        <form action="./list" method="get" style="display:flex; gap:8px; align-items:center;">
            <input type="hidden" name="appType" value="${param.appType}">
            <select name="column"
                    style="padding:8px 12px; border:1px solid #ddd;
                           border-radius:6px; font-size:13px;">
                <option value="app_title"
                    ${param.column == 'app_title'  ? 'selected' : ''}>서류명</option>
                <option value="app_type"
                    ${param.column == 'app_type'   ? 'selected' : ''}>문서종류</option>
                <option value="app_status"
                    ${param.column == 'app_status' ? 'selected' : ''}>진행상황</option>
            </select>
            <input type="text" name="keyword" value="${param.keyword}"
                   placeholder="검색어 입력"
                   style="padding:8px 12px; border:1px solid #ddd;
                          border-radius:6px; font-size:13px; width:220px;">
            <button type="submit"
                    style="padding:8px 16px; background:var(--main-color); color:white;
                           border:none; border-radius:6px; font-size:13px; cursor:pointer;">
                🔍 검색
            </button>
        </form>
    </div>

    <%-- 목록 테이블 --%>
    <div style="background:white; border-radius:10px;
                box-shadow:0 1px 4px rgba(0,0,0,0.08); overflow:hidden;">
        <table style="width:100%; border-collapse:collapse; font-size:14px;">
            <thead>
                <tr style="border-bottom:2px solid var(--main-color);">
                    <th style="padding:14px 16px; text-align:left; font-weight:600;
                               color:var(--main-color);">기안자</th>
                    <th style="padding:14px 16px; text-align:left; font-weight:600;
                               color:var(--main-color);">문서종류</th>
                    <th style="padding:14px 16px; text-align:left; font-weight:600;
                               color:var(--main-color);">서류명</th>
                    <th style="padding:14px 16px; text-align:left; font-weight:600;
                               color:var(--main-color);">기안일</th>
                    <th style="padding:14px 16px; text-align:center; font-weight:600;
                               color:var(--main-color);">진행상황</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="appDto" items="${list}">
                    <tr style="border-bottom:1px solid #f0f0f0; cursor:pointer;"
                        onmouseover="this.style.background='#f8f9ff'"
                        onmouseout="this.style.background='white'"
                        onclick="location.href='./detail?appId=${appDto.appId}'">
                        <td style="padding:14px 16px;">${appDto.empName}</td>
                        <td style="padding:14px 16px;">${appDto.appType}</td>
                        <td style="padding:14px 16px;">${appDto.appTitle}</td>
                        <td style="padding:14px 16px; color:#888;">${appDto.appDate}</td>
                        <td style="padding:14px 16px; text-align:center;">
                            <c:choose>
                                <c:when test="${appDto.appStatus == '승인'}">
                                    <span style="background:#e8f5e9; color:#2e7d32;
                                                 padding:4px 10px; border-radius:20px;
                                                 font-size:12px; font-weight:600;">승인</span>
                                </c:when>
                                <c:when test="${appDto.appStatus == '반려'}">
                                    <span style="background:#ffebee; color:#c62828;
                                                 padding:4px 10px; border-radius:20px;
                                                 font-size:12px; font-weight:600;">반려</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="background:#fff8e1; color:#f57f17;
                                                 padding:4px 10px; border-radius:20px;
                                                 font-size:12px; font-weight:600;">처리중</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="5"
                            style="padding:40px; text-align:center; color:#aaa;">
                            문서가 없습니다.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <%-- 페이징 --%>
    <div style="margin-top:20px; text-align:center;">
        <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
    </div>
</div>