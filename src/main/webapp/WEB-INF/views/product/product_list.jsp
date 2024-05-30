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
a{
	text-decoration: none;
	color: black;
}
.product_list{
	position: relative;
    margin-top: 30px;
    max-width: 1920px;
    min-width: 1380px;
    padding-left: 80px;
    padding-right: 80px;
}
.product_list h2{
	float: left;
	margin-left: 47%;
	margin-top:0;
	margin-bottom: 30px;
	letter-spacing:0.25em;
	font-weight: bold;
}
.product_list p{
	float: right;
	margin: 15px 1.5% 10px 0;
}
.box{
	overflow: auto;
}
.clear{ 
	clear: both;
}

.product { 
    list-style: none;
    width: 20%;
    float: left;
    margin-bottom: 20px;
    padding: 0 1.5% 0 0;
}

.product img{
	width: 100%;
	margin-bottom: 5px;
}
.product .name{
	font-weight: bold;
	font-size: 16px;
}
.product .price{
	font-size: 14px;
}

.paging {
    margin-top: 20px;
    text-align: center;
    font-size: 18px;
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

.selected {
    font-weight: bold;
}
.product_wrap{
	display: flex;
	flex-wrap: wrap;
}
.review{ 
	display: flex;
	justify-content: space-between;
}
</style>
</head>
<body>
<div class="product_list">
	<div class="box">
		<h2>${stype}</h2>
		<p>
			<a href="product_list?sort=latest&stype=${stype}" class="${sort == 'latest' ? 'selected' : ''}">최신등록순</a> |
            <a href="product_list?sort=highest&stype=${stype}" class="${sort == 'highest' ? 'selected' : ''}">높은가격순</a> |
            <a href="product_list?sort=lowest&stype=${stype}" class="${sort == 'lowest' ? 'selected' : ''}">낮은가격순</a> 
		</p>
		<div class="clear"></div>
		<div class="product_wrap">
 		<c:forEach items="${list }" var="aa" >
			<div class="product">
				<div><a href="detailview?snum=${aa.snum}"> 
					<c:set var="imageArray" value="${fn:split(aa.image, ',')}" />
						<c:forEach items="${imageArray}" var="imageName" varStatus="loop">
		   					<c:if test="${loop.index == 0}">
		       					<img alt="" src="./image/${imageName}">
		   					</c:if>
						</c:forEach>
				</a></div>
				<div class="name"><a href="detailview?snum=${aa.snum}">${aa.sname}</a></div>
				<div class="price"><a href="detailview?snum=${aa.snum}"><f:formatNumber value="${aa.price }" pattern="#,###"/></a></div>

				<c:if test="${aa.count!=0 }">
					<div class="review">
						<div><a href="detailview?snum=${aa.snum}"><img alt="" src="./image/reviewStar.png" style="width: 17px;" > ${Math.round(aa.productrank*10)/10. }</a></div>
						<div><a href="detailview?snum=${aa.snum}">리뷰 수 : ${aa.count }</a></div>
					</div>
				</c:if>
			</div>
		</c:forEach>
		</div>
	</div>
	
	<div class="paging">
		<ul>
			<li>
				<c:if test="${paging.startPage!=1 }"> 
	      		  	<a href="product_list?nowPage=${paging.startPage-1 }&cntPerPage=${paging.cntPerPage}&stype=${stype}&sort=${sort}">◀</a> 
	   			</c:if>  
	      		<c:forEach begin="${paging.startPage }" end="${paging.endPage}" var="p"> 
	         	<c:choose>
	            <c:when test="${p == paging.nowPage }"> 
	               <b><span style="color: black;">${p}</span></b>
	            </c:when>   
	            <c:when test="${p != paging.nowPage }"> 
	               <a href="product_list?nowPage=${p}&cntPerPage=${paging.cntPerPage}&stype=${stype}&sort=${sort}">${p}</a>
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