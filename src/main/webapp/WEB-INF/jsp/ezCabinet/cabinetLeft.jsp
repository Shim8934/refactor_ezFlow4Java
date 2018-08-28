<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>

<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezCabinet.css', 'msg')}"       type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css">
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
			<ul><div id="cabinetModulesTree" class="cabinetTree2"></div></ul>
			
			<!-- 공유 한은 캐비넷 -->
			<h2 id="shareCabinet"><span><spring:message code='ezCabinet.t157'/></span></h2>
			<ul><div id="myShareTree" class="cabinetTree2"></div></ul>
			
			<!-- 공유 반은 캐비넷 -->
			<h2 id="sharedCabinet"><span><spring:message code='ezCabinet.t05'/></span></h2>
			<ul><div id="cabinetShareTree" class="cabinetTree2"></div></ul>
			
			<!-- 용량보기 -->
			<div class="volumeDiv">
				<p class="volume_num"><img src="/images/volume_num.png"></p>
				<p class="volume_graph" id="myProgress">
					<c:choose>
						<c:when test="${percent > 90}"                 ><span id="myBar" class="myBar_red"    style="width: ${percent < 100 ? percent : 100}%;"></span></c:when>
						<c:when test="${percent <= 90 && percent > 70}"><span id="myBar" class="myBar_orange" style="width: ${percent}%;"                      ></span></c:when>
						<c:when test="${percent <= 70 && percent > 60}"><span id="myBar" class="myBar_yellow" style="width: ${percent}%;"                      ></span></c:when>
						<c:when test="${percent <= 60 && percent > 0}" ><span id="myBar" class="myBar_green"  style="width: ${percent}%;"                      ></span></c:when>
						<c:when test="${percent == 0}"                 ><span id="myBar" class="myBar_white"  style="width: 0%;"                               ></span></c:when>
					</c:choose>
				</p>
				<dl class="volumeDL">
					<c:choose>
						<c:when test="${capacityType == 0}">
							<dt id="useVol"><c:out value='${useVolume}'/><span> / <spring:message code='ezCabinet.t114'/></span></dt>
							<dd id="usePer" style="color: #0470e4;">0%</dd>
						</c:when>
						<c:otherwise>
							<dt id="useVol"><c:out value='${useVolume}'/><span> / <c:out value="${totalCapacity}"/> MB</span></dt>
							<dd id="usePer" style="color: #0470e4;"><c:out value="${percent > 100 ? 100 : percent}"/>%</dd>
						</c:otherwise>
					</c:choose>
				</dl>
			</div>
			
			<!-- 환경설정 -->
			<h3 id="cabinetConfig"><span><spring:message code="ezCabinet.t06"/></span></h3>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')             }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTree.js')   }"></script>
		<script type="text/javascript">
			var CabUserLeft = function() {
				var cabinetTree = new CabinetTree();
				var relatedTree = new CabinetTree();
				var shareTree   = new CabinetTree();
				var myShareTree = new CabinetTree();
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
					document.getElementById("sharedCabinet"    ).addEventListener("click", function(e) {getSharedCabinet(); }, false);
					document.getElementById("shareCabinet"     ).addEventListener("click", function(e) {getMyShareCabinet();}, false);
					
					var cabinetAdminElmt = document.getElementById("cabinetAdmin");
					if (cabinetAdminElmt) {cabinetAdminElmt.addEventListener("click", function(e) {getAdminPage();} , false);}
					if (!document.getElementById("myBar").className == "") {drawVolume();}
				}
				
				function getCabinet(obj) {
					var cabinetId = obj.getAttribute("role");
					window.parent.frames["right"].location.href = "/ezCabinet/myCabinet.do?cabinetId=" + cabinetId;
				}
				
				function getShareCabinet(obj) {
					var cabinetId = obj.getAttribute("role");
					window.parent.frames["right"].location.href = "/ezCabinet/getShareCabinet.do?cabinetId=" + cabinetId;
				}
				
				function getMyCabinet()  {
					var cabinetTreeElmt = document.getElementById("cabinetTree");
					var spanElmt        = cabinetTreeElmt.querySelector("span[level='0']");
					if (spanElmt) {spanElmt.click();}
				}
				
				function getAdminPage()  {window.open("/admin/ezCabinet/cabinetAdminMain.do", "", "");}
				function getConfigPage() {window.parent.frames["right"].location.href = "/ezCabinet/cabinetConfig.do";}
				function reloadRelatedTree(currentNode) {relatedTree.makeTree({cabinetNode : currentNode});}
				
				function reloadTree(currentNode, mode) {
					var cabinetNodeId   = "root";
					var myCabinetDiv    = document.getElementById("cabinetTree");
					var currentSelected = myCabinetDiv.querySelector("span[class='selectedNode']");
					
					if (currentSelected && currentSelected.getAttribute("role")) {cabinetNodeId = currentSelected.getAttribute("role");}
					if (mode && currentNode == cabinetNodeId) {cabinetNodeId = "root";}
					
					cabinetTree.makeTree({cabinetNode : cabinetNodeId});
				}
				
				function reloadMyShareTree(nodeId) {
					var myShareCabinet  = document.getElementById("myShareTree");
					var currentSelected = myShareCabinet.querySelector("span[class='selectedNode']");
					if (currentSelected && currentSelected.getAttribute("role") == nodeId) {currentSelected = "";}
					
					myShareTree.makeTree({cabinetNode : currentSelected});
				}
				
				function getManagement() {
					var mycabinetElmt  = document.getElementById("cabinetTree");
					var selectedNode   = mycabinetElmt.querySelector("span[class='selectedNode']");
					var selectedNodeId = "";
					
					if (selectedNode) {selectedNodeId = selectedNode.getAttribute("role");}
					window.open("/ezCabinet/cabinetManagement.do?node=" + selectedNodeId, "management", getOpenWindowfeature(600, 505));
				}
				
				function getRelatedCabinet() {
					relatedTree.setTreeInfo({
						treeId     : "cabinetModulesTree",
						treeType   : "cabinet",
						type       : "list",
						initialUrl : "/ezCabinet/getRelatedCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : getCabinet,
						dblClick   : null
					});
					
					relatedTree.makeTree();
				}
				
				function getSharedCabinet() {
					shareTree.setTreeInfo({
						treeId     : "cabinetShareTree",
						treeType   : "cabinet",
						type       : "share",
						initialUrl : "/ezCabinet/getSharedCabinetTree.do",
						shareUrl   : "/ezCabinet/getSharedCabinetsByUser.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : getShareCabinet,
						dblClick   : null
					});
					
					shareTree.makeTree();
				}
				
				function getMyShareCabinet() {
					myShareTree.setTreeInfo({
						treeId     : "myShareTree",
						treeType   : "cabinet",
						type       : "listshare",
						initialUrl : "/ezCabinet/getMyShareCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : getCabinet,
						dblClick   : null
					});
					
					myShareTree.makeTree();
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
							var pElmt             = document.getElementById("myProgress");
							var userVolElmt       = document.getElementById("useVol");
							var usedPerElmt       = document.getElementById("usePer");
							var spanElmt          = document.createElement("span");
							pElmt.innerHTML       = "";
							pElmt.appendChild(spanElmt);
							
							if (capacityType == 0) {
								usedPerElmt.textContent = "0%";
								spanElmt.style.width    = "0%";
								userVolElmt.innerHTML   = getFileSize(result["totalUsed"]) + "<span>/ " + CabinetMessages.strNolimit + "</span>";
							}
							else {
								usedPerElmt.textContent = percent + "%";
								spanElmt.style.width    = percent + "%";
								userVolElmt.innerHTML   = getFileSize(result["totalUsed"]) + "<span>/ " + result['totalCapacity'] + "MB</span>";
							}
							
							var colorClass = "myBar_green";
							
							switch (true) {
								case percent > 90 : colorClass = "myBar_red"   ; break;
								case percent > 70 : colorClass = "myBar_orange"; break;
								case percent > 60 : colorClass = "myBar_yellow"; break;
								case percent == 0 : colorClass = "myBar_white" ; break;
							}
							
							spanElmt.className = colorClass;
						},
						error : function(error) {}
					});
				}
				
				function getFileSize(fileSize) {
					var result = fileSize + "B";
					
					switch(true) {
						case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
						case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2)    + "MB"; break;
						case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2)       + "KB"; break;
					}
					
					return result;
				}
				
				return {
					reloadTree    : reloadTree,
					relateTree    : reloadRelatedTree,
					reloadMyShare : reloadMyShareTree,
					draw          : drawVolume
				};
			}();
		</script>
	</body>
</html>