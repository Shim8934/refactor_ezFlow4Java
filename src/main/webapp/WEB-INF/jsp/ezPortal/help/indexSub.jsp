<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	</head>
	<frameset cols="158,*" border="0" framespacing="0" frameborder="NO">
		<frame src="${lUrl}" name="left" frameborder="NO" scrolling="auto" noresize marginwidth="0" marginheight="0">
		<frame src="${rUrl}" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO" name="right">
	</frameset>
	<body>
	</body>
</html>