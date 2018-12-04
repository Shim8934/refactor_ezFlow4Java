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
		parent.duplicatedExecutor.onClosePopup(result);
		
		parent.closeAllPopup();
		window.close();
	}

	// 		function afterDeleteSuccess() {
	// 			parent.refreshView();
	// 			wClose();
	// 		}
	
	// 		function isValid(str){
	// 			var regex = /[*:"\\|<>\/?]/g;
	// 			return regex.test(str);
	// 		}
	
	// 		function ok_Click() {
	// 			var newName = document.getElementById("nameInput").value;
	
	// 			if (newName == "") {
	// 				alert('<spring:message code='ezWebFolder.t400'/>');
	// 				return;
	// 			}
	
	// 			if (isValid(newName)) {
	// 				alert('<spring:message code='ezWebFolder.t211'/>');
	// 				return;
	// 			}
	
	// 			$.ajax({
	// 				type: "POST",
	// 				url: "/ezWebFolder/renameFile.do",
	// 				data: {
	// 					"fileId"  : fileId,
	// 					"newName" : newName
	// 				},
	// 				dataType: "JSON",
	// 				async: true,
	// 				success : function(data) {
	// 					var code = data.code;
	
	// 					switch(code) {
	// 						case 0: 
	// 							afterDeleteSuccess();
	// 							break;
	// 						case 1:
	// 							alert("<spring:message code='ezWebFolder.t306'/>");
	// 							break;
	// 						case 2:
	// 							alert("<spring:message code='ezWebFolder.t305'/>");
	// 							break;
	// 						case 3:
	// 							alert("<spring:message code='ezWebFolder.t300' />");
	// 							break;
	// 					}
	// 				},
	// 				error : function(jqXHR, textStatus, errorThrown) {
	// 					alert("<spring:message code='ezWebFolder.t134'/>" + jqXHR.status + ", " + textStatus);
	// 				}
	// 			});
	// 		}
	function onClickOverwrite() {
		onClickClose({
			code: "OVERWRITE",
			looping: document.getElementById("all-apply").checked
		});
	}

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
	<h1 id="topMenu" style="margin: 2px;"><spring:message code='ezWebFolder.t500' /></h1>
	<div id="close">
		<ul>
			<li><span id="btnCancel" onclick="onClickClose('SKIP')"></span></li>
		</ul>
	</div>
	<table class="content" style="border-top: none; width: 100%;">
		<tr>
			<td style="padding: 15px 0px;">
				<div style="text-align: center;"><spring:message code='ezWebFolder.t501' /></div>
				<table class="content-inner" style="width: 100%; margin: 10px 0px;">
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
				</div>
			</td>
		</tr>
	</table>
	<div class="btnpositionNew">
		<a class="imgbtn" onclick="onClickOverwrite();"> <span><spring:message code='ezWebFolder.t506' /></span></a> <a class="imgbtn" onclick="onClickSkip();"> <span><spring:message code='ezWebFolder.t507' /></span></a> <a class="imgbtn" onclick="onClickRename();"> <span><spring:message code='ezWebFolder.t508' /></span></a>
	</div>
</body>
</html>