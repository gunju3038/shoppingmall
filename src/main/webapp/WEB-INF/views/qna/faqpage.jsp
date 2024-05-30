<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="faq_menubox.jsp" %>
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
    margin-bottom: 30px;
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

.toggle-btn {
    text-align: right;
}

.toggle-btn button {
    background-color: transparent;
    border: none;
    font-size: 16px;
    cursor: pointer;
    outline: none;
}

.toggle-btn button::before {
    content: '';
}

.pre-container {
    display: none;
    transition: max-height 0.3s ease-in-out;
    max-height: 0;
    overflow: hidden;
}

.pre-container.active {
    display: table-row;
    max-height: none;
}

td {
  font-size: 16px;
}


th:first-child {
  width: 40%;
}

.btnlist{
   float: right;
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
    <h2 class="pagetitle">FAQ</h2>
<div class="row">
    <div class="col-xs-12 col-md-8 col-md-offset-2">
        <table class="table table-hover">
            <tbody>
                <c:forEach items="${list}" var="aa">
                    <tr>
                    <td>${aa.btype}</td>
                    <td>${aa.btitle}</td>
                    <td class="toggle-btn"><button onclick="toggleContent(this)">▽</button></td>
                </tr>
                    <tr class="pre-container">
                    <td colspan="3" class="text-left" valign="top">
                    <input type="hidden" name="bnum" value="${aa.bnum}">
                        <img alt="" src="${pageContext.request.contextPath}/resources/qnaimg/${aa.bpicture}" style="width: 50%; height: auto;" id="bpicture">
                        <div>
                            <pre style="white-space: pre-wrap;border:none;background-color: white;">${aa.bcontent}</pre>    
                        </div>
                        <c:choose>
                        <c:when test="${id eq 'admin'}">
                              <div class="btnlist">
                              <a href="fmodifypage?bnum=${aa.bnum}" class="btn btn-xs btn-info">수정</a>
                              <a href="#" class="btn btn-xs btn-warning">삭제</a>
                              <a href="faq" class="btn btn-xs btn-success">목록</a>
                              </div>
                            </c:when>
                      </c:choose>
                    </td>   
                </tr>
                </c:forEach>
            </tbody>
            <!-- 페이징처리 -->
    <tr style="border-left: none;border-right: none;border-bottom: none">
       <td colspan="7" style="text-align: center;">
       <c:if test="${paging.startPage!=1 }">
          <a href="faq?nowPage=${paging.startPage-1 }&cntPerPage=${paging.cntPerPage}">◀</a>
       </c:if>   
          <c:forEach begin="${paging.startPage }" end="${paging.endPage}" var="p"> 
             <c:choose>
                <c:when test="${p == paging.nowPage }"> <!-- 현재 페이지를 빨갛게 표시 -->
                   <b><span style="color: blue;">${p}</span></b>
                </c:when>   
                <c:when test="${p != paging.nowPage }"> <!-- 현재 페이지가 아니면 페이지 정보를 넘김 -->
                   <a href="faq?nowPage=${p}&cntPerPage=${paging.cntPerPage}">${p}</a>
                </c:when>   
             </c:choose>
          </c:forEach>
          <c:if test="${paging.endPage != paging.lastPage}">
          <a href="faq?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage }">▶</a>
       </c:if>
       </td>
    </tr>
<!-- 페이징처리 -->
        </table>
        <form action="faqsearchgogo" method="post">
            <div class="search_wrap">
                <div class="search_area">
                <select id="selectbtype" name="stype">
                 <option value="btitle">제목</option>
                 <option value="bcontent">내용</option>
                 <option value="all">제목+내용</option>
                </select>
                    <input type="text" name="keyword" placeholder="검색어를 입력하세요">
                    <button>Search</button>
                </div>
            </div>  
        </form>
        <c:choose>
         <c:when test="${id eq 'admin'}">
              <div class="btninput"><button onclick="location.href='./faqinput'" class="intbtn">글쓰기</button></div>
          </c:when>
          </c:choose>
    </div>
</div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
    $(".toggle-btn button").click(function(){
        var preContainer = $(this).closest('tr').next('.pre-container');
        if (preContainer.hasClass('active')) {
            preContainer.removeClass('active');
            $(this).text('▽');
        } else {
            preContainer.addClass('active');
            $(this).text('△');
        }
    });
    
    $(".btn-warning").click(function(e){
        e.preventDefault();
        
        var bnum = $("input[name='bnum']").val();
        var originalbimg = $("#bpicture").attr('src');
        
        var check = confirm("정말로 삭제하시겠습니까?");
        if (check) {
            $.ajax({
                type: "POST",
                async: true,
                url: "noticedelete",
                data: {"bnum": bnum, "originalbimg": originalbimg},
                success: function(response) {
                    alert("삭제가 완료되었습니다.");
                    window.location.href = "./faq";
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