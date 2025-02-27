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
		<script type="text/javascript" src="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mobile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>			
	</head>
	<body class="loginbody">
		<section id="sampleDetail" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/sampleTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">				
		      	<div class="ui-body ui-body-a ui-corner-all">
		      		<div data-role="fieldcontain">
		        		<h1>오픈솔루션팀 차장 장진혁입니다.</h1>
		        	</div>	
     				<div data-role="fieldcontain" style="font-size:12px">     				
     					보낸사람 : "장진혁"     				
     				</div>
     				<div data-role="fieldcontain" style="font-size:12px">     				
     					받는사람 : "김길동"     				
     				</div>
     				<div data-role="fieldcontain" style="font-size:12px">     				
     					참조 : "오픈솔루션팀"     				
     				</div>
     				<div data-role="fieldcontain" style="font-size:12px">     				
     					받은날짜 : 2017-05-29 06:20     				
     				</div>
     				<div data-role="fieldcontain" style="font-size:12px">
     					안녕하세요.<br/>
     					장진혁입니다.<br/><br/>
     					
     					이번에 모바일 관련하여 상세화면을 만들어 보았습니다. 이번에 모바일 관련하여 상세화면을 만들어 보았습니다. 이번에 모바일 관련하여 상세화면을 만들어 보았습니다. 이번에 모바일 관련하여 상세화면을 만들어 보았습니다. 이번에 모바일 관련하여 상세화면을 만들어 보았습니다. 
     					
     					 
     				</div>
		      	</div>												
     		</div>
     		<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/sampleFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/samplePopup.jsp" />
     		<!-- layer Popup import -->
     	</section>
	</body>	
</html>