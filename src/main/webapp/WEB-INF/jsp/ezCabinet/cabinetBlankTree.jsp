<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height: 100%;">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css">
	</head>
	<body class="mainbody overY blankBody">
		<h1 id="cabInfo"><spring:message code='${message}'/></h1>
		<div class="cabBlankMain">
			<div class="blankDiv">
				<img src="/images/cabinet/notree.png">
				<div class="blankMsg"><spring:message code="ezCabinet.t163"/></div>
			</div>
		</div>
	</body>
</html>
