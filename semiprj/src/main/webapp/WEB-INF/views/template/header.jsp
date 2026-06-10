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
    
    <!-- lightpick CDN-->
    <script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/locale/ko.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/lightpick.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/css/lightpick.min.css" rel="stylesheet">
    
    <!-- Summernote -->
	<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
	<!-- 한글 -->
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/lang/summernote-ko-KR.min.js"></script>
    
    <script type="text/javascript">
	    $(function(){
	        $("[name=managerToggle]").change(function(){
	
	            $.post("/menu/toggle", {
	                managerToggle : $(this).is(":checked")
	            }, function(){
	                location.reload();
	            });
	
	        });
	    });
    </script>
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
					<c:choose>
					    <c:when test="${sessionScope.loginRole == '관리자'}">
					        <jsp:include page="/WEB-INF/views/template/menu_admin.jsp"/>
					    </c:when>
					    <c:otherwise>
					        <jsp:include page="/WEB-INF/views/template/menu_emp.jsp"/>
					    </c:otherwise>
					</c:choose>
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
                        </c:if>

                        <!-- 회원 상태 -->
                        <c:if test="${sessionScope.loginId != null && sessionScope.loginRole != null}">
                        

                        <div class="cell center">
                            <!-- 이미지와 글자를 겹쳐서 배치하기 위해 영역을 설정하고 내부에 요소 배치 -->
                            <div class="image-hover image-circle image-shadow"
                                    style="width: 150px; margin: 0 auto;">
                                    <img src="/emp/profile?empNo=${sessionScope.loginNo}" width="100">
                                <%-- <img src="/emp/profile?empId=${sessionScope.loginId}"> --%>
                                <div class="content">
                                    <a href="/emp/mypage" class="white">
                                        <i class="fa-solid fa-user"></i>
                                        <span>내 정보 보기</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="cell flex-area flex-vertical flex-center">
                            <div class="center-right">
                            	<div class="side-cell dept" style="width: 100px">
								    <c:choose>
								        <c:when test="${sessionScope.managerToggle}">
								            ${sessionScope.loginRole}
								        </c:when>
								        <c:otherwise>
								            ${loginUser.empDept}
								        </c:otherwise>
								    </c:choose>
                            	</div>
                            	<div>
                            		<c:if test="${sessionScope.managerToggle != null}">
									    <label class="toggle">
									        <input type="checkbox" name="managerToggle"
									            <c:if test="${sessionScope.managerToggle}">checked</c:if>>
									        <span class="slider"></span>
									    </label>
									</c:if>
                            	</div>
                            </div>
                            
                            <div class="side-cell center mt-10" style="width: 150px">
                            	${loginUser.empName}/${loginUser.empPosition}
                            </div>
        
                        </div>
                        
                        </c:if>
                        
                    </div>