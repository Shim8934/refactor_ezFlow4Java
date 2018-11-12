<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
<input id="schedule_usedTheme" type="hidden" value="${usedTheme}">
	<c:choose>
		<c:when test="${usedTheme eq 3}">
			<article class="schedule_small box_shadow schedule_calendar">
				<div class="layDIV">
					<div class="sCalendarArea">
						<div id="CalendarMini" class="scalendar"></div>
					</div>
				</div>
			</article>

			<article class="schedule_small box_shadow schedule_scheduleList">
				<div class="layDIV">
					<div class="sCalendarArea">
						<dl class="portlet_title portlet_schedule">
							<dt class="portletText">
								<spring:message code='main.t203' />
							</dt>
							<dd class="portletPlus" onclick="goSchedule();">
								<img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png">
							</dd>
						</dl>
						<div id="scheduleList" class="sschedule_list">
						</div>
					</div>
				</div>
			</article>
		</c:when>
		<c:otherwise>
			<article class="box_shadow">
			<div class="layDIV">
				<dl class="portlet_title sortablePortlet">
					<dt class="portletText">
						<spring:message code='main.t203' />
					</dt>
					<dd class="portletPlus" onclick="goSchedule();">
						<img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png">
					</dd>
				</dl>
				<div class="sCalendarArea">
					<div id="CalendarMini" class="scalender"></div>
					<div id="scheduleList" class="sschedule_list"></div>
				</div>
			</div>
			</article>			
		</c:otherwise>
	</c:choose>
</body>
</html>