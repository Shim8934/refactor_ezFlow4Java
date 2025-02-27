<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />				
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>			
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.css')}" />
    	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mobile/mobile.css')}" />  		  	
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/mobile/mobile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mResource.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>			
	</head>
	<body class="loginbody">
		<section id="sampleList" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezResource/mResourceTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">				
				<ul data-role="listview" data-inset="false" data-theme="a">
				<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:searchOptionAjax();">환경설정업조회</li>
				<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:updateOptionAjax();">환경설정업데이트</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:searchResSchMainList();">자원예약메인리스트</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:searchResSchList();">자원예약리스트</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:searchResFolderList();">자원폴더리스트</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:searchResFavoriteList();">자원즐겨찾기리스트</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:searchResSchDetail();">자원예약상세</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:checkResSchRepeat();">자원예약중복체크</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:insertResSchedule();">자원예약등록</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:updateResSchedule();">자원예약수정</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:deleteResSchedule();">자원예약삭제</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:insertResFavorite();">즐겨찾기추가</li>
					<li class="fa fa-caret-down " style="font-size:15px" onclick="javascript:deleteResFavorite();">즐겨찾기삭제</li>
				</ul>
				<div class="writeButton" onclick="alert('write!')" style="display:none"></div>				
     		</div>     		
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezResource/mResourceFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezResource/mResourcePopup.jsp" />
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