<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>


<div class="pds-width">
<div class="gw-page-head">
    <div class="gw-breadcrumb">
        관리자 > 직원관리
    </div>
    <h1>대기 사원 목록</h1>
    <p>현재 대기 사원의 목록을 볼 수 있습니다.</p>
</div>

<div class="gw-list-panel">	
	<div class="gw-table-top">
        <div>
            <div class="gw-table-title">
                직원 목록
            </div>

            <div class="gw-table-sub">
                총 ${pageVO.count}명의 직원
            </div>
        </div>
    </div>
	
	<table class="gw-table">
				<thead>
						<tr align="center">
								
								
								<th>사원실명</th>
								<th>사원아이디</th>
								<th>부서</th>
								<th>직위</th>
								<th>활성화여부</th>
								<th>담당사수</th>
								<th>입사일</th>
								<th>승인하기</th>
						</tr>
				</thead>
				<tbody>
					<c:forEach var="empDto" items="${list}">
						<tr align="center" onclick="location.href='./detail?empNo=${empDto.empNo}'" style="cursor:pointer;">
								<td>${empDto.empName}</td>
								<td>${empDto.empId}</td>
								<td>${deptDto.deptName}</td>
								<td>${empDto.empPosition}</td>
								<td>${empDto.empApprovalStatus}</td>
								<td>${empDto.empMentor}</td>								
								<td><fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy-MM-dd"/></td>								
								<td onclick="event.stopPropagation();">
								    <form action="./approval" method="post" style="display:inline;">
								        <input type="hidden" name="empNo" value="${empDto.empNo}" />
								        <button type="submit" class="gw-btn-outline"
								                onclick="return confirm('승인 처리하시겠습니까?');">
								            승인
								        </button>
								    </form>
								</td>
						</tr>
					</c:forEach>
				</tbody>
		</table>
		<div class="gw-pagination">
			<c:set var="pageUrl" value="./waitingList"/>
		  	<jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>

