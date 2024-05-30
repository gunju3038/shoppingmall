<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="notice_menubox.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<style type="text/css">
.row1 {
   margin:0px auto;
    width: 700px;
    height: 650px;
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
<title>Insert title here</title>
</head>
<body>
<div class="container">
     <div class="row row1">
      <table class="table">
         <c:forEach items="${list}" var="aa">
        <tr>
        	<th>제목</th>
         	<td>${aa.btitle}</td>
        </tr>
        <tr>
         	<th>작성일</th>
         	<td>${aa.bdate}</td>
        </tr>
        <tr>
         	<th>작성자</th>
         	<td>
	        	 ${aa.bid}
	        	<input type="hidden" name="bnum" value="${aa.bnum}">
         	</td>
        </tr>
        <tr>
     		<td colspan="4" class="text-left" valign="top" height="300">
           		<img alt="" id="bpicture" src="${pageContext.request.contextPath}/resources/qnaimg/${aa.bpicture}" style="max-width: 100%; height: auto;">
	           	<div>
	               <pre style="white-space: pre-wrap;border:none;background-color: white;">${aa.bcontent}</pre>    
	           	</div>
       		</td>
       </tr>
       <tr>
          <td colspan="4" class="text-right">
	          <c:choose>
		          <c:when test="${id eq 'admin' or id eq aa.bid}">
		            <a href="nmodify?bnum=${aa.bnum}" class="btn btn-xs btn-info">수정</a>
		            <a href="#" class="btn btn-xs btn-warning" id="delbnt">삭제</a>
		          </c:when>
	          </c:choose>
	          <a href="notice" class="btn btn-xs btn-success">목록</a>
          </td>
       </tr>
       </c:forEach>
     </table>
    </div>
  </div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
   $("#delbnt").click(function(e){
      e.preventDefault();
      
      var bnum = $("input[name='bnum']").val();
      var originalbimg = $("#bpicture").attr('src');  //이미지파일 넘길떄는 src로 넘겨야함
      
      var check = confirm("정말로 삭제하시겠습니까?");
      if (check) {
         $.ajax({
            type: "POST",
            async: true,
            url: "noticedelete",
            data: {"bnum": bnum, "originalbimg": originalbimg},
            success: function(response) {
               alert("삭제가 완료되었습니다.");
               window.location.href = "./notice";
            },
            error: function(xhr, status, error) {
               alert("삭제에 실패했습니다.");
               console.error(xhr.responseText);
            }
         });
      }
   });
});
</script>
</body>
</html>