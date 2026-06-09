<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
	.side-title{
	    background:#fafafa;
	    border-bottom:1px solid #ddd;
	    padding:15px;
	    font-size:20px;
	    font-weight:bold;
	    text-align:center;
	}
	
	.side-link{
	    display:block;
	    padding:10px 15px;
	    text-decoration:none;
	    color:#333;
	    font-size:17px;
	    text-align: left !important;
	}
	
	.side-link:hover{
	    background:#f5f5f5;
	}
	
	.rank-link{
	    display:block;
	    padding:8px 12px;
	    text-decoration:none;
	    color:#333;
	    font-size:14px;
	    white-space:nowrap;
	    overflow:hidden;
	    text-overflow:ellipsis;
	}
	.board-rank{
	    height:180px;
	}
	
	.side-section{
	    border:1px solid #e5e5e5;
	    border-radius:10px;
	    overflow:hidden;
	    margin-bottom:15px;
	}
	
	.side-section:last-child{
	    border-bottom: none;
	}
</style>
<div class="container w-100 mt-10 side-area center cell flex-fill">
	<div class="board-side">
		<div class="side-section">
           	 <div class="side-title">부서목록</div>
          	 	<div>
			        <c:forEach var="deptDto" items="${list}">
			        	<c:if test="${deptDto.parentDeptId==0}">
				            <a href="./detail?deptId=${deptDto.deptId}" class="side-link">
				                <i class="fa-solid fa-folder style="margin-right: 5px; color: #ffb703;"></i>
				                ${deptDto.deptName}
				            </a>
				        </c:if>
			        </c:forEach>
   				</div>
        </div>
    </div>                	 
</div>
                    
                
</div>
<div class="w-200 flex-fill">