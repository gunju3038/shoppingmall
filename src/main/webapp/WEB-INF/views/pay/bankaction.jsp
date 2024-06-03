<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.bankDiv{ 
	text-align: center;
    border: 2px solid gray;
    width: 700px;
    top: 30%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 24px;
    position: relative;
    padding: 10px 10px;
    margin-top: 150px;
}
</style>
</head>
<body>
<div class="bankDiv">
	<p>아래 계좌번호로 입금 부탁드립니다.</p>
	<p>은행명: ${bankChoice}은행</p>
	<p>계좌번호: ${account}</p>
	<p>입금이 확인되면 주문이 처리될 예정입니다. 감사합니다.</p>
</div>
</body>
</html>