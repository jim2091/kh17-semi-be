<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home2.jsp"></jsp:include>

<style>
    .search-wrapper {
        display: flex;
        align-items: center;
        gap: 6px;
    }
    
    .search-wrapper select,
    .search-wrapper input {
        height: 42px;
        padding: 0 12px;
        border: 1px solid var(--border-color);
        border-radius: 6px;
        background-color: var(--card-bg);
        color: var(--text-color);
        font-size: 14px;
        box-sizing: border-box;
    }
    .gw-table-link:hover {
        color: var(--main-dark) !important;
        transform: translate(4px, -1px); 
        text-decoration: none !important; 
    }
    
    .head-link {
        display: inline-block;
        color: var(--list-text-color) !important;
        font-weight: 500;
        text-decoration: none !important; 
        transition: all 0.2s ease-in-out;
    }

    .head-link:hover {
        color: var(--main-color) !important; 
        transform: translate(0, -2px); 
        text-decoration: none !important; 
    }

</style>

<script>
$(function() {
	var savedTheme = localStorage.getItem("gwTheme");

	if (savedTheme) {
		$("body").addClass(savedTheme);
	} else {
		$("body").addClass("theme-blue");
	}

	$(".theme-btn").click(function() {
		$(".theme-popup").toggle();
	});

	$(".theme-item").click(
			function() {
				var theme = $(this).data("theme");

				$("body").removeClass(
						"theme-blue theme-green theme-purple theme-dark")
						.addClass(theme);

				localStorage.setItem("gwTheme", theme);

				$(".theme-popup").hide();
			});

	$(".check-all").change(function() {
		$("input[name=pdsNoList]").prop("checked", this.checked);
	});

	$("input[name=pdsNoList]")
			.change(
					function() {
						$(".check-all")
								.prop(
										"checked",
										$("input[name=pdsNoList]").length == $("input[name=pdsNoList]:checked").length);
					});
});
</script>

<div class="gw-hero">
    <div>
        <h1>부서 목록 및 검색 🏢</h1>
        <p>회사의 부서 정보를 조회하고 체계적으로 관리할 수 있습니다.</p>
    </div>
</div>

<div class="gw-table-top mt-30">
    <div class="gw-table-title">
        <form action="./list" class="search-wrapper">
            <select name="column" class="gw-form-select">
                <option value="dept_name" ${param.column == "dept_name" ? "selected" : ""}>부서명</option>
                <option value="parent_dept_name" ${param.column == "parent_dept_name" ? "selected" : ""}>상위부서</option>
                <option value="dept_id" ${param.column == "dept_id" ? "selected" : ""}>부서코드</option>
            </select>
            <input type="text" name="keyword" class="gw-search input" placeholder="검색어 입력" value="${param.keyword}">
            <button type="submit" class="gw-btn-outline">
                <i class="fa-solid fa-magnifying-glass"></i> 검색
            </button>        
        </form>
    </div>

    <div class="gw-table-actions">
        <a href="./listTree" class="gw-btn-outline me-10">
            <i class="fa-solid fa-sitemap"></i> 조직도 보기
        </a>
        <c:if test="${loginRole != null && loginRole == '관리자'}">
            <a href="./insert" class="gw-btn-outline me-10" style="background: var(--main-color); color: #fff;">
                <i class="fa-solid fa-plus"></i> 부서 등록
            </a>
        </c:if>    	
    </div>
</div>

<div>
    <table class="gw-table">
        <thead>
            <tr>
                <th class="w-10">부서코드</th>
                <th class="w-25">상위부서</th>
                <th class="w-35">부서명</th>
                <th class="w-25">부서장</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="deptDto" items="${list}">
            <tr>
                <td><code style="font-weight: 600; color: var(--text-muted);">${deptDto.deptId}</code></td>
                
                <td>
                    <c:choose>
                        <c:when test="${deptDto.parentDeptId == 0}">
                            <span class="status wait" style="background:transparent; border: 1px solid var(--border-color); color: var(--text-muted);">없음</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status ing" style="background: var(--main-light); color: var(--main-color); font-weight: 600;">
                                ${deptDto.parentDeptName}
                            </span>
                        </c:otherwise>
                    </c:choose>
                </td>
                
                <td class="gw-title-cell" style="padding-left: 30px;">
                    <a href="./detail?deptId=${deptDto.deptId}" class="gw-table-link">
                        <i class="fa-regular fa-folder-open me-5"></i> ${deptDto.deptName}
                    </a>
                </td>
                
                <td>
                    <c:choose>
                        <c:when test="${deptDto.deptHeadName == null}">
                            <span class="empty-head">❌ 공석</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/emp/detail?empNo=${deptDto.deptHeadId}" class="head-link">
                                <i class="fa-solid fa-user-tie me-5" style="color: var(--text-muted);"></i> ${deptDto.deptHeadName}
                            </a>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            </c:forEach>
            
            <c:if test="${empty list}">
                <tr>
                    <td colspan="4" style="padding: 50px 0; color: var(--text-muted);">
                        <i class="fa-solid fa-triangle-exclamation fa-2x mb-10"></i><br>
                        검색 결과와 일치하는 부서가 존재하지 않습니다.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div> 

<div class="cell center mt-30">
    <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>