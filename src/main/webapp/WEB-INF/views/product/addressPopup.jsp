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
h2{
	text-align: center;
}
a{
	text-decoration: none;
	color: black;
}
.addresslist{
	margin: 5px;
	padding: 10px;
	border: 1px solid gray;
	display: flex;
	justify-content: space-between;
}

.btn_div {
    display: flex;
    justify-content: flex-end; 
    align-items: center; /* 세로 방향 중앙 정렬 */
}
.btn_div button{
	min-width: 60px; 
	height: 40px;
    padding: 0 10px;
    line-height: 28px;
    font-size: 14px;
    font-weight: 700;
    border-radius: 2px;
    background-color: #333;
    color: white;
}
</style>
</head>
<body>
<h2>배송지 목록</h2>
<c:forEach items="${list }" var="aa">
<div class="addresslist">
	<div class="list_div">
	<c:set var="addressArray" value="${fn:split(aa.address, ',')}" />
	 <a href="#" onclick="setAddress('${aa.adlistname}', '${aa.tel}', '${addressArray[0]}', '${addressArray[1]}', '${addressArray[2]}'); return false;">
	<span style="font-weight: 700; font-size: 18px;">${aa.adlistname }</span><br>
	<span>${aa.tel }</span> <br>
	<span>${addressArray[0]}</span>
	<span>${addressArray[1]}</span>
	<span>${addressArray[2]}</span> 
	</a>
	</div>
	<div class="btn_div">
		<button type="button" onclick="setAddress('${aa.adlistname}', '${aa.tel}', '${addressArray[0]}', '${addressArray[1]}', '${addressArray[2]}')">선택</button>
	</div>
</div>
</c:forEach>

<script type="text/javascript">
function setAddress(name,tel,postcode,address1,address2) {
	window.opener.document.getElementById('name').value = name;
	window.opener.document.getElementById('tel').value = tel;
    window.opener.document.getElementById('postcode').value = postcode;
    window.opener.document.getElementById('address1').value = address1;
    window.opener.document.getElementById('address2').value = address2;
    window.close();
}
</script>
</body>
</html>