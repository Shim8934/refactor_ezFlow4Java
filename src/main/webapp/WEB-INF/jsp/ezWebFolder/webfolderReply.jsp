<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
<script type="text/javascript">
	var parentId = "<c:out value='${fileId}'/>";
	var files = [];

	function okClick() {
		if (files.length == 0) {
			alert("<spring:message code='webfolder.reply.nofile' />");
			return;
		}

		parent.uploadReply(parentId, [files[0]]);
	}

	window.onload = function() {
		if (!parent.inputNameDlg_cross_dialogArguments) {
			folderUppId = "";
			functionType = "";

		} else {
			folderUppId = parent.inputNameDlg_cross_dialogArguments[0];
			functionType = parent.inputNameDlg_cross_dialogArguments[3];
		}

		if (functionType == "insert" && fileId == 0) {
			$('#topMenu').text("<spring:message code='ezWebFolder.t302'/>");
			$('#fileNamediv').text('<spring:message code='ezWebFolder.t514'/>');
		} else if (functionType == "update" && fileId == 0) {
			$('#topMenu').text("<spring:message code='ezWebFolder.t303'/>");
			$('#fileNamediv').text('<spring:message code='ezWebFolder.t514'/>');
		}

		var content = document.getElementById("content");
		content.addEventListener("dragover", onDragOver);
		content.addEventListener("dragenter", function(e) {
			this.style.border = "2px dashed skyblue";
			onDragEnter(e);
		});
		content.addEventListener("dragleave", function(e) {
			this.style.border = "";
		});
		// content.ondragover = function(e) { onDragOver(e) };
		content.addEventListener("drop", function onDrop(evt) {
			this.style.border = "";
			var file = [];
			document.getElementById("replyFile").onDrop
			if (evt != undefined) {
				evt.stopPropagation();
				evt.preventDefault();

				if (evt.dataTransfer.items == undefined || evt.dataTransfer.items == null) {
					if (evt.dataTransfer.files.length == 0) {
						alert(messages.strLangDragNDrop);
						return;
					}

					var filelist = (evt == undefined) ? document.getElementById("file").files : evt.dataTransfer.files;

					if (filelist.length == 0) {
						return;
					}

					files = filelist;
				} else {
					var length = evt.dataTransfer.items.length;

					for (var i = 0; i < length; i++) {
						var entry = evt.dataTransfer.items[i].webkitGetAsEntry();

						if (entry.isFile) {
							var filelist = (evt == undefined) ? document.getElementById("replyFile").files : evt.dataTransfer.files;

							if (filelist.length == 0) {
								return;
							}

							files = filelist;
						} else if (entry.isDirectory) {
							alert(messages.strLangDragNDrop);
							return;
						}
					}
				}
			} else {
				var filelist = (evt == undefined) ? document.getElementById("replyFile").files : evt.dataTransfer.files;

				if (filelist.length == 0) {
					return;
				}

				files = filelist;
			}

			refreshDescription()
		});
		
		content.addEventListener("click", function() {
			document.getElementById("replyFile").click();
		});
		
		document.getElementById("replyFile").addEventListener("change", function() {
			files = document.getElementById("replyFile").files;
			refreshDescription();
		});
	}

	function refreshDescription() {
		document.getElementById("description").innerHTML =
			files.length === 0
				? "<spring:message code='webfolder.reply.description' />"
				: files[0].name;
	}
	
	function wClose() {
		parent.closeAllPopup();
		window.close();
	}
</script>
<style>
#content {width:100%;height:100px;display:table;border:2px dashed darkgray;
vertical-align:middle;text-align:center;background: #f8f8f8;box-sizing:border-box;}
#content:hover {border:2px dashed skyblue;}
#description {display:table-cell;vertical-align:middle;color:dimgray;font-size:13px;}
#content input[type='file'] {display:none;}
</style>
</head>
<body class="popup" style="overflow: hidden;">
	<h1 id="topMenu">
		<spring:message code='webfolder.reply.title' />
	</h1>
	<div id="close">
		<ul>
			<li><span id="btnCancel" onclick="wClose()"></span></li>
		</ul>
	</div>
	<div id="content">
		<p id="description"><spring:message code='webfolder.reply.description' /></p>
		<input id="replyFile" type="file">
	</div>
	<div class="btnpositionNew">
		<a id="btnSave" class="imgbtn" onclick="okClick();">
			<span><spring:message code='ezWebFolder.t116' /></span>
		</a>
	</div>
</body>
</html>