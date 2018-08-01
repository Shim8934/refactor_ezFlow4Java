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
			<table class="tblApprovalInf">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="creator" class="cursor wide"><c:out value="${item.creatorName}"/></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td id="createdDate" class="nowrap"><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
				<tr>
				<tr>
					<th><c:out value="${senderColumn.columnName}"/></th>
					<td id="senderMail" class="cursor wide"><c:out value="${sender.userName}"/></td>
					<th><c:out value="${timeColumn.columnName}"/></th>
					<td class="nowrap"><c:out value="${fn:substring(timeColumn.columnValue, 0, 19)}"/></td>
				<tr>
				<tr>
					<th><c:out value="${receiverColumn.columnName}"/></th>
					<td colspan="3"><div id="receivers" class="cabemailDiv"></div></td>
				<tr>
				<c:if test="${not empty forwardList}">
					<tr>
						<th><c:out value="${forwardColumn.columnName}"/></th>
						<td colspan="3"><div id="forwards" class="cabemailDiv"></div></td>
					<tr>
				</c:if>
				<tr>
					<th><spring:message code='ezCabinet.t51'/></th>
					<td id="title" class="overfl" colspan="3"><c:out value="${item.title}"/></td>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td colspan="3"><div id="rlWrapDiv" class="rlFileDiv"><div id="fileListDiv" class="rlDocDiv"></div></div></td>
				</tr>
			</table>
		</div>
		
		<div class="${not empty forwardList ? 'mailContDiv1' : 'mailContDiv2'}"><iframe id="mailIframe" class="cabrlframe2"></iframe></div>
		
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
		<script type="text/javascript">
			
		</script>
		<script type="text/javascript">CabinetEmailFile.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>