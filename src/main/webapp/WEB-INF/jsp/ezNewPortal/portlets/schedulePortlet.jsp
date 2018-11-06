<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
	<div class="layDIV">
		<dl class="portlet_title sortablePortlet">
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