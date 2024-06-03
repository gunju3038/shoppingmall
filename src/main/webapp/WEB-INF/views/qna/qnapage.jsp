<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="qna_menubox.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
/* Google web font CDN*/
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400;500;700&display=swap');
* {
	margin: 0; 
	padding: 0; 
	box-sizing: border-box; 		
	font-family: 'Noto Sans KR', sans-serif;
}

.pagetitle {
	text-align: center;
	margin-top: 50px;
}
.intbtn {
    border-radius: 5px;
    background-color: #333;
    color: #fff;
    border: none;
    padding: 8px 20px;
    font-size: 14px;
    cursor: pointer;
    float: right;
    margin-top: -30px;
}
.intbtn:hover {
	background: #000000;
}

th,td {
  width: 25%;
  height: 50px;
}

th.tc, td.tc {
  width: 30%;
}

th:nth-child(4),
td:nth-child(4) {
  width: 10%;
}

form {
  float: left;
  margin-left: -100px;
  margin-top: -30px;
}

.search_area{
  display: inline-block;
  margin-top: 10px;
  margin-left: 100px;
}
.search_area input{
  height: 30px;
  width: 150px;
  margin-right: 10px;
  display: inline-block;
}
.search_area button{
  width: auto;
  height: 30px;
  padding: 0px 10px;
  color: #fff;
  background-color: #6b6b83;
}
.search_area button:hover {
	background: #000000;
}
</style>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<title>Insert title here</title>
</head>
<body>

<div class="container">
    <h2 class="pagetitle">Q&A</h2>
<div class="row">
    <div class="col-xs-12 col-md-8 col-md-offset-2">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>구분</th>
                    <th class="tc">제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${list}" var="aa">
                    <tr>
                        <td>
                        	<c:forEach var="i" begin="1" end="${aa.indent }"> <!-- 댓글 쓴만큼 들여쓰기(indent)를 하므로 반복 기준점으로 잡아줄 수 있다. -->
							<!-- &emsp; --> <!-- &emsp = 한칸 띄우기 기능, 밑의 이모티콘을 출력하는 걸로 대체 -->
							<span style="color: #7743DB;">☞(답변완료)</span>
							</c:forEach>
                        	${aa.btype}
                        </td>
                        <td class="tc">
	                        <c:forEach var="i" begin="1" end="${aa.secret }">
	                        🔒︎
	                        </c:forEach>
	                        <a href="qnacontentpage?bnum=${aa.bnum}&bid=${aa.bid}&step=${aa.step}&secret=${aa.secret}">${aa.btitle}</a>
                        </td>
                        <td>${aa.bid}</td>
                        <td>${aa.bdate}</td>
                    </tr>	
                </c:forEach>
            </tbody>
            <!-- 페이징처리 -->
	<tr style="border-left: none;border-right: none;border-bottom: none">
	   <td colspan="7" style="text-align: center;">
	   
	   <c:if test="${paging.startPage!=1 }"> <!-- 현재 페이지가 1페이지가 아니라면 -->
	      <a href="qna?nowPage=${paging.startPage-1 }&cntPerPage=${paging.cntPerPage}">◀</a> <!--"page?nowPage=${paging.startPage-1 } = 시작 페이지에서 -1 빼서 넘김 -->
	      
	   </c:if>   
	   
	      <c:forEach begin="${paging.startPage }" end="${paging.endPage}" var="p"> 
	         <c:choose>
	            <c:when test="${p == paging.nowPage }"> <!-- 현재 페이지를 빨갛게 표시 -->
	               <b><span style="color: blue;">${p}</span></b>
	            </c:when>   
	            <c:when test="${p != paging.nowPage }"> <!-- 현재 페이지가 아니면 페이지 정보를 넘김 -->
	               <a href="qna?nowPage=${p}&cntPerPage=${paging.cntPerPage}">${p}</a>
	            </c:when>   
	         </c:choose>
	      </c:forEach>
	     
	      <c:if test="${paging.endPage != paging.lastPage}">
	      <a href="qna?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage }">▶</a>
	   </c:if>
	   
	   </td>
	</tr>
<!-- 페이징처리 -->
        </table>
        <form action="qnasearchgogo" method="post">
    <div class="search_wrap">
        <div class="search_area">
            <input type="text" name="keyword" placeholder="검색어를 입력하세요">
            <button>Search</button>
        </div>
    </div>  
</form>
	<div class="btninput"><button onclick="location.href='./qnainputform'" class="intbtn">글쓰기</button></div>
    </div>
  </div>
</div>
<script type="text/javascript">
    $(document).ready(function(){
        $('.search_area button').click(function(){
            $(this).closest('form').submit();
        });
    });
</script>
</body>
</html>