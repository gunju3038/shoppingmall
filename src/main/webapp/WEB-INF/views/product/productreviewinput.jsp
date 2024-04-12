<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 리뷰</title>
</head>
<body>
<form action="productreviewsave" method="post" enctype="multipart/form-data">
	<table border="1" width="400px" align="center">
		<tr>
			<th>제목</th>
			<td>
				<input type="text" name="btitle"> 
				<input type="hidden" name="snum" value="${snum }">
			</td>
		</tr>
		<tr>
			<th>내용</th>
			<td><textarea rows="5" cols="40" name="bcontent" style="resize: none;"></textarea> </td>
		</tr>
		<tr>
			<th>이미지</th>
			<td><input type="file" name="bpicture"> </td>
		</tr>
		<tr>
			<th>평가</th>
			<td>
				<select name="productrank">
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
				</select>
				<span> / 5 </span>
			</td> 
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" value="리뷰쓰기">
				<input type="reset" value="취소">
				<input type="button" value="이전화면으로" onclick="history.back()">
			</td>
		</tr>
	</table>
</form>
</body>
</html>