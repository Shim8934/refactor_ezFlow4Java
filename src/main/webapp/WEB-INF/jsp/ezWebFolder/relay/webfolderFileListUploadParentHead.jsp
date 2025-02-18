<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
<%--<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>--%>
<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>

<!-- webfolderFileUpload -->
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/duplicate-file.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/webfolderFilePick.js')}"></script>

<script type="text/javascript">
	// fileFolderDrop.js 에서 사용하는 변수들.
	var uploadIng = false;
	var uploadIngStatusMessage = "<spring:message code='uploadIngStatusMessage'/>";
	var resultErr1 = "<spring:message code='ezWebFolder.t306'/>";
	var resultErr2 = "<spring:message code='ezWebFolder.t305'/>";
	var resultErr3 = "<spring:message code='ezWebFolder.t300'/>";
	var resultErr4 = "<spring:message code='ezWebFolder.t249'/>";
	var resultErr5 = "<spring:message code='ezWebFolder.t250'/>";
	var resultErr6 = "<spring:message code='ezWebFolder.kes014'/>";
	var strSuccess = "<spring:message code='ezWebFolder.t27' />";
	var strErr	   = messages.strLang4;
</script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/webfolderFileUploadParent.js')}"></script>