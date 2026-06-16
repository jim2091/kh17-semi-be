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
    width:200px;
    height:200px;
    object-fit:cover;
    border-radius:20px;
    border:4px solid #fff;
	box-shadow:0 4px 12px rgba(0,0,0,0.08);
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
.agent-cell{
    max-width:350px;
    overflow:hidden;
    text-overflow:ellipsis;
    white-space:nowrap;
}
.security-card{
    display:flex;
    align-items:center;
    justify-content:space-between;

    padding:20px;

    background:white;
    border:1px solid #e8eefc;
    border-radius:16px;
}

.security-icon{
    width:50px;
    height:50px;

    display:flex;
    justify-content:center;
    align-items:center;

    border-radius:50%;

    background:#edf4ff;
    color:var(--main-color);

    font-size:20px;
}

.security-content{
    flex:1;
    margin-left:15px;
}

.security-title{
    font-size:14px;
    color:#6b7280;
}

.security-value{
    margin-top:4px;
    font-size:17px;
    font-weight:600;
    color:#111827;
}
</style>

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 > 마이페이지</div>
	    <h1>마이페이지</h1>
	    <p>[ ${empDto.empName} ] 님의 상세 프로필 정보입니다.</p>
	</div>


	<div class="gw-list-panel gw-card">
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


	<div class="gw-card mt-50">
	    <div style="display:flex; justify-content:space-between; align-items:center;">
	        <div class="gw-table-title">최근 로그인 이력</div>
	        <a href="./history?empNo=${empDto.empNo}"
	           class="gw-btn-outline">
	            더보기<i class="fa-solid fa-caret-right"></i>
	        </a>
	    </div>
	    <table class="gw-table gw-list-panel mt-10">
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
					<td class="agent-cell">${empHistoryDto.empHistoryAgent}</td>
				</tr>
			</c:forEach>
			</tbody>
	    </table>
    </div>
    
    <div class="security-card mt-50">
	    <div class="security-icon">
	        <i class="fa-solid fa-lock"></i>
	    </div>
	    
	    <div class="security-content">
	        <div class="security-title">
	            비밀번호 변경일
	        </div>
	        <div class="security-value">
	            <fmt:formatDate value="${empDto.empPwChange}" pattern="yyyy-MM-dd HH:mm"/>
	        </div>
	    </div>
	
	    <a href="./password" class="gw-btn-outline">
	        <i class="fa-solid fa-key"></i>변경하기
	    </a>
	</div>


	<div class="center mt-50 mb-50">
	    <c:if test="${sessionScope.loginNo == empDto.empNo}">
	        <a href="./edit?empNo=${empDto.empNo}"
	           class="gw-btn-primary">
	            <i class="fa-solid fa-user-pen"></i>
	            정보수정
	        </a>
	    </c:if>

	    <a href="./list"
	       class="gw-btn-outline">
	        <i class="fa-solid fa-list"></i>
	        목록으로
	    </a>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>