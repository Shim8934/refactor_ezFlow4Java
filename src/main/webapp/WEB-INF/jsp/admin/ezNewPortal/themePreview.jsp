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
.preview img {width:1160px; height:600px;}
.preview {text-align:center;}
</style>
</head>
<body class="popup">
<h1><spring:message code='ezNewPortal.t122' /></h1>
<p><spring:message code='ezNewPortal.t123' /></p>
<div class="preview">
	<img alt="Theme${themeId }_Frame${frameId}" src="/images/ezNewPortal/themeImg/Theme${themeId }_Frame${frameId}.JPG">
</div>
</body>
</html>