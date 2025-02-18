<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')}">
	</head>
	<body class="popup cabMag">
		<h1 id="cabMagHeader" role='<c:out value="${node}"></c:out>'><spring:message code="ezCabinet.t03"/></h1>
		
		<div id="cabMgClose" class="cabClose"><ul><li><span></span></li></ul></div>
		
		<div class="cabMgTree" id="cabinetMgTree"></div>
		
		<jsp:include page="/WEB-INF/jsp/ezCabinet/management/cabinetAdd.jsp"   ></jsp:include>
		<jsp:include page="/WEB-INF/jsp/ezCabinet/management/cabinetMove.jsp"  ></jsp:include>
		<jsp:include page="/WEB-INF/jsp/ezCabinet/management/cabinetDelete.jsp"></jsp:include>
		
		<div class="cabdivBttn2" id="cabMgDivBttn">
			<a class="cabBttn"><span><spring:message code="ezCabinet.t75"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t78"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t76"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t77"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t46"/></span></a>
		</div>
		
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTree.js')   }"></script>
		<script type="text/javascript">
			(function() {
				var myCabinetTree = new CabinetTree();
				initEvents();
				
				function initEvents() {
					document.onselectstart = function() {return false;};
					
					myCabinetTree.setTreeInfo({
						treeId     : "cabinetMgTree",
						treeType   : "cabinet",
						type       : "normal",
						initialUrl : "/ezCabinet/getMyCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : null,
						dblClick   : null
					});
					
					myCabinetTree.makeTree({cabinetNode : document.getElementById("cabMagHeader").getAttribute("role")});
					
					document.getElementById("cabMgClose").onclick   = function(e) {closeWindow();};
					document.getElementById("cabMoveClose").onclick = function(e) {closeCabinetDialog("moveCab");};
					document.getElementById("cabAddClose").onclick  = function(e) {closeCabinetDialog("addCab");};
					
					var cabMgBttnElmt        = document.getElementById("cabMgDivBttn");
					var listMgBttns          = cabMgBttnElmt.children;
					listMgBttns[0].onclick   = function(e) {addCabinetDialog();};
					listMgBttns[1].onclick   = function(e) {changeCabinetDialog();};
					listMgBttns[2].onclick   = function(e) {moveCabinetDialog("move");};
					listMgBttns[3].onclick   = function(e) {moveCabinetDialog("copy");};
					listMgBttns[4].onclick   = function(e) {deleteCabinetDialog();};
					
					var cabAddBttnElmt       = document.getElementById("cabAddBttn");
					var listAddBttns         = cabAddBttnElmt.children;
					listAddBttns[0].onclick  = function(e) {modifyCabinet();};
					listAddBttns[1].onclick  = function(e) {closeCabinetDialog("addCab");};
					
					var nameElmt1            = document.getElementById("cabNameTxt1");
					nameElmt1.addEventListener("keydown", function(e) {onInputCabName(e);}, false);
					
					var cabMoveBttnElmt      = document.getElementById("cabMoveBttn");
					var listMoveBttns        = cabMoveBttnElmt.children;
					listMoveBttns[0].onclick = function(e) {moveCabinetHandler();};
					listMoveBttns[1].onclick = function(e) {closeCabinetDialog("moveCab");};
					
					var cabDelBttnElmt       = document.getElementById("cabDelBttn");
					var listDelBttns         = cabDelBttnElmt.children;
					listDelBttns[0].onclick  = function(e) {delCabinet();};
					listDelBttns[1].onclick  = function(e) {closeCabinetDialog("delCab");};
				}
				
				function onInputCabName(event) {if (event.keyCode == 13) {modifyCabinet();}}
				
				function modifyCabinet() {
					var h1TtlElmt = document.getElementById("addCabTtl");
					var mode      = h1TtlElmt.getAttribute("role");
					if (!mode) {alert(CabinetMessages.strError); return;}
					
					var strName1 = document.getElementById("cabNameTxt1").value.replace(/\s/g,'');
					if (!strName1) {alert("<spring:message code='ezCabinet.t83'/>"); return;}
					if (strName1.length > 50) {alert("<spring:message code='ezCabinet.t165'/>"); return;}
					if (checkCabinetName(strName1)) {alert('<spring:message code="ezCabinet.t82"/>'); return;}
					
					var handleFunct = mode == "add" ? addCabinet : changeCabinet;
					handleFunct(strName1);
				}
				
				function afterChangeCabinet(data, mode) {
					var code           = data.code;
					var successHandler = null;
					
					switch(mode) {
						case "add"   : successHandler = afterAddCabinetSuccessfully    ; break;
						case "change": successHandler = afterChangeCabinetSuccessfully ; break;
						case "del"   : successHandler = afterDeleteCabinetSuccessfully ; break;
						case "copy"  :
						case "move"  : successHandler = afterMoveCabinetSuccessfully   ; break;
					}
					
					switch(code) {
						case 0 : successHandler(mode)               ; break;
						case 1 : alert(CabinetMessages.strParamErr) ; break;
						case 2 : alert(CabinetMessages.strError)    ; break;
						case 3 : alert(CabinetMessages.strPerm)     ; break;
						case 4 : alert(CabinetMessages.strRoot)     ; break;
						case 5 : alert(CabinetMessages.strMovErr2)  ; break;
						case 6 : alert(CabinetMessages.strMovErr3)  ; break;
						case 7 : alert(CabinetMessages.strCapacity) ; break;
						case 8 : alert(CabinetMessages.strDelete3)  ; break;
						default: alert(CabinetMessages.strError)    ; return;
					}
				}
				
				function afterMoveCabinetSuccessfully(mode) {
					var strMessage = mode == "copy" ? CabinetMessages.strCopy : CabinetMessages.strMove;
					alert(strMessage);
					closeCabinetDialog("moveCab");
					reloadTree();
				}
				
				function afterChangeCabinetSuccessfully() {
					alert(CabinetMessages.strSave);
					document.getElementById("cabNameTxt1").value = "";
					closeCabinetDialog("addCab");
					reloadTree();
				}
				
				function afterAddCabinetSuccessfully() {
					alert(CabinetMessages.strAdd);
					document.getElementById("cabNameTxt1").value = "";
					closeCabinetDialog("addCab");
					reloadTree();
				}
				
				function afterDeleteCabinetSuccessfully() {
					alert(CabinetMessages.strDel);
					closeCabinetDialog("delCab");
					reloadTree("del");
				}
				
				function reloadTree(mode) {
					var selectedNode = document.querySelector("span[class='selectedNode']");
					var currentNode  = "";
					
					if (selectedNode) {currentNode = selectedNode.getAttribute("role");}
					if (!mode || mode != "del") {if (selectedNode) {currentNode = selectedNode.getAttribute("role");}}
					
					myCabinetTree.makeTree({cabinetNode : (!mode || mode != "del" ? currentNode : "")});
					var leftPanel = window.opener;
					
					if (leftPanel) {leftPanel.CabUserLeft.reloadTree(currentNode, mode);}
				}
				
				function moveCabinetHandler() {
					var selectedNode = document.getElementById("cabinetMgTree").querySelector("span.selectedNode");
					if (!selectedNode) {alert(CabinetMessages.strSelect); return;}
					if (selectedNode.getAttribute("level") == "0") {alert(CabinetMessages.strRoot); return;}
					
					var h1TtlElmt = document.getElementById("moveCabTtl");
					var mode      = h1TtlElmt.getAttribute("role");
					
					if (!mode) {alert(CabinetMessages.strError); return;}
					
					moveCabinet(mode);
				}
				
				function addCabinet(strName1) {
					var url      = "/ezCabinet/addCabinet.do";
					var parentId = document.getElementById("cabinetMgTree").querySelector("span.selectedNode").getAttribute("role");
					var data     = {parentId : parentId, cabName1 : strName1};
					
					makeAjaxCall(data, "GET", url, afterChangeCabinet, null, true, "add");
				}
				
				function changeCabinet(strName1) {
					var url  = "/ezCabinet/renameCabinet.do";
					var data = {
						cabinetId : document.getElementById("cabinetMgTree").querySelector("span.selectedNode").getAttribute("role"),
						cabName1  : strName1
					};
					
					makeAjaxCall(data, "GET", url, afterChangeCabinet, null, true, "change");
				}
				
				function moveCabinet(mode) {
					var url        = "/ezCabinet/moveCabinet.do";
					var cabinetId  = document.getElementById("cabinetMgTree").querySelector("span.selectedNode").getAttribute("role");
					
					var parentNode = document.getElementById("cabinetMoveTree").querySelector("span.selectedNode");
					if (!parentNode) {alert(CabinetMessages.strSelect); return;}
					
					var parentId   = parentNode.getAttribute("role");
					if (cabinetId == parentId) {alert(CabinetMessages.strMovErr1); return;}
					
					var data = {
						cabinetId : cabinetId,
						parentId  : parentId,
						mode      : mode
					};
					
					makeAjaxCall(data, "GET", url, afterChangeCabinet, null, true, mode);
				}
				
				function delCabinet() {
					var url  = "/ezCabinet/deleteCabinet.do";
					var data = {cabinetId : document.querySelector("span.selectedNode").getAttribute("role")};
					
					makeAjaxCall(data, "GET", url, afterChangeCabinet, null, true, "del");
				}
				
				function checkCabinetName(str) {
					var regex = /[*:"\\|<>\/?]/g;
					return regex.test(str);
				}
				
				function changeCabinetTitle(mode, type) {
					var h1ElmtId  = type == "addCabinet" ? "addCabTtl" : "moveCabTtl";
					var h1TtlElmt = document.getElementById(h1ElmtId);
					
					switch (mode) {
						case "add"   : h1TtlElmt.textContent = CabinetMessages.strTtlAdd   ; break;
						case "change": h1TtlElmt.textContent = CabinetMessages.strTtlChange; break;
						case "move"  : h1TtlElmt.textContent = CabinetMessages.strTtlMove  ; break;
						case "copy"  : h1TtlElmt.textContent = CabinetMessages.strTtlCopy  ; break;
						default      : alert(CabinetMessages.strError); return;
					}
					
					h1TtlElmt.setAttribute("role", mode);
				}
				
				function closeCabinetDialog(mode) {
					var divInfo         = getDivInfo(mode, "off");
					var cabAddDiv       = document.getElementById(divInfo.cabDivId);
					cabAddDiv.className = "popup " + divInfo.cabDivClass;
					removeFogPanel();
					
					if (mode == "moveCab") {document.getElementById("cabinetMoveTree").innerHTML = "";}
				}
				
				function addCabinetDialog() {
					var selectedNode = document.querySelector("span.selectedNode");
					if (!selectedNode) {alert(CabinetMessages.strSelect); return;}
					
					addFogPanel();
					changeCabinetTitle("add", "addCabinet");
					document.getElementById("cabNameTxt1").value = "";
					showCabinetPopup("addCab", 320, 165);
				}
				
				function changeCabinetDialog() {
					var selectedNode = document.querySelector("span.selectedNode");
					
					if (!selectedNode) {alert(CabinetMessages.strSelect); return;}
					if (selectedNode.getAttribute("level") == "0") {alert(CabinetMessages.strRoot1); return;}
					
					document.getElementById("cabNameTxt1").value = selectedNode.getAttribute("name1");
					addFogPanel();
					changeCabinetTitle("change", "addCabinet");
					showCabinetPopup("addCab", 320, 165);
				}
				
				function deleteCabinetDialog() {
					var selectedNode = document.querySelector("span.selectedNode");
					
					if (!selectedNode) {alert(CabinetMessages.strSelect); return;}
					if (selectedNode.getAttribute("level") == "0") {alert(CabinetMessages.strRoot); return;}
					
					addFogPanel();
					showCabinetPopup("delCab", 330, 200);
				}
				
				function moveCabinetDialog(mode) {
					var selectedNode = document.querySelector("span.selectedNode");
					
					if (!selectedNode) {alert(CabinetMessages.strSelect); return;}
					if (selectedNode.getAttribute("level") == "0") {alert(CabinetMessages.strRoot2); return;}
					
					addFogPanel();
					
					//Add new tree
					var subTree = new CabinetTree();
					
					subTree.setTreeInfo({
						treeId     : "cabinetMoveTree",
						treeType   : "cabinet",
						type       : "normal",
						initialUrl : "/ezCabinet/getMyCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : null,
						dblClick   : null
					});
					
					subTree.makeTree();
					
					changeCabinetTitle(mode, "moveCabinet");
					showCabinetPopup("moveCab", 340, 410);
				}
				
				function getDivInfo(mode, type) {
					var divInfo = {};
					
					switch (mode) {
						case "addCab" : divInfo.cabDivId = "cabAddDiv" ; divInfo.cabDivClass = type == "off" ? "cabAddoff" : "cabAddon" ; break;
						case "moveCab": divInfo.cabDivId = "cabMoveDiv"; divInfo.cabDivClass = type == "off" ? "cabMoveoff": "cabMoveon"; break;
						case "delCab" : divInfo.cabDivId = "cabDelDiv" ; divInfo.cabDivClass = type == "off" ? "cabDeloff" : "cabDelon" ; break;
					}
					
					return divInfo;
				}
				
				function showCabinetPopup(mode, divWidth, divHeight) {
					var divInfo           = getDivInfo(mode, "on");
					var cabAddDiv         = document.getElementById(divInfo.cabDivId);
					var position          = getPosition(divWidth, divHeight);
					cabAddDiv.style.top   = position[0] + "px";
					cabAddDiv.style.right = position[1] + "px";
					
					cabAddDiv.className = mode == "delCab"? divInfo.cabDivClass : "popup " + divInfo.cabDivClass;
				}
				
				function addFogPanel() {
					var fogPanel       = document.createElement("div");
					fogPanel.className = "cabFogPanel";
					document.body.appendChild(fogPanel);
				}
				
				function removeFogPanel() {
					var fogPanel = document.querySelector("div[class='cabFogPanel']");
					if (fogPanel) {document.body.removeChild(fogPanel);}
				}
				
				function closeWindow() {window.close();}
				
				function getPosition(popUpW, popUpH) {
					var returnValue = new Array();
					var heigth      = window.parent.document.documentElement.clientHeight;
					if (heigth == 0) {heigth = window.parent.document.body.clientHeight;}
					
					var width = window.parent.document.documentElement.clientWidth;
					if (width == 0) {width = window.parent.document.body.clientWidth;}
					
					var pleftpos   = parseInt(width)  - popUpW;
					heigth         = parseInt(heigth) - popUpH;
					returnValue[0] = (heigth / 2);
					returnValue[1] = pleftpos / 2;
					
					return returnValue;
				}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode, moreParam) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						success : function(data) {
							handleSuccess(data, moreParam);
						},
						error : function(error) {
							if (handleError != null) {handleError();}
							
							alert(CabinetMessages.strError);
						}
					});
				}
			})();
		</script>
	</body>
</html>

