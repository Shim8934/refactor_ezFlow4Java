<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />				
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.css')}" />
    	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mobile/mobile.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mobile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mBoard.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		
		<script type="text/javascript">
			//변수 선언
			var mBoardInfo = '${mBoardInfo}';
			var type = '${mBoardInfo.type}';
			var boardID = '${mBoardInfo.boardID}';
			
			$(document).ready(function () {
				$('.writeButton').css('bottom', 60);
				$('.writeButton').css('left', $(window).width() - 60 );
				
				$(window).on('resize', function() {
					$('.writeButton').css('bottom', 60);
					$('.writeButton').css('left', $(window).width() - 60 );
				});
				
				//getBoardItemList();
			})
		</script>			
	</head>
	<body class="loginbody">
		<section id="boardItemList" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezBoard/mBoardTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="ui-content" data-role="content">
				<ul data-role="listview" data-inset="false" data-theme="a">
				</ul>
				<div class="writeButton" onclick="alert('write!')"></div>
     		</div>
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezBoard/mBoardFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezBoard/mBoardPopup.jsp" />
     		<!-- layer Popup import -->
     	</section>
	</body>	
</html>