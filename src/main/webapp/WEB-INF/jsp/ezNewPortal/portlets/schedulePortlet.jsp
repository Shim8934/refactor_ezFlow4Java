<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/schedulePortlet.js')}"></script>		
	<c:choose>
		<c:when test="${checkBrowser == true}">
			<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_IEEIP.js')}"></script>
		</c:when>
		<c:otherwise>
			<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/sCalendarMini_EIP.js')}"></script>
		</c:otherwise>
	</c:choose>
</head>
<body>
	<div class="layDIV02">
		<dl class="portlet_title">
			<dt class="portletText"><spring:message code='main.t203' /></dt>
			<dd class="portletPlus" onclick="goSchedule();">
				<img src="/images/kr/main/portlet_Plus.png">
			</dd>
		</dl>
		<div class="sCalendarArea">
			<div id="CalendarMini" class="scalender"></div>
			<div id="scheduleList" class="sschedule_list"></div>
		</div>
	</div>
</body>
</html>