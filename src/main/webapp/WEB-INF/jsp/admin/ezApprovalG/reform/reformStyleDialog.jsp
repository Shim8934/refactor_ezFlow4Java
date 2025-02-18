<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='reform.style.title' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/reform/designProcessor.css')}" type="text/css">
<style type="text/css">
#prop_style {
	width: 100%;
	height: 150px;
	box-sizing: border-box;
	resize: none;
}
</style>
<script type="text/javascript">
	var args = window.opener.argsForDialog;
	var controlElement = args.controlElement;
	var isIE11Mode = args.isIE11Mode;
	var completionHandlerForDialog = args.completionHandlerForDialog;
	var kSelectionOutlineSytle = "#00FF00 dotted medium";
	
	function onLoadHandler() {
		var propElement = document.getElementById("prop_style");
		var attValue = controlElement.getAttribute("style");
		attValue = attValue != null ? attValue : "";
		attValue = removeOutlineStyle(attValue);
		attValue = attValue != null ? attValue : "";
		propElement.value = attValue;
	}

	function removeOutlineStyle(styleValue) {
		if (isIE11Mode) {
			var styleList = styleValue.split(";");
			for (var i = 0; i < styleList.length; i++) {
				if (styleList[i].trim().substr(0, 7) == "outline") {
					styleList.splice(i, 1);
					break;
				}
			}
			
			return styleList.join(";").trim();
		} else {
			return styleValue;
		}
	}

	function applyStyle() {
		var propElement = document.getElementById("prop_style");
		if (isIE11Mode) {
			var styleValue = propElement.value + " outline: " + kSelectionOutlineSytle + ";";
			controlElement.setAttribute("style", styleValue);
		} else {
			var styleValue = propElement.value;
			controlElement.setAttribute("style", styleValue);
		}
		
		if (controlElement.tagName == "TD" || controlElement.tagName == "TH") {
			var gridElement = controlElement.parentNode.parentNode.parentNode;
			for (var i = 0; i < gridElement.rows.length; i++) {
				var row = gridElement.rows[i];
				var cell = row.cells[controlElement.cellIndex];
				cell.style.width = controlElement.style.width;
			}
			
			var row = controlElement.parentNode;
			for (var i = 0; i < row.cells.length; i++) {
				var cell = row.cells[i];
				cell.style.height = controlElement.style.height;
			}
		}
	}

	function btnOK_onclick() {
		applyStyle();
		
		window.close();
	}

	function btnApply_onclick() {
		applyStyle();
	}

	function btncancel_onclick() {
		window.close();
	}

	window.onunload = function() {
		completionHandlerForDialog();
	};
</script>
</head>
<body class="popup" style="overflow: hidden" onload="onLoadHandler()">
	<h1 style="margin-bottom: 0px">
		<spring:message code='reform.style.title' />
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
			<td><textarea id="prop_style" class="textarea"></textarea></td>
		</tr>
	</table>
	<div class="btnposition btnpositionNew">
		<a class="imgbtn">
			<span onclick="btnOK_onclick()"><spring:message code='reform.public.confirm' /></span>
		</a>
		<a class="imgbtn">
			<span onclick="btnApply_onclick()"><spring:message code='reform.public.apply' /></span>
		</a>
	</div>
</body>
</html>