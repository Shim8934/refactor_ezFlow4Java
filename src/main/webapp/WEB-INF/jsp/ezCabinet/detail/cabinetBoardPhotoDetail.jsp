<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"        %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"      %>
<%@ taglib prefix="fn"     uri = "http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCabinet.t108'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')}">
	</head>
	<body class="popup cabDetail">
		<%-- <h1 id="fileFileH1"><spring:message code='ezCabinet.t108'/></h1> --%>
		<div class="cabBttnDiv2" id="fileDivBttn">
			<c:if test="${permission != 0}">
				<a class="cabBttn2"><span><spring:message code='ezCabinet.t78'/></span></a>
				<a class="cabBttn2"><span><spring:message code='ezCabinet.t46'/></span></a>
			</c:if>
			<a class="cabBttn2"><span><spring:message code='ezCabinet.t144'/></span></a>
			<%-- <a class="cabBttnP"><span><spring:message code='ezCabinet.t66'/></span></a> --%>
		</div>
		
		<jsp:include page="/WEB-INF/jsp/ezCabinet/detail/cabinetPhotoDownload.jsp"></jsp:include>
		
		<c:if test="${permission != 0}">
			<div class="cabBttnDiv2" id="fileModifyDivBttn" style="display: none;">
				<a class="cabBttn2"><span><spring:message code='ezCabinet.t14'/></span></a>
				<a class="cabBttn2"><span><spring:message code='ezCabinet.t15'/></span></a>
			</div>
		</c:if>
		<div id="cabRlClose" class="cabClose"><ul><li><span></span></li></ul></div>
		<div class="divInfo">
			<table class="tblBoardInf cabcolor">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="fileCreator" class="cursor overfl wide"><c:out value="${item.creatorName}"/></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td class="nowrap"><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t161'/></th>
					<td id="title" class="overfl" colspan="3"><c:out value="${item.title}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t52'/></th>
					<td id="summary" class="overfl" colspan="3"><c:out value="${item.summary}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td colspan="3"><div id="rlWrapDiv" class="rlFileDiv"><div id="fileListDiv" class="rlDocDiv"></div></div></td>
				</tr>
			</table>
			
			<table class="tblBoardInf">
				<tr>
					<th><c:out value="${boardWriter.columnName}"/></th>
					<td id="boardCreator" class="cursor overfl wide"></td>
					<th><c:out value="${boardTime.columnName}"/></th>
					<td class="nowrap"><c:out value="${fn:substring(boardTime.columnValue, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${boardTitle.columnName}"/></th>
					<td class="overfl" colspan="3"><c:out value="${boardTitle.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${boardDesc.columnName}"/></th>
					<td class="overfl" colspan="3" title="<c:out value="${boardDesc.columnValue}"/>"><c:out value="${boardDesc.columnValue}"/></td>
				</tr>
			</table>
		</div>
		
		<div class="boardContDiv2"><iframe id="boardIframe" class="cabrlframe2"></iframe></div>
		
		<%-- <div class="cabBttnDiv" id="fileDivBttn">
			<c:if test="${permission != 0}">
				<a class="cabBttn"><span><spring:message code='ezCabinet.t78'/></span></a>
				<a class="cabBttn"><span><spring:message code='ezCabinet.t46'/></span></a>
			</c:if>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t144'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
		
		<jsp:include page="/WEB-INF/jsp/ezCabinet/detail/cabinetPhotoDownload.jsp"></jsp:include>
		
		<c:if test="${permission != 0}">
			<div class="cabBttnDiv" id="fileModifyDivBttn" style="display: none;">
				<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
				<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
			</div>
		</c:if> --%>
		
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')             }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')   }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetFileHelper.js')}"></script>
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
					
					var cabMgBttnElmt                               = document.getElementById("cabPhotoBttn");
					var listMgBttns                                 = cabMgBttnElmt.children;
					listMgBttns[0].onclick                          = function(e) {selectAllPhoto();};
					listMgBttns[1].onclick                          = function(e) {downloadPhotoList();};
					listMgBttns[2].onclick                          = function(e) {closeDownloadPopup();};
					document.getElementById("cabDownClose").onclick = function(e) {closeDownloadPopup();};
					
					//Add list of images
					var cabPhotoUl       = document.getElementById("photoSelect");
					cabPhotoUl.innerHTML = "";
					var attachList       = getIframeContent().attach;
					
					for (var i = 0, len = attachList.length; i < len; i++) {
						var liElmt    = document.createElement("li");
						var divElmt   = document.createElement("div");
						var inputElmt = document.createElement("input");
						var imgElmt   = document.createElement("img");
						inputElmt.setAttribute("type", "checkbox");
						inputElmt.setAttribute("filePath", attachList[i]["filePath"]);
						inputElmt.setAttribute("fileName", attachList[i]["fileName"]);
						imgElmt.onclick  = function(e) {selectThisPhoto(this);};
						imgElmt.src      = attachList[i]["filePath"];
						liElmt.className = "ptdownloadwrap";
						divElmt.appendChild(inputElmt);
						divElmt.appendChild(imgElmt);
						liElmt.appendChild(divElmt);
						cabPhotoUl.appendChild(liElmt);
					}
				}
				
				function selectThisPhoto(imgElmt) {
					var parentDiv     = imgElmt.parentElement;
					var inputElmt     = parentDiv.querySelector("input[type='checkbox']");
					inputElmt.checked = inputElmt.checked == true ? false : true;
				}
				
				function closeDownloadPopup() {
					var cabPhotoDiv       = document.getElementById("cabPhotoDiv");
					cabPhotoDiv.className = "popup cabPhotooff";
					removeFogPanel();
					
					//Unselect all inputs
					var cabPhotoUl = document.getElementById("photoSelect");
					var inputList   = cabPhotoUl.querySelectorAll("input[type='checkbox']");
					for (var i = 0, len = inputList.length; i < len; i++) {
						inputList[i].checked = false;
					}
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
					var cabPhotoDiv  = document.getElementById("photoSelect");
					var inputList    = cabPhotoDiv.querySelectorAll("input[type='checkbox']:checked");
					
					if (inputList.length == 0) {alert(CabinetMessages.strSelect3); return;}
					
					var listSelected = [];
					
					for (var i = 0, len = inputList.length; i < len; i++) {
						var inputELmt   = inputList[i];
						listSelected.push({
							filePath : inputELmt.getAttribute("filePath"),
							fileName : inputELmt.getAttribute("fileName")
						});
					}
					
					closeDownloadPopup();
					
					var counter = 0;
					downloadOneFile(listSelected, 0);
				}
				
				function downloadOneFile(listSelected, index) {
					if (index >= listSelected.length) {return;}
					var photoItem   = listSelected[index];
					var downloadUrl = "/ezCabinet/downloadAttachFile?filePath=" + encodeURIComponent( photoItem["filePath"]) + "&fileName=" + encodeURIComponent(photoItem["fileName"]);
					var attachFrame = document.getElementById("attachFrame");
					attachFrame.src = downloadUrl;
					
					setTimeout(function() {downloadOneFile(listSelected, index + 1);}, 2000);
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