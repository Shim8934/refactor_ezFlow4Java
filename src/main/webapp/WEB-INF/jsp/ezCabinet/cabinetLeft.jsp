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
				<h3 id="cabinetManagement"><span><spring:message code='ezCabinet.t03'/></span></h3>
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
		
		<script type="text/javascript" src="/js/mouseeffect.js"                     ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript">
			(function() {
				drawVolume();
				getMyCabinet();
				setButtons();
				
				function setButtons() {
					document.onselectstart = function(e) {return false;}
					initToggleList(document.getElementById("left"), "h2", "ul", "li");
					
					document.getElementById("myCabinet"        ).addEventListener("click", function(e) {getMyCabinet();} , false);
					document.getElementById("cabinetAdmin"     ).addEventListener("click", function(e) {getAdminPage();} , false);
					document.getElementById("cabinetConfig"    ).addEventListener("click", function(e) {getConfigPage();}, false);
					document.getElementById("cabinetManagement").addEventListener("click", function(e) {getManagement();}, false);
				}
				
				function getAdminPage()  {window.open("/admin/ezCabinet/cabinetAdminMain.do", "", "");}
				function getConfigPage() {window.parent.frames["right"].location.href = "/ezCabinet/cabinetConfig.do";}
				function getMyCabinet()  {window.parent.frames["right"].location.href = "/ezCabinet/myCabinet.do";}
				function getManagement() {window.open("/ezCabinet/cabinetManagement.do", "management", getOpenWindowfeature(600, 500));}
				
				function getOpenWindowfeature(popUpW, popUpH) {
					var heigth   = window.screen.availHeight;
					var width    = window.screen.availWidth;
					var left     = 0;
					var top      = 0;
					var pleftpos = parseInt(width) - popUpW;
					heigth       = parseInt(heigth) - popUpH;
					left         = pleftpos / 2;
					top          = heigth / 2;
					var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
					return feature;
				}
				
				function drawVolume() {
					$.ajax({
						url: "/ezCabinet/getUserCapicity.do",
						type: "POST",
						dataType: "JSON",
						async : true,
						success : function(data) {
							var result            = data.capacity;
							var capacityType      = result["capacityType"];
							var percent           = result["usedRate"];
							var totalVolume       = capacityType == 0 ? CabinetMessages.strNolimit : result["totalCapacity"] + "MB"  + " (" + percent + "%)";
							var useVolume         = getFileSize(result["totalUsed"]);
							var barElmt           = document.getElementById("myBar");
							var volumeInf         = document.getElementsByClassName("volumes")[0];
							barElmt.style.width   = percent < 100 ? percent + "%" : "100%";
							volumeInf.textContent = useVolume + " / " + totalVolume;
							var colorClass        = "myBar_green";
							
							switch (true) {
								case percent > 90 : colorClass = "myBar_red"   ; break;
								case percent > 70 : colorClass = "myBar_orange"; break;
								case percent > 60 : colorClass = "myBar_yellow"; break;
								case percent == 0 : colorClass = "myBar_white" ; break;
							}
							
							barElmt.className = colorClass;
						},
						error : function(error) {}
					});
				}
				
				function getFileSize(fileSize) {
					var result = fileSize + "B";
					
					switch(true) {
						case fileSize > 1073741824 : result = (Math.floor(parseFloat(fileSize / 1073741824 * 10)) / 10).toFixed(1) + "GB"; break;
						case fileSize > 1048576    : result = (Math.floor(parseFloat(fileSize / 1048576) * 10) / 10).toFixed(1) + "MB"   ; break;
						case fileSize > 1024       : result = parseInt(fileSize / 1024) + "KB"                                           ; break;
					}
					
					return result;
				}
			})();
		</script>
	</body>
</html>