<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>

<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	
	<body class="leftbody" style="overflow: auto; height: 100%;">
		<div id="left">
			<div class="left_cabinet"><span><spring:message code='ezCabinet.t01'/></span></div>
			
			<!-- 나의 캐비넷  -->
			<h2 id="myCabinet"><span><spring:message code='ezCabinet.t02'/></span></h2>
			<ul>
				<div id="cabinetTree" class="cabinetTree"></div>
				<!-- 캐비넷  관리 -->
				<h3><span><spring:message code='ezCabinet.t03'/></span></h3>
				<!-- 공유 캐비넷  -->
				<h3><span><spring:message code='ezCabinet.t04'/></span></h3>
			</ul>
			
			<!-- 연동 캐비넷 -->
			<h2><span><spring:message code='ezCabinet.t32'/></span></h2>
			<ul></ul>
			
			<!-- 공유 반은 캐비넷 -->
			<h2><span><spring:message code='ezCabinet.t05'/></span></h2>
			<ul></ul>
			
			<!-- 용량보기 -->
			<div class="volumeDiv">
				<div id="myProgress"></div>
				<div class="volumeBar"><div id="myBar" class="myBar_green" style="width: 22%;"></div></div>
				<div class="volumes">248.1M / 1.2G (22%)</div>
			</div>
			
			<!-- 환경설정 -->
			<h3 id="cabinetConfig"><span><spring:message code="ezCabinet.t06"/></span></h3>
			
			<!-- 캐비닛 관리자 -->
			<c:if test="${isCabinetAdmin == '1'}">
				<h3><span id="cabinetAdmin"><spring:message code="ezCabinet.t07" /></span></h3>
			</c:if>
		</div>
		
		<div id="bnkBlockLeft" class="blockLeft" style="display: none;"></div>
		
		<script src="/js/mouseeffect.js"></script>
		<script type="text/javascript">initToggleList(document.getElementById("left"), "h2", "ul", "li");</script>
		<script type="text/javascript">
			(function() {
				document.onselectstart = function(e) {return false;}
				setButtons();
				getMyCabinet();
				
				function setButtons() {
					var myCabinet     = document.getElementById("myCabinet");
					myCabinet.addEventListener("click", function(e) {getMyCabinet();}, false);
					
					var adminSpan  = document.getElementById("cabinetAdmin");
					adminSpan.addEventListener("click", function(e) {getAdminPage();}, false);
					
					var configSpan = document.getElementById("cabinetConfig");
					configSpan.addEventListener("click", function(e) {getConfigPage();}, false);
				}
				
				function getAdminPage()  {window.open("/admin/ezCabinet/cabinetAdminMain.do", "", "");}
				function getConfigPage() {window.parent.frames["right"].location.href = "/ezCabinet/cabinetConfig.do";}
				function getMyCabinet()  {window.parent.frames["right"].location.href = "/ezCabinet/myCabinet.do";}
			})();
		</script>
	</body>
</html>