<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='reform.selection.title' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/reform/reformUseProcessor.js')}"></script>
<style>
#grid {
	border-collapse: collapse;
	width: 100%;
}

#grid td {
	padding: 8px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

#grid th {
	padding: 8px;
	border: none;
	background-color: #8b9199;
	color: white;
}

#grid tr:hover {
	background-color: #f5f5f5;
}
</style>
<script type="text/javascript">
	var args;
	var gridData;
	var headerData;
	
	function onLoadHandler() {
		if (window.showModalDialog) {
			args = window.dialogArguments;
		} else {
			args = window.opener.argsForSelectionDialog;
		}
		gridData = args.gridData;
		headerData = args.headerData;
		
		var gridTable = document.getElementById("grid");
		if (headerData != null && headerData.length > 0) {
			var row = gridTable.insertRow(-1);
			for (var i = 0; i < headerData.length; i++) {
				var headerCell = document.createElement("TH");
				headerCell.innerText = headerData[i];
				row.appendChild(headerCell);
			}
		}
		
		for (var i = 0; i < gridData.length; i++) {
			var rowData = gridData[i];
			var row = gridTable.insertRow(-1);
			row.onclick = function() {
				if (headerData != null && headerData.length > 0) {
					window.returnValue = this.rowIndex - 1;
				} else {
					window.returnValue = this.rowIndex;
				}
				
				if (!window.showModalDialog) {
					window.opener.completionHandlerForSelectionDialog(window.returnValue);
				}
				
				window.close();
			};
			for (var j = 0; j < headerData.length; j++) {
				var cellData = rowData[j];
				var cell = row.insertCell(j);
				cell.innerText = cellData;
			}
		}
	}
</script>
</head>
<body class="popup" style="overflow: hidden" onload="onLoadHandler()">
	<h1 style="margin-bottom: 0px">
		<spring:message code='reform.selection.title' />
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
			<td>
				<div style="width: 100%; height: 188px; overflow: auto">
					<table id="grid">
					</table>
				</div>
			</td>
		</tr>
	</table>
</body>
</html>