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
    width: 80%;
    margin-top:20px;
    border-collapse: collapse;
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
th{
	text-align: center;
}
</style>
</head>
<body>
<div class="order_list">
	<h2>마일리지 목록</h2>
<table align="center" class="ordertable">
	<tr>
		<th>주문번호</th>
		<th>상품명</th>
		<th>구입수량</th>
		<th>금액</th>
		<th>결재시간</th>
		<th>상태</th>
		<th>사용 마일리지</th>
		<th>마일리지 획득</th>
		<th>총 마일리지</th>
	</tr>
	<c:forEach items="${list }" var="aa">
	<tr>
		<td>${aa.orderid }</td>
		<td>${aa.sname }</td>
		<td>${aa.paynum }</td>
		<td><f:formatNumber pattern="#,###" value="${aa.totprice }"></f:formatNumber></td>
		<td>${aa.payendtime }</td>
		<td>${aa.paystate }</td>
		<td>
			<f:formatNumber pattern="- #,###" value="${aa.usepoint }"></f:formatNumber>
		</td>
		<td>
			<f:formatNumber pattern="+ #,###" value="${aa.savepoint }"></f:formatNumber>
		</td>
		<td>
			<f:formatNumber pattern="#,###" value="${aa.nowpoint }"></f:formatNumber>
		</td>
		
	</tr>
</c:forEach>
</table>
</div>
</body>
</html>