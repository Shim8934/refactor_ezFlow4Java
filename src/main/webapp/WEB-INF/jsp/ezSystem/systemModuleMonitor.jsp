<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"  href="${util.addVer('main.e15', 'msg')}" type="text/css">
<title><spring:message code="ezSystem.kbh1" /></title>
<style type="text/css">
	body.mainbody table.content tr.total {border-top-style: double;}
	body.mainbody table.content td {width: auto;padding-left: 10px;}
	body.mainbody table.content {width: 100%;}
	
</style>
</head>
<body class="mainbody" style="overflow:hidden;">
	<h1><spring:message code="ezSystem.kbh1" /></h1>
	<table class="content">
		<tbody>
			<tr>
				<th><spring:message code="ezSystem.kbh2" /></th>
				<th><spring:message code="ezSystem.kbh3" /></th>
				<th><spring:message code="ezSystem.kbh4" /></th>
				<th><spring:message code="ezSystem.kbh5" /></th>
			</tr>
			<tr>
				<th><spring:message code="ezSystem.kbh6" /></th>
				<td><c:out value="${modules.moduleMap.mail.storageSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.mail.tableSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.mail.totalSizePerModuleStr}" /></td>
			</tr>
			<%-- <tr>
				<th><spring:message code="ezSystem.kbh7" /></th>
			</tr> --%>
			<tr>
				<th><spring:message code="ezSystem.kbh8" /></th>
				<td><c:out value="${modules.moduleMap.schedule.storageSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.schedule.tableSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.schedule.totalSizePerModuleStr}" /></td>
			</tr>
			<tr>
				<th><spring:message code="ezSystem.kbh9" /></th>
				<td><c:out value="${modules.moduleMap.board.storageSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.board.tableSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.board.totalSizePerModuleStr}" /></td>
			</tr>
			<tr>
				<th><spring:message code="ezSystem.kbh10" /></th>
				<td><c:out value="${modules.moduleMap.community.storageSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.community.tableSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.community.totalSizePerModuleStr}" /></td>
			</tr>
			<tr>
				<th><spring:message code="ezSystem.kbh11" /></th>
				<td><c:out value="${modules.moduleMap.resource.storageSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.resource.tableSizeStr}" /></td>
				<td><c:out value="${modules.moduleMap.resource.totalSizePerModuleStr}" /></td>
			</tr>
			<tr class="total">
				<th><spring:message code="ezSystem.kbh12" /></th>
				<td><c:out value="${modules.storageSizeAllModuleStr}" /></td>
				<td><c:out value="${modules.tableSizeAllModuleStr}" /></td>
				<td><c:out value="${modules.totalSizeAllModuleStr}" /></td>
			</tr>
		</tbody>
	</table>
</body>
</html>