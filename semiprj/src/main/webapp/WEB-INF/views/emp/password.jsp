<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>


<div class="gw-page-head">
    <div class="gw-breadcrumb">
        마이페이지 > 비밀번호 변경
    </div>

    <h1>비밀번호 변경</h1>
    <p>기존 비밀번호 확인 후 새로운 비밀번호로 변경할 수 있습니다.</p>
</div>

<form action="./password" method="post">

    <div class="container w-80">

        <div class="gw-list-panel">

            <table class="gw-table">
                <tbody>

                    <tr>
                        <th width="220">기존 비밀번호</th>
                        <td>
                            <input type="password"
                                   name="originPw"
                                   class="gw-form-input">
                        </td>
                    </tr>

                    <tr>
                        <th>새 비밀번호</th>
                        <td>
                            <input type="password"
                                   name="changePw"
                                   class="gw-form-input">
                        </td>
                    </tr>

                </tbody>
            </table>

        </div>

        <c:if test="${param.error != null}">
            <div class="gw-list-panel mt-20">
                <i class="fa-solid fa-triangle-exclamation"></i>
                비밀번호가 일치하지 않거나 기존 비밀번호와 동일합니다.
            </div>
        </c:if>

        <div class="mt-30"
             style="
                display:flex;
                justify-content:center;
                gap:10px;
             ">

            <button type="submit"
                    class="gw-btn-primary">
                <i class="fa-solid fa-key"></i>
                비밀번호 변경
            </button>

            <a href="./mypage"
               class="gw-btn-outline">
                <i class="fa-solid fa-arrow-left"></i>
                돌아가기
            </a>

        </div>

    </div>

</form>




<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>