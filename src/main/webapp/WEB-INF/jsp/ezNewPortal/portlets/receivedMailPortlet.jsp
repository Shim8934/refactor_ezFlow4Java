<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<article class="mail box_shadow">
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
					<spring:message code='main.t00038' />
				</dt>
				<dd class="portletPlus" onclick="Mailmore_btnClick()">
					<img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png">
				</dd>
				<dd class="mailGraph" id="mailGraph"></dd>
			</dl>
			<ul id="MailList" class="portlet_list"></ul>
		</div>
	</article>
</body>
</html>
