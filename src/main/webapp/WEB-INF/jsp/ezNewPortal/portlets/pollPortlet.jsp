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
		var portletName = "<c:out value='${portletName }'/>";
		ellipsisTitle(portletName, 5);
	});
</script>
<body>
	<article class="box_shadow">
		<div class="layDIV pollLay" style="height: 100%;">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
				</dt>
				<dd class="portletPlus plus" id="pollPlus"></dd>
			</dl>
			<div class="vote_contents" id="pollInfo">
<!-- 				<div id="pollInfo"></div> -->
			</div>
		</div>
	</article>
</body>
</html>