<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
.container {
    margin: 0;
    top: 20%;
    left: 50%;
    position: absolute;
    transform: translateX(-50%);
    background-color: #fff;
    border-radius: 9px;
    border-top: 10px solid #000;
    border-bottom: 10px solid #000;
    width: 600px;
    height: 350px;
    border-left: 1px solid #808080;
    border-right: 1px solid #808080;
}

body {
    color: #666;
    font-family: 'Noto Sans KR', sans-serif;
}

h2 {
    font-family: 'Noto Sans KR', sans-serif;
    color: #414345;
    font-size: 25px;
    margin-top: 30px;
    text-align: center;
}

h4 {
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 20px;
    text-align: center;
    color: #3A6073;
    margin-top: 0px;
}

table {
    border-collapse: collapse;
    border-spacing: 0;
    width: 90%;
    margin: 15px auto;
    margin-top: 30px;
}

tr td,
tr th {
    padding-top: 10px;
    padding-bottom: 10px;
}

th,
td {
    padding: 6px 15px;
    border: 1px solid #c6c9cc;
}

th {
    background: #000;
    color: #fff;
    text-align: center;
}

td {
    border-right: 1px solid #c6c9cc;
    border-bottom: 1px solid #c6c9cc;
    background-color: #fff;
    text-align: left;
}

.movebtn {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

.btn1,
.btn2,
.btn3 {
    border: 0;
    background: #333;
    color: #fff;
    border-radius:10px;
    width: 150px;
    height: 40px;
    font-size: 16px;
    margin-left: 15px;
    transition: 0.3s;
    cursor: pointer;
}

.btn1:hover,
.btn2:hover,
.btn3:hover {
    background: #000000;
}
</style>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="container">
	<h2>아이디찾기</h2>
	<h4>고객님 아이디 찾기가 완료 되었습니다.</h4>
	<c:forEach items="${list }" var="aa">
	<table>
	    <tr><th>이름</th><td>${aa.name }</td></tr>
	    <tr><th>ID</th><td>${aa.id }</td></tr>
	    <tr><th>email</th><td>${aa.email }</td></tr>
	</table>
	</c:forEach>
		<div class="movebtn">
			<button onclick="location.href='./pwforget'" class="btn1">비밀번호 찾기</button>
			<button onclick="location.href='./login'" class="btn2">로그인</button>
			<button onclick="location.href='./membershipjoin2'" class="btn3">회원가입</button>
		</div>
	</div>
</body>
</html>