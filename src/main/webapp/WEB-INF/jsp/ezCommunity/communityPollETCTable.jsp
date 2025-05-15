<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>poll_etc_table</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	</head>
	
	<body style="background-image:none; margin:0" >
		<table class="popuplist" width="100%" style="padding:0px;margin:0px;border-collapse: collapse;">
			<tr>
			    <th width="50"><spring:message code = 'ezCommunity.t662' /></th>
			    <th><spring:message code = 'ezCommunity.t663' /></th>
			</tr>
			
			<c:forEach items="${responseList }" var = "response" varStatus="status">
				<tr>
			        <td width="50" align="center">${status.count }</td>
			        <td><c:out value="${response.answerETC }"/></td>
				</tr>
			</c:forEach>
			
		</table>
	</body>
</html>