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
		<script type="text/javascript" src="${util.addVer('/js/mobile/mEMail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>			
	</head>
	<body class="loginbody">
		<section id="sampleList" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezEmail/mMailTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">				
				<ul class="fa-ul" data-role="listview" data-inset="false" data-theme="a">
				<c:forEach items="${MessagesList}" var="message"  varStatus="i">
				<li>
					<a href="/mobile/ezEmail/mailRead.do?folderId=${message.folderId}&messageId=${message.messageId}" style="height:50px;">
					<i class="fa-li fa fa-check-square" id="checklist${i}" style="float:left; top:25px; left:10px; position:absolute"></i>
					<div style="left:70px; width:95%; position:absolute;">
					<h2 style="font-size:12px">
					<c:if test="${message.read==0}"><i class="fa fa-envelope" style="font-size:12px;"></c:if>
					<c:if test="${message.read==1}"><i class="fa fa-envelope-o" style="font-size:12px;"></c:if>
					${message.sender}</i></h2>
					<p class="ui-li-aside">${message.receivedt}</p>
					<p>${message.subject}</p>
					<c:if test="${message.flag==0}">
					<i class="fa fa-star-o" aria-hidden="true" style="float:right; top:25px; right:35px; position:absolute"></i>
					</c:if>
					<c:if test="${message.flag==1}">
					<i class="fa fa-star" aria-hidden="true" style="float:right; top:25px; right:35px; position:absolute"></i>
					</c:if>
					</div>
					</a>
				</li>
				</c:forEach>
				    <li style="background-color: transparent;text-align:center">
						P A G I N G
					</li>					
				</ul>
				<div class="writeButton" onclick="alert('write!')" style="display:none"></div>				
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