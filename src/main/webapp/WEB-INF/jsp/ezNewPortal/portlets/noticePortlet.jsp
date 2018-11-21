<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
<head>
</head>
<body>
	<article class="notice box_shadow">
	<div class="layDIV">
		<dl class="portlet_title sortablePortlet">
			<dt class="portletText"><spring:message code='ezNewPortal.t044' /></dt>
			<dd class="portletPlus" id="noticePlus">
				<img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png">
			</dd>
		</dl>
		<div id="BoardList_NewBoard">
		</div>
		<ul class="noti_portlet_list" id="BoardList_NewBoard">
		</ul>
	</div>
	</article>
</body>
</html>