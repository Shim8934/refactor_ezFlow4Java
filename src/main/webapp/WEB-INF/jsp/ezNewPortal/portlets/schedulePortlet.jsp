<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
<input id="schedule_usedTheme" type="hidden" value="<c:out value='${usedTheme}'/>">
	<c:choose>
		<c:when test="${usedTheme eq 1}">
			<dl class="portlet_title sortablePortlet" style="position: relative; width: 100%; bottom: 0px; z-index: 998; border-bottom:none; background:none; height: 50px;"></dl>
			<div class= "box_shadow" style="position:relative; bottom:49px; overflow:hidden;">
				<article class="schedule_small box_shadow schedule_calendar" style="box-shadow:none;">
					<div class="layDIV">
						<div class="sCalendarArea">
							<div id="CalendarMini" class="scalender"></div>
						</div>
					</div>
				</article>
	
				<article class="schedule_small box_shadow schedule_scheduleList" style="box-shadow:none;">
					<div class="layDIV">
						<div class="sCalendarArea">
							<dl class="portlet_title portlet_schedule sortablePortlet">
								<dt class="portletText" id="scheduleDateTextDT">
								</dt>
								<dd class="portletPlus plus" onclick="goSchedule();" style="position: relative; z-index: 999;"></dd>
								<dd class="portletPlus portlet_cal" style="position: relative; z-index: 999;">
									<input type="text" class="DatePicker_class" name="scheduleSdatepicker" id="scheduleSdatepicker"  size="10" readonly="readonly">
								</dd>
							</dl>
							<div id="scheduleList" class="sschedule_list">
							</div>

						</div>
					</div>
				</article>
			</div>
		</c:when>
		<c:when test="${usedTheme eq 3}">
			<dl class="portlet_title sortablePortlet" style="position: relative; width: 100%; bottom: 0px; z-index: 998; border-bottom:none; background:none;"></dl>
			<div class="box_shadow" style="position:relative; bottom:53px; overflow:hidden;"  box-shadow: 0px 1px 5px 0px rgba(0, 0, 0, 0.10); border-radius: 20px;">
				<article class="schedule_small box_shadow schedule_calendar">
					<div class="layDIV">
						<div class="sCalendarArea">
							<div id="CalendarMini" class="scalender"></div>
						</div>
					</div>
				</article>
	
				<article class="schedule_small box_shadow schedule_scheduleList">
					<div class="layDIV">
						<div class="sCalendarArea">
							<dl class="portlet_title portlet_schedule sortablePortlet">
								<dt class="portletText" id="scheduleDateTextDT">
								</dt>
								<dd class="portletPlus plus" onclick="goSchedule();" style="position: relative; z-index: 999;"></dd>
								<dd class="portletPlus portlet_cal" style="position: relative; z-index: 999;">
									<input type="text" class="DatePicker_class" name="scheduleSdatepicker" id="scheduleSdatepicker"  size="10" readonly="readonly">
								</dd>
							</dl>
							<div id="scheduleList" class="sschedule_list">
							</div>

						</div>
					</div>
				</article>
			</div>
		</c:when>
		<c:otherwise>
			<dl class="portlet_title sortablePortlet" style="position: relative; width: 100%; bottom: 0px; z-index: 998; border-bottom:none; background:none;"></dl>
			<div class="box_shadow" style="position:relative; bottom:53px; overflow:hidden;">
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
							<dl class="portlet_title portlet_schedule sortablePortlet">
								<dt class="portletText" id="scheduleDateTextDT">
								</dt>
								<dd class="portletPlus plus" onclick="goSchedule();" style="position: relative; z-index: 999;"></dd>
								<dd class="portletPlus portlet_cal" style="position: relative; z-index: 999;">
									<input type="text" class="DatePicker_class" name="scheduleSdatepicker" id="scheduleSdatepicker"  size="10" readonly="readonly">
								</dd>
							</dl>
							<div id="scheduleList" class="sschedule_list">
							</div>

						</div>
					</div>
				</article>
			</div>
		</c:otherwise>
	</c:choose>
	<%-- <article class="box_shadow">
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
			</article>			 --%>
	
	<script>
	 
	</script>
	
</body>
</html>