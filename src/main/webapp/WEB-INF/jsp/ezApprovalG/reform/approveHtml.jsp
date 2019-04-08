<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" href="${util.addVer('/css/reform/useProcessor.css')}">
<jsp:include page="lang/lang.jsp"></jsp:include>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/reform/reformUseProcessor.js')}"></script>
<!-- data picker-->
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
<!-- time picker-->
<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
<script type="text/javascript">
	var reformEditorContent = "";
	
	window.onload = function() {
		document.body.innerHTML = window.parent.bodyInnerHtml;
		parent.BodyTagsEnabled(document.body);
		
		var reformEditorWrapper = document.getElementById("reform-editor");
		
		if (reformEditorWrapper) {
			var editorHeight = reformEditorWrapper.scrollHeight;
			
			reformEditorContent = reformEditorWrapper.innerHTML;
			reformEditorWrapper.innerHTML = "<iframe id='iframe_content_reform' name='iframe_content_reform' class='viewbox' style='width:100%;margin:0px;padding:0px; height:" + editorHeight + "px;' scrolling='no' src='/ezEditor/selectEditor.do?height=" + editorHeight
					+ "&id=reformeditor' frameborder='0'></iframe>";
		}
		
		reformUseProc.onLoadHandler();
	}

	function editComplete() {
		// reform inner editor
		if (window.iframe_content_reform) {
			// set editor content to innerHTML
			document.getElementById("reform-editor").innerHTML = iframe_content_reform.GetEditorContent();
		}
		
		reformUseProc.onUnloadHandler();
	}

	// inner editor callback
	function Editor_Complete() {
		iframe_content_reform.SetEditorContent(reformEditorContent);
	}
</script>
<c:if test="${!empty reformFunctionUrl}">
	<script type="text/javascript" src="${util.addVer(reformFunctionUrl)}"></script>
</c:if>
</head>
<body></body>
</html>