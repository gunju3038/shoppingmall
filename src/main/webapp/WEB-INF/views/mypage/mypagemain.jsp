<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
th, td{
	text-align: center;
}
table{
	border: none;
}
th{
	padding-top: 25px;
	padding-bottom: 10px;
}
td{
	padding-bottom: 5px;
}
.bottomline{
	padding-bottom: 3px;
	border-bottom: 1px solid black;
}
#top{
	padding-top: 7px;
}

</style>

<meta charset="UTF-8">
<title>마이 페이지 메인</title>
</head>
<body>
<c:forEach items="${list }" var="aa">
	<div>
		<div>
			<table width="200px" align="left">
				<tr>
					<th>MYPAGE</th>
				</tr>
				
				
				<tr>
					<th>쇼핑정보</th>
				</tr>
				<tr>
					<td><a href="payoutview">주문/배송</a></td>
				</tr>
				<tr>
					<td>취소/교환/반품</td>
				</tr>
				<tr>
					<td><a href="basketout">장바구니</a></td>
				</tr>
				
				
				<tr>
					<th>혜택정보</th>
				</tr>
				<tr>
					<td><a href="couponview">쿠폰</a></td>
				</tr>
				<tr>
					<td>마일리지</td>
				</tr>
				
				
				<tr>
					<th>참여 & 문의</th>
				</tr>
				<tr>
					<td>문의내역</td>
				</tr>
				<tr>
					<td>Q&A</td>
				</tr>
				<tr>
					<td>나의 상품리뷰</td>
				</tr>
				<tr>
					<td>이벤트 응모내역</td>
				</tr>
				
				
				<tr>
					<th>회원정보</th>
				</tr>
				<tr>
					<td>회원정보 수정</td>
				</tr>
				<tr>
					<td>배송지 관리</td>
				</tr>
				<tr>
					<td>결재 관리</td>
				</tr>
				<tr>
					<td>회원 탈퇴</td>
				</tr>
			</table>
		</div>
		
		<div>
			<table width="700px" align="center">
				<tr>
					<th>${aa.id}(${aa.membershipdto.name})님의 현재 회원 등급은 ${aa.membershipdto.stringrank } 입니다.</th>
					<th><a href="#">등급별 혜택</a></th>
				</tr>
				
			</table>
			
			<table width="400px" align="center">
				<tr>
					<th>쿠폰</th>
					<th>마일리지</th>
				</tr>
				<tr>
					<td><a href="couponview">${aa.couponnum }</a></td>
					<td><a href="#">0M</a></td>
				</tr>
			</table>
		
			<table width="400px" align="center">
				<tr>
					<th colspan="2" class="bottomline">최근 주문 상품</th>
				</tr>
				<tr>
					<td colspan="2" id="top">최근 주문 내역이 없습니다.</td>
				</tr>
				<tr>
					<th><a href="#">주문 배송 조회</a></th>
					<th><a href="#">취소/교환/반품 조회</a></th>
				</tr>
			</table>
		
			<table width="400px" align="center">
				<tr>
					<th>베스트 상품</th>
				</tr>
			</table>
		</div>
	</div>	
</c:forEach>
</body>
</html>