<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t1' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	</head>
	<body class="popup" style="overflow:hidden;">
		<h1><spring:message code = 'ezCommunity.t1' /></h1>
		<div id="close">
			<ul><li><span name="button3" onClick="window.close()"></span></li></ul>
		</div>
		<table class="content">
			<tr>
				<th><spring:message code = 'ezCommunity.t9' /></th>
				<td><c:out value = '${club.c_SysopID}' />(${club.userName})</td>
			</tr>
			<tr>
				<th><spring:message code = 'ezCommunity.t9991' /></th>
				<td><c:out value = '${club.c_ClubName}' /></td>
			</tr>
			<tr>
				<th><spring:message code = 'ezCommunity.t550' /></th>
				<td><c:out value = '${fn:substring(club.applicationDate, 0, 10)}' /></td>
			</tr>
			<tr height="100%">
				<th><spring:message code = 'ezCommunity.t71' /></th>
				<td style="padding:0px 2px 0px 0px;">
					<textarea style="background-color:#ffffff; width:97%; height:120px; cursor:default; border:none; resize:none;" readonly><c:out value = '${club.closeReason}' /></textarea>
				</td>
			</tr>
		</table>
	</body>
</html>