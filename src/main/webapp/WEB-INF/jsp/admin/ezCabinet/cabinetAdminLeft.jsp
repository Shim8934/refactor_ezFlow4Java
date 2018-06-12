<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
		<div id="left" style="overflow: auto">
			<div class="left_cabinet"><span><spring:message code='ezCabinet.t01'/></span></div>
			
			<!-- 기본설정 -->
			<h2><span><spring:message code='ezCabinet.t09'/></span></h2>
			<ul></ul>
			
			<!-- 용량설정 -->
			<h2><span><spring:message code='ezCabinet.t10'/></span></h2>
			<ul>
				<li><span id="personal"><spring:message code='ezCabinet.t11'/></span></li>
				<li><span id="group"   ><spring:message code='ezCabinet.t12'/></span></li>
			</ul>
		</div>
		<div id="bnkBlockLeft" class="blockLeft" style="width:100%; height:100%; display: none; z-index: 10;" onclick="closePop();"></div>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
			(function() {
				initToggleList(document.getElementById("left"), "h2", "ul", "li");
				setBttns();
				getBasicPage();
				
				function setBttns() {
					var leftDiv = document.getElementById("left");
					var h2List  = leftDiv.getElementsByTagName("h2");
					h2List[0].firstElementChild.onclick = function(e) {getBasicPage();};
					h2List[1].firstElementChild.onclick = function(e) {getPersonalPage();};
					
					var persElmnt     = document.getElementById("personal");
					var groupElmt     = document.getElementById("group");
					persElmnt.onclick = function(e) {getPersonalPage();};
					groupElmt.onclick = function(e) {getGroupPage();};
				}
				
				function getBasicPage()    {window.open("/admin/ezCabinet/getBasicPage.do", "right");}
				function getPersonalPage() {window.open("/admin/ezCabinet/getPersonalPage.do", "right");}
				function getGroupPage()    {window.open("/admin/ezCabinet/getGroupPage.do", "right");}
			})();
		</script>
	</body>
</html>