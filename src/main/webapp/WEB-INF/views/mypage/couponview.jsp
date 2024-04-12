<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>쿠폰 보기</title>
</head>
<body>
<c:forEach items="${list }" var="aa">
	<table border="1" width="400px" align="center">
		<tr>
			<th>쿠폰 총 개수 : ${aa.couponnum }</th>
		</tr>
		<tr>
			<th>만원 쿠폰 개수 : ${aa.mannum } </th>
		</tr>
		<tr>
			<th>20% 할인 쿠폰 개수 : ${aa.twentinum }</th>
		</tr>
		<tr>
			<th>10% 할인 쿠폰 개수 : ${aa.tennum }</th>
		</tr>
	</table>
</c:forEach>
</body>
</html>