<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css"/>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
	<title><spring:message code='main.t00037'/></title>
</head>
<script type="text/javascript">
    window.resizeTo("1200", "800");
</script>
<body>
<c:choose>
	<c:when test="${packageType != 'standard'}">
		<c:choose>
			<c:when test="${lang != '3'}">
				<iframe id="topFrame" src="/ezPortal/help/top.do?topMenuID=${topMenuID }" name="top">
				<iframe id="mainFrame" src="/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftMail.do&rUrl=/ezPortal/help/main.do?id=/images/help/mail_01"
					   name="bottom">
			</c:when>
			<c:otherwise>
				<iframe id="topFrame" src="/ezPortal/help/top.do?lang=jp&topMenuID=${topMenuID }" name="top">
				<iframe id="mainFrame" src="/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPortal.do?lang=jp&rUrl=/ezPortal/help/main.do?id=/images/help/portal_jp_01"
					   name="bottom">
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${lang != '3'}">
				<iframe id="topFrame" src="/ezPortal/help/top.do?topMenuID=${topMenuID }" name="top">
				<iframe id="mainFrame" src="/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPortal.do&rUrl=/ezPortal/help/main.do?id=/images/help/portal_01"
					   name="bottom">
			</c:when>
			<c:otherwise>
				<iframe id="topFrame" src="/ezPortal/help/top.do?lang=jp&topMenuID=${topMenuID }" name="top">
				<iframe id="mainFrame" src="/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPortal.do?lang=jp&rUrl=/ezPortal/help/main.do?id=/images/help/portal_jp_01"
					   name="bottom">
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
</body>
</html>