<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil"                      %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"        %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"      %>
<%@ taglib prefix="fn"     uri = "http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCabinet.t138'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, request, "<spring:message code='ezCabinet.css' />")%>" type="text/css">
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezCabinet/cabinet.css")%>" type="text/css" />
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
					<th><c:out value="${jourWriter.columnName}"/></th>
					<td id="journalCreator" class="cursor overfl"></td>
					<th><c:out value="${jourDate.columnName}"/></th>
					<td><c:out value="${jourDate.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${jourType.columnName}"/></th>
					<td><c:out value="${jourType.columnValue}"/></td>
					<th><c:out value="${formname.columnName}"/></th>
					<td><c:out value="${formname.columnValue}"/></td>
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
		
		<div class="journalContDiv"><iframe id="journalIframe" class="cabrlframe2"></iframe></div>
		
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
		
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, request, "<spring:message code='ezCabinet.lang' />")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezCabinet/cabinetFileHelper.js")%>"></script>
		<script type="text/javascript">
			var CabinetJournalFile = function() {
				var cabinetHelper = null;
				function initEvents(itemID) {
					cabinetHelper = new CabinetFileHelper({
						itemid   : itemID,
						callback : genderInformation,
						print    : filePrint,
						module   : "jounl",
						iframe   : "journalIframe",
						type     : "content"
					});
					cabinetHelper.start();
				}
				
				function genderInformation(fileItem, displayUserInforPopup, showInfoId, showInfoEmail, scrollHandler) {
					var result        = fileItem.fileDetail;
					var journalWriter = fileItem.writerVO;
					
					//Display board creator name
					document.getElementById("journalCreator").textContent = journalWriter["userName"];
					
					//Display popup
					displayUserInforPopup("fileCreator" , result["creatorId"], showInfoId);
					displayUserInforPopup("journalCreator", journalWriter["userId"], showInfoId);
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
		<script type="text/javascript">CabinetJournalFile.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>