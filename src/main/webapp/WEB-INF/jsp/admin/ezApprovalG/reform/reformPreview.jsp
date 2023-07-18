<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='reform.preview.title' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/js/ezEditor/kukudocsEditor/stylesheets/editor_style.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<style type="text/css">
	body {all: unset;}
</style>
<script language="javascript" type="text/javascript">
	var args = window.opener.argsForDialog;
	var mainHtml = args.mainHtml;
	var bodyHtml = args.bodyHtml;
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
<body>
	<div id="div_Content" style="margin: 23px 0px 0px 0px; padding: 0px; width: 100%; height: 100%;"></div>
</body>
</html>
