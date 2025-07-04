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
<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
<style>
.content { border: 1px solid lightgrey; width: 100%; text-align: center; table-layout: fixed; }
.content th { padding: 0; text-align: center; }
.content td { width:inherit; }
.container {
	height: 295px;
	overflow: scroll;
	-ms-overflow-style: none;  /* Internet Explorer 10+ */
	scrollbar-width: none;  /* Firefox */
}
.container::-webkit-scrollbar { 
	display: none;  /* Safari and Chrome */
}
</style>
<script type="text/javascript">
	var primary = "<c:out value='${primary}'/>";
	var fileId = "<c:out value='${fileId}'/>";

	window.onload = function() {
		document.getElementById("btn-cancel").addEventListener("click", closePopup);
		<c:choose>
			<c:when test="${isPermitted}">
				document.getElementById("btn-download").addEventListener("click", versionDownload);
				document.getElementById("btn-restore").addEventListener("click", versionRestore);
				document.getElementById("btn-delete").addEventListener("click", versionDelete);
				
				document.getElementById("all-selector").addEventListener("change", function(event) {
					Array.prototype.slice.call(document.querySelectorAll(".selector")).forEach(function(checkbox) {
						checkbox.checked = event.target.checked;
					});
				});
				
				<c:if test="${usePreview}">
					document.getElementById("btn-preview").addEventListener("click", versionPreview);
				</c:if>
			</c:when>
			<c:otherwise>
				document.getElementById("btn-ok").addEventListener("click", closePopup);
			</c:otherwise>
		</c:choose>
	}

	function closePopup() {
		parent.closeAllPopup();
		window.close();
	}

	<c:if test="${isPermitted}">
	function getSelectedVersions() {
		var versions = [];
		
		Array.prototype.slice.call(document.querySelectorAll(".selector")).forEach(function(checkbox) {
			if (checkbox.checked) {
				versions.push(checkbox.getAttribute("id"));
			}
		});
		
		return versions;
	}

	function checkNonSelected(versions) {
		if (versions.length == 0) {
			alert("<spring:message code='webfolder.version.choice' />");
			return true;
		}
		
		return false;
	}

	function checkNonSelectedOnce(versions) {
		if (checkNonSelected(versions)) {
			return true;
		}
		
		if (versions.length > 1) {
			alert("<spring:message code='webfolder.version.once' />");
			return true;
		}
		
		return false;
	}

	function fileVersionDim(dim) {
		if (typeof window.parent.showProgress != "function" || typeof window.parent.hideProgress != "function") { return; }

		var dimPanelDIV = document.getElementById("dimPanel");
		if (dim) {
			dimPanelDIV.style.display = "block";
			window.parent.showProgress();
		} else {
			window.parent.hideProgress();
			dimPanelDIV.style.display = "none";
		}
	}

	function versionDownload() {
		var versions = getSelectedVersions();
		
		if (checkNonSelectedOnce(versions)) {
			return;
		}

		downloadFrame.location.href = "/ezWebFolder/downloadVersion.do?fileId=" + fileId
				+ "&versions=" + encodeURIComponent(versions.toString());
	}

	function versionPreview() {
		var versions = getSelectedVersions();
		
		if (checkNonSelectedOnce(versions)) {
			return;
		}
		
		fileVersionDim(true);
		
		$.ajax({
			dataType: "JSON",
			url: "/ezWebFolder/filePreview.do",
			data: { "fileId" : fileId, "version" : versions[0] },
			success: function(previewData) {
				if (previewData.status == "ok") {
					if (previewData.code == 1) {
						alert(messages.unsupportedFormat);
						return;
					}

					window.open(previewData.data, "_blank");
				} else {
					alert(messages.strLang7);
				}
			},
			error: function(error) {
				alert(messages.strLang7 + error);
			},
			complete: function() {
				fileVersionDim(false);
				clearTimeout(sTimeOut);
			}
		});
	}

	function versionRestore() {
		var versions = getSelectedVersions();
		
		if (checkNonSelectedOnce(versions)) {
			return;
		}
		
		if (confirm("<spring:message code='webfolder.version.restore' />")) {
			$.ajax({
				type: "POST",
				async: true,
				url: "/ezWebFolder/restoreVersion.do",
				data: {
					fileId: fileId,
					version: versions[0]
				},
				success: function(data) {
					if (data.status == "ok") {
						location.reload();
						parent.refreshView();
					} else {
						alert("<spring:message code='webfolder.version.restore.error' />");
					}
				},
				error: function(data) {
					alert("<spring:message code='webfolder.version.restore.error' />");
				}
			});
		}
	}

	function versionDelete() {
		var versions = getSelectedVersions();
		
		if (checkNonSelected(versions)) {
			return;
		}
		
		if (confirm("<spring:message code='webfolder.version.delete' />")) {
			
			$.ajax({
				type: "POST",
				async: true,
				url: "/ezWebFolder/deleteVersions.do",
				data: {
					fileId: fileId,
					versions: versions.toString()
				},
				success: function(data) {
					if (data.status == "ok") {
						location.reload();
					} else {
						alert("<spring:message code='webfolder.version.delete.error' />");
					}
				},
				error: function(data) {
					alert("<spring:message code='webfolder.version.delete.error' />");
				}
			});
		}
	}
	</c:if>
