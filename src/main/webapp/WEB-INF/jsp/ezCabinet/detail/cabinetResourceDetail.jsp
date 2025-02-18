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
			<a class="cabBttn2"><span><spring:message code='ezCabinet.t111'/></span></a>
			<%-- <a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a> --%>
		</div>
		<c:if test="${permission != 0}">
			<div class="cabBttnDiv2" id="fileModifyDivBttn" style="display: none;">
				<a class="cabBttn2"><span><spring:message code='ezCabinet.t14'/></span></a>
				<a class="cabBttn2"><span><spring:message code='ezCabinet.t15'/></span></a>
			</div>
		</c:if>
		<div id="cabRlClose" class="cabClose"><ul><li><span></span></li></ul></div>
		<div class="divInfo">
			<table class="tblEmailInf cabcolor">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="creator" class="overfl cursor wide" title="<c:out value="${item.creatorName}"/>"><c:out value="${item.creatorName}"/></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td id="createdDate" class="nowrap"><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
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
			
			<table class="tblEmailInf">
				<tr>
					<th><c:out value="${resourceitem.columnName}"/></th>
					<td class="overfl wide2" colspan="3" title="<c:out value="${resourceitem.columnValue}"/>"><c:out value="${resourceitem.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${creator.columnName}"/></th>
					<td id="resCreator" colspan="3" class="overfl cursor wide" title="<c:out value="${creatorUser.userName}"/>"><c:out value="${creatorUser.userName}"/></td>
				</tr>
				<tr>
					<th><c:out value="${resourcedate.columnName}"/></th>
					<td class="overfl" colspan="3" title="<c:out value="${resourcedate.columnValue}"/>"><c:out value="${resourcedate.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${resTitle.columnName}"/></th>
					<td class="overfl" colspan="3"><c:out value="${resTitle.columnValue}"/></td>
				</tr>
			</table>
		</div>
		
		<div class="resContDiv"><iframe id="resIframe" class="cabrlframe2"></iframe></div>
		
		<%-- <div class="cabBttnDiv" id="fileDivBttn">
			<c:if test="${permission != 0}">
				<a class="cabBttn"><span><spring:message code='ezCabinet.t78'/></span></a>
				<a class="cabBttn"><span><spring:message code='ezCabinet.t46'/></span></a>
			</c:if>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t111'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
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
			var CabinetResourceFile = function() {
				var cabinetHelper = null;
				function initEvents(itemID) {
					cabinetHelper = new CabinetFileHelper({
						itemid   : itemID,
						callback : genderInformation,
						print    : filePrint,
						module   : "resrc",
						iframe   : "resIframe",
						type     : "content"
					});
					cabinetHelper.start();
				}
				
				function genderInformation(fileItem, displayUserInforPopup, showInfoId, showInfoEmail, scrollHandler) {
					var result  = fileItem.fileDetail;
					var creator = fileItem.creator;
					
					//Display popup
					displayUserInforPopup("creator"   , result["creatorId"], showInfoId);
					displayUserInforPopup("resCreator", creator["userId"]  , showInfoId);
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
		<script type="text/javascript">CabinetResourceFile.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>