<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<div class="gw-page-head">
    <div class="gw-breadcrumb">
        관리자 > 직원관리
    </div>

    <h1>직원 상세정보</h1>
    <p>직원의 상세 프로필 정보입니다.</p>
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
        <div class="gw-muted">${empDto.empPosition}</div>
    </div>

<table class="gw-table">
        <tbody>
        	<tr>
                <th width="20%">사원번호</th>
                <td>${empDto.empNo}</td>
            </tr>
        	<tr>
                <th>사원실명</th>
                <td>${empDto.empName}</td>
            </tr>
            <tr>
                <th>부서</th>
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
                <th>권한</th>
                <td>${empDto.empLevel}</td>
            </tr>
            <tr>
                <th>활성화여부</th>
                <td>${empDto.empUseYn}</td>
            </tr>
            <tr>
                <th>입사일</th>
                <td>
                    <fmt:formatDate
                        value="${empDto.empHireDate}"
                        pattern="yyyy-MM-dd"/>
                </td>
            </tr>
            <tr>
                <th>퇴사일</th>
                <td>
                    <fmt:formatDate
                        value="${empDto.empRetiredDate}"
                        pattern="yyyy-MM-dd"/>
                </td>
            </tr>
            <tr>
                <th>등록일</th>
                <td>
                    <fmt:formatDate
                        value="${empDto.empCreateAt}"
                        pattern="yyyy-MM-dd"/>
                </td>
            </tr>
            <tr>
                <th>최종 비밀번호 변경일</th>
                <td>${empDto.empPwChange}</td>
            </tr>
        </tbody>
    </table>
    
    <div class="center mt-30">

            <a href="./edit?empNo=${empDto.empNo}"
               class="gw-btn-primary">
                <i class="fa-solid fa-user-pen"></i>
                사원정보수정
            </a>

        <a href="./list"
           class="gw-btn-outline">
            <i class="fa-solid fa-list"></i>
            목록으로
        </a>

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

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>