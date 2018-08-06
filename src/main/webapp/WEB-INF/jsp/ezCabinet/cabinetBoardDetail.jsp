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
					<th><c:out value="${writer.columnName}"/></th>
					<td id="boardCreator" class="cursor overfl"></td>
					<th><c:out value="${boardTime.columnName}"/></th>
					<td><c:out value="${fn:substring(boardTime.columnValue, 0, 19)}"/></td>
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
		
		<div class="boardContDiv"><iframe id="boardIframe" class="cabrlframe2"></iframe></div>
		
		<div class="cabBttnDiv" id="fileDivBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t78'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t46'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t111'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
		
		<div class="cabBttnDiv" id="fileModifyDivBttn" style="display: none;">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetFileHelper.js"     ></script>
		<script type="text/javascript">
			var CabinetBoardFile = function() {
				var cabinetHelper = null;
				function initEvents(itemID) {
					cabinetHelper = new CabinetFileHelper({
						itemid   : itemID,
						callback : genderInformation,
						print    : filePrint,
						module   : "board",
						iframe   : "boardIframe",
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
				}
				
				function filePrint(scrollPrint, unsetAllScrollTd, displayIframePrint, removeIframePrint) {
					var listElmtId = ["fileListDiv"];
					scrollPrint(listElmtId);
					displayIframePrint();
					window.focus();
					window.print();
					removeIframePrint();
					unsetAllScrollTd(listElmtId);
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
		<script type="text/javascript">CabinetBoardFile.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>