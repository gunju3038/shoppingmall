<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 목록</title>
<style type="text/css">

h2{
  text-align:center;
  margin:0;
}
h5{
	margin-left: 5px;
    font-size: 15px;
    line-height: 4px;
}
.member_list{
	margin-top: 24px;
    width: 72%;
    min-width:1360px;
    left:330px;
    position: absolute;
}
.membertable {
    width: 100%;
    margin-top:20px;
    border-collapse: collapse;
}

.membertable th, .membertable td {
    padding: 8px;
    border: 1px solid #dddddd;
    background-color: #ffffff;
}

.membertable th {
    background-color: #333;
    color: #ffffff;
}

.searchDiv{
	float: right;
}
th{
	text-align: center;
}
</style>
</head>
<body>
<div class="member_list">
	<h2>회원 목록</h2>
	<div class="searchDiv">
	<form action="member_search" method="post">
	<select name="search_key" style="height: 26px;">
		<option value="아이디">아이디</option>
		<option value="이름">이름</option>
		<option value="회원등급">회원등급</option>
	</select>	
	<input type="text" name="search_value" required="required">
	<label for="member_search" style="border: 1px solid; width: 40px; height: 26px;"><h5>검색</h5></label> 
	<input type="submit" id="member_search" style="display: none;" >
	</form>
	</div>
	<table class="membertable">
		<tr>
			<th>아이디</th>
			<th>비밀번호</th>
			<th>이름</th>
			<th>전화번호</th>
			<th>이메일</th>
			<th>주민번호</th>
			<th>주소</th>
			<th>회원등급</th>
			<th>비고</th>
		</tr>
		
	<c:forEach items="${list }" var="aa">	
		<tr>
			<td>${aa.id }</td>
			<td>${aa.pw }</td>
			<td>${aa.name }</td>
			<td>${aa.tel }</td>
			<td>${aa.email }</td>
			<td>${aa.pid }</td>
			<td>${aa.address }</td>
			<td>${aa.stringrank }</td>
			<td>
				<a href="adminmembershipupdateview?id=${aa.id }"><input type="button" value="수정하기"></a>
				<a href="membershipdeleteview?id=${aa.id }"><input type="button" value="삭제하기"></a>
			</td>
		</tr>
	</c:forEach>
	
</table>
</div>
</body>
</html>