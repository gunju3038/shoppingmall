<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
th, td{
	text-align: center;
}
table{
	border: none;
}
th{
	padding-top: 25px;
	padding-bottom: 10px;
}
td{
	padding-bottom: 5px;
}
.bottomline{
	padding-bottom: 3px;
	border-bottom: 1px solid black;
}
#top{
	padding-top: 7px;
}

</style>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>
<body>
<table width="300px" align="left">
	<tr>
		<th>상품 주문 현황</th>
	</tr>
	<tr>
		<td><a href="payoutviewall">현재 주문 목록 보기</a></td>
	</tr>
	<tr>
		<td>환불 목록 보기</td>
	</tr>
	<tr>
		<td>교환 목록 보기</td>
	</tr>
	
	<tr>
		<th>회원 가입 현황</th>
	</tr>
	<tr>
		<td><a href="memberviewall">회원 목록</a></td>
	</tr>
</table>
</body>
</html>