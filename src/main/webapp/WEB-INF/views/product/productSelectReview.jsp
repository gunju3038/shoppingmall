<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
.container {
    width: 1000px;
    height: auto;
    margin: auto;
    margin-top: 30px;
    margin-bottom: 20px;
    border: 1px solid #ccc;
    border-radius: 9px;
    border-top: 10px solid #000000;
    border-bottom: 10px solid #000000;
    padding: 20px;
    background-color: #fff;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    overflow: hidden;
}

.inputform {
    margin-bottom: 20px;
    margin-top: 10px;
}

.inputform span {
    margin-bottom: 5px;
    font-size: 18px;
}
.inputform input[type="radio"]{
	margin: 0;
    width: 20px;
    height: 20px;
    accent-color: black;
    margin-right: 3px;
    vertical-align: -3px;
}

.btn-container button {
    margin: 0 20px;
    width: 100px;
    background-color: #16222A;
    color: #fff;
    border: none;
    border-radius: 5px;
    padding: 8px 16px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.btn-container {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
}

.btn-container button:hover {
    background-color: #000000;
}

h2 {
    margin-bottom: 10px;
    margin-top: 3%;
}
</style>
<meta charset="UTF-8">
<title>상품 리뷰</title>
</head>
<body>
<div class="container" role="main">
    <h2 class="notice">리뷰 할 상품을 선택하세요</h2>
    <form action="productreviewinput" method="get">
        <div class="inputform">
          	<c:forEach items="${list}" var="aa">
			    <input type="radio" name="snum" value="${aa.snum}" id="product_${aa.snum}">
			    <label for="product_${aa.snum}">
			        <span class="name">${aa.sname}</span>
			    </label>
			    <br>
			</c:forEach>
        </div>
        <div class="btn-container">
            <button type="submit" class="btn btn-sm btn-primary" id="btnSave">리뷰등록</button>
            <button type="button" class="btn btn-sm btn-primary" id="btnList" onclick="history.back()">이전</button>
        </div>
    </form>
</div>
</body>
</html>
