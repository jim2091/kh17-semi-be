<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.gw-profile-wrap{
    display:flex;
    gap:30px;
    align-items:flex-start;
}

.gw-profile-image img{
    width:180px;
    height:180px;
    object-fit:cover;
    border-radius:20px;
}

.gw-profile-info{
    flex:1;
}

.gw-info-row{
    display:flex;
    padding:12px 0;
    border-bottom:1px solid #eee;
}

.gw-info-row strong{
    width:120px;
    color:#666;
}

.gw-info-row span{
    flex:1;
}
</style>

<div class="gw-page-head">
    <div class="gw-breadcrumb">
        사용자 > 마이페이지
    </div>

    <h1>내 정보</h1>
    <p>[${empDto.empName}]의 상세 프로필 정보입니다.</p>
</div>


<div class="gw-card">

    <div class="gw-profile-wrap">

        <div class="gw-profile-image">
            <img src="/emp/profile?empNo=${empDto.empNo}">
        </div>

        <div class="gw-profile-info">

            <div class="gw-info-row">
                <strong>사원명</strong>
                <span>${empDto.empName}</span>
            </div>

            <div class="gw-info-row">
                <strong>부서</strong>
                <span>${deptDto.deptName}</span>
            </div>

            <div class="gw-info-row">
                <strong>직위</strong>
                <span>${empDto.empPosition}</span>
            </div>

            <div class="gw-info-row">
                <strong>담당사수</strong>
                <span>${empDto.empMentor}</span>
            </div>

            <div class="gw-info-row">
                <strong>이메일</strong>
                <span>${empDto.empEmail}</span>
            </div>

            <div class="gw-info-row">
                <strong>연락처</strong>
                <span>${empDto.empContact}</span>
            </div>

            <div class="gw-info-row">
                <strong>주소</strong>
                <span>
                    [${empDto.empPost}]
                    ${empDto.empAddress1}
                    ${empDto.empAddress2}
                </span>
            </div>

        </div>

    </div>

</div>

<div class="gw-card">

    <div style="display:flex; justify-content:space-between; align-items:center;">
        <h3>최근 로그인 이력</h3>
        <a href="./history?empNo=${empDto.empNo}"
           class="gw-btn-outline">
            전체보기
        </a>
    </div>

    <table class="gw-table">
			<thead>
			<tr>
				<th>일시</th>
				<th>접속주소</th>
				<th>에이전트</th>
			</tr>
			</thead>
		<tbody>
		<c:forEach var= "empHistoryDto" items="${loginHistory}">
			<tr>
			<td>${empHistoryDto.empHistoryTime}</td>
			<td>${empHistoryDto.empHistoryAddress}</td>
			<td>${empHistoryDto.empHistoryAgent}</td>
			</tr>
		</c:forEach>
		</tbody>
    </table>
    


</div>
<div class="gw-card">

    <h3>보안 설정</h3>

    <div class="gw-info-row">
        <strong>비밀번호 변경일</strong>
        <span>
            <fmt:formatDate
                value="${empDto.empPwChange}"
                pattern="yyyy-MM-dd HH:mm"/>
        </span>
    </div>

</div>

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

</div>






<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>