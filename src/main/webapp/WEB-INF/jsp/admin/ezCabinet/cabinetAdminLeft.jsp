<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil"                      %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css"/>
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	</head>
	<body class="newLeft" style="overflow: hidden;">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title">
				<spring:message code='ezCabinet.t154'/>
			</div>
			
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
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
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')      }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript">
			(function() {
				window.addEventListener("load", init, false);
				window.addEventListener("resize", resizeWindow, false);
				
				setBttns();
				getBasicPage();
				
				function init() {
					$(".adminListBox").mCustomScrollbar({theme : "dark"});
					resizeWindow();
				}
				
				function resizeWindow() {
					$(".adminListBox").height(window.innerHeight - 58);
				}
				
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