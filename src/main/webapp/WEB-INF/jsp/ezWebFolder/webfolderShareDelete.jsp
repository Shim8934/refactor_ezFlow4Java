<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var type = "<c:out value='${type}'/>";
			var files = "<c:out value='${fileList}'/>".split(",");
			var folders = "<c:out value='${folderList}'/>".split(",");
			
			window.onload = function () {
				var popupMsg = messages.strLang32;
				
				if (type == "EDIT") {
					popupMsg = messages.strLang31 + popupMsg;
				}
				
				document.getElementById("popupMsg").innerHTML = popupMsg;
			}
			
			function wClose() {
				parent.closeAllPopup();
				window.close();
			}
			
			function ok_Click() {
				if (type == "EDIT") {
					parent.shareContext.deleteShare2();
				} else {
					parent.shareContext.deleteShare();
				}
			}
		</script>
	</head>
	<body class="popup" style="overflow: hidden;"> 
		<h1 id ="topMenu" style="margin:0px;margin-top:2px"><spring:message code='ezWebFolder.t218'/></h1>
		<div id="close">
	        <ul>
	            <li><span id="btnCancel" onclick="wClose();"></span></li>
	        </ul>
	    </div>
		<div id="popupMsg" style="margin: 0px 0px 12px;height:110px;border:1px solid #ddd;padding:15px;font-size:12px;">
		</div>
		<div class="btnpositionNew">
			<a id="btnSave" class="imgbtn" onclick="ok_Click();"><span><spring:message code='ezWebFolder.t116'/></span></a>
		</div>
	</body>
</html>