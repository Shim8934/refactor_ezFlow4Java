<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil"                      %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezCabinet.css', 'msg')}"       type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css"/>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
		<div id="left" style="overflow: auto">
			<div class="left_admin">
				<img src="/images/admin/first.png" width="13px" height="13px"/>&nbsp;<spring:message code='ezCabinet.t154'/>
			</div>
			
			<!-- 기본설정 -->
			<h2><span><spring:message code='ezCabinet.t09'/></span></h2>
			<ul></ul>
			
			<!-- 용량설정 -->
			<h2><span><spring:message code='ezCabinet.t10'/></span></h2>
			<ul></ul>
			
			<!-- 모듈설정-->
			<h2><span><spring:message code='ezCabinet.t155'/></span></h2>
			<ul></ul>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')             }"></script>
		<script type="text/javascript">
			(function() {
				initToggleList(document.getElementById("left"), "h2", "ul", "li");
				setBttns();
				getBasicPage();
				
				function setBttns() {
					var leftDiv = document.getElementById("left");
					var h2List  = leftDiv.getElementsByTagName("h2");
					
					h2List[0].addEventListener("click", function(e) {getBasicPage();}, false);
					h2List[1].addEventListener("click", function(e) {getPersonalPage();}, false);
					h2List[2].addEventListener("click", function(e) {getRelatedConfig();}, false);
					h2List[0].firstElementChild.onclick = function(e) {getBasicPage();};
					h2List[1].firstElementChild.onclick = function(e) {getPersonalPage();};
					h2List[2].firstElementChild.onclick = function(e) {getRelatedConfig();};
				}
				
				function getBasicPage()     {window.open("/admin/ezCabinet/getBasicPage.do", "right");}
				function getPersonalPage()  {window.open("/admin/ezCabinet/getPersonalPage.do", "right");}
				function getRelatedConfig() {window.open("/admin/ezCabinet/getRelatedCabinetConfig.do", "right");}
			})();
		</script>
	</body>
</html>