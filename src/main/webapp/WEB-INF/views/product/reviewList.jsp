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
a{
	text-decoration: none;
	color: gray;
}
h2{
  text-align:center;
  margin-bottom:20px;
}
h5{
	margin-left: 5px;
    font-size: 15px;
    line-height: 4px;
}

.admintouttable {
  border-top: solid 2px black;
  border-collapse: collapse;
  width: 100%;
  font-size: 14px;
}
.adminoutth {
  padding: 15px 0px;
  border-bottom: 1px solid lightgrey;
  text-align: center;
}
.adminouttd {
  padding: 15px 0px;
  border-bottom: 1px solid lightgrey;
  text-align: center;
}
.product_list{
	margin-top: 24px;
    width: 72%;
    min-width:1360px;
    left:330px;
    position: absolute;

}
.cart_list img{
  width: 120px;
  height: 140px;
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
.searchDiv{
	float: right;
}
</style>
</head>
<body>
<div class="product_list">
<form action="product_search" method="get">
	<h2>리뷰 관리</h2>
	</form>
        <div class="cart_list">    	
        	<table class="admintouttable" >
            	<tr>
				    <th class="adminoutth">이미지</th>
				    <th class="adminoutth">상품명</th>
				    <th class="adminoutth">아이디</th>
				    <th class="adminoutth">리뷰제목</th>
				</tr>
 				<c:forEach items="${list }" var="aa">
 				 <tr class="cart_list_detail"> 
 				    <td class="adminouttd">						    
 				    	<c:set var="imageArray" value="${fn:split(aa.image, ',')}" />
						<c:forEach items="${imageArray}" var="imageName" varStatus="loop">
		   					<c:if test="${loop.index == 0}">
		       					<img alt="" src="./image/${imageName}" width="100px" height="100px">
		   					</c:if>
						</c:forEach>
					</td> 
					<td class="adminouttd"><a href="detailReview?bnum=${aa.bnum}">${aa.sname}</a></td>
 				    <td class="adminouttd">${aa.id}</td>
 				    <td class="adminouttd">${aa.btitle}</td> 
				    <td class="adminouttd"></td>
				</tr> 
				
				</c:forEach> 
				<tr style="border-left: none;border-right: none;border-bottom: none;">
				   <td colspan="5" style="text-align: center; font-size: 15px;  padding: 10px;">
	   
	   			   <c:if test="${paging.startPage!=1 }"> 
	      		   		<a href="productout?nowPage=${paging.startPage-1 }&cntPerPage=${paging.cntPerPage}">◀</a> 
	   			   </c:if>  
	      		<c:forEach begin="${paging.startPage }" end="${paging.endPage}" var="p"> 
	         	<c:choose>
	            <c:when test="${p == paging.nowPage }"> 
	               <b><span style="color: black;">${p}</span></b>
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
       </div>
</div>
</body>
</html>