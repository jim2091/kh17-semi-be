<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_app.jsp"></jsp:include>


<div class="container w-900 mt-50 mb-50">
	<div class="complete-wrap">
		<div class="complete-icon">
			<i class="fa-solid fa-check"></i>
		</div>
		<div class="complete-title">결재 전송이 완료되었습니다!</div>
		<div class="complete-sub">담당 결재자에게 문서가 전달되었습니다.</div>
		<div class="complete-btns">
			<a href="./list" class="btn-list">
				<i class="fa-solid fa-list"></i> 문서 목록
			</a>
			<a href="./expInsert" class="btn-new">
				<i class="fa-solid fa-file-arrow-up"></i> 새 문서 작성
			</a>
		</div>
	</div>
</div>