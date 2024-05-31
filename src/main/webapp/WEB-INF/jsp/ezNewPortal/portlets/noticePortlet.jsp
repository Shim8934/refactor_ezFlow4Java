<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
<head>
</head>
<body>
	<input id="noticePortlet_usedTheme" type="hidden" value="<c:out value='${usedTheme}'/>">
	<article class="notice box_shadow">
	<div class="layDIV">
		<dl class="portlet_title sortablePortlet">
			<dt class="portletText"><c:out value='${portletName }'/></dt>
			<dd class="portletPlus" id="noticePlus">
				<img src="/images/ezNewPortal/portlet_Plus<c:out value='${usedTheme}'/>.png">
			</dd>
		</dl>
		<div>
			<ul id="BoardList_NewBoard" class='noti_portlet_list portletPagingArea'></ul>
		</div>
		<ul class="noti_portlet_list">
		</ul>
	</div>
	<span class="portlet_list_nav prev"></span>
	<span class="portlet_list_nav next"></span>
	</article>
</body>
</html>