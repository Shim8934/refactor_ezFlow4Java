<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t1252' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script language="javascript" type="text/javascript">
	var args = window.opener.argsForDialog;
	var mainHtml = args.mainHtml;
	var completionHandlerForDialog = args.completionHandlerForDialog;
	var pDraftFlag = "DRAFT";
	
	window.onload = function() {
		try {
			if (document.body.scroll === "") {
				document.body.scroll = "yes";
			}
			
			var divContent = document.getElementById('div_Content');
			divContent.innerHTML = mainHtml;
			
			var iframeHTML = "<iframe id='iframe_content' name='iframe_content' style='width:100%;margin:0px;padding:0px;height:100%;overflow:auto;' src='reformPreviewContent.do' frameborder='0'></iframe>";
			var mainBody = document.getElementById('body');
			if (mainBody != null) {
				mainBody.innerHTML = iframeHTML;
			} else {
				divContent.innerHTML = iframeHTML;
			}
		} catch (e) {}
	};
	
	window.onunload = function() {
		completionHandlerForDialog();
	};
	
	function btnClose_onclick() {
		window.close();
	}
</script>
</head>
<body class="popup" style="overflow: auto;">
	<table class="layout" style="margin: 0px; padding: 0px;">
		<tr>
			<td style="height: 20px;">
				<div id="menu">
					<ul>
					</ul>
				</div>
				<div id="close">
					<ul>
						<li>
							<span id="btnClose" onclick="return btnClose_onclick()"></span>
						</li>
					</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: top; height: 100%; text-align: center;">
				<div id="div_Content" style="margin: 23px 0px 0px 0px; padding: 0px; width: 100%; height: 100%;"></div>
			</td>
		</tr>
	</table>
	<script type="text/javascript">
		selToggleList(document.getElementById("menu"), "ul", "li", "0");
	</script>
</body>
</html>
