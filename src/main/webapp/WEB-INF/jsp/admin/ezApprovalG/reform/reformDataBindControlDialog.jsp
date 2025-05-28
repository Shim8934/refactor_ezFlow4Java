<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='reform.databind.title' /></title>
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
	border: 0;
}

.tbl_type {
	width: 100%;
	border-bottom: 1px solid #dddee2;
	font-family: '돋움', dotum;
	font-size: 12px;
	table-layout: fixed;
}

#prop_id:invalid::placeholder {
	color: #666;
}

#prop_sql {
	font-family: Courier New, Helvetica, sans-serif;
	font-size: 14px;
	min-height: 105px;
	border: 1px solid #999;
	color: #333;
	resize: none;
}

input, textarea {
	ime-mode: inactive;
}

textarea {
	height: 192px;
}
</style>
<script type="text/javascript">
	var args = window.opener.argsForDialog;
	var command = args.command;
	var webEditorDocument = args.webEditorDocument;
	var dataSourceList = args.dataSourceList;
	var dataBindID = args.dataBindID;
	var dataBindControlInfo = args.dataBindControlInfo;
	var completionHandlerForDialog = args.completionHandlerForDialog;
	var returnValue = null;
	
	function onLoadHandler() {
		var controlElement = document.getElementById("prop_data_source");
		for (var i = 0; i < dataSourceList.length; i++) {
			var option = document.createElement("option");
			option.value = dataSourceList[i];
			option.text = dataSourceList[i];
			controlElement.add(option);
		}
		
		if (command == "modify") {
			var controlElement = document.getElementById("prop_id");
			controlElement.value = dataBindID;
			
			controlElement = document.getElementById("prop_data_source");
			var isFound = false;
			for (var i = 0; i < controlElement.options.length; i++) {
				if (controlElement.options[i].value == dataBindControlInfo.dataSource) {
					controlElement.selectedIndex = i;
					isFound = true;
					break;
				}
			}
			if (!isFound) {
				alert("<spring:message code='reform.databind.warning.notfound' />");
			}
			
			controlElement = document.getElementById("prop_sql");
			controlElement.value = dataBindControlInfo.sql;
		}
	}

	function btnOK_onclick() {
		var result = [];
		var controlElement = document.getElementById("prop_id");
		var dataBindControlID = controlElement.value.trim();
		if (dataBindControlID == "") {
			dataBindControlID = dataBindID;
			
			if (dataBindControlID === undefined) {
				alert("<spring:message code='reform.databind.invalid.id' />");
				controlElement.focus();
				return;
			}
		} else if (dataBindID != dataBindControlID) {
			var existingElement = webEditorDocument.getElementById(dataBindControlID);
			if (existingElement != null) {
				alert("<spring:message code='reform.invalid.id.duplicated' />");
				controlElement.focus();
				return;
			}
		}
		
		result[0] = dataBindControlID;
		controlElement = document.getElementById("prop_data_source");
		result[1] = controlElement.value;
		controlElement = document.getElementById("prop_sql");
		result[2] = controlElement.value;
		
		returnValue = JSON.stringify(result);
		
		window.close();
	}

	window.onunload = function() {
		completionHandlerForDialog(returnValue);
	};
</script>
</head>
<body class="popup" style="overflow: hidden" onload="onLoadHandler()">
	<h1 style="margin-bottom: 0px">
		<spring:message code='reform.databind.title' />
	</h1>
	<div id="close">
		<ul>
			<li>
				<span onclick="window.close()"></span>
			</li>
		</ul>
	</div>
	<table width="100%" cellspacing="0" border="1" class="tbl_type2">
		<colgroup>
			<col width="100">
			<col>
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code='reform.databind.id' />
				</th>
				<td>
					<input id="prop_id" type="text" />
				</td>
			</tr>
			<tr>
				<th><spring:message code='reform.databind.source' /></th>
				<td>
					<select id="prop_data_source" style="width: 100%;"></select>
				</td>
			</tr>
			<tr>
				<th><spring:message code='reform.databind.sql' /></th>
				<td>
					<textarea id="prop_sql"></textarea>
				</td>
			</tr>
		</tbody>
	</table>
	<div class="btnposition btnpositionNew">
		<a class="imgbtn">
			<span onclick="btnOK_onclick()"><spring:message code='reform.public.confirm' /></span>
		</a>
	</div>
</body>
</html>
