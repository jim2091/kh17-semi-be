<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"/>
<jsp:include page="/WEB-INF/views/template/side_home2.jsp"/>

<script>
$(function(){
    $("#btn-delete-dept").click(function(){
        var deptId = $(this).data("dept-id");
        if (!confirm("정말 이 부서를 삭제하시겠습니까?")) return;

        $.ajax({
            url    : "../rest/dept/delete",
            method : "post",
            data   : { deptId : deptId },
            success: function(){ alert("부서가 정상적으로 삭제되었습니다."); location.href = "./list"; },
            error  : function(){ alert("삭제 중 오류가 발생했거나 권한이 없습니다."); }
        });
    });
});

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
<div class="dept-screen">
<!-- ── 페이지 헤더 ── -->
<div class="gw-page-head">
    <h1>${deptDto.deptName}</h1>
</div>

<!-- ── 부서 기본 정보 ── -->
<div class="gw-list-panel mb-10">
    <div class="card-header">
        <span class="card-title">기본 정보</span>
    </div>
    <table class="gw-table">
        <thead>
            <tr>
                <th>부서 ID</th>
                <th>상위 부서</th>
                <th>부서장</th>
                <th>개설일</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>${deptDto.deptId}</td>
                <td>
                    <c:choose>
                        <c:when test="${deptDto.parentDeptId == 0 || empty deptDto.parentDeptId}">
                            <span class="gw-muted">없음</span>
                        </c:when>
                        <c:otherwise>
                            <a href="./detail?deptId=${deptDto.parentDeptId}" class="gw-table-link">
                                ${deptDto.parentDeptName}
                            </a>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                	<a href="${pageContext.request.contextPath}/emp/detail?empNo=${empDto.empNo}" 
                			class="gw-table-link">${empDto.empName}
                    </a>
                </td>
                <td><fmt:formatDate value="${deptDto.deptCreateAt}" pattern="yyyy-MM-dd"/></td>
            </tr>
        </tbody>
    </table>
    <c:if test="${not empty deptDto.deptContent}">
        <div style="margin-top:14px; padding-top:14px; border-top:1px solid var(--border-color); color:var(--sub-text); font-size:14px;">
            <i class="fa-solid fa-memo" style="margin-right:6px;"></i>${deptDto.deptContent}
        </div>
    </c:if>
</div>

<!-- ── 하위 부서 목록 ── -->
<c:if test="${not empty childDeptList}">
    <div class="gw-list-panel mb-10">
        <div class="card-header">
            <span class="card-title">하위 부서</span>
        </div>
        <table class="gw-table">
            <thead>
                <tr>
                    <th>부서 코드</th>
                    <th>부서명</th>
                    <th>부서장</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="child" items="${childDeptList}">
                    <tr>
                        <td>${child.deptId}</td>
                        <td>
                            <a href="./detail?deptId=${child.deptId}" class="gw-table-link">
                                ${child.deptName}
                            </a>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${empty child.deptHeadName}">
                                    <span class="gw-muted">(공석)</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/emp/detail?empNo=${child.deptHeadId}" class="gw-table-link">
                                        ${child.deptHeadName}
                                    </a>
                                    
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</c:if>

<!-- ── 직원 목록 ── -->
<div class="gw-list-panel">
    <div class="card-header">
        <span class="card-title">직원 목록</span>
        <span class="gw-muted" style="font-size:13px;">${memberList.size()}명</span>
    </div>
    <table class="gw-table">
        <thead>
            <tr>
                <th class="w-25">성명</th>
                <th class="w-25">직위</th>
                <th>전화번호</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty memberList}">
                    <tr><td colspan="3" class="gw-table-empty">소속 직원이 없습니다.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="emp" items="${memberList}">
                        <tr>
                            <td>
                            	<a href="${pageContext.request.contextPath}/emp/detail?empNo=${empDto.empNo}" 
			                			class="gw-table-link">${empDto.empName}
			                    </a>
		                    </td>
                            <td>${emp.empPosition}</td>
                            <td>${emp.empContact}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<!-- ── 액션 버튼 ── -->
<div class="gw-form-actions" style="border-top:none; margin-top:18px; justify-content:flex-end;">
    <a href="./listTree" class="gw-btn-outline">
        <i class="fa-solid fa-users"></i> 조직도
    </a>
    <a href="./list" class="gw-btn-outline">
        <i class="fa-solid fa-list"></i> 목록
    </a>
    <c:if test="${sessionScope.loginRole == '관리자'}">
        <a href="./insert" class="gw-btn-outline">
            <i class="fa-solid fa-plus"></i> 신규 등록
        </a>
        <a href="./edit?deptId=${deptDto.deptId}" class="gw-btn-outline">
            <i class="fa-solid fa-pen"></i> 수정
        </a>
        <a href="./block?deptId=${deptDto.deptId}"
           class="gw-btn-outline"
           style="${deptDto.deptYn == 'Y' ? 'color:var(--danger-color); border-color:var(--danger-color);' : 'color:var(--success-color); border-color:var(--success-color);'}">
            <i class="fa-solid ${deptDto.deptYn == 'Y' ? 'fa-ban' : 'fa-circle-check'}"></i>
            ${deptDto.deptYn == 'Y' ? '비활성화' : '활성화'}
        </a>
        <button type="button" class="gw-btn-danger" id="btn-delete-dept" data-dept-id="${deptDto.deptId}">
            <i class="fa-solid fa-trash"></i> 삭제
        </button>
    </c:if>
</div>
</div>
<jsp:include page="/WEB-INF/views/template/footer2.jsp"/>