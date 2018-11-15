<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.t551' /></title>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/reademail.js')}"></script>
		<script type="text/javascript">
			var shareId = "${shareId}";
		</script>
		<style> 
			p { margin-bottom: 0; margin-top: 0; } 
		</style>
	</head>
	<body style="margin:3px 3px 3px 3px;">
		<div style="width:100%;height:100%;">
			<div style="margin:10px 10px 10px 10px;">
			${htmlBody}
			</div>
		</div>
	</body>
</html>