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
			<table class="tblEmailInf">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="creator" colspan="3" class="overfl cursor wide" title="<c:out value="${item.creatorName}"/>"><c:out value="${item.creatorName}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td id="createdDate" colspan="3" class="nowrap cabdatetd"><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${creator.columnName}"/></th>
					<td id="addrCreator" colspan="3" class="overfl cursor wide" title="<c:out value="${creatorUser.userName}"/>"><c:out value="${creatorUser.userName}"/></td>
				</tr>
				<tr>
					<th><c:out value="${createdate.columnName}"/></th>
					<td colspan="3" class="nowrap cabdatetd"><c:out value="${fn:substring(createdate.columnValue, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${modifier.columnName}"/></th>
					<td id="addrMod" colspan="3" class="overfl cursor wide" title="<c:out value="${modifierUser.userName}"/>"><c:out value="${modifierUser.userName}"/></td>
				</tr>
				<tr>
					<th><c:out value="${modifydate.columnName}"/></th>
					<td colspan="3" class="nowrap cabdatetd"><c:out value="${fn:substring(modifydate.columnValue, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${company.columnName}"/></th>
					<td id="addrMod" colspan="3" class="overfl" title="<c:out value="${company.columnValue}"/>"><c:out value="${company.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${department.columnName}"/></th>
					<td class="nowrap overfl cabdatetd" colspan="3" title="<c:out value="${department.columnValue}"/>"><c:out value="${department.columnValue}"/></td>
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
			<table class="tblEmailInf">
				<tr>
					<th><c:out value="${compnumber.columnName}"/></th>
					<td id="addrMod" colspan="3" class="overfl" title="<c:out value="${compnumber.columnValue}"/>"><c:out value="${compnumber.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${usernumber.columnName}"/></th>
					<td class="nowrap overfl" colspan="3" title="<c:out value="${usernumber.columnValue}"/>"><c:out value="${usernumber.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${faxnumber.columnName}"/></th>
					<td id="addrMod" colspan="3" class="overfl" title="<c:out value="${faxnumber.columnValue}"/>"><c:out value="${faxnumber.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${homepage.columnName}"/></th>
					<td colspan="3" class="nowrap overfl" title="<c:out value="${homepage.columnValue}"/>"><c:out value="${homepage.columnValue}"/></td>
				</tr>
				<tr>
					<th rowspan="2" ><c:out value="${compaddr.columnName}"/></th>
					<td colspan="3" class="overfl"><c:out value="${companyzip.columnValue}"/></td>
				</tr>
				<tr>
					<td colspan="3" class="overfl" title="<c:out value="${compaddr.columnValue}"/>"><c:out value="${compaddr.columnValue}"/></td>
				</tr>
				<tr>
					<th rowspan="2" ><c:out value="${homeaddr.columnName}"/></th>
					<td colspan="3" class="overfl"><c:out value="${homezip.columnValue}"/></td>
				</tr>
				<tr>
					<td colspan="3" class="overfl" title="<c:out value="${homeaddr.columnValue}"/>"><c:out value="${homeaddr.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${memo.columnName}"/></th>
					<td colspan="3"><div class="cabmemo"><c:out value="${memo.columnValue}"/></div></td>
				</tr>
			</table>
		</div>
		
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
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetFileHelper.js"     ></script>
		<script type="text/javascript">
			var CabinetNormalAddress = function() {
				var cabinetHelper = null;
				function initEvents(itemID) {
					cabinetHelper = new CabinetFileHelper({
						itemid   : itemID,
						callback : genderInformation,
						print    : filePrint,
						module   : "naddr",
						type     : "normal"
					});
					cabinetHelper.start();
				}
				
				function genderInformation(fileItem, displayUserInforPopup, showInfoId, showInfoEmail, scrollHandler) {
					var result   = fileItem.fileDetail;
					var creator  = fileItem.creator;
					var modifier = fileItem.modifier;
					
					//Display popup
					displayUserInforPopup("creator"    , result["creatorId"], showInfoId);
					displayUserInforPopup("addrCreator", creator["userId"]  , showInfoId);
					displayUserInforPopup("addrMod"    , modifier["userId"] , showInfoId);
				}
				
				function filePrint(scrollPrint, unsetAllScrollTd, displayIframePrint, removeIframePrint) {
					var listElmtId = ["fileListDiv"];
					scrollPrint(listElmtId);
					window.focus();
					window.print();
					unsetAllScrollTd(listElmtId);
				}
				
				function getRelatedFiles()       {return cabinetHelper.get();}
				function saveRelatedFiles(files) {cabinetHelper.save(files);}
				
				return {
					init : initEvents,
					get  : getRelatedFiles,
					save : saveRelatedFiles
				};
			}();
		</script>
		<script type="text/javascript">CabinetNormalAddress.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>