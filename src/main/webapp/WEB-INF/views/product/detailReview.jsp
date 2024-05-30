<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
	<h2>상세 리뷰</h2>
	<table align="center" class="ordertable">
	<c:forEach items="${list }" var="aa">
		<tr>
			<th>상품명</th>
			<td>${aa.sname }</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${aa.id }</td>
		</tr>
		<tr>
			<th>제목</th>
			<td>${aa.btitle }</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>${aa.bcontent }</td>
		</tr>
		<tr>
			<th>사진</th>
			<td>
				<img alt="" src="./image/${aa.bpicture}" width="400px" height="400px">
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<button type="button" onclick="bestIn(${aa.bnum})">베스트리뷰 등록</button>
				<button type="button" onclick="bestOut(${aa.bnum})">베스트리뷰 등록해제</button>
			</td>
		</tr>
	</c:forEach>
</table>
</div>

<script type="text/javascript">
function bestIn(bnum) {
	$.ajax({
        type: 'POST',
        url: 'bestreview',
        data: {"bnum":bnum},
        success: function (result) {
            if(result=='1'){
            	alert("베스트리뷰 등록 완료")
            }
            else{
            	alert("ERROR")
            }        	
        },
        error: function (xhr, status, error) {
            // 에러 처리
            console.error(error);
        }
    });	
}

function bestOut(bnum) {
	$.ajax({
        type: 'POST',
        url: 'bestreviewout',
        data: {"bnum":bnum},
        success: function (result) {
            if(result=='1'){
            	alert("베스트리뷰 등록 해제")
            }
            else{
            	alert("ERROR")
            }        	
        },
        error: function (xhr, status, error) {
            // 에러 처리
            console.error(error);
        }
    });	
}
</script>
</body>
</html>