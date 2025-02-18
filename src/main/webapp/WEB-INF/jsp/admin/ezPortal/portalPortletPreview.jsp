<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t261'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezPortal/skin.css')}" type="text/css" />
		<script type="text/javascript">
			var portletWidth = "${portletWidth}";
			var portletHeight = "${portletHeight}";
			
		  	try {
		     	if("${portletWidth}" != "9999")
		            window.resizeTo(parseInt(portletWidth)+30, parseInt(portletHeight)+120);
		        else
		            window.resizeTo(window.screen.availWidth, parseInt(portletHeight)+120);
			} catch (e) {}
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
        <h1><spring:message code='ezPortal.t261'/></h1>
        ${strHTML }
	</body>
</html>