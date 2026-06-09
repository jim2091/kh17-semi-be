<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/admin_attn_side_home.jsp"></jsp:include>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>근무제도 관리</title>
<style>
    /* 근무제도 전용 클래스 스타일링 */
    .work-system-container {
        padding: 20px;
        max-width: 600px;
    }
    
    .work-title-area {
        width: 100%;
        border-bottom: 1px solid #333333;
        padding-bottom: 6px;
        margin-bottom: 25px;
    }
    
    .work-title-area h2 {
        font-size: 16px;
        font-weight: bold;
        color: #000000;
        margin: 0;
    }
    
    .work-item-group {
        margin-bottom: 20px;
    }
    
    .work-item-row {
        display: flex;
        align-items: center;
        margin-bottom: 15px;
    }
    
    .work-custom-box {
        width: 16px;
        height: 16px;
        cursor: pointer;
        margin-right: 12px;
        accent-color: #000000;
    }
    
    .work-item-label {
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        user-select: none;
    }
    
    .work-btn-area {
        margin-top: 20px;
    }
    
    .work-submit-btn {
        padding: 5px 12px;
        font-size: 12px;
        background-color: #1a1a1a;
        color: #ffffff;
        border: none;
        border-radius: 2px;
        cursor: pointer;
    }
    
    .work-submit-btn:hover {
        background-color: #333333;
    }
</style>

<script>
    // 체크박스 형식 다중 선택 방지 로직
    function toggleWorkSystem(obj) {
        const boxes = document.getElementsByName("work_code");
        
        if (!obj.checked) {
            obj.checked = true;
            return;
        }
        
        boxes.forEach((box) => {
            if (box !== obj) {
                box.checked = false;
            }
        });
    }
</script>
</head>
<body>
<div class="work-system-container">
    
    <div class="work-title-area">
        <h2>근무제도 관리</h2>
    </div>

    <form action="${pageContext.request.contextPath}/attn/admin/manage" method="post">
        <div class="work-item-group">
            
            <%-- DB에서 조회한 근무제도 목록만 매핑 --%>
            <c:forEach var="work" items="${workSystemList}">
                <div class="work-item-row">
                    <input type="checkbox"
                           id="ws_${work['WORK_CODE']}"
                           name="work_code"
                           value="${work['WORK_CODE']}"
                           class="work-custom-box"
                           onclick="toggleWorkSystem(this)"
                           <c:if test="${work['IS_ACTIVE'] eq 'Y'}">checked="checked"</c:if>>

                    <label for="ws_${work['WORK_CODE']}" class="work-item-label">
                        <c:out value="${work['WORK_NAME']}" />
                    </label>
                </div>
            </c:forEach>
            
        </div>

        <div class="work-btn-area">
            <button type="submit" class="work-submit-btn">설정 저장</button>
        </div>
    </form>
    
</div>
</body>
</html>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>