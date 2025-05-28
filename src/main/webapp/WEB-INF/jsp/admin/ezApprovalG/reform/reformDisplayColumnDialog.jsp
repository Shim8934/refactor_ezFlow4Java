<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='reform.displaycolumn.title' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/reform/designProcessor.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<style type="text/css">
.tbl_type {
	border: 0
}

.tbl_type {
	width: 100%;
	border-bottom: 1px solid #dddee2;
	font-family: '돋움', dotum;
	font-size: 12px;
	table-layout: fixed
}

#prop_column {
	width: 100%;
	font-family: Courier New, Helvetica, sans-serif;
	font-size: 14px;
	border: 1px solid #999;
	color: #333;
	box-sizing: border-box;
	resize: none;
	font-family: Courier New, Helvetica, sans-serif;
}

input, textarea {
	ime-mode: inactive;
}

textarea {
	height: 116px;
}
</style>
<script type="text/javascript">
	var args = window.opener.argsForDialog;
	var currentValue = args.currentValue;
	var completionHandlerForDialog = args.completionHandlerForDialog;
	var returnValue = null;
	
	function onLoadHandler() {
		var controlElement = document.getElementById("prop_column");
		
		controlElement.value = currentValue;
	}

	function btnOK_onclick() {
		var controlElement = document.getElementById("prop_column");
		
		returnValue = controlElement.value;
		
		window.close();
	}

	window.onunload = function() {
		completionHandlerForDialog(returnValue);
	};
</script>
</head>
<body class="popup" style="overflow: hidden" onload="onLoadHandler()">
	<h1 style="margin-bottom: 0px">
		<spring:message code='reform.displaycolumn.title' />
	</h1>
	<div id="close">
		<ul>
			<li>
				<span onclick="window.close()"></span>
			</li>
		</ul>
	</div>
	<table style="width: 100%; margin-top: 5px">
		<tr>
			<td><textarea id="prop_column" class="textarea"></textarea></td>
		</tr>
	</table>
	<div class="btnposition btnpositionNew">
		<a class="imgbtn">
			<span onclick="btnOK_onclick()"><spring:message code='reform.public.confirm' /></span>
		</a>
	</div>
</body>
</html>