<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>poll_etc_table</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	</head>
	
	<body style="background-image:none; margin:0" >
		<table class="popuplist" width="100%">
			<tr>
			    <th width="50"><spring:message code = 'ezCommunity.t662' /></th>
			    <th><spring:message code = 'ezCommunity.t663' /></th>
			</tr>
			
			<c:forEach items="${responseList }" var = "response" varStatus="status">
				<tr>
			        <td width="50" align="center">${status.count }</td>
			        <td>${response.answerETC }</td>
				</tr>
			</c:forEach>
			
		</table>
	</body>
</html>