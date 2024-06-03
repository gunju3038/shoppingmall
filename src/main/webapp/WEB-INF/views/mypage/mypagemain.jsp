<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
table{
	border: none;
	margin-left: auto; 
	margin-right: auto;

}
th{
	text-align: center;
	padding-top: 25px;
	padding-bottom: 10px;
}
td{
	text-align: center;
	padding-bottom: 5px;
}
.bottomline{
	align-content: center;
	text-align: center;
	padding-bottom: 3px;
	border-bottom: 1px solid black;
}
#top{
	padding-top: 7px;
}
tr{
	text-align: center;
}
a{
	text-align: center;
}
#sidemenu{
	width: 250px;
	border-right: 1px;
	border-right-color: gray;
}

@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap');
.amdinline{ 
	position: fixed;
	left:300px;
	top: 0;
	height: 100vh;
	border-right: 2px solid #eeeeee;
}
.admintable{
	border: none;
	z-index: 999;
	position: relative;
  	width: 300px;
}
.adminth{
	padding-top: 25px;
	padding-bottom: 10px;
	text-align: center;
	
}
.admintd{
	padding-bottom: 5px;
	text-align: center;
	color: gray;
}
.admintd a {
    text-decoration: none;
    color: #3B5249;
    transition: color 0.3s ease, text-decoration 0.3s ease;
}

.admintd a:hover {
    text-decoration: underline;
    color: #1D2D50;
}

a{
	text-decoration: none;
	color: black;
}
.bottomline{
	padding-bottom: 3px;
	border-bottom: 1px solid black;
}



h2{
  text-align:center;
  margin-top:40px;
}
.order_list{
	margin-top: 24px;
    width: 72%;
    min-width:1360px;
    left:330px;
    position: absolute;
}
.ordertable {
    width: 50%;
    margin-top:20px;
    border-collapse: collapse;
    text-align: center;
}

.ordertable th, .ordertable td {
    padding: 8px;
    border: 1px solid #dddddd;
    background-color: #ffffff;
    text-align: center;
}

.ordertable th {
    background-color: #333;
    color: #ffffff;
}
.product_list{
	position: absolute;
 	margin-top: 3%;
	left: 320px;
	display: flex;
}
.product_list h3{
	float: left;
	margin-left: 42%;
	margin-top:0;
	margin-bottom: 30px;
}

.box{
	overflow: auto;
}
.clear{ 
	clear: both;
}
.product{ 
    list-style: none;
    width: 20%;
    float: left;
    margin-bottom: 20px;
    padding: 0 1.5% 0 0;
	
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



</style>
<meta charset="UTF-8">
<title>마이 페이지 메인</title>
</head>
<body>
<c:forEach items="${list }" var="aa">
	<div>
		
		
		<div>
			<table width="700px" align="center">
				<tr>
					<th>${aa.id}(${aa.membershipdto.name})님의 현재 회원 등급은 ${aa.membershipdto.stringrank } 입니다.</th>
					<th class="admintd"><a href="rankgift">등급별 혜택</a></th>
				</tr>
				
			</table>
			
			<table width="400px" align="center">
				<tr>
					<th>쿠폰</th>
					<th>마일리지</th>
				</tr>
				<tr>
					<td class="admintd"><a href="couponview">${aa.couponnum }</a></td>
					<td class="admintd">
						<a href="mileageview"> 
							<f:formatNumber value="${aa.membershipdto.point }" pattern="#,###M"/>
						</a>
					</td>
				</tr>
			</table>
			
			<table width="800px" align="center">
				<tr align="center">
					<th colspan="2" class="bottomline">최근 주문 상품 5개(1달 이내)</th>
				</tr>
			</table>
		
			<table width="1000px" align="center" class="ordertable">
			
				<tr>
				    <c:choose>
				        <c:when test="${not empty list2}">
				            <div id="datatrue">
				                <tr>
				                    <th>주문번호</th>
				                    <th>상품명</th>
				                    <th>구입수량</th>
				                    <th>금액</th>
				                    <th>구매일</th>
				                    <th>상태</th>
				                    <th>비고</th>
				                </tr>
				                <c:forEach items="${list2}" var="bb">
				                    <tr>
				                        <td>${bb.orderid}</td>
				                        <td>${bb.sname}</td>
				                        <td>${bb.paynum}</td>
				                        <td><f:formatNumber value="${bb.totprice}" pattern="#,###"/></td>
				                        <td>${bb.payendtime.substring(0,10)}</td>
				                        <td>${bb.paystate}</td>
				                        <td class="admintd" style="width: 180px; text-align: center;">
				                        	<a href="productreviewinput?snum=${bb.snum }"><button type="button">리뷰쓰기</button></a>
							          		<a href="paycancel?orderid=${bb.orderid }"><input type="button" value="환불하기"></a>
				                        </td>
				                    </tr>
				                </c:forEach>
				            </div>
				        </c:when>
				        <c:otherwise>
				            <div id="datafalse">
				                <td colspan="2" id="top">최근 주문 내역이 없습니다.</td>
				            </div>
				        </c:otherwise>
				    </c:choose>
				</tr>
				
				
			</table>
			
			<table width="400px" align="center">
				<tr>
					<th class="admintd"><a href="guestpayoutview">주문 배송 조회</a></th>
					<th class="admintd"><a href="refundview">환불/교환/취소 조회</a></th>
				</tr>
			
			</table>
		
			
			
					<div class="product_list">
					<div class="box">
						<h3>베스트 상품</h3>
					<div class="clear"></div>
				 		<c:forEach items="${list3 }" var="cc">
							<div class="product">
								<div><a href="detailview?snum=${cc.snum}"> 
									<c:set var="imageArray" value="${fn:split(cc.image, ',')}" />
										<c:forEach items="${imageArray}" var="imageName" varStatus="loop">
						   					<c:if test="${loop.index == 0}">
						       					<img alt="" src="./image/${imageName}">
						   					</c:if>
										</c:forEach>
								</a></div>
								<div class="name"><a href="detailview?snum=${cc.snum}">${cc.sname}</a></div>
								<div class="price"><a href="detailview?snum=${cc.snum}"><f:formatNumber value="${cc.price }" pattern="#,###"/></a></div>
								<c:if test="${cc.count!=0 }">
									<div class="review">
										<div><a href="detailview?snum=${cc.snum}"><img alt="" src="./image/reviewStar.png" style="width: 17px;" > ${Math.round(cc.productrank*10)/10. }</a></div>
										<div><a href="detailview?snum=${cc.snum}">리뷰 수 : ${cc.count }</a></div>
									</div>
								</c:if>
							</div>
						</c:forEach>
					</div>
					</div>

		</div>
	</div>	
</c:forEach>
</body>
</html>