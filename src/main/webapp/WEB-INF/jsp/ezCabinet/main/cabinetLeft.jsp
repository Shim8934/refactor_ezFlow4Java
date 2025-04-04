<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>

<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	</head>
	
	<body class="newLeft">
		<div id="left" class="lnb">
			<div class="left_title">
				<spring:message code='ezCabinet.t01'/>
				<span id="cabinetConfig" class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezCabinet.t06"/>"></span>
			</div>
			
			<div class="cabinetListBox">
				<!-- 나의 캐비넷  -->
				<h2 id="myCabinet" class="on"><span class="sub_iconLNB tree_arrow_down"></span><span style="font-size: 16px; font-weight: bold;"><spring:message code='ezCabinet.t02'/></span></h2>
				<ul class="lnbUL on">
					<li id="cabinetTree"></li>
					<!-- 캐비넷  관리 -->
					<li><span id="cabinetManagement" class="list_text"><spring:message code='ezCabinet.t03'/></span></li>
				</ul>
				
				<!-- 연동 캐비넷 -->
				<h2 id="relatedCabinet"><span class="sub_iconLNB tree_plus"></span><span style="font-size: 16px; font-weight: bold;"><spring:message code='ezCabinet.t32'/></span></h2>
				<ul class="lnbUL off"><li id="cabinetModulesTree" class="cabinetTree2"></li></ul>
				
				<!-- 공유한 캐비넷 -->
				<h2 id="shareCabinet"><span class="sub_iconLNB tree_plus"></span><span style="font-size: 16px; font-weight: bold;"><spring:message code='ezCabinet.t157'/></span></h2>
				<ul class="lnbUL off"><li id="myShareTree" class="cabinetTree2"></li></ul>
				
				<!-- 공유받은 캐비넷 -->
				<h2 id="sharedCabinet"><span class="sub_iconLNB tree_plus"></span><span style="font-size: 16px; font-weight: bold;"><spring:message code='ezCabinet.t05'/></span></h2>
				<ul class="lnbUL off"><li id="cabinetShareTree" class="cabinetTree2"></li></ul>
			</div>
			
			<!-- 용량보기 -->
			<div class="mail_space">
				<span class="mail_spaceText">
					<spring:message code="ezCabinet.t120" />&nbsp;
					<c:choose>
						<c:when test="${capacityType == 0}">
							<%-- <dt id="useVol"><c:out value='${useVolume}'/><span> / <spring:message code='ezCabinet.t114'/></span></dt> --%>
							<span id="usePer">0%</span>
						</c:when>
						<c:otherwise>
							<%-- <dt id="useVol"><c:out value='${useVolume}'/><span> / <c:out value="${totalCapacity}"/>MB</span></dt> --%>
							<span id="usePer"><c:out value="${percent > 100 ? 100 : percent}"/>%</span>
						</c:otherwise>
					</c:choose>
				</span>
				<span id="myProgress">
					<c:choose>
						<c:when test="${percent >= 80}"                ><span id="myBar" class="mailBar myBar_red"    style="width: ${percent < 100 ? percent : 100}%;"></span></c:when>
						<c:when test="${percent >= 70 && percent < 80}"><span id="myBar" class="mailBar myBar_orange" style="width: ${percent}%;"                      ></span></c:when>
						<c:when test="${percent >   0 && percent < 70}"><span id="myBar" class="mailBar myBar_blue"   style="width: ${percent}%;"                      ></span></c:when>
						<c:when test="${percent == 0}"                 ><span id="myBar" class="mailBar myBar_white"  style="width: 0%;"                               ></span></c:when>
					</c:choose>
				</span>
			</div>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')      }"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')                }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTree.js')         }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript">
			var UserLang =  "<c:out value = '${UserLang} '/>";
			var CabUserLeft = function() {
				var cabinetTree = new CabinetTree();
				var relatedTree = new CabinetTree();
				var shareTree   = new CabinetTree();
				var myShareTree = new CabinetTree();
				
				window.addEventListener("load", init, false);
				window.addEventListener("resize", resizeWindow, false);
				
				setButtons();
				
				function init() {
					$(".cabinetListBox").mCustomScrollbar({theme : "dark"});
					resizeWindow();
				}
				
				function resizeWindow() {
					$(".cabinetListBox").height(window.innerHeight - 105);
				}
				
				function setButtons() {
					document.onselectstart = function(e) {return false;}
					
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
					var targetSpan = "";
					var checkInterval = setInterval(function() {
						targetSpan = document.querySelector("#cabinetTree div span.list_text[level='0']");
						if (targetSpan) {
							targetSpan.className = "list_text node_selected selectedNode";
							var cabinetId = targetSpan.getAttribute("role");
							window.parent.frames["right"].location.href = "/ezCabinet/myCabinet.do?cabinetId=" + cabinetId;
							clearInterval(checkInterval);
						}
					}, 100);
					
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
				
				function handleErrorTree(errorUrl) {window.parent.frames["right"].location.href = errorUrl;}
				
				function openCabinet(obj) { // 2023-06-23 황인경 - 디자인 개선 > 캐비넷 > 좌측메뉴 > 트리구조 LNB 이미지 수정 및 클래스 제어
					if ($("#" + obj).hasClass("on")) {
						$("#" + obj).attr("class", "off");
						$("#" + obj).next().attr("class", "lnbUL off");
						$("#" + obj).children().eq(0).attr("class", "sub_iconLNB tree_plus");
					} else {
						$("h2.on").attr("class", "off");
						$(".lnbUL.on").attr("class", "lnbUL off");
						$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
						$("#" + obj).attr("class", "on");
						$("#" + obj).next().attr("class", "lnbUL on");
						$("#" + obj).children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
					}

 					/*var leftDivElmt = document.getElementById("leftFrame");
					var h2Elmt      = leftDivElmt.querySelectorAll("h2");
					var ulElmt      = leftDivElmt.querySelectorAll("ul");
					
					var len = h2Elmt.length;
					
					for (var i = 0; i < len; i++) {
						if (h2Elmt[i].getAttribute("class") == "on") {
							h2Elmt[i].className = "off";
							ulElmt[i].className = "lnbUL off";
						}
						
						if (h2Elmt[i].getAttribute("id") == obj) {
							h2Elmt[i].className = "on";
							ulElmt[i].className = "lnbUL";
						}
					} */
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
					openCabinet("myCabinet");
					
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
				
				function destroyRelatedTree() {document.getElementById("cabinetModulesTree").innerHTML = "";}
				
				function getManagement() {
					var mycabinetElmt  = document.getElementById("cabinetTree");
					var selectedNode   = mycabinetElmt.querySelector("span[class='selectedNode']");
					var selectedNodeId = "";
					
					if (selectedNode) {selectedNodeId = selectedNode.getAttribute("role");}
					window.open("/ezCabinet/cabinetManagement.do?node=" + selectedNodeId, "management", getOpenWindowfeature(600, 505));
				}
				
				function getRelatedCabinet() {
					openCabinet("relatedCabinet");
					
					relatedTree.setTreeInfo({
						treeId     : "cabinetModulesTree",
						treeType   : "cabinet",
						type       : "list",
						initialUrl : "/ezCabinet/getRelatedCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						errHandler : handleErrorTree,
						click      : getCabinet,
						dblClick   : null
					});
					
					relatedTree.makeTree();
				}
				
				function getSharedCabinet() {
					openCabinet("sharedCabinet");
					
					shareTree.setTreeInfo({
						treeId     : "cabinetShareTree",
						treeType   : "cabinet",
						type       : "share",
						initialUrl : "/ezCabinet/getSharedCabinetTree.do",
						shareUrl   : "/ezCabinet/getSharedCabinetsByUser.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						errHandler : handleErrorTree,
						click      : getShareCabinet,
						dblClick   : null
					});
					
					shareTree.makeTree();
				}
				
				function getMyShareCabinet() {
					openCabinet("shareCabinet");
					
					myShareTree.setTreeInfo({
						treeId     : "myShareTree",
						treeType   : "cabinet",
						type       : "listshare",
						initialUrl : "/ezCabinet/getMyShareCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						errHandler : handleErrorTree,
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
						type: "GET",
						dataType: "JSON",
						async : true,
						success : function(data) {
							var result            = data.capacity;
							var capacityType      = result["capacityType"];
							var percent           = result["usedRate"] > 100 ? 100 : result["usedRate"];
							var pElmt             = document.getElementById("myProgress");
							//var userVolElmt       = document.getElementById("useVol");
							var usedPerElmt       = document.getElementById("usePer");
							var spanElmt          = document.createElement("span");
							pElmt.innerHTML       = "";
							pElmt.appendChild(spanElmt);
							
							if (capacityType == 0) {
								usedPerElmt.textContent = "0%";
								spanElmt.style.width    = "0%";
								//userVolElmt.innerHTML   = getFileSize(result["totalUsed"]) + "<span>/ " + CabinetMessages.strNolimit + "</span>";
							}
							else {
								usedPerElmt.textContent = percent + "%";
								spanElmt.style.width    = percent + "%";
								//userVolElmt.innerHTML   = getFileSize(result["totalUsed"]) + "<span>/ " + result['totalCapacity'] + "MB</span>";
							}
							
							var colorClass = "mailBar myBar_blue";
							
							switch (true) {
								case percent >= 80 : colorClass = "mailBar myBar_red"   ; break;
								case percent >= 70 : colorClass = "mailBar myBar_orange"; break;
								case percent ==  0 : colorClass = "mailBar myBar_white" ; break;
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
					destroyTree   : destroyRelatedTree, 
					reloadMyShare : reloadMyShareTree,
					draw          : drawVolume
				};
			}();
		</script>
	</body>
</html>