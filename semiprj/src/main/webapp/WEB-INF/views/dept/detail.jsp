<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 상단 헤더 및 사이드바 영역 불러오기 -->
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<!-- 
    [주의] 
    기존 header.jsp 마지막에 좌측 사이드바가 끝나고 우측 본문 영역인 
    <div style="flex-grow: 1; ..."> 가 이미 열려있는 구조라면 아래의 본문 영역 div 태그는 제외하셔도 됩니다.
    여기서는 독립적인 정렬을 위해 우측 배치용 div로 감싸주었습니다.
-->
<div class="attn-content-body" style="flex-grow: 1; padding-left: 40px; box-sizing: border-box; font-family: 'Malgun Gothic', sans-serif;">
    
    <!-- 본문 타이틀 -->
    <div class="cell mb-30" style="border-bottom: 2px solid #333; padding-bottom: 10px;">
        <h1 class="bold" style="margin: 0; font-size: 28px; color: #222;">근태 기록</h1>
    </div>

    <!-- 검색 폼 -->
    <div class="cell mb-20">
        <form id="searchForm" action="/attn/list" method="get" style="display: flex; align-items: center; gap: 8px;">
            <select id="yearSelect" name="year" onchange="changeDate()" 
                    style="padding: 8px 16px; border: 1px solid #333; border-radius: 8px; font-size: 16px; background-color: #fff;">
                <c:forEach var="y" begin="2020" end="2030">
                    <option value="${y}" ${search.year == y ? 'selected' : ''}>${y}년</option>
                </c:forEach>
            </select>

            <select id="monthSelect" name="month" onchange="changeDate()" 
                    style="padding: 8px 16px; border: 1px solid #333; border-radius: 8px; font-size: 16px; background-color: #fff;">
                <c:forEach var="m" begin="1" end="12">
                    <c:set var="formattedM" value="${m < 10 ? '0' : ''}${m}" />
                    <option value="${formattedM}" ${search.month == formattedM ? 'selected' : ''}>${m}월</option>
                </c:forEach>
            </select>

            <button type="button" onclick="setToday()" 
                    style="padding: 8px 20px; border: 1px solid #333; border-radius: 8px; font-size: 16px; background-color: #fff; cursor: pointer; font-weight: bold;">
                오늘
            </button>
        </form>
    </div>

    <!-- 데이터 테이블 -->
    <div class="cell mb-30">
        <table class="attn-table" style="width: 100%; border-collapse: collapse; text-align: left; font-size: 15px;">
            <thead>
                <tr style="height: 45px; border-bottom: 2px solid #555; color: #555; font-weight: bold;">
                    <th style="width: 12%; padding: 10px 5px;">월/일</th>
                    <th style="width: 15%;">부재사항</th>
                    <th style="width: 20%;">계획근로시간</th>
                    <th style="width: 23%;">근태기록시간</th>
                    <th style="width: 15%;">근로시간</th>
                    <th style="width: 15%;">상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty attnList}">
                        <tr style="height: 120px; text-align: center;">
                            <td colspan="6" style="color: #999; border-bottom: 1px solid #eee;">조회된 근태 기록이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="dto" items="${attnList}">
                            <fmt:formatDate var="dayOfWeek" value="${dto.attnWorkDate}" pattern="E"/>
                            <c:set var="dateColor" value="#222"/>
                            <c:if test="${dayOfWeek == '토'}"><c:set var="dateColor" value="#0066cc"/></c:if>
                            <c:if test="${dayOfWeek == '일'}"><c:set var="dateColor" value="#ff3333"/></c:if>

                            <tr style="height: 50px; border-bottom: 1px solid #eee;">
                                <td style="padding: 10px 5px; font-weight: bold; color: ${dateColor};">
                                    <fmt:formatDate value="${dto.attnWorkDate}" pattern="d E"/>
                                </td>
                                
                                <td style="color: #222;">
                                    <c:choose>
                                        <c:when test="${dto.attnRecord == '연차'}">
                                            <span style="color: #ffa500; font-size: 12px; margin-right: 3px;">○</span> 연차
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td style="color: #888; font-style: italic;">09:00~18:00</td>
                                
                                <td style="color: #222;">
                                    <c:choose>
                                        <c:when test="${not empty dto.attnInTime}">
                                            <fmt:formatDate value="${dto.attnInTime}" pattern="HH:mm"/>
                                        </c:when>
                                        <c:otherwise>--:--</c:otherwise>
                                    </c:choose>
                                    ~
                                    <c:choose>
                                        <c:when test="${not empty dto.attnOutTime}">
                                            <fmt:formatDate value="${dto.attnOutTime}" pattern="HH:mm"/>
                                        </c:when>
                                        <c:otherwise>--:--</c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td style="color: #222;">
                                    <c:choose>
                                        <c:when test="${dto.attnWorkTime > 0}">${dto.attnWorkTime}시간</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td style="color: #222;">
                                    <c:choose>
                                        <c:when test="${dto.attnRecord == '정상출근'}">
                                            <span style="color: #2ec4b6; margin-right: 4px;">●</span> ${dto.attnRecord}
                                        </c:when>
                                        <c:when test="${dto.attnRecord == '지각' || dto.attnRecord == '결근' || dto.attnRecord == '조퇴'}">
                                            <span style="color: #ff3333; margin-right: 4px;">●</span> ${dto.attnRecord}
                                        </c:when>
                                        <c:otherwise>
                                            ${dto.attnRecord}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- 페이지네이션 -->
    <div class="cell center mb-30" style="display: flex; justify-content: center; align-items: center; gap: 15px; margin-top: 40px;">
        <span style="border: 1px solid #333; padding: 4px 8px; font-weight: bold; background-color: #fff;">1</span>
        <span style="cursor: pointer; color: #555;">2</span>
        <span style="cursor: pointer; color: #555;">3</span>
        <span style="cursor: pointer; color: #555;">4</span>
        <span style="cursor: pointer; color: #555;">5</span>
        <span style="cursor: pointer; color: #555;">6</span>
        <span style="cursor: pointer; color: #555;">7</span>
        <span style="cursor: pointer; color: #555;">8</span>
        <span style="cursor: pointer; color: #555;">9</span>
        <span style="cursor: pointer; color: #555;">10</span>
        <span style="display: inline-flex; align-items: center; justify-content: center; width: 22px; height: 22px; background-color: #000; color: #fff; border-radius: 50%; font-size: 12px; cursor: pointer;">
            &#10142;
        </span>
    </div>

    <!-- 하단 연차 정보 요약 -->
    <div class="cell mt-30" style="padding-top: 20px; border-top: 1px solid #ddd; width: 300px; margin-bottom: 40px;">
        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
            <span style="font-size: 15px; color: #333;">총 연차</span>
            <div style="position: relative; display: inline-block;">
                <input type="text" value="15" readonly 
                       style="width: 100px; padding: 6px 25px 6px 10px; border: 1px solid #333; border-radius: 8px; text-align: right; font-size: 14px;">
                <span style="position: absolute; right: 8px; top: 7px; font-size: 13px; color: #333;">일</span>
            </div>
        </div>
        <div style="display: flex; align-items: center; justify-content: space-between;">
            <span style="font-size: 15px; color: #333;">잔여연차일수</span>
            <div style="position: relative; display: inline-block;">
                <input type="text" value="11.5" readonly 
                       style="width: 100px; padding: 6px 25px 6px 10px; border: 1px solid #333; border-radius: 8px; text-align: right; font-size: 14px;">
                <span style="position: absolute; right: 8px; top: 7px; font-size: 13px; color: #333;">일</span>
            </div>
        </div>
    </div>

</div>

<!-- 스크립트 영역 -->
<script>
    function changeDate() {
        document.getElementById("searchForm").submit();
    }
    
    function setToday() {
        const now = new Date();
        document.getElementById("yearSelect").value = now.getFullYear();
        document.getElementById("monthSelect").value = String(now.getMonth() + 1).padStart(2, '0');
        changeDate();
    }
</script>

<!-- 하단 푸터 영역 불러오기 -->
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>