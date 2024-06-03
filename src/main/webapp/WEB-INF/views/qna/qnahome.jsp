<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객센터</title>
<style type="text/css">
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400;500;700&display=swap');
* {
   margin: 0; 
   padding: 0; 
   box-sizing: border-box;       
   font-family: 'Noto Sans KR', sans-serif;
}
.container {
  text-align: center;
  margin-top: 5%;
  margin-left: auto;
  margin-right: auto;
}
h2 {
  margin-bottom: 30px;
  margin-top: 5%;
  font-family: 'Noto Sans KR', sans-serif;
}
.menu_box {
    background-color: #ffffff;
    border: 1px solid transparent;
    border-radius: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 10px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    position: relative;
    max-width: 600px;
    width: 90%;
    margin: 0 auto;
}
.nav {
    position: relative;
    display: flex;
    align-items: center;
}
.item {
    padding: 15px 20px;
    margin: 0 10px;
    font-size: 18px;
    color: #83818c;
    font-weight: 500;
    transition: 0.5s;
    flex-shrink: 0;
}
.item:hover {
    color: #51829B;
}
.item.active,
.item.active:hover {
    color: #35374B;
    border-bottom: 2px solid #35374B;
}
.indicator {
    position: absolute;
    left: 0;
    bottom: 0;
    width: var(--widthJS);
    height: 5px;
    background: #B5C0D0;
    border-radius: 8px 8px 0 0;
    transform: translateX(var(--transformJS));
    transition: 0.5s;
}
.myqna {
  background-color: #EAD8C0;
  padding: 20px; 
  border-radius: 10px;
  margin-top: 20px;
  color: #222831;
}

.myqna dl {
  margin-bottom: 20px;
}

.myqna dt {
  font-weight: bold;
  margin-bottom: 20px;
}

.myqna dd {
  margin-left: 10px;
  color: #1B3C73;
}

.count {
  color: #944E63;
  font-weight: bold;
}

td {
  text-align: left;
}
.container2{
	margin-bottom: 50px;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function() {
    let navItems = document.querySelectorAll(".item");
    let indicator = document.querySelector(".indicator");

    function changeIndicator(item) {
        let rect = item.getBoundingClientRect();
        indicator.style.setProperty("--transformJS", `${rect.left}px`);
        indicator.style.setProperty("--widthJS", `${rect.width}px`);
    }

    function setActiveItem(item) {
        navItems.forEach((navItem) => navItem.classList.remove("active"));
        item.classList.add("active");
    }

    navItems.forEach((item) =>
        item.addEventListener("click", () => {
            setActiveItem(item);
            changeIndicator(item); 
        })
    );

    let activeLink = document.querySelector(".active");
    if(activeLink) {
        changeIndicator(activeLink);
    }
});

function fetchData(status) {
    $.ajax({
        url: "qnagetme",
        method: "post",
        data: { status: status },
        dataType: "json",
        success: function(data) {
            updateTable(data);
        },
        error: function(xhr, textStatus, errorThrown) {
            console.error("Error fetching data:", textStatus);
        }
    });
}

function updateTable(data) {
    let membershipId = "${membership.id}";
    let tableTitle = $("<h2></h2>").addClass("pagetitle").text(membershipId + "님의 Q&A");

    let thead = $("<thead></thead>");
    let headerRow = $("<tr></tr>");
    headerRow.append($("<th></th>").text("구분"));
    headerRow.append($("<th></th>").addClass("tc").text("제목"));
    headerRow.append($("<th></th>").text("작성자"));
    headerRow.append($("<th></th>").text("작성일"));
    thead.append(headerRow);

    let tbody = $("<tbody></tbody>").attr("id", "addgo");
    data.forEach(function(item) {
        let btype = item.btype;
        let btitle = item.btitle;
        let bid = item.bid;
        let bdate = item.bdate;
        let bnum = item.bnum;
        let step = item.step;
        let secret = item.secret;
        let indent = item.indent;

        let row = $("<tr></tr>");
        let td1 = $("<td></td>").text(btype);
        let td2 = $("<td></td>").addClass("tc");

        for (let i = 1; i <= indent; i++) {
            td2.append($("<span style='color: #7743DB;'>☞(답변완료)</span>"));
        }

        for (let i = 1; i <= secret; i++) {
            td2.append($("<span style='color: red;'>🔒</span>"));
        }

        let link = $("<a></a>").attr("href", "qnacontentpage?bnum=" + bnum + "&step=" + step + "&secret=" + secret + "&bid=" + bid).text(btitle);
        td2.append(link);

        let td3 = $("<td></td>").text(bid);
        let td4 = $("<td></td>").text(bdate);

        row.append(td1, td2, td3, td4);
        tbody.append(row);
    });

    let table = $("<table></table>").addClass("table table-hover qna-list");
    table.append(thead);
    table.append(tbody);

    let container = $(".container2");
    container.empty();
    container.append(tableTitle);
    container.append(table);
}

$(document).ready(function() {
    let qnasuccessElement = $("#qnasuccesscount");
    let myqnaingElement = $("#myqnaingcount");

    qnasuccessElement.on("click", function() {
        fetchData("qnasuccess");
    });

    myqnaingElement.on("click", function() {
        fetchData("myqnaing");
    });
});
</script>
</head>
<body>
<div class="container">
    <h2>고객센터</h2>
    <div class="menu_box">
        <nav class="nav">
            <a href="qnahome" class="item active">Home</a>
            <a href="notice" class="item">공지사항</a>
            <a href="qna" class="item">Q&A</a>
            <a href="faq" class="item">FAQ</a>
            <span class="indicator"></span>
        </nav>
    </div>
    <c:choose>
        <c:when test="${loginstate == true}">
            <div class="myqna">
                <dl>
                    <dt>MY문의 진행현황</dt>
                    <dd>
                        <a id="qnasuccesscount" class="count">${qnasuccess}</a> 건 답변완료,
                        <a id="myqnaingcount" class="count">${myqnaing}</a> 건 답변대기중 입니다.
                    </dd>
                </dl>
            </div>
            <div class="container2">
            </div>
         </c:when>
         <c:otherwise>
             <div class="myqna">
                <dl>
                    <dt>MY문의 진행현황</dt>
                    <dd>문의를 보기 위해선 로그인 해주세요.</dd>
					<dd><a href="login"> 로그인</a></dd>
                </dl>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>