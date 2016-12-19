<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>처리중입니다.</title>
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
			<script language="JScript">
				function fileinfo_change(fileinfo)
				{
					message.innerText = fileinfo;
				}
			</script>
	</head>

	<body scroll="no" class="msgbody">
		<div class="message"><span class="point">처리중입니다.<br>
			잠시만 기다려 주십시오.</span><br><br>
		<div id="message">${fileInfo}</div></div>
	</body>
</html>