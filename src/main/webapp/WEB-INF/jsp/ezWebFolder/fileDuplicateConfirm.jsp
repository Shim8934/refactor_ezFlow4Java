<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
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
	
	function onClickCancel() {
		onClickClose({
			code: "SKIP",
			looping: false
		});
	}
	
	function checkedLooping() {
		var checkbox = document.getElementById("all-apply");
		
		if (checkbox) {
			return checkbox.checked;
		}
		
		return false;
	}
	
	<c:if test="${isAccessible && isAllFiles && not isReply}">
	function onClickOverwrite() {
		onClickClose({
			code: "OVERWRITE",
			looping: checkedLooping()
		});
	}
	</c:if>

	function onClickSkip() {
		onClickClose({
			code: "SKIP",
			looping: checkedLooping()
		});
	}
	
	<c:if test="${not isFolder}">
	function onClickRename() {
		var currentName = "${fileName}";

		try {
			var nameTd = parent.document.querySelector(".wfFileName[title='<c:out value='${fileName}' />']");
			
			if (!nameTd) {
				var lastDot = currentName.lastIndexOf(".");
				lastDot = lastDot < 0 ? currentName.length : currentName.lastIndexOf(".");
				currentName = currentName.substr(0, lastDot);
			} else {
				var fileExt;
	
				if (parent.location.href.indexOf("trashCan.do") > 0) {
					fileExt = nameTd.parentElement.getAttribute("ext");
				} else {
					fileExt = nameTd.getAttribute("ext");
				}
	
				if (fileExt && fileExt != ".none") {
					currentName = currentName.substr(0, currentName.length - fileExt.length - 1);
				}
			} // if end
		} catch (ignore) {}

		parent.inputNameDlg_cross_dialogArguments = { currentName: currentName }
		document.body.style.opacity = 0;
		parent.DivPopUpShow(450, 200, "/ezWebFolder/fileRenameConfirm.do?isUploading");
	}
	</c:if>
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
				<spring:message code='webfolder.duplicate.folder.title' />
			</c:when>
			<c:otherwise>
				<spring:message code='webfolder.duplicate.file.title' />
			</c:otherwise>
		</c:choose>
	</h1>
	<div id="close">
		<ul>
			<li><span id="btnCancel" onclick="onClickCancel()"></span></li>
		</ul>
	</div>
	<table class="content" style="border-top: none; width: 100%;">
		<tr>
			<td style="padding: 15px 0;">
				<c:choose>
					<c:when test="${isFolder}">
						<div style="text-align: center;"><spring:message code='webfolder.duplicate.content' /></div>
						<table class="content-inner" style="width: 100%; margin: 10px 0;">
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 60%;">
								<col style="width: 20%;">
							</colgroup>
							<tr>
								<td><h2><spring:message code='webfolder.duplicate.table.name' /></h2></td>
								<td colspan="2">${fileName}</td>
							</tr>
						</table>
					</c:when>
					<c:otherwise>
						<div style="text-align: center;"><spring:message code='webfolder.duplicate.content' /><br><spring:message code='webfolder.duplicate.file.content' /></div>
						<table class="content-inner" style="width: 100%; margin: 10px 0;">
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 60%;">
								<col style="width: 20%;">
							</colgroup>
							<tr>
								<td><h2><spring:message code='webfolder.duplicate.table.name' /></h2></td>
								<td colspan="2">${fileName}</td>
							</tr>
							<tr>
								<td><h2><spring:message code='webfolder.duplicate.table.new' /></h2></td>
								<td id="current-date">${newDate}</td>
								<td style="text-align: center;">${newSize}</td>
							</tr>
							<tr>
								<td><h2><spring:message code='webfolder.duplicate.table.old' /></h2></td>
								<td>${oldDate}</td>
								<td style="text-align: center;">${oldSize}</td>
							</tr>
						</table>
						<div style="text-align: center;">
							<c:if test="${not isFolder && not isOne}"><input id="all-apply" type="checkbox" style="vertical-align: middle;"> <label for="all-apply" style="vertical-align: middle;"><spring:message code='webfolder.duplicate.looping' /></label></c:if>
							<c:if test="${not isAccessible && isAllFiles}"><p style="margin: 10px 0 0 0; color: red;"><spring:message code='webfolder.duplicate.permission' /></p></c:if>
						</div>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</table>
	<div class="btnpositionNew">
		<c:if test="${isAccessible && isAllFiles && not isReply}"><a class="imgbtn" onclick="onClickOverwrite();"><span><spring:message code='webfolder.duplicate.button.overwrite' /></span></a></c:if>
		<a class="imgbtn" onclick="onClickSkip();"><span><c:choose><c:when test="${isFolder}"><spring:message code="ezWebFolder.t116" /></c:when><c:otherwise><spring:message code="webfolder.duplicate.button.skip" /></c:otherwise></c:choose></span></a>
		<c:if test="${not isFolder}"><a class="imgbtn" onclick="onClickRename();"><span><spring:message code='webfolder.duplicate.button.rename' /></span></a></c:if>
	</div>
</body>
</html>