<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
<head>
</head>
<script type="text/javascript">
	$(function() {
		var portletName = "<c:out value='${portletName }'/>";
		ellipsisTitle(portletName, 2);
	});
</script>
<body>
	<input id="noticePortlet_usedTheme" type="hidden" value="<c:out value='${usedTheme}'/>">
	<article class="notice box_shadow">
	<div class="layDIV">
		<dl class="portlet_title sortablePortlet">
			<dt class="portletText"></dt>
			<dd class="portletPlus plus" id="noticePlus"></dd>
		</dl>
		<div>
			<ul id="BoardList_NewBoard" class='noti_portlet_list portletPagingArea'></ul>
			<input type="hidden" id="pageChk">
		</div>
		<ul class="noti_portlet_list">
		</ul>
	</div>
	<div class="portletPageNav">
		<span class="portlet_list_nav prev"></span>
		<span class="portlet_list_nav next"></span>
	</div>
	</article>
</body>
</html>