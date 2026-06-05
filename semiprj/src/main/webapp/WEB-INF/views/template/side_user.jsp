<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
				
<div class="container w-100 mt-10 side-area center cell flex-fill">
<div class="board-side">
<c:if test="${sessionScope.loginId != null && sessionScope.loginRole != null}">
	<c:if test="${sessionScope.loginRole == '관리자'}">
			<div class="side-section">
				<div class="side-title">인사관리</div>
				<a href="/admin/register" class="side-link">
					<i class="fa-solid fa-user-plus"></i>직원 등록하기
				</a>
				<a href="/admin/list" class="side-link">
					<i class="fa-solid fa-list"></i>직원 목록 및 검색
				</a>
				<a href="/admin/waitingList" class="side-link">
					<i class="fa-regular fa-hourglass"></i>대기 직원 목록
				</a>
				
			</div>
	</c:if>		
	<c:if test="${sessionScope.loginRole != '관리자'}">				
    		<div class="side-section">
	  			<div class="side-title">직원목록</div>
	           	<a href="/emp/list" class="side-link">
	           		<i class="fa-solid fa-list"></i>직원 목록 및 검색
	           	</a>
				<a href="/emp/mypage" class="side-link">
					<i class="fa-solid fa-user-pen"></i>마이페이지
				</a>
			</div> 
	</c:if>						
</c:if>							
</div>
</div>
                </div>
				<div class="w-200 flex-fill">				