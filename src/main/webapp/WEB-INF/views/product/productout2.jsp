<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
	a{
		text-decoration: none; <!-- 다른 css에 a가 적용되었는지 살필 것 -->
	}
	td{
		border: 0;
		color: #000000;
	}
</style>
<meta charset="UTF-8">
<title>상품 출력</title>
</head>
<body>
<c:forEach items="${list }" var="aa">
	<a href="detailview?snum=${aa.snum}">
		<div>
			<table border="1" width="200px" align="center">
				<tr>
					<td>
						<c:if test="${aa.best eq 1}"> <!-- best가 1이라면 베스트 상품 출력 -->
							베스트 상품
						</c:if>
					</td>
				</tr>
				<tr>
					<td>
						<c:set var="imageArray" value="${fn:split(aa.image, ', ')}" />
						<c:forEach items="${imageArray}" var="imageName" varStatus="loop">
		   					<c:if test="${loop.index == 0}">
		       					<img alt="" src="./image/${imageName }" width="100px" height="100px">
		       					
		   					</c:if>
						</c:forEach>
						<input type="hidden" name="snum" value="${aa.snum }">
					</td>
				</tr>
				<tr>
					<td>${aa.sname }</td>
				</tr>
				<tr>	
					<td><f:formatNumber value="${aa.price }" pattern="#,###원"/> </td>
				</tr>
			</table>
		</div>
	</a>
</c:forEach>

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
</body>
</html>