</script>
</head>
<body class="popup" style="overflow: hidden;">
	<h1 id="topMenu">
		<spring:message code='webfolder.version.title' />
	</h1>
	<div id="close">
		<ul>
			<li><span id="btn-cancel"></span></li>
		</ul>
	</div>
	<div class="container">
		<table class="content">
			<colgroup>
				<c:if test="${isPermitted}">
					<col width="25" />
				</c:if>
				<col width="35" />
				<col width="150" />
				<col width="60" />
				<col width="70" />
			</colgroup>
			</div>
			<tbody>
				<tr>
					<c:if test="${isPermitted}">
						<th style="height: 30px;"><div class="custom_checkbox"><input id="all-selector" type="checkbox" /></div></th>
					</c:if>
					<th><spring:message code='webfolder.version.td.num' /></th>
					<th><spring:message code='webfolder.version.td.date' /></th>
					<th><spring:message code='ezWebFolder.t157' /></th>
					<th><spring:message code='webfolder.version.td.modifier' /></th>
				</tr>
				<c:forEach var="history" items="${histories}" varStatus="status">
					<tr>
						<c:if test="${isPermitted}">
							<td>
								<c:if test="${not status.first}">
									<div class="custom_checkbox"><input id="${history.version}" class="selector" type="checkbox" /></div>
								</c:if>
							</td>
						</c:if>
						<td>${history.version}.0</td>
						<td>${history.modifiedDate}</td>
						<td>${history.fileSize}</td>
						<td>
							<c:choose>
								<c:when test="${primary eq 1}">${history.modifiedAuthorName}</c:when>
								<c:otherwise>${history.modifiedAuthorName2}</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty histories}">
					<tr>
						<td colspan="${isPermitted ? '5' : '4'}">
							<spring:message code='webfolder.version.td.nodata' />
						</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
	<div class="btnpositionNew">
		<c:choose>
			<c:when test="${isPermitted}">
				<a id="btn-download" class="imgbtn"><span><%-- <c:choose>
					<c:when test="${subTypeC eq 'meeting' or isEncrypted}"><spring:message code='webfolder.version.button.watch' /></c:when>
					<c:otherwise> --%><spring:message code='webfolder.version.button.download' /><%-- </c:otherwise></c:choose> --%>
					</span></a>
				<c:if test="${usePreview}">
					<a id="btn-preview" class="imgbtn"><span><spring:message code='webfolder.version.button.watch' /></span></a>
				</c:if>
				<a id="btn-restore" class="imgbtn"><span><spring:message code='ezWebFolder.t287' /></span></a>
				<a id="btn-delete" class="imgbtn"><span><spring:message code='ezWebFolder.t111' /></span></a>
			</c:when>
			<c:otherwise>
				<a id="btn-ok" class="imgbtn"><span><spring:message code='ezWebFolder.t116' /></span></a>
			</c:otherwise>
		</c:choose>
	</div>
	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;background:rgba(0,0,0,0.5)" id="dimPanel">&nbsp;</div>
	<iframe name="downloadFrame" style="display: none;"></iframe>
</body>
</html>