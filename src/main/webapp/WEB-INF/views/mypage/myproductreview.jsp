<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">

h2{
  text-align:center;
  margin-top:40px;
}
.order_list{
	margin-top: 24px;
    width: 72%;
    min-width:1360px;
    left:330px;
    position: absolute;
}
.ordertable {
    width: 55%;
    margin-top:20px;
    border-collapse: collapse;
    text-align: center;
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


</style>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2 style="text-align: center;">상품 리뷰</h2>
	<table align="center" class="ordertable">
		<tr>
			<th>상품이미지</th>
			<th>상품명</th>
			<th>제목</th>
			<th>작성일</th>
			<th>평가</th>
			<th>비고</th>
		</tr>
	<c:forEach items="${list }" var="bb">	
		<tr>
			<td><a href="reviewproductview?snum=${bb.snum }&sname=${bb.sname}"><img src="./image/${bb.image }" width="60px" height="60px"></a></td>
			<td><a href="reviewproductview?snum=${bb.snum }&sname=${bb.sname}">${bb.sname }</a></td>
			<td>${bb.btitle }</td>
			<td>${bb.bdate.substring(0,10) }</td>
			<td>${bb.productrank } / 5</td>
			<td>
				<button type="button" onclick="location.href='productreviewinput?snum=${bb.snum}'">리뷰수정</button>
				<button type="button" onclick="reviewdelete('${bb.snum }')">리뷰삭제</button>
			</td>
			
		</tr>
	</c:forEach>	
		
	</table>
	
	<script type="text/javascript">
		function reviewdelete(snum) {
			if(confirm("정말로 삭제하시겠습니까?")){
				$.ajax({
					type: "get",
		            async: true,
		            url: "productReviewDelete",
		            data: {"snum": snum},
		            success: function(result) {
		            	alert("삭제완료");
		                location.href = '/haha/myproductreview';
		            },
		            error: function () {
		                alert("에러");
		            }
		        });	
			}
			else{
				alert("삭제 취소")
				
			}
				
		}
	</script>
</body>
</html>