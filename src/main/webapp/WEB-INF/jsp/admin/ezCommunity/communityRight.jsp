<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>right</title>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<c:choose>
	<c:when test="${cID == '' }">
		<iframe src="/admin/ezCommunity/searchKey.do" name="comm_main"></iframe>
	</c:when>
	<c:otherwise>
		<iframe src="/ezCommunity/commHome/commHome.do?code=<c:out value='${cID}'/>" name="comm_main"></iframe>
	</c:otherwise>
</c:choose>
</body>
</html>