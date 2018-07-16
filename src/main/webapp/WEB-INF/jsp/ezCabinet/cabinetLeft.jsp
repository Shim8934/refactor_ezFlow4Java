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
			<h2 id="relatedCabinet"><span><spring:message code='ezCabinet.t32'/></span></h2>
			<ul>
				<div id="cabinetModulesTree" class="cabinetTree"></div>
			</ul>
			
			<!-- 공유 반은 캐비넷 -->
			<h2><span><spring:message code='ezCabinet.t05'/></span></h2>
			<ul></ul>
			
			<!-- 용량보기 -->
			<div class="volumeDiv">
				<div id="myProgress"></div>
				<div class="volumeBar">
					<c:choose>
						<c:when test="${percent > 90}"                 ><div id="myBar" class="myBar_red"    style="width: ${percent < 100 ? percent : 100}%;"></div></c:when>
						<c:when test="${percent <= 90 && percent > 70}"><div id="myBar" class="myBar_orange" style="width: ${percent}%;"></div></c:when>
						<c:when test="${percent <= 70 && percent > 60}"><div id="myBar" class="myBar_yellow" style="width: ${percent}%;"></div></c:when>
						<c:when test="${percent <= 60 && percent > 0}" ><div id="myBar" class="myBar_green"  style="width: ${percent}%;"></div></c:when>
						<c:when test="${percent == 0}"                 ><div id="myBar" class="myBar_white"  style="width: 0%;"></div></c:when>
					</c:choose>
				</div>
				<c:choose>
					<c:when test="${capacityType == 0}">
						<div class="volumes"><c:out value='${useVolume}'/> / <spring:message code='ezCabinet.t114'/></div>
					</c:when>
					<c:otherwise>
						<div class="volumes"><c:out value='${useVolume}'/> / <c:out value="${totalCapacity}"/> MB (<c:out value="${percent > 100 ? 100 : percent}"/>%)</div>
					</c:otherwise>
				</c:choose>
				
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
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript">
			var CabUserLeft = function() {
				var cabinetTree = new CabinetTree();
				var subTree     = new CabinetTree();
				setButtons();
				
				function setButtons() {
					document.onselectstart = function(e) {return false;}
					initToggleList(document.getElementById("left"), "h2", "ul", "li");
					
					cabinetTree.setTreeInfo({
						treeId     : "cabinetTree",
						treeType   : "cabinet",
						type       : "normal",
						initialUrl : "/ezCabinet/getMyCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : getCabinet,
						dblClick   : null
					});
					
					cabinetTree.makeTree({cabinetNode : "root"});
					
					document.getElementById("myCabinet"        ).addEventListener("click", function(e) {getMyCabinet();     }, false);
					document.getElementById("cabinetConfig"    ).addEventListener("click", function(e) {getConfigPage();    }, false);
					document.getElementById("cabinetManagement").addEventListener("click", function(e) {getManagement();    }, false);
					document.getElementById("relatedCabinet"   ).addEventListener("click", function(e) {getRelatedCabinet();}, false);
					
					var cabinetAdminElmt = document.getElementById("cabinetAdmin");
					if (cabinetAdminElmt) {cabinetAdminElmt.addEventListener("click", function(e) {getAdminPage();} , false);}
					if (document.getElementById("myBar").className == "") {drawVolume();}
				}
				
				function getCabinet(obj) {
					var cabinetId = obj.getAttribute("role");
					window.parent.frames["right"].location.href = "/ezCabinet/myCabinet.do?cabinetId=" + cabinetId;
				}
				
				function getMyCabinet()  {
					var cabinetTreeElmt = document.getElementById("cabinetTree");
					var spanElmt        = cabinetTreeElmt.querySelector("span[level='0']");
					if (spanElmt) {spanElmt.click();}
				}
				
				function getAdminPage()  {window.open("/admin/ezCabinet/cabinetAdminMain.do", "", "");}
				function getConfigPage() {window.parent.frames["right"].location.href = "/ezCabinet/cabinetConfig.do";}
				function reloadTree(currentNode) {cabinetTree.makeTree({cabinetNode : currentNode});}
				
				function getManagement() {
					var mycabinetElmt  = document.getElementById("cabinetTree");
					var selectedNode   = mycabinetElmt.querySelector("span[class='selectedNode']");
					var selectedNodeId = "";
					
					if (selectedNode) {selectedNodeId = selectedNode.getAttribute("role");}
					window.open("/ezCabinet/cabinetManagement.do?node=" + selectedNodeId, "management", getOpenWindowfeature(600, 500));
				}
				
				function getRelatedCabinet() {
					subTree.setTreeInfo({
						treeId     : "cabinetModulesTree",
						treeType   : "cabinet",
						type       : "list",
						initialUrl : "/ezCabinet/getRelatedCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : getCabinet,
						dblClick   : null
					});
					
					subTree.makeTree();
				}
				
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
							var percent           = result["usedRate"] > 100 ? 100 : result["usedRate"];
							var totalVolume       = capacityType == 0 ? CabinetMessages.strNolimit : result["totalCapacity"] + "MB"  + " (" + percent + "%)";
							var useVolume         = getFileSize(result["totalUsed"]);
							var barElmt           = document.getElementById("myBar");
							var volumeInf         = document.getElementsByClassName("volumes")[0];
							barElmt.style.width   = percent + "%";
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
						case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
						case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2) + "MB"   ; break;
						case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2) + "KB"      ; break;
					}
					
					return result;
				}
				
				return {
					reloadTree : reloadTree,
					draw       : drawVolume
				};
			}();
		</script>
	</body>
</html>