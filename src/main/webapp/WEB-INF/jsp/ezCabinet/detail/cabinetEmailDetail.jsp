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
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	</head>
	<body class="popup cabDetail">
		<%-- <h1 id="fileFileH1"><spring:message code='ezCabinet.t108'/></h1> --%>
		<div id="menu">
			<div class="cabBttnDiv2" id="fileDivBttn">
				<ul>
					<c:if test="${permission != 0}">
						<li class="cabBttn2"><span><spring:message code='ezCabinet.t78'/></span></li>
						<li class="cabBttn2"><span><spring:message code='ezCabinet.t46'/></span></li>
					</c:if>
					<li class="cabBttn2"><span><spring:message code='ezCabinet.t111'/></span></li>
					<%-- <a class="cabBttn2"><span><spring:message code='ezCabinet.t66'/></span></a> --%>
				</ul>
			</div>
			<c:if test="${permission != 0}">
				<div class="cabBttnDiv2" id="fileModifyDivBttn" style="display: none;">
					<ul>
						<li class="cabBttn2"><span><spring:message code='ezCabinet.t14'/></span></li>
						<li class="cabBttn2"><span><spring:message code='ezCabinet.t15'/></span></li>
					</ul>
				</div>
			</c:if>
		</div>
		<div id="cabRlClose" class="cabClose"><ul><li><span></span></li></ul></div>
		<div class="divInfo">
			<table class="tblEmailInf cabcolor">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="creator" class="overfl cursor wide" title="<c:out value="${item.creatorName}"/>"><c:out value="${item.creatorName}"/></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td id="createdDate" class="nowrap cabdatetd"><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
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
					<th><c:out value="${sender.columnName}"/></th>
					<td id="senderMail" class="overfl cursor wide" title="<c:out value="${senderUser.userName}"/>"><c:out value="${senderUser.userName}"/></td>
					<th><c:out value="${emailTime.columnName}"/></th>
					<td class="nowrap cabdatetd"><c:out value="${fn:substring(emailTime.columnValue, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${receiver.columnName}"/></th>
					<td colspan="3"><div id="receivers" class="cabemailDiv"></div></td>
				</tr>
				<c:if test="${not empty forwardList}">
					<tr>
						<th><c:out value="${forward.columnName}"/></th>
						<td colspan="3"><div id="forwards" class="cabemailDiv"></div></td>
					</tr>
				</c:if>
				<tr>
					<th><c:out value="${mailTitle.columnName}"/></th>
					<td class="overfl" colspan="3"><c:out value="${mailTitle.columnValue}"/></td>
				</tr>
			</table>
		</div>
		
		<div class="${not empty forwardList ? 'mailContDiv1' : 'mailContDiv2'}"><iframe id="mailIframe" class="cabrlframe2"></iframe></div>
		
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
			var CabinetEmailFile = function() {
				var cabinetHelper = null;
				function initEvents(itemID) {
					cabinetHelper = new CabinetFileHelper({
						itemid   : itemID,
						callback : genderInformation,
						print    : printEmail,
						module   : "mail",
						iframe   : "mailIframe",
						type     : "content"
					});
					cabinetHelper.start();
				}
				
				function genderInformation(fileItem, displayUserInforPopup, showInfoId, showInfoEmail, scrollHandler) {
					var result    = fileItem.fileDetail;
					var sender    = fileItem.sender;
					var receivers = fileItem.receivers;
					var forwards  = fileItem.forwards;
					
					//Display popup
					displayUserInforPopup("creator"   , result["creatorId"], showInfoId);
					displayUserInforPopup("senderMail", sender["userEmail"], showInfoEmail);
					
					scrollHandler("receivers", receivers, showInfoEmail, "userEmail", "userName", "");
					scrollHandler("forwards" , forwards , showInfoEmail, "userEmail", "userName", "");
				}
				
				function printEmail(scrollPrint, unsetAllScrollTd, displayIframePrint, removeIframePrint) {
					var listElmtId = ["fileListDiv", "forwards", "receivers"];
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
		<script type="text/javascript">CabinetEmailFile.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>