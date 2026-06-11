<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>


	<div class="gw-detail-panel pds-width">

        <div class="gw-page-head">
		    <div class="gw-breadcrumb">홈 / 자료실 / 상세보기</div>
		    <h1>${pdsDto.pdsTitle}</h1>
		    <p>자료의 상세 내용과 첨부파일을 확인할 수 있습니다.</p>
		</div>

        <div class="gw-form-panel">
		
		    <!-- 작성자 / 날짜 / 조회수 -->
		    <div class="gw-detail-info">
		        <div class="gw-detail-author">
		            <i class="fa-regular fa-user"></i>
		
		            <c:choose>
		                <c:when test="${pdsDto.pdsWriter == null}">
		                    (퇴사한 사용자)
		                </c:when>
		                <c:otherwise>
		                    <a href="/emp/detail?empNo=${pdsDto.pdsWriter}" class="gw-table-link">
		                        ${pdsDto.empName}
		                    </a>
		                </c:otherwise>
		            </c:choose>
		        </div>
		
		        <div class="gw-detail-meta">
		            <span>
		                <i class="fa-regular fa-calendar"></i>
		                <fmt:formatDate value="${pdsDto.pdsWtime}" pattern="yyyy-MM-dd HH:mm"/>
		            </span>
		
		            <span>
		                <i class="fa-regular fa-eye"></i>
		                ${pdsDto.pdsReadcount}
		            </span>
		        </div>
		    </div>
		
		    <!-- 본문 -->
		    <div class="gw-form-row">
		        <label class="gw-form-label">내용</label>
		
		        <div class="gw-content-box">
		            <pre>${pdsDto.pdsContent}</pre>
		        </div>
		    </div>
		
		    <!-- 첨부파일 -->
		    <div class="gw-form-row">
		        <label class="gw-form-label">파일 첨부</label>
		
		        <div class="gw-file-view">
		            <c:choose>
		                <c:when test="${empty attachList}">
		                    <span class="gw-file-name">
		                        첨부파일이 없습니다.
		                    </span>
		                </c:when>
		
		                <c:otherwise>
		                    <c:forEach var="attachDto" items="${attachList}">
		                        <a class="gw-file-download"
		                           href="/download/modern?attachNo=${attachDto.attachNo}">
		                            <i class="fa-solid fa-paperclip"></i>
		                            ${attachDto.attachName}
		                        </a>
		                    </c:forEach>
		                </c:otherwise>
		            </c:choose>
		        </div>
		    </div>
		
		    <!-- 이전글 / 다음글 -->
		    <div class="gw-form-row">
		        <label class="gw-form-label">이전 / 다음 글</label>
		
		        <div class="gw-nav-box">
		
		            <div class="gw-nav-row">
		                <span class="gw-nav-label">이전글</span>
		
		                <c:if test="${prevPdsDto != null}">
		                    <a href="./detail?pdsNo=${prevPdsDto.pdsNo}" class="gw-table-link">
		                        ${prevPdsDto.pdsTitle}
		                    </a>
		                </c:if>
		            </div>
		
		            <div class="gw-nav-row">
		                <span class="gw-nav-label">다음글</span>
		
		                <c:if test="${nextPdsDto != null}">
		                    <a href="./detail?pdsNo=${nextPdsDto.pdsNo}" class="gw-table-link">
		                        ${nextPdsDto.pdsTitle}
		                    </a>
		                </c:if>
		            </div>
		
		        </div>
		    </div>
		
		    <!-- 버튼 -->
		    <div class="gw-form-actions">
		        <a href="./list" class="gw-btn-outline">
		            <i class="fa-solid fa-list"></i>
		            <span>목록으로</span>
		        </a>
		
		        <a href="./edit?pdsNo=${pdsDto.pdsNo}" class="gw-btn-outline">
		            <i class="fa-solid fa-pen"></i>
		            <span>수정하기</span>
		        </a>
		
		        <a href="./delete?pdsNo=${pdsDto.pdsNo}"
		           class="gw-btn-danger btn-content-delete">
		            <i class="fa-regular fa-trash-can"></i>
		            <span>삭제하기</span>
		        </a>
		    </div>
		
		</div>

    </div>

</div>

<script>
$(function(){
    $(".btn-content-delete").click(function(e){
        var choice = window.confirm("정말 삭제하시겠습니까?");

        if(choice == false) {
            e.preventDefault();
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>