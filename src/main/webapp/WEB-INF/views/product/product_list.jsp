<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.product_list{
	position: relative;
 	margin-top: 3%;
	width: 1920px; 
	padding-left: 5%;
	padding-right: 5%;	
}
.product_list h3{
	float: left;
	margin-left: 47%;
	margin-top:0;
	margin-bottom: 30px;
}
.product_list p{
	float: right;
	margin-bottom: 10px;
	margin-top: 15px;
}
.box{
	height: 1020px;
}
.clear{ 
	clear: both;
}
.product{ 
	list-style:none;
	width: 340px;
	float: left;
	margin-bottom: 30px;
	
}
.product img{
	width: 100%;
	margin-bottom: 10px;
}
.product .name{
	font-weight: bold;
	font-size: 18px;
}
.product .price{
	font-size: 14px;
}

.paging {
    margin-top: 20px;
    text-align: center;
}

.paging ul {
    list-style: none;
    padding: 0;
}

.paging ul li {
    display: inline;
    margin-right: 5px;
}

.paging ul li a {
    text-decoration: none;
}

.paging ul li b {
    color: red;
}
</style>

</head>
<body>

<div class="product_list">
	<div class="box">
		<h3>${stype}</h3>
		<p> 최신등록순 | 높은가격순 | 낮은가격순 </p>
		<div class="clear"></div>
 		<c:forEach items="${list }" var="aa">
			<ul class="product">
				<li><a href="detailview?snum=${aa.snum}"> 
					<c:set var="imageArray" value="${fn:split(aa.image, ', ')}" />
						<c:forEach items="${imageArray}" var="imageName" varStatus="loop">
		   					<c:if test="${loop.index == 0}">
		       					<img alt="" src="resources/image/${imageName}" width="300px" height="360px">
		   					</c:if>
						</c:forEach>
				</a></li>
				<li class="name"><a href="detailview?snum=${aa.snum}">${aa.sname}</a></li>
				<li class="price"><a href="detailview?snum=${aa.snum}"><f:formatNumber value="${aa.price }" pattern="#,###"/></a></li>
				<li class="intro"><a href="detailview?snum=${aa.snum}">${aa.intro }</a></li>
				<li class="review"><a href="detailview?snum=${aa.snum}">.리뷰갯수</a></li>
			</ul>
		</c:forEach>
		
	</div>
	
	<div class="paging">
		<ul>
			<li>
				<c:if test="${paging.startPage!=1 }"> 
	      		  	<a href="product_list?nowPage=${paging.startPage-1 }&cntPerPage=${paging.cntPerPage}&stype=${stype}">◀</a> 
	   			</c:if>  
	      		<c:forEach begin="${paging.startPage }" end="${paging.endPage}" var="p"> 
	         	<c:choose>
	            <c:when test="${p == paging.nowPage }"> 
	               <b><span style="color: black;">${p}</span></b>
	            </c:when>   
	            <c:when test="${p != paging.nowPage }"> 
	               <a href="product_list?nowPage=${p}&cntPerPage=${paging.cntPerPage}&stype=${stype}">${p}</a>
	            </c:when>   
		         </c:choose>
		      </c:forEach>
			      <c:if test="${paging.endPage != paging.lastPage}">
			      <a href="product_list?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage }&stype=${stype}">▶</a>
			   </c:if>
			<li>   
		</ul>
	</div>
	<div class="clear"></div>
</div>
</body>
</html>