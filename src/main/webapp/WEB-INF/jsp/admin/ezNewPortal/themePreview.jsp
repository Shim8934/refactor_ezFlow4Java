<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezNewPortal.t122' /></title>
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
		<style type="text/css">
			.preview img {width:1160px; height:600px; margin:10px 0px;}
			.preview {text-align:center; border:1px solid #ddd; margin-top:20px}
		</style>
	</head>
	<body class="popup">
		<h1><spring:message code='ezNewPortal.t122' /></h1>
		<div class="preview">
			<img alt="Theme${themeId }_Frame${frameId}" src="/images/ezNewPortal/themeImg/Theme${themeId }_Frame${frameId}.JPG">
		</div>
	</body>
</html>