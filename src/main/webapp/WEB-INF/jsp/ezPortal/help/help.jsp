<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<title><spring:message code='main.t00037' /></title>
	</head>
	<script type="text/javascript">
    	window.resizeTo("1200", "800");
	</script>
	<frameset rows="68,*" framespacing="0" frameborder="no" border="0">
    	
    		<c:choose>
    			<c:when test="${packageType != 'standard'}">
    				<c:choose>	
						<c:when test="${lang != '3'}">
							<frame src="/ezPortal/help/top.do?topMenuID=${topMenuID }" name="top" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0">
  							<frame src="/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftMail.do&rUrl=/ezPortal/help/main.do?id=/images/help/mail_01" name="bottom" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0">
						</c:when>
						<c:otherwise>
							<frame src="/ezPortal/help/top.do?lang=jp&topMenuID=${topMenuID }" name="top" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0">
   							<frame src="/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPortal.do?lang=jp&rUrl=/ezPortal/help/main.do?id=/images/help/portal_jp_01" name="bottom" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0">
						</c:otherwise>
					</c:choose>
    			</c:when>
    			<c:otherwise>
    				<c:choose>	
						<c:when test="${lang != '3'}">
							<frame src="/ezPortal/help/top.do?topMenuID=${topMenuID }" name="top" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0">
  							<frame src="/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPortal.do&rUrl=/ezPortal/help/main.do?id=/images/help/portal_01" name="bottom" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0">
						</c:when>
						<c:otherwise>
							<frame src="/ezPortal/help/top.do?lang=jp&topMenuID=${topMenuID }" name="top" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0">
   							<frame src="/ezPortal/help/indexSub.do?lUrl=/ezPortal/help/leftPortal.do?lang=jp&rUrl=/ezPortal/help/main.do?id=/images/help/portal_jp_01" name="bottom" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0">
						</c:otherwise>
					</c:choose>
    			</c:otherwise>
    		</c:choose>
    	
	</frameset>
	<noframes>
		<body></body>
	</noframes>
</html>