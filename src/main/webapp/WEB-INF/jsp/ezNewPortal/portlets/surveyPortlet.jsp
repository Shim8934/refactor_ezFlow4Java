<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<script type="text/javascript">
	$(function() {
		var portletId = "<c:out value='${portletId }'/>";
		var portletName = "<c:out value='${portletName }'/>";
		ellipsisTitle(portletName, portletId);
	});
</script>
<body>
	<article class="box_shadow survey">
		<div class="layDIV pollLay">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
				</dt>
				<dd class="portletPlus plus" id="surveyPlus"></dd>
			</dl>
			<div class="vote_contents">
				<div id="surveyInfo">
					<ul id="surveyUl" class="portlet_list portletPagingArea">
						<!-- <li class="mail_open" ></li> -->
					</ul>
				</div>
			</div>
		</div>
		<div class="portletPageNav">
			<span class="portlet_list_nav prev"></span>
			<span class="portlet_list_nav next"></span>
		</div>
	</article>
</body>
</html>