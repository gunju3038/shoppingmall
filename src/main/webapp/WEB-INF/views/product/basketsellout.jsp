<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매 페이지</title>
</head>
<body>

<form action=""> <!-- 결재창으로 이동 -->
	<div>
		<table border="1" width="500px" align="center">
		<c:if test="${not empty list}"> <!-- list를 한번만 출력하려고 사용 -->
			<tr>
				<th>배송지</th> 
				<td colspan="4">
					<span>${list[0].membershipdto.address }</span>
					<input type="hidden" name="address" value="${list[0].membershipdto.address }"> 
				</td>
				<td>
					<input type="button" value="수정">
				</td>
			</tr>
			<tr>
				<th>이름</th> 
				<td colspan="4">
					<span>${list[0].membershipdto.name }</span>
					<input type="hidden" name="name" value="${list[0].membershipdto.name }"> 
				</td>
				<td>
					<input type="button" value="수정">
				</td>
			</tr>
			<tr>
				<th>연락처</th> 
				<td colspan="4">
					<span>${list[0].membershipdto.tel }</span>
					<input type="hidden" name="tel" value="${list[0].membershipdto.tel }"> 
				</td>
				<td>
					<input type="button" value="수정">
				</td>
			</tr>
			<tr>
				<th>Email</th> 
				<td colspan="4">
					<span>${list[0].membershipdto.email }</span>
					<input type="hidden" name="email" value="${list[0].membershipdto.email }"> 
				</td>
				<td>
					<input type="button" value="수정">
				</td>
			</tr>
			<tr>
				<th>배송 요청사항</th>
				<td colspan="5">
					<select name="request">
						<option value="부재">부재시 연락주세요</option>
						<option value="경비실">경비실에 보관해주세요</option>
						<option value="문앞">문앞에 놓아주세요</option>
					</select>
				</td>
			</tr>
		</c:if>
	</div>
	
	<div>
		<c:set var="totalPrice" value="0" />
		<c:forEach items="${list }" var="aa">
		<c:set var="totalPrice" value="${totalPrice + aa.totprice}" /> <!-- 장바구니 목록 총 가격 계산 -->
			<tr>
				<th>상품이미지</th>
				<th>상품명</th>
				<th>상품사이즈</th>
				<th>상품색상</th>
				<th>상품수량</th>
				<th>상품가격</th>
			</tr>
			<tr>
				<td>
					<img alt="" src="./image/${aa.image }" width="60px" height="60px">
					<input type="hidden" name="image" value="${aa.image }"> 
				</td>
				<td>
					<span>${aa.sname }</span>
					<input type="hidden" name="sname" value="${aa.sname }">
				</td>
				<td>
					<span>${aa.ssize }</span>
					<input type="hidden" name="ssize" value="${aa.ssize }">
				</td>
				<td>
					<span>${aa.color }</span>
					<input type="hidden" name="ssize" value="${aa.color }">
				</td>
				<td>
					<span>${aa.guestbuysu }</span>
					<input type="hidden" name="guestbuysu" value="${aa.guestbuysu }">
				</td>
				<td>
					<span><f:formatNumber value="${aa.totprice }" pattern="#,###원"/></span>
					<input type="hidden" name="totprice" value="${aa.totprice }">
					<input type="hidden" name="snum" value="${aa.snum }">
					<input type="hidden" name="stype" value="${aa.stype }">
				</td>
			</tr>
		</c:forEach>
			<tr>
			    <td colspan="6" align="center">
			        <!-- 총 가격 출력 -->
			        <input type="hidden" name="totalPrice" value="${totalPrice}">
			        <input type="submit" value="<f:formatNumber value='${totalPrice}' pattern='총 #,###원'/> 구입하기">
			    </td>
			</tr>
		</table>	
	</div>
</form>
</body>
</html>