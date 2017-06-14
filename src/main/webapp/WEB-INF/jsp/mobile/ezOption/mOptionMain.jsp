<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezEKP Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />				
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
		<link rel="stylesheet" type="text/css" href="/js/jquery.mobile/jquery.mobile-1.4.5.min.css" />
    	<link rel="stylesheet" type="text/css" href="/css/mobile/mobile.css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery.mobile/jquery.mobile-1.4.5.min.js"></script>
		<script type="text/javascript" src="/js/mobile/mobile.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>	
		
		<script>
			function saveEnvironment() {
				 $.ajax({
                  type:"POST",
                  dataType:"text",
                  data : {
                  	lang : $('input[name = radio-view]:checked').val(),
                  	dpBoardCnt: $('input[name = slider-2]').val(),
                  	async: false,
                  },
                  url: "/mobile/ezOption/saveOption.do",
                    success: function (data) {
                    }
                });
			}
		</script>	
	</head>
	<body class="loginbody">
		<section id="sampleList" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezOption/mOptionTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">
				<form id="mainForm" name="mainForm" method="post">					
					<div class="ui-corner-all custom-corners">
					  <div class="ui-bar ui-bar-a">
					    <h3>언어 설정</h3>
					  </div>
					  <div class="ui-body ui-body-a">
					    <div data-role="fieldcontain">
						<fieldset data-role="controlgroup" data-type="horizontal">
						<input type="radio" name="radio-view" id="radio-view-a" value ='1' onClick = "javascript:selectLangClick()" />
						<label for="radio-view-a">한글</label>
						<input type="radio" name="radio-view" id="radio-view-b" value ='2' onClick = "javascript:selectLangClick()"  />
						<label for="radio-view-b">영어</label>
						</fieldset>
						</div>
					  </div>
					</div>	
					
					<div class="ui-corner-all custom-corners">
					  <div class="ui-bar ui-bar-a">
					    <h3>게시판 표시</h3>
					  </div>
					  <div class="ui-body ui-body-a">
	    				<input type="range" name="slider-2" id="slider-2" data-highlight="true" min="0" max="100" value="10">
					</div>
					</div>	
					
					<div class="ui-corner-all custom-corners">
					  <div class="ui-bar ui-bar-a">
					    <h3>개인화</h3>
					  </div>
					  <div class="ui-body ui-body-a">
						 <div data-role="fieldcontain">
							<fieldset data-role="controlgroup" data-type="horizontal">
							<input type="radio" name="radio-view2" id="radio-view-a1" value="list"  />
							<label for="radio-view-a1">기본</label>
							<input type="radio" name="radio-view2" id="radio-view-b1" value="grid"  />
							<label for="radio-view-b1">개인</label>
							</fieldset>
						<input id ="plus" type="button"  value="플러스"  />
						</div>
					 </div>
					</div>
					<div>
					<p align="center">
					<button class="show-page-loading-msg" data-textonly="false" data-textvisible="true" data-inline="true" onclick="javascript:saveEnvironment()">적용하기</button>
					</p>
					</div>
				</form>
     		</div>    		
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/sampleFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/samplePopup.jsp" />
     		<!-- layer Popup import -->
     		
     		<div id="test" class="ui-content" style="min-width: 255px; max-width: 285px; text-align:center" data-role="popup" data-overlay-theme="b" data-transition="slidedown">
		    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
		    <div>		    	
				<input name="search-1" id="search-1" type="search" placeholder="search mail..">
				<a class="ui-btn" href="#">검 색</a>
			</div>			
		</div>
     	</section>
	</body>	
</html>