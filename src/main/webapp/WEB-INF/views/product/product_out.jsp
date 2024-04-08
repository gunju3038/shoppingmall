<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">

h2{
  text-align:center;
  margin:14px;
}
body {
  margin: 0;
  background: #fff;
}
table {
  border-top: solid 2px black;
  border-collapse: collapse;
  width: 100%;
  min-width: 1280px;
  
  font-size: 14px;
}

td {
  padding: 15px 0px;
  border-bottom: 1px solid lightgrey;
  text-align: center;
}
.product_list{
    width: 100%;
    padding-left: 80px;
    padding-right: 80px;
}
.cart_list img{
  width: 180px;
  height: 200px;
}
.cart_list_detail td:nth-child(1) { /* 이미지가 있는 두 번째 열의 td 요소를 선택합니다. */
  width: 160px; /* 이미지 칸의 너비를 조정합니다. */
  text-align: center; /* 이미지를 가운데 정렬합니다. */
}

.cart_list_detail td:not(:nth-child(1)) { /* 이미지가 아닌 나머지 열의 td 요소를 선택합니다. */
  text-align: center; /* 텍스트를 가운데 정렬합니다. */
}



.cart_delete{
  width: 60px;
  height: 30px;
  font-size: 12px;
  margin: auto;
  border-radius: 5px;
  color: #000;
  background-color:#fff;
  border: 1px #808080 solid;
  }


</style>
</head>
<body>
<div class="product_list">
	<h2>상품관리</h2>
	<form>
        <div class="cart_list">    	
        	<table>
            	<tr>
				  
				    <td>이미지</td>
				    <td>상품명</td>
				    <td>사이즈</td>
				    <td>재고</td>
				    <td>상품금액</td>
				    <td>비고</td>
				</tr>
 				<c:forEach items="${list }" var="aa">
 				 <tr class="cart_list_detail"> 
 				    <td>						    
 				    	<c:set var="imageArray" value="${fn:split(aa.image, ', ')}" />
						<c:forEach items="${imageArray}" var="imageName" varStatus="loop">
		   					<c:if test="${loop.index == 0}">
		       					<img alt="" src="resources/image/${imageName}" width="100px" height="100px">
		   					</c:if>
						</c:forEach>
					</td> 
 				    <td>${aa.sname}</td> 
 				    <td>${aa.ssize}</td> 
				    <td>${aa.su} </td> 
					<td><f:formatNumber value="${aa.price }" pattern="#,###원"/> </td>
				    <td>
						<button type="button" class="cart_delete" onclick="위치">수정</button>
				    	<button type="button" class="cart_delete" onclick="위치">삭제</button></td> 
				</tr> 
				
				</c:forEach> 
	
       			</table>
 		
        </div>
	</form>
	<div>
<!-- 페이징처리 -->
<table align="center">
	<tr style="border-left: none;border-right: none;border-bottom: none">
	   <td colspan="5" style="text-align: center;">
	   
	   <c:if test="${paging.startPage!=1 }"> 
	      <a href="productout?nowPage=${paging.startPage-1 }&cntPerPage=${paging.cntPerPage}">◀</a> 
	      
	   </c:if>   
	   
	      <c:forEach begin="${paging.startPage }" end="${paging.endPage}" var="p"> 
	         <c:choose>
	            <c:when test="${p == paging.nowPage }"> 
	               <b><span style="color: red;">${p}</span></b>
	            </c:when>   
	            <c:when test="${p != paging.nowPage }"> 
	               <a href="productout?nowPage=${p}&cntPerPage=${paging.cntPerPage}">${p}</a>
	            </c:when>   
	         </c:choose>
	      </c:forEach>
	     
	      <c:if test="${paging.endPage != paging.lastPage}">
	      <a href="productout?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage }">▶</a>
	   </c:if>
	   
	   </td>
	</tr>
</table>
<!-- 페이징처리 -->
</div>
	
</div>
</body>
</html>