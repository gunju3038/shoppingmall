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
  margin:0;
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
	<h2>상품관리</h2>
	<div class="searchDiv">
	<select name="search_key" style="height: 26px;">
		<option value="전체">전체</option>
		<option value="상의">상의</option>
		<option value="하의">하의</option>
		<option value="아우터">아우터</option>
	</select>	
	<input type="text" name="search_value" >
	<label for="product_search" style="border: 1px solid; width: 40px; height: 26px;"><h5>검색</h5></label> 
	<input type="submit" id="product_search" style="display: none;">
	</div>
	</form>
        <div class="cart_list">    	
        	<table class="admintouttable" >
            	<tr>
				    <th class="adminouttd">이미지</th>
				    <th class="adminouttd">분류</th>
				    <th class="adminouttd">상품명</th>
				    <th class="adminouttd">사이즈 별 재고</th>
				    <th class="adminouttd">상품금액</th>
				    <th  class="adminouttd" style="width: 150px;">비고</th>
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
					<td class="adminouttd">${aa.stype}</td>
 				    <td class="adminouttd">${aa.sname}</td> 
 				    
				    <td class="adminouttd">
 				    	<p>S : ${aa.ssize}</p>
 				    	<p>M : ${aa.msize}</p>
 				    	<p>L : ${aa.lsize}</p>
 				    	<p>XL : ${aa.xlsize}</p>	
 				    </td> 
					<td class="adminouttd"><f:formatNumber value="${aa.price }" pattern="#,###원"/> </td>
				    <td class="adminouttd">
						<button type="button" class="cart_delete" onclick="modifyProduct(${aa.snum})">수정</button>
						<button type="button" class="cart_delete" onclick="deleteProduct(${aa.snum})">삭제</button>
				</tr> 
				</c:forEach> 
				<tr style="border-left: none;border-right: none;border-bottom: none;">
				   <td colspan="7" style="text-align: center; font-size: 15px;  padding: 10px;">
	   
	   			   <c:if test="${paging.startPage!=1 }"> 
	      		   		<a href="product_search?nowPage=${paging.startPage-1 }&cntPerPage=${paging.cntPerPage}&search_key=${search_key}&search_value=${search_value}">◀</a> 
	   			   </c:if>  
	      		<c:forEach begin="${paging.startPage }" end="${paging.endPage}" var="p"> 
	         	<c:choose>
	            <c:when test="${p == paging.nowPage }"> 
	               <b><span style="color: black;">${p}</span></b>
	            </c:when>   
	            <c:when test="${p != paging.nowPage }"> 
	               <a href="product_search?nowPage=${p}&cntPerPage=${paging.cntPerPage}&search_key=${search_key}&search_value=${search_value}">${p}</a>
	            </c:when>   
		         </c:choose>
		      </c:forEach>
			      <c:if test="${paging.endPage != paging.lastPage}">
			      <a href="product_search?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage }&search_key=${search_key}&search_value=${search_value}">▶</a>
			   </c:if>
	   		</td>
		</tr>
       </table>
       </div>
</div>

<script type="text/javascript">
function deleteProduct(snum) {
    if (confirm("정말로 삭제하시겠습니까?")) {
        window.location.href = "deleteProduct?snum=" + snum; 
    }
    else {
		return false;
	}
}
function modifyProduct(snum) {
    window.location.href = "updateproductview?snum=" + snum; 
}
</script>
</body>
</html>