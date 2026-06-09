<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

					<div class="container w-100 mt-10 side-area center cell flex-fill">
						<c:if test="${sessionScope.loginId != null}">
						<div class="board-side">
							<div class="side-section">
								<div class="side-title">쪽지</div>
								<a href="/message/receiveList" class="side-link">
									<i class="fa-solid fa-arrow-right-to-bracket"></i> 받은 쪽지함
								</a>
								<a href="/message/sendList" class="side-link">
									<i class="fa-solid fa-arrow-right-from-bracket"></i> 보낸 쪽지함
								</a>
								<a href="/message/write" class="side-link">
									<i class="fa-regular fa-paper-plane"></i> 쪽지 보내기
								</a>
								</div>
							</div>
						</div>
						</c:if>
                	</div>
				<div class="w-200 flex-fill">