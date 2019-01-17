<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
	<article class="box_shadow">
		<div class="layDiv pollLay">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
					<c:out value='${portletName }'/>
				</dt>
				<dd class="portletPlus" id="pollPlus">
					<img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png">
				</dd>
			</dl>
			<div class="vote_contents">
			<div id="pollInfo"></div>
			</div>
		</div>
	</article>
</body>
</html>