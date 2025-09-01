<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><spring:message code='ezCommunity.t1529'/> <spring:message code='ezCommunity.t565'/></title>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<iframe id="left"
		src="/ezCommunity/adminLeft.do?code=<c:out value = '${code}' />&num=<c:out value ='${num}' />" name="left"></iframe>
<iframe src="/ezCommunity/adminRight.do?code=<c:out value = '${code}' />" id="right" name="right"></iframe>
</body>
</html>