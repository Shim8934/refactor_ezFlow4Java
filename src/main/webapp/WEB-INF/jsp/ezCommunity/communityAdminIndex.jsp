<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Community <spring:message code = 'ezCommunity.t565' /></title>
	</head>
	<frameset cols="192,*" frameborder="NO" border="0" framespacing="0">
		<frame name="left" scrolling="NO" noresize src="/ezCommunity/adminLeft.do?code=<c:out value = '${code}' />&num=<c:out value ='${num}' />" marginwidth="0" marginheight="0">
		<frame name="right" src="/ezCommunity/adminBasic.do?code=<c:out value = '${code}' />&flag=<c:out value = '${flag}' />" marginwidth="0" marginheight="0" scrolling="auto" frameborder="NO">
	</frameset>
	<noframes>
		<body bgcolor="#FFFFFF" text="#000000">
		</body>
	</noframes>
</html>