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
.preview img {width:829px; height:600px;}
.preview {text-align:center;}
</style>
</head>
<body class="popup">
<h1><spring:message code='ezNewPortal.t122' /></h1>
<p><spring:message code='ezNewPortal.t123' /></p>
<div class="preview">
	<img alt="theme${themeId }_frame${frameId}" src="/images/ezNewPortal/themeImg/img_theme${themeId }_frame${frameId}.GIF">
</div>
</body>
</html>