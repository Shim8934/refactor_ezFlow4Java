<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" href="${util.addVer('/css/reform/useProcessor.css')}">
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
<c:if test="${!empty reformFunctionUrl}">
	<script type="text/javascript" src="/${util.addVer(reformFunctionUrl)}"></script>
</c:if>
<script type="text/javascript">
	window.onload = function() {
		document.body.innerHTML = window.parent.bodyInnerHtml;
		parent.BodyTagsEnabled(document.body);
		
		reformUseProc.onLoadHandler();
	}

	function editComplete() {
		reformUseProc.onUnloadHandler();
	}
</script>
</head>
<body></body>
</html>