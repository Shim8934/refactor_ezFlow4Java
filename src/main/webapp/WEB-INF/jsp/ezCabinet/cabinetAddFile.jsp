<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabAddMain">
		<h1><spring:message code="ezCabinet.t67"/></h1>
		
		<div id="cabAddClose" class="cabClose"><ul><li><span><spring:message code='ezCabinet.t66'/></span></li></ul></div>
		
		<div class="divInfo">
			<table class="tblFileInf">
				<tr><th><spring:message code='ezCabinet.t51'/></th><td><input maxlength="250" type="text" placeholder="<spring:message code='ezCabinet.t70'/>"></td></tr>
				<tr><th><spring:message code='ezCabinet.t52'/></th><td><input maxlength="250" type="text" placeholder="<spring:message code='ezCabinet.t71'/>"></td></tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td><div class="rlFileDiv"><input type="text"><a><span id="rlBttn"><spring:message code='ezCabinet.t93'/></span></a></div></td>
				</tr>
			</table>
		</div>
		
		<div class="fileUploadDiv" id="fileDiv">
			<div class="fileList off">
				<ul class="ulFiles"></ul>
			</div>
			<div class="divInform">
				<span><spring:message code='ezCabinet.t68'/></span>
				<span><spring:message code='ezCabinet.t69'/></span>
			</div>
		</div>
		
		<div class="cabBttnDiv" id="cabAddBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
		
		<input type="file" id="fileBttn" multiple="multiple" style="display: none;">
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetFile.js"   ></script>
		<script type="text/javascript">
			(function() {
				var rlWindow = null;
				initEvents();
				
				function initEvents() {
					document.onselectstart  = function () { return false;};
					var closeBttn           = document.getElementById("cabAddClose").firstElementChild.firstElementChild.firstElementChild;
					closeBttn.onclick       = function(e) {closeWindow();};
					var cabdivBttnElmt      = document.getElementById("cabAddBttn");
					var listBttns           = cabdivBttnElmt.children;
					listBttns[0].onclick    = function(e) {};
					listBttns[1].onclick    = function(e) {closeWindow();};
					
					var fileUploadBttn      = document.getElementById("fileBttn");
					fileUploadBttn.onchange = function(e) {CabinetFile.upload();};
					
					var fileDivElmt         = document.getElementById("fileDiv");
					fileDivElmt.onclick     = function(e) {startUpload();};
					
					var relatedBttn         = document.getElementById("rlBttn");
					relatedBttn.onclick     = function(e) {getRelatedFile();};
				}
				
				function getRelatedFile() {
					if (rlWindow) {rlWindow.close();}
					
					rlWindow = window.open("/ezCabinet/getRelatedFile.do", "relatedWd", getOpenWindowfeature(800, 600));
				}
				
				function startUpload() {document.getElementById("fileBttn").click();}
				function closeWindow() {window.close();}
				
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
			})();
		</script>
	</body>
</html>