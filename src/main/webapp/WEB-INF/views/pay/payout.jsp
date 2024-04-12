	

	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 구입 결과</title>

<style type="text/css">

h2{
  text-align:center;
  margin:0;
}
.order_list{
	margin-top: 24px;
    width: 72%;
    min-width:1360px;
    left:330px;
    position: absolute;
}
.ordertable {
    width: 100%;
    margin-top:20px;
    border-collapse: collapse;
}

.ordertable th, .ordertable td {
    padding: 8px;
    border: 1px solid #dddddd;
    background-color: #ffffff;
}

.ordertable th {
    background-color: #333;
    color: #ffffff;
}


</style>
</head>
<body>
<div class="order_list">
	<h2>주문 목록</h2>
<table class="ordertable">

	<tr>
		<th>주문번호</th>
		<th>상품명</th>
		<th>구입수량</th>
		<th>금액</th>
		<th>결재시간</th>
		<th>상태</th>
		<th>비고</th>
	</tr>
	<c:forEach items="${list }" var="aa">
	<tr>
		<td>${aa.orderid }</td>
		<td>${aa.sname }</td>
		<td>${aa.paynum }</td>
		<td>${aa.totprice }</td>
		<td>${aa.payendtime }</td>
		<td>결재완료</td>
		<td style="width: 180px; text-align: center;">
			<input type="button" value="환불하기">
			<input type="button" value="교환하기">
		</td>
	</tr>
</c:forEach>
</table>
</div>
</body>
</html>