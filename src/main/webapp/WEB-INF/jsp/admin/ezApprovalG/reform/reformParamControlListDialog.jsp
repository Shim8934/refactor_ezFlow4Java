<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='reform.params.title' /></title>
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

input, textarea {
	ime-mode: inactive;
}
</style>
<script type="text/javascript">
	var args = window.opener.argsForDialog;
	var currentControlElement = args.currentControlElement;
	var controlList = args.controlList;
	var passedParamControlList = args.paramControlList;
	var completionHandlerForDialog = args.completionHandlerForDialog;
	var returnValue = null;
	var paramControlList = [];
	
	function onLoadHandler() {
		var controlElement = document.getElementById("prop_param_control_list");
		for (var i = 0; i < controlList.length; i++) {
			if (controlList[i] != currentControlElement.id) {
				var option = document.createElement("option");
				option.value = controlList[i];
				option.text = controlList[i];
				/*
				if (passedParamControlList.indexOf(controlList[i]) >= 0) {
				    option.selected = true;
				}
				 */
				controlElement.add(option);
			}
		}
	}

	function onChangeHandler(element) {
		for (var i = 0; i < element.options.length; i++) {
			var value = element.options[i].value;
			if (element.options[i].selected == true) {
				if (paramControlList.indexOf(value) == -1) {
					paramControlList.push(value);
				}
			} else {
				var pos = paramControlList.indexOf(value);
				if (pos != -1) {
					paramControlList.splice(pos, 1);
				}
			}
		}
	}

	function btnOK_onclick() {
		var result = "";
		for (var i = 0; i < paramControlList.length; i++) {
			if (result != "") {
				result += ",";
			}
			result += paramControlList[i];
		}
		
		returnValue = result;
		
		window.close();
	}

	function btncancel_onclick() {
		window.close();
	}

	window.onunload = function() {
		completionHandlerForDialog(returnValue);
	};
</script>
</head>
<body class="popup" style="overflow: hidden" onload="onLoadHandler()">
	<h1 style="margin-bottom: 0px">
		<spring:message code='reform.params.title' />
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
			<td><p id="directive_message"><spring:message code='reform.params.directive' /></p> <select multiple id="prop_param_control_list" size="6" class="textarea" onchange="onChangeHandler(this)"></select></td>
		</tr>
	</table>
	<div class="btnposition btnpositionNew">
		<a class="imgbtn">
			<span onclick="btnOK_onclick()"><spring:message code='reform.public.confirm' /></span>
		</a>
	</div>
</body>
</html>