<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
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
    width: 50%;
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<meta charset="UTF-8">
<title>결제환불</title>
</head>
<body>
<table align="center" class="ordertable">
<c:forEach items="${list }" var="aa">
	<tr>
		<th>주문번호</th>
		<th>상품명</th>
		<th>구입수량</th>
		<th>금액</th>
		<th>결재시간</th>
	</tr>
	<tr>
		<td>${aa.orderid }</td>
		<td>${aa.sname }</td>
		<td>${aa.paynum }</td>
		<td>
			${aa.totprice }
			<input type="hidden" name="totprice" value="${aa.totprice }" id="totprice">
		</td>
		<td>
			${aa.payendtime }
			${aa.orderid }
			<input type="hidden" name="tid" value="${aa.tid }" id="tid">	
			<input type="hidden" name="orderid" value="${aa.orderid }" id="orderid">					
		</td>	
	</tr>	
	<tr>
		<td colspan="5" align="center"><span>정말로 환불하시겠습니까?</span></td>
	</tr>
	<tr>
		<td colspan="5" align="center">
			<button onclick="kakaopaycancel('${aa.payment}')">환불하기</button>
		</td>
	</tr>
	
</c:forEach>
</table>
<script type="text/javascript">
function kakaopaycancel(payment) {
	if (payment === '카카오페이') {
        var formData = {
            tid: $('#tid').val(),
            totprice: $('#totprice').val(),
            orderid: $('#orderid').val()
        };
        console.log("카카오");
        $.ajax({
            type: 'POST',
            url: 'paycancelrequest',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function (response) {
                alert("환불처리가 완료되었습니다.");
                window.location.href = 'main';
            },
            error: function (xhr, status, error) {
                console.error(error);
            }
        });
    } else {
   			var orderid = $('#orderid').val();
   			console.log("무통장");
   	        $.ajax({
   	        	type: "post",
   	            url: 'bankCancel',
   	            data: {"orderid":orderid},
   	            success: function (response) {
   	                alert("환불처리가 완료되었습니다.");
   	                window.location.href = 'main';
   	            },
   	            error: function (xhr, status, error) {
   	                console.error(error);
   	            }
   	        });
    }
}
</script>
</body>
</html>