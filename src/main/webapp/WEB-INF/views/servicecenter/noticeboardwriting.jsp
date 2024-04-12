<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 게시판 글쓰기</title>
</head>
<body>
<%
	HttpSession hs = request.getSession();
	String id = (String) hs.getAttribute("id");
%>
<form action="noticeboardsave" method="post">
	<table border="1" width="400px" align="center">
		<tr>
			<th>구분</th>
			<td>
				<select name="qselect">
					<option value="로그인">로그인</option>
					<option value="주문결재">주문결재</option>
					<option value="상품문의">상품문의</option>
					<option value="교환반품">교환/반품</option>
					<option value="AS">AS</option>
				</select>
			</td> 
		</tr>
		<tr>
			<th>작성자</th>
			<td><input type="text" name="id" value="<%=id %>" readonly> </td>
		</tr>
		<tr>
			<th>제목</th>
			<td><input type="text" name="title"> </td>
		</tr>
		<tr>
			<th>내용</th>
			<td>
				<textarea rows="5" cols="40" name="contents" style="resize: none;"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" value="글쓰기">
				<input type="reset" value="취소">
				<input type="button" value="이전으로" >
			</td>
		</tr>
	</table>
</form>
</body>
</html>