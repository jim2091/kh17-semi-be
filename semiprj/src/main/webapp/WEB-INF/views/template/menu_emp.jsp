<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 비회원일 때 보여줄 메뉴 -->
<ul class="menu">
	<li>
	    <a href="/">
	        <span>홈</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <span>전자결재</span>
		</a>
        <!-- 하위 메뉴 -->
        <ul>
            <li>
                <a href="#">
                    <span>내 문서함</span>
                </a>
            </li>
            <li>
                <a href="#">
                    <span>결재 문서함</span>
                </a>
            </li>
        </ul>
	</li>
	<li>
	    <a href="/board/list">
	        <span>게시판</span>
		</a>
	</li>
	<li>
	    <a href="/emp/list">
	        <span>직원목록</span>
	    </a>
	</li>
	<li>
	    <a href="/dept/list">
	        <span>부서목록</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <span>근태관리</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <span>일정</span>
	    </a>
	</li>

	<li class="divider"></li>
	
	<li style="width: 50px;">
	    <a href="#">
	        <i class="fa-solid fa-paper-plane"></i>
	    </a>
	</li>
	<li style="width: 50px;">
	    <a href="#">
	        <i class="fa-solid fa-bell"></i>
	    </a>
	</li>
	<c:if test="${sessionScope.attnYn == false}">
	<li>
	    <a href="#">
	        <span>출근</span>
	    </a>
	</li>
	</c:if>
	<c:if test="${sessionScope.attYn == true}">
	<li>
	    <a href="#">
	        <span>퇴근</span>
	    </a>
	</li>
	</c:if>

	<li>
	    <a href="/emp/logout">
	        <span>로그아웃</span>
	    </a>
	</li>

</ul>