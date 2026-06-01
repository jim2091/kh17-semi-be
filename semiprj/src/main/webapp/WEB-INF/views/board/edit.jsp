<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<form action=".edit" method="post" enctype="multipart/form-data" autocomplete="off"  class="form-check">
	<!-- 기본키(번호, boardNo)를 숨김 첨부 -->
	<input type="hidden" name="boardNo" value="${boardDto.boardNo}">

	<div class="container w-800 mt-50 mb-50">
		<!-- 페이지 제목 -->
		<div class="cell">
			<h1 class="mt-0 mb-0">기존 글 수정</h1>
		</div>
	
		<!-- 경고문 -->
		<div class="cell">
			<i class="fa-solid fa-circle-exclamation red"></i>
			타인에 대한 무분별한 비방글은 경고 없이 삭제될 수 있습니다.
		</div>

		<!-- 제목 입력창 -->
		<div class="cell mt-50">
			<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="boardTitle" class="field w-100">
			<div class="fail-feedback">[필수] 제목을 입력해주세요.</div>
		</div>

		<!-- 종류 드롭박스 -->
		<div class="cell">
			<label>종류 <i class="fa-solid fa-asterisk red"></i></label>
			<select name="boardHead" class="field w-100">
				<option value="">-- 선택하세요 --</option>
				<!-- (*) 공지는 관리자에게만 보임 -->
				<c:if test="${sessionScope.empLevel == '관리자'}">
					<option ${boardDto.boardHead == '공지' ? 'selected' : ''}>공지</option>
				</c:if>
				<option ${boardDto.boardHead == '자유' ? 'selected' : ''}>자유</option>
				<option ${boardDto.boardHead == '정보' ? 'selected' : ''}>정보</option>	
				<option ${boardDto.boardHead == '질문' ? 'selected' : ''}>질문</option>
			</select>
			<div class="fail-feedback">[필수] 종류를 선택하세요.</div>
		</div>

		<!-- 유형 체크박스 -->
		<div class="cell">
			<label>유형 <i class="fa-solid fa-asterisk red"></i></label>
			
		</div>
		
		<!-- 내용 입력창 -->
		<div class="cell">
            <label>내용 <i class="fa-solid fa-asterisk red"></i></label>
            <textarea name="boardContent" rows="10" class="field w-100"></textarea>
            <div class="right">
                <span>0</span> / 1000
            </div>
            <div class="fail-feedback">[필수] 내용을 입력하세요.</div>
        </div>
        
        <!-- 목록/수정 버튼 -->
		<div class="cell mt-50 right">
			<a href="./list" class="btn btn-neutral">
				<i class="fa-solid fa-list"></i>
				<span>목록으로</span>
			</a>
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-floppy-disk"></i>
				<span>수정하기</span>
             </button>
		</div>
	</div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>