<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<div style="padding:30px;">

    <%-- 탭 네비게이션 --%>
    <div style="display:flex; gap:0; margin-bottom:24px; border-bottom:2px solid var(--main-color);">
        <a href="/app/list"
           style="padding:12px 28px; text-decoration:none; font-size:14px; font-weight:600;
                  background:#f8f9fa; color:#888; border-radius:8px 8px 0 0;">
            📄 기안 문서함
        </a>
        <a href="/appr/list"
           style="padding:12px 28px; text-decoration:none; font-size:14px; font-weight:600;
                  background:var(--main-color); color:white; border-radius:8px 8px 0 0;">
            ✅ 결재 문서함
        </a>
    </div>

    <%-- 검색 영역 --%>
    <div style="background:white; border-radius:10px; padding:16px 20px;
                box-shadow:0 1px 4px rgba(0,0,0,0.08); margin-bottom:16px;">
        <form action="/appr/list" method="get" style="display:flex; gap:8px; align-items:center;">
            <select name="column"
                    style="padding:8px 12px; border:1px solid #ddd;
                           border-radius:6px; font-size:13px;">
                <option value="app_line_type"
                    ${param.column == 'app_line_type'   ? 'selected' : ''}>문서종류</option>
                <option value="app_line_status"
                    ${param.column == 'app_line_status' ? 'selected' : ''}>진행상황</option>
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
                <c:forEach var="line" items="${list}">
                    <tr style="border-bottom:1px solid #f0f0f0; cursor:pointer;"
                        onmouseover="this.style.background='#f8f9ff'"
                        onmouseout="this.style.background='white'"
                        onclick="location.href='/appr/detail?appId=${line.appId}'">
                        <td style="padding:14px 16px;">${line.reqEmpName}</td>
                        <td style="padding:14px 16px;">${line.appLineType}</td>
                        <td style="padding:14px 16px;">${line.appTitle}</td>
                        <td style="padding:14px 16px; color:#888;">${line.appDate}</td>
                        <td style="padding:14px 16px; text-align:center;">
                            <c:choose>
                                <c:when test="${line.appLineStatus == '완료'}">
                                    <span style="background:#e8f5e9; color:#2e7d32;
                                                 padding:4px 10px; border-radius:20px;
                                                 font-size:12px; font-weight:600;">완료</span>
                                </c:when>
                                <c:when test="${line.appLineStatus == '반려'}">
                                    <span style="background:#ffebee; color:#c62828;
                                                 padding:4px 10px; border-radius:20px;
                                                 font-size:12px; font-weight:600;">반려</span>
                                </c:when>
                                <c:when test="${line.appLineStatus == '진행중'}">
                                    <span style="background:#fff8e1; color:#f57f17;
                                                 padding:4px 10px; border-radius:20px;
                                                 font-size:12px; font-weight:600;">진행중</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="background:#f5f5f5; color:#999;
                                                 padding:4px 10px; border-radius:20px;
                                                 font-size:12px; font-weight:600;">대기</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="5"
                            style="padding:40px; text-align:center; color:#aaa;">
                            결재할 문서가 없습니다.
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
</div>