<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/top.js')}"></script>
</head>
<body>
<iframe id="left" class="fold" src="/ezApprovalG/apprGLeft.do?listType=${listType}" name="left"
		style="width:<c:out value='${leftFrameWidth}'/>px"></iframe>
<iframe src="" id="right" name="right"></iframe>

<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
</div>
</body>
</html>