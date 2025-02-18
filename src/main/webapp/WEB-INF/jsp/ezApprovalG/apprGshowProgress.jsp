<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1565'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
			<script language="JScript">
				function fileinfo_change(fileinfo)
				{
					message.innerText = fileinfo;
				}
			</script>
	</head>

	<body scroll="no" class="msgbody">
		<div class="message"><span class="point"><spring:message code='ezApprovalG.t1565'/><br>
			<spring:message code='ezApproval.t900'/></span><br><br>
		<div id="message">${fileInfo}</div></div>
	</body>
</html> 