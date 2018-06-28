<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabMag">
		<h1><spring:message code="ezCabinet.t03"/></h1>
		
		<div id="cabMgClose" class="cabClose"><ul><li><span><spring:message code='ezCabinet.t66'/></span></li></ul></div>
		
		<div class="cabMgTree" id="cabinetMgTree"></div>
		
		<jsp:include page="/WEB-INF/jsp/ezCabinet/cabinetAdd.jsp"   ></jsp:include>
		<jsp:include page="/WEB-INF/jsp/ezCabinet/cabinetMove.jsp"  ></jsp:include>
		<jsp:include page="/WEB-INF/jsp/ezCabinet/cabinetDelete.jsp"></jsp:include>
		
		<div class="cabdivBttn" id="cabMgDivBttn">
			<a class="cabBttn"><span><spring:message code="ezCabinet.t75"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t78"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t76"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t77"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t46"/></span></a>
		</div>
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript">
			(function() {
				initEvents();
				
				function initEvents() {
					document.onselectstart   = function() {return false;};
					var closeBttn            = document.getElementById("cabMgClose").firstElementChild.firstElementChild.firstElementChild;
					closeBttn.onclick        = function(e) {closeWindow();};
					var cabMoveCloseBttn     = document.getElementById("cabMoveClose").firstElementChild.firstElementChild.firstElementChild;
					cabMoveCloseBttn.onclick = function(e) {closeCabinetDialog("moveCab");};
					var cabDelCloseBttn      = document.getElementById("cabDelClose").firstElementChild.firstElementChild.firstElementChild;
					cabDelCloseBttn.onclick  = function(e) {closeCabinetDialog("delCab");};
					
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
					var nameElmt2            = document.getElementById("cabNameTxt2");
					nameElmt1.addEventListener("keydown", function(e) {onInputCabName(e);}, false);
					nameElmt2.addEventListener("keydown", function(e) {onInputCabName(e);}, false);
					
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
					var strName2 = document.getElementById("cabNameTxt2").value.replace(/\s/g,'');
					
					if (!strName1) {alert("<spring:message code='ezCabinet.t83'/>"); return;}
					if (!strName2) {alert("<spring:message code='ezCabinet.t84'/>"); return;}
					
					if (checkCabinetName(strName1)) {alert('<spring:message code="ezCabinet.t82"/>'); return;}
					if (checkCabinetName(strName2)) {alert('<spring:message code="ezCabinet.t82"/>'); return;}
					
					var handleFunct = mode == "add" ? addCabinet : changeCabinet;
					handleFunct(strName1, strName2);
				}
				
				function addCabinet(strName1, strName2) {
					//*Note add cabinet function here
				}
				
				function changeCabinet(strName1, strName2) {
					//*Note change cabinet function here
				}
				
				function moveCabinetHandler(){
					var h1TtlElmt = document.getElementById("moveCabTtl");
					var mode      = h1TtlElmt.getAttribute("role");
					if (!mode) {alert(CabinetMessages.strError); return;}
					
					//*Note check selected cabinet here
					var handleFunct = mode == "move" ? moveCabinet : copyCabinet;
					handleFunct();
				}
				
				function moveCabinet() {
					//*Note move cabinet function here
				}
				
				function copyCabinet() {
					//*Note copy cabinet function here
				}
				
				function delCabinet() {
					//*Note delete cabinet function here
				}
				
				function checkCabinetName(str){
					var regex = /[*:"\\|<>\/?]/g;
					return regex.test(str);
				}
				
				function changeCabinetTitle(mode, type) {
					var h1ElmtId  = type == "addCabinet" ? "addCabTtl" : "moveCabTtl";
					var h1TtlElmt = document.getElementById(h1ElmtId);
					
					switch	(mode) {
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
				}
				
				function addCabinetDialog() {
					//Check if selected Cabinet exist
					
					addFogPanel();
					changeCabinetTitle("add", "addCabinet");
					document.getElementById("cabNameTxt1").value = "";
					document.getElementById("cabNameTxt2").value = "";
					showCabinetPopup("addCab", 300, 162);
				}
				
				function changeCabinetDialog() {
					//Check if selected cabinet exist
					
					//Set 2 names of selected cabinet to 2 input elements
					//document.getElementById("cabNameTxt1").value = "";
					//document.getElementById("cabNameTxt2").value = "";
					addFogPanel();
					changeCabinetTitle("change", "addCabinet");
					showCabinetPopup("addCab", 300, 162);
				}
				
				function deleteCabinetDialog() {
					//Check if selected Cabinet exist
					
					addFogPanel();
					showCabinetPopup("delCab", 350, 160);
				}
				
				function moveCabinetDialog(mode) {
					//Check if selected Cabinet exist
					
					addFogPanel();
					changeCabinetTitle(mode, "moveCabinet");
					showCabinetPopup("moveCab", 320, 400);
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
					cabAddDiv.className   = "popup " + divInfo.cabDivClass;
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
			})();
		</script>
	</body>
</html>

