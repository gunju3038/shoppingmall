<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<style type="text/css">
.row1 {
	margin:0px auto;
    width: 700px;
    height: 400px;
    margin-top: 10%;
}


th{
	text-align: center;
	background-color: #31363F;
	color: #ffffff;
	width: 15%;
}

td{
	text-align: center;
	width: 30%;
}

pre {
    white-space: pre-wrap;
    border: none;
    background-color: white;
    word-wrap: break-word;
}
</style>
<meta charset="UTF-8">
<title>답글 입력</title>
</head>
<body>
<div class="container">
     <div class="row row1">
     <form action="qnacommentsave" method="post">
     <c:forEach items="${list}" var="aa">
     <h4 style="text-align: center;">${aa.bid } 님의 문의에 대한 답글쓰기</h4>
      <table class="table">
     
        <tr>
         <th>제목</th>
         <td>
         	
         	<input type="text" name="btitle">
         	
         	<input type="hidden" name="bnum" value="${aa.bnum}">
         	<input type="hidden" name="btype" value="문의답변글">
         	<input type="hidden" name="bid" value="관리자">
	        <input type="hidden" name="groups" value="${aa.groups}">
	        <input type="hidden" name="step" value="${aa.step}">
	        <input type="hidden" name="indent" value="${aa.indent}"> 
         </td>
        </tr>
        
        
        <tr>
        <th>내용</th>
	    <td colspan="4" class="text-left" valign="top" height="300">
	   	        
	        <div>
	            <pre style="white-space: pre-wrap;border:none;background-color: white;">
	            	<textarea rows="10" cols="40" name="bcontent"></textarea>
	            </pre>    
	        </div>
	    </td>
		</tr>
        <tr>
          <td colspan="4" class="text-right">
          	<button type="submit">답글쓰기</button>
            
            <a href="qna" class="btn btn-xs btn-success">목록</a>
          </td>
        </tr>
        
        </c:forEach>
      </table>
      </form>
     </div>
     
</div>
</body>
</html>