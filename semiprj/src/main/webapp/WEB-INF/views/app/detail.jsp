<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<script>
	$(function() {
		var savedTheme = localStorage.getItem("gwTheme");

		if (savedTheme) {
			$("body").addClass(savedTheme);
		} else {
			$("body").addClass("theme-blue");
		}

		$(".theme-btn").click(function() {
			$(".theme-popup").toggle();
		});

		$(".theme-item").click(
				function() {
					var theme = $(this).data("theme");

					$("body").removeClass(
							"theme-blue theme-green theme-purple theme-dark")
							.addClass(theme);

					localStorage.setItem("gwTheme", theme);

					$(".theme-popup").hide();
				});

		$(".check-all").change(function() {
			$("input[name=pdsNoList]").prop("checked", this.checked);
		});

		$("input[name=pdsNoList]")
				.change(
						function() {
							$(".check-all")
									.prop(
											"checked",
											$("input[name=pdsNoList]").length == $("input[name=pdsNoList]:checked").length);
						});
	});
</script>

<div style="padding: 30px;">
	<%-- 상단 타이틀 --%>
	<div
		style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
		<h2
			style="margin: 0; font-size: 22px; font-weight: 700; color: var(--main-color);">📄
			결재문서 상세</h2>
		<button onclick="location.href='./list'"
			style="padding: 8px 16px; background: #f0f0f0; color: #333; border: none; border-radius: 6px; font-size: 13px; cursor: pointer;">
			← 목록으로</button>
	</div>

	<%-- 문서 기본 정보 --%>
	<div
		style="background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08); padding: 24px; margin-bottom: 16px;">
		<h3
			style="margin: 0 0 16px 0; font-size: 15px; color: var(--main-color); font-weight: 600;">문서
			정보</h3>
		<table
			style="width: 100%; border-collapse: collapse; font-size: 14px;">
			<tr style="border-bottom: 1px solid #f0f0f0;">
				<th
					style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; width: 120px; background: #fafafa;">문서종류</th>
				<td style="padding: 12px 16px;">${appDto.appType}</td>
				<th
					style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; width: 120px; background: #fafafa;">진행상황</th>
				<td style="padding: 12px 16px;"><c:choose>
						<c:when test="${appDto.appStatus == '승인'}">
							<span
								style="background: #e8f5e9; color: #2e7d32; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">승인</span>
						</c:when>
						<c:when test="${appDto.appStatus == '반려'}">
							<span
								style="background: #ffebee; color: #c62828; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">반려</span>
						</c:when>
						<c:otherwise>
							<span
								style="background: #fff8e1; color: #f57f17; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">처리중</span>
						</c:otherwise>
					</c:choose></td>
			</tr>
			<tr style="border-bottom: 1px solid #f0f0f0;">
				<th
					style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; background: #fafafa;">문서명</th>
				<td style="padding: 12px 16px;" colspan="3">${appDto.appTitle}</td>
			</tr>
			<tr style="border-bottom: 1px solid #f0f0f0;">
				<th
					style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; background: #fafafa;">기안자</th>
				<td style="padding: 12px 16px;">${appDto.empName}</td>
				<th
					style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; background: #fafafa;">기안일</th>
				<td style="padding: 12px 16px;">${appDto.appDate}</td>
			</tr>
			<tr>
				<th
					style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; background: #fafafa;">내용</th>
				<td style="padding: 12px 16px;" colspan="3">${appDto.appContent}</td>
			</tr>
		</table>
	</div>

	<%-- 휴가신청서 추가 정보 --%>
	<c:if test="${not empty vacAppDto}">
		<div
			style="background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08); padding: 24px; margin-bottom: 16px;">
			<h3
				style="margin: 0 0 16px 0; font-size: 15px; color: var(--main-color); font-weight: 600;">
				휴가 정보</h3>
			<table
				style="width: 100%; border-collapse: collapse; font-size: 14px;">
				<tr style="border-bottom: 1px solid #f0f0f0;">
					<th
						style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; width: 120px; background: #fafafa;">휴가
						구분</th>
					<td style="padding: 12px 16px;">${vacAppDto.vacType}</td>
					<th
						style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; width: 120px; background: #fafafa;">휴가
						기간</th>
					<td style="padding: 12px 16px;">${vacAppDto.vacStartDate} ~
						${vacAppDto.vacEndDate}</td>
				</tr>
			</table>
		</div>
	</c:if>

	<%-- 품의서 추가 정보 --%>
	<c:if test="${not empty expAppDto}">
		<div
			style="background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08); padding: 24px; margin-bottom: 16px;">
			<h3
				style="margin: 0 0 16px 0; font-size: 15px; color: var(--main-color); font-weight: 600;">
				품의 정보</h3>
			<table
				style="width: 100%; border-collapse: collapse; font-size: 14px;">
				<tr style="border-bottom: 1px solid #f0f0f0;">
					<th
						style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; width: 120px; background: #fafafa;">지출일</th>
					<td style="padding: 12px 16px;">${expAppDto.expDate}</td>
					<th
						style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; width: 120px; background: #fafafa;">지출금액</th>
					<td style="padding: 12px 16px;"><fmt:formatNumber
							value="${expAppDto.expPrice}" pattern="#,###" />원</td>
				</tr>
				<tr style="border-bottom: 1px solid #f0f0f0;">
					<th
						style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; background: #fafafa;">지출내역</th>
					<td style="padding: 12px 16px;" colspan="3">${expAppDto.expHistory}</td>
				</tr>
				<tr style="border-bottom: 1px solid #f0f0f0;">
					<th
						style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; background: #fafafa;">지출방법</th>
					<td style="padding: 12px 16px;">${expAppDto.expHow}</td>
					<th
						style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; background: #fafafa;">지출목적</th>
					<td style="padding: 12px 16px;">${expAppDto.expPurpose}</td>
				</tr>
			</table>
		</div>
	</c:if>

	<%-- 업무기안서 추가 정보 --%>
	<c:if test="${not empty dftAppDto}">
		<div
			style="background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08); padding: 24px; margin-bottom: 16px;">
			<h3
				style="margin: 0 0 16px 0; font-size: 15px; color: var(--main-color); font-weight: 600;">
				업무기안 정보</h3>
			<table
				style="width: 100%; border-collapse: collapse; font-size: 14px;">
				<tr>
					<th
						style="padding: 12px 16px; text-align: left; color: #888; font-weight: 600; width: 120px; background: #fafafa;">업무일</th>
					<td style="padding: 12px 16px;">${dftAppDto.dftDate}</td>
				</tr>
			</table>
		</div>
	</c:if>

	<%-- 결재선 --%>
	<div
		style="background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08); padding: 24px;">
		<h3
			style="margin: 0 0 16px 0; font-size: 15px; color: var(--main-color); font-weight: 600;">결재선</h3>
		<table
			style="width: 100%; border-collapse: collapse; font-size: 14px;">
			<thead>
				<tr style="background: #f8f9fa; border-bottom: 1px solid #eee;">
					<th
						style="padding: 12px 16px; text-align: left; color: #555; font-weight: 600;">순서</th>
					<th
						style="padding: 12px 16px; text-align: left; color: #555; font-weight: 600;">결재자</th>
					<th
						style="padding: 12px 16px; text-align: left; color: #555; font-weight: 600;">부서</th>
					<th
						style="padding: 12px 16px; text-align: left; color: #555; font-weight: 600;">직급</th>
					<th
						style="padding: 12px 16px; text-align: center; color: #555; font-weight: 600;">상태</th>
					<th
						style="padding: 12px 16px; text-align: left; color: #555; font-weight: 600;">결재일</th>
					<th
						style="padding: 12px 16px; text-align: left; color: #555; font-weight: 600;">반려사유</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="line" items="${lineList}">
					<tr style="border-bottom: 1px solid #f0f0f0;">
						<td style="padding: 12px 16px;">${line.appLineOrder}</td>
						<td style="padding: 12px 16px;">${line.empName}</td>
						<td style="padding: 12px 16px; color: #888;">${line.empDept}</td>
						<td style="padding: 12px 16px; color: #888;">${line.empPosition}</td>
						<td style="padding: 12px 16px; text-align: center;"><c:choose>
								<c:when test="${line.appLineStatus == '완료'}">
									<span
										style="background: #e8f5e9; color: #2e7d32; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">완료</span>
								</c:when>
								<c:when test="${line.appLineStatus == '반려'}">
									<span
										style="background: #ffebee; color: #c62828; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">반려</span>
								</c:when>
								<c:when test="${line.appLineStatus == '진행중'}">
									<span
										style="background: #fff8e1; color: #f57f17; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">진행중</span>
								</c:when>
								<c:otherwise>
									<span
										style="background: #f5f5f5; color: #999; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">대기</span>
								</c:otherwise>
							</c:choose></td>
						<td style="padding: 12px 16px; color: #888;">${line.appLineDate}</td>
						<td style="padding: 12px 16px; color: #c62828;">${line.appLineRej}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty lineList}">
					<tr>
						<td colspan="7"
							style="padding: 40px; text-align: center; color: #aaa;">
							결재선이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>

</div>