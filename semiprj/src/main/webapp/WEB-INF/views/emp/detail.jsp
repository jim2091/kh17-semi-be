<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
	.position-badge{
    display:inline-block;
    padding:4px 12px;
    border-radius:999px;

    background:#eef4ff;
    color:var(--main-color);

    font-size:13px;
    font-weight:600;
}
</style>

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 > 직원목록 > 직원정보</div>
	    <h1>직원 상세정보</h1>
	    <p>직원의 상세 프로필 볼 수 있습니다.</p>
	</div>

	<div class="gw-list-panel">
	    <div class="center mb-30">
	        <img src="/emp/profile?empNo=${empDto.empNo}"
	             width="140"
	             height="140"
	             style="
	                border-radius:50%;
	                object-fit:cover;
	                border:4px solid var(--main-light);
	             ">
        <h2 class="mt-20">${empDto.empName}</h2>
        <div class="position-badge">${empDto.empPosition}</div>
    </div>

    <table class="gw-table">
        <tbody>
            <tr>
                <th width="30%">부서</th>
                <td>${deptDto.deptName}</td>
            </tr>
            <tr>
                <th>직위</th>
                <td>${empDto.empPosition}</td>
            </tr>
            <tr>
                <th>담당사수</th>
                <td>${empDto.empMentor}</td>
            </tr>
            <tr>
                <th>사원아이디</th>
                <td>${empDto.empId}</td>
            </tr>
            <tr>
                <th>생년월일</th>
                <td>${empDto.empBirth}</td>
            </tr>
            <tr>
                <th>이메일</th>
                <td>${empDto.empEmail}</td>
            </tr>
            <tr>
                <th>연락처</th>
                <td>${empDto.empContact}</td>
            </tr>
            <tr>
                <th>주소</th>
                <td>
                    [${empDto.empPost}]
                    ${empDto.empAddress1}
                    ${empDto.empAddress2}
                </td>
            </tr>
            <tr>
                <th>입사일</th>
                <td>
                    <fmt:formatDate
                        value="${empDto.empHireDate}"
                        pattern="yyyy-MM-dd"/>
                </td>
            </tr>
        </tbody>
    </table>

    <div class="center mt-30">
        <c:if test="${sessionScope.loginNo == empDto.empNo}">
            <a href="./edit?empNo=${empDto.empNo}"
               class="gw-btn-primary">
                <i class="fa-solid fa-user-pen"></i>
                내정보수정
            </a>
        </c:if>

        <a href="./list"
           class="gw-btn-outline">
            <i class="fa-solid fa-list"></i>
            목록으로
        </a>
        <a href="javascript:history.back();"
           class="gw-btn-outline">
            <i class="fa-solid fa-arrow-left"></i>
            뒤로가기
        </a>
	</div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>