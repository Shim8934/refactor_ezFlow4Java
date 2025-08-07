<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<title>main</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<c:choose>
	<c:when test="${cID == ''}">
		<iframe id="left" src="/admin/ezCommunity/left.do" name="left"></iframe>
		<iframe src="/admin/ezCommunity/right.do" id="right" name="right"></iframe>
	</c:when>
	<c:otherwise>
		<iframe id="left" src="/admin/ezCommunity/left.do" name="left"></iframe>
		<iframe src="/admin/ezCommunity/right.do?cID=<c:out value='${cID}'/>" id="right" name="right"></iframe>
	</c:otherwise>
</c:choose>
</body>
</html>