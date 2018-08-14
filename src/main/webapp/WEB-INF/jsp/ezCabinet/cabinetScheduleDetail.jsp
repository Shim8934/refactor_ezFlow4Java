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
			<table class="tblEmailInf">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="creator" class="overfl cursor wide" title="<c:out value="${item.creatorName}"/>"><c:out value="${item.creatorName}"/></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td id="createdDate" class="nowrap cabdatetd"><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${creator.columnName}"/></th>
					<td id="resCreator" class="overfl cursor wide" title="<c:out value="${creatorUser.userName}"/>"><c:out value="${creatorUser.userName}"/></td>
					<th><c:out value="${createdate.columnName}"/></th>
					<td class="overfl" title="<c:out value="${createdate.columnValue}"/>"><c:out value="${createdate.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${publicstatus.columnName}"/></th>
					<td class="overfl" title="<c:out value="${publicstatus.columnValue}"/>"><c:out value="${publicstatus.columnValue}"/></td>
					<th><c:out value="${priority.columnName}"/></th>
					<td class="nowrap cabdatetd"><c:out value="${priority.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${scheduletype.columnName}"/></th>
					<td class="overfl" title="<c:out value="${scheduletype.columnValue}"/>"><c:out value="${scheduletype.columnValue}"/></td>
					<th><c:out value="${location.columnName}"/></th>
					<td class="nowrap cabdatetd"><c:out value="${location.columnValue}"/></td>
				</tr>
				<c:if test="${not empty groupname}">
					<tr>
						<th><c:out value="${groupname.columnName}"/></th>
						<td class="overfl" colspan="3" title="<c:out value="${groupname.columnValue}"/>"><c:out value="${groupname.columnValue}"/></td>
					</tr>
				</c:if>
				<c:if test="${not empty attendant}">
					<tr>
						<th><c:out value="${attendant.columnName}"/></th>
						<td colspan="3"><div id="attend" class="cabemailDiv"></div></td>
					</tr>
				</c:if>
				<tr>
					<th><c:out value="${scheduledate.columnName}"/></th>
					<td class="overfl" colspan="3" title="<c:out value="${scheduledate.columnValue}"/>"><c:out value="${scheduledate.columnValue}"/></td>
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
		
		<div class="${(not empty attendant) || (not empty groupname) ? 'schContDiv1' : 'schContDiv2'}"><iframe id="schIframe" class="cabrlframe2"></iframe></div>
		
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
		
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
		
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, request, "<spring:message code='ezCabinet.lang' />")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezCabinet/cabinetFileHelper.js")%>"></script>
		<script type="text/javascript">
			var CabinetScheduleFile = function() {
				var cabinetHelper = null;
				function initEvents(itemID) {
					cabinetHelper = new CabinetFileHelper({
						itemid   : itemID,
						callback : genderInformation,
						print    : filePrint,
						module   : "schedl",
						iframe   : "schIframe",
						type     : "content"
					});
					cabinetHelper.start();
				}
				
				function genderInformation(fileItem, displayUserInforPopup, showInfoId, showInfoEmail, scrollHandler) {
					var result  = fileItem.fileDetail;
					var creator = fileItem.creator;
					var attend  = fileItem.attend;
					
					//Display popup
					displayUserInforPopup("creator"   , result["creatorId"], showInfoId);
					displayUserInforPopup("resCreator", creator["userId"]  , showInfoId);
					
					scrollHandler("attend", attend, showInfoId, "userId", "userName", "");
				}
				
				function filePrint(scrollPrint, unsetAllScrollTd, displayIframePrint, removeIframePrint) {
					var listElmtId = ["fileListDiv", "attend"];
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
		<script type="text/javascript">CabinetScheduleFile.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>