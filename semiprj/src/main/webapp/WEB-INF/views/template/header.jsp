<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KH정보교육원</title>
    <link rel="icon" href="/images/kh.jpg" type="image/jpeg">

    <!-- 아이콘 -->
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">

    <!-- 디자인을 작성하기 위한 영역 -->
    <link rel="stylesheet" type="text/css" href="/css/commons_semi.css">
    <style>
        /* div { box-shadow: 0 0 0 1px gray ;} */
    </style>
    
    <!-- jQuery CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    
</head>
<body>
    <!-- 메인 컨테이너1 + 내부영역4 -->
    <div class="container w-1200">
        <div class="flex-area flex-vertical">
            <!-- 헤더 영역 -->
            <div class="flex-area">
                <div class="w-20 flex-area flex-center">
                    <a href="https://kh-academy.co.kr/main/main.kh">
						<img src="/images/logo.svg" style="width: 200px">
					</a>
                </div>
                <div class="w-80 flex-area flex-center">
				<c:if test="${sessionScope.loginId == null || sessionScope.loginRole == null}">
					<jsp:include page="/WEB-INF/views/template/menu_normal.jsp"></jsp:include>
				</c:if>     
				<c:if test="${sessionScope.loginId != null && sessionScope.loginRole != null}">
					<c:if test="${sessionScope.loginRole != '관리자'}">
						<jsp:include page="/WEB-INF/views/template/menu_emp.jsp"></jsp:include>
					</c:if>
					<c:if test="${sessionScope.loginRole == '관리자'}">
						<jsp:include page="/WEB-INF/views/template/menu_admin.jsp"></jsp:include>
					</c:if>
				</c:if>
           		</div>
            </div>



            <!-- 사이드바 및 컨텐츠 -->
            <div style="min-height: 600px;" class="flex-area mt-20">
                <div class="w-200 flex-area flex-vertical">
                    <div class="container w-100 side-area cell">
                    
                    	<c:if test="${sessionScope.loginId == null || sessionScope.loginRole == null}">
                        <!-- 비회원 상태 -->
                        <div class="cell center">
                            <h3>비회원 상태</h3>
                        </div>
                        <div class="cell center">
                            <a href="/emp/login">
                                <i class="fa-solid fa-right-to-bracket"></i>
                                <span>로그인</span>
                            </a>
                        </div>
                        <!-- <div class="cell center">
                            <a href="/emp/join">
                                <i class="fa-solid fa-user-plus"></i>
                                <span>회원가입</span>
                            </a>
                        </div> -->
                        </c:if>

                        <!-- 회원 상태 -->
                        <c:if test="${sessionScope.loginId != null && sessionScope.loginRole != null}">
                        

                        <div class="cell center">
                            <!-- 이미지와 글자를 겹쳐서 배치하기 위해 영역을 설정하고 내부에 요소 배치 -->
                            <div class="image-hover image-circle image-shadow"
                                    style="width: 150px; margin: 0 auto;">
                                <%-- <img src="/emp/profile?empId=${sessionScope.loginId}"> --%>
                                <div class="content">
                                    <a href="/emp/mypage" class="white">
                                        <i class="fa-solid fa-user"></i>
                                        <span>내 정보 보기</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="cell center">
                            <h3>
                            	${loginUser.empDept}<br>
                            	${loginUser.empName}/${loginUser.empPosition}

                            </h3>
                        </div>
                        
                        </c:if>
                        
                    </div>
					<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>
					
                <div class="w-200 flex-fill">