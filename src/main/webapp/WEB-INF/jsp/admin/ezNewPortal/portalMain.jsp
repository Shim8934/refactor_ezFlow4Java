<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
</head>
<body>
<iframe id="left" src="/admin/ezNewPortal/portalLeftMenu.do" name="left"></iframe>
<c:if test="${packageType != 'mail' and usePortal eq 'YES'}">
	<iframe src="/admin/ezNewPortal/portalThemes.do" id="right" name="right"></iframe>
</c:if>
<c:if test="${packageType == 'mail' or usePortal eq 'NO'}">
	<iframe src="/admin/ezNewPortal/portalLogos.do" id="right" name="right"></iframe>
</c:if>
</body>
</html>