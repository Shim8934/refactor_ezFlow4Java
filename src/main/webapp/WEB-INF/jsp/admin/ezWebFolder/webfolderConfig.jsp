<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html class="frame_main wf">
<head>
	<title><spring:message code="ezOrgan.t303"/></title>
	<link rel="shortcut icon" href="/images/icon/gilfavicon.ico">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body class="body_frame_main">
<iframe id="topFrame" src="/admin/ezWebFolder/webfolderAdminTop.do"></iframe>
<div id="bottomFrame">
	<iframe id="left" src="/admin/ezWebFolder/webfolderAdminLeft.do" name="left"></iframe>
	<iframe src="about:blank" id="right" name="right"></iframe>
</div>
</body>
</html>
