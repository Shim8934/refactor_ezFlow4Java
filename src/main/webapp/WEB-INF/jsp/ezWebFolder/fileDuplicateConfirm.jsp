<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">
<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
<script type="text/javascript">
	function onClickClose(result) {
		parent.duplicateFile.onClosePopup(result);
		
		parent.closeAllPopup();
		window.close();
	}

	<c:if test="${isOwner}">
	function onClickOverwrite() {
		onClickClose({
			code: "OVERWRITE",
			looping: document.getElementById("all-apply").checked
		});
	}
	</c:if>

	function onClickSkip() {
		onClickClose({
			code: "SKIP",
			looping: document.getElementById("all-apply").checked
		});
	}

	function onClickRename() {
		parent.DivPopUpShow(450, 250, "/ezWebFolder/fileRenameConfirm.do?isUploading");
	}
</script>
<style>
table.content-inner td {
	width: inherit;
}

table.content-inner td>h2 {
	text-align: center;
}
</style>
</head>
<body class="popup" style="overflow: hidden;">
	<h1 id="topMenu" style="margin: 2px;">
		<c:choose>
			<c:when test="${isFolder}">
				<spring:message code='ezWebFolder.t510' />
			</c:when>
			<c:otherwise>
				<spring:message code='ezWebFolder.t500' />
			</c:otherwise>
		</c:choose>
	</h1>
	<div id="close">
		<ul>
			<li><span id="btnCancel" onclick="onClickClose('SKIP')"></span></li>
		</ul>
	</div>
	<table class="content" style="border-top: none; width: 100%;">
		<tr>
			<td style="padding: 15px 0;">
				<c:choose>
					<c:when test="${isFolder}">
						<div style="text-align: center;"><spring:message code='ezWebFolder.t501' /></div>
						<table class="content-inner" style="width: 100%; margin: 10px 0;">
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 60%;">
								<col style="width: 20%;">
							</colgroup>
							<tr>
								<td><h2><spring:message code='ezWebFolder.t511' /></h2></td>
								<td colspan="2">${folderName}</td>
							</tr>
						</table>
					</c:when>
					<c:otherwise>
						<div style="text-align: center;"><spring:message code='ezWebFolder.t501' /></div>
						<table class="content-inner" style="width: 100%; margin: 10px 0;">
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 60%;">
								<col style="width: 20%;">
							</colgroup>
							<tr>
								<td><h2><spring:message code='ezWebFolder.t503' /></h2></td>
								<td colspan="2">${fileName}</td>
							</tr>
		
							<tr>
								<td><h2><spring:message code='ezWebFolder.t504' /></h2></td>
								<td id="current-date">${newDate}</td>
								<td style="text-align: center;">${newSize}</td>
							</tr>
							<tr>
								<td><h2><spring:message code='ezWebFolder.t505' /></h2></td>
								<td>${oldDate}</td>
								<td style="text-align: center;">${oldSize}</td>
							</tr>
						</table>
						<div style="text-align: center;">
							<input id="all-apply" type="checkbox" style="vertical-align: middle;"> <label for="all-apply" style="vertical-align: middle;"><spring:message code='ezWebFolder.t502' /></label>
							<c:if test="${not isOwner}"><p style="margin: 10px 0 0 0; color: red;"><spring:message code='ezWebFolder.t509' /></p></c:if>
						</div>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</table>
	<div class="btnpositionNew">
		<c:if test="${isOwner}"><a class="imgbtn" onclick="onClickOverwrite();"><span><spring:message code='ezWebFolder.t506' /></span></a></c:if>
		<a class="imgbtn" onclick="onClickSkip();"><span><spring:message code='ezWebFolder.t507' /></span></a>
		<c:if test="${not isFolder}"><a class="imgbtn" onclick="onClickRename();"><span><spring:message code='ezWebFolder.t508' /></span></a></c:if>
	</div>
</body>
</html>