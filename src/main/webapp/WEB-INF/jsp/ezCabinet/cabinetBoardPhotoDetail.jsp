<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"        %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"      %>
<%@ taglib prefix="fn"     uri = "http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCabinet.t138'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabDetail">
		<h1 id="fileFileH1"><spring:message code='ezCabinet.t108'/></h1>
		
		<div class="divInfo">
			<table class="tblBoardInf">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="fileCreator" class="cursor overfl"><c:out value="${item.creatorName}"/></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${boardWriter.columnName}"/></th>
					<td id="boardCreator" class="cursor overfl"></td>
					<th><c:out value="${boardTime.columnName}"/></th>
					<td><c:out value="${fn:substring(boardTime.columnValue, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${boardDesc.columnName}"/></th>
					<td class="overfl" colspan="3" title="<c:out value="${boardDesc.columnValue}"/>"><c:out value="${boardDesc.columnValue}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t51'/></th>
					<td id="title" class="overfl" colspan="3"><c:out value="${item.title}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td colspan="3"><div id="rlWrapDiv" class="rlFileDiv"><div id="fileListDiv" class="rlDocDiv"></div></div></td>
				</tr>
			</table>
		</div>
		
		<div class="boardContDiv2"><iframe id="boardIframe" class="cabrlframe2"></iframe></div>
		
		<div class="cabBttnDiv" id="fileDivBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t78'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t46'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t144'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
		
		<jsp:include page="/WEB-INF/jsp/ezCabinet/cabinetPhotoDownload.jsp"></jsp:include>
		
		<div class="cabBttnDiv" id="fileModifyDivBttn" style="display: none;">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetFileHelper.js"     ></script>
		<script type="text/javascript">
			var CabinetBoardPhoto = function() {
				var cabinetHelper = null;
				function initEvents(itemID) {
					cabinetHelper = new CabinetFileHelper({
						itemid   : itemID,
						callback : genderInformation,
						photo    : "yes",
						download : downloadAllPhoto,
						iframe   : "boardIframe",
						module   : "photo",
						type     : "content"
					});
					cabinetHelper.start();
				}
				
				function genderInformation(fileItem, displayUserInforPopup, showInfoId, showInfoEmail, scrollHandler) {
					var result      = fileItem.fileDetail;
					var boardWriter = fileItem.writerVO;
					
					//Display board creator name
					document.getElementById("boardCreator").textContent = boardWriter["userName"];
					
					//Display popup
					displayUserInforPopup("fileCreator" , result["creatorId"]  , showInfoId);
					displayUserInforPopup("boardCreator", boardWriter["userId"], showInfoId);
					
					var cabMgBttnElmt        = document.getElementById("cabPhotoBttn");
					var listMgBttns          = cabMgBttnElmt.children;
					listMgBttns[0].onclick   = function(e) {selectAllPhoto();};
					listMgBttns[1].onclick   = function(e) {downloadPhotoList();};
					listMgBttns[2].onclick   = function(e) {closeDownloadPopup();};
					
					//Add list of images
					var cabPhotoDiv = document.getElementById("photoSelect");
					var attachList  = getIframeContent().attach;
					for (var i = 0, len = attachList.length; i < len; i++) {
						var divElmt   = document.createElement("div");
						var inputElmt = document.createElement("input");
						var imgElmt   = document.createElement("img");
						inputElmt.setAttribute("type", "checkbox");
						inputElmt.setAttribute("filePath", attachList[i]["filePath"]);
						imgElmt.src   = attachList[i]["filePath"];
						divElmt.className = "ptdownloadwrap";
						divElmt.appendChild(inputElmt);
						divElmt.appendChild(imgElmt);
						cabPhotoDiv.appendChild(divElmt);
					}
				}
				
				function closeDownloadPopup(mode) {
					var cabPhotoDiv       = document.getElementById("cabPhotoDiv");
					cabPhotoDiv.className = "popup cabPhotooff";
					removeFogPanel();
				}
				
				function removeFogPanel() {
					var fogPanel = document.querySelector("div[class='cabFogPanel']");
					if (fogPanel) {document.body.removeChild(fogPanel);}
				}
				
				function downloadAllPhoto() {
					addFogPanel();
					var cabAddDiv         = document.getElementById("cabPhotoDiv");
					var position          = getPosition(410, 450);
					cabAddDiv.style.top   = position[0] + "px";
					cabAddDiv.style.right = position[1] + "px";
					cabAddDiv.className   = "popup cabPhotoon";
				}
				
				function selectAllPhoto() {
					var cabPhotoDiv = document.getElementById("photoSelect");
					var inputList   = cabPhotoDiv.querySelectorAll("input[type='checkbox']");
					for (var i = 0, len = inputList.length; i < len; i++) {
						inputList[i].checked = true;
					}
				}
				
				function downloadPhotoList() {
					var cabPhotoDiv = document.getElementById("photoSelect");
					var listAttach  = [];
					var inputList   = cabPhotoDiv.querySelectorAll("input[type='checkbox']:checked");
					for (var i = 0, len = inputList.length; i < len; i++) {
						listAttach.push(inputList[i].getAttribute("filePath"));
					}
					
					console.log("ListAttach: " + JSON.stringify(listAttach));
				}
				
				function getPosition(popUpW, popUpH) {
					var returnValue = new Array();
					var heigth      = window.parent.document.documentElement.clientHeight;
					if (heigth == 0) {heigth = window.parent.document.body.clientHeight;}
					
					var width = window.parent.document.documentElement.clientWidth;
					if (width == 0) {width = window.parent.document.body.clientWidth;}
					
					var pleftpos   = parseInt(width)  - popUpW;
					heigth         = parseInt(heigth) - popUpH;
					returnValue[0] = (heigth / 2);
					returnValue[1] = pleftpos / 2;
					
					return returnValue;
				}
				
				function addFogPanel() {
					var fogPanel       = document.createElement("div");
					fogPanel.className = "cabFogPanel";
					document.body.appendChild(fogPanel);
				}
				
				function getRelatedFiles()       {return cabinetHelper.get();}
				function saveRelatedFiles(files) {cabinetHelper.save(files);}
				function getIframeContent()      {return cabinetHelper.getContent();}
				
				return {
					init       : initEvents,
					get        : getRelatedFiles,
					save       : saveRelatedFiles,
					getContent : getIframeContent
				};
			}();
		</script>
		<script type="text/javascript">CabinetBoardPhoto.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>