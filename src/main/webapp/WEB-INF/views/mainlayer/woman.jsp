<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"  href="resources/css/test.css">
</head>
<body>
 	<div class="img_parentsdiv">
    	<div class="img_childdiv"><a href="#"><img src="resources/img/cat2.jpg"></a></div>
    	<div class="img_childdiv"><a href="#"><img src="resources/img/cat2.jpg"></a></div>
    	<div class="img_childdiv"><a href="#"><img src="resources/img/cat2.jpg"></a></div>
    </div>
   
<script type="text/javascript">
	window.addEventListener('wheel', function(e){
		e.preventDefault();
	},{passive : false});
	
	var $html = $('html');
	var page = 0;
	var lastPage = $('.img_childdiv').length;

	$html.animate({scrollTop:0},500);
	
	$(window).on('wheel', function(e){
		if($html.is(':animated')) return;
		if(e.originalEvent.deltaY > 0){
			if(page == lastPage) page = 0;
			else page++;
		}else if(e.originalEvent.deltaY < 0){
			if(page == 0) page = lastPage;
			else page--;
		}
		
		var posTop = page * $('.img_childdiv').height();
		console.log(posTop);
		$html.animate({scrollTop : posTop},700);
	 
	});
	
	$(window).scroll(function(){
		if ($(this).scrollTop() > 300){
			$('.btn_gotop').show();
		} else{
			$('.btn_gotop').hide();
		}
	});
	$('.btn_gotop').click(function(){
		$('html, body').animate({scrollTop:0},400);
		return false;
	});
</script>
   
</body>
</html>