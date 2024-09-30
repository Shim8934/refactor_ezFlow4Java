<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Connection Portlet</title>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
</head>
<body>
	<script type="text/javascript">
		$(function() {
			var portletId = "<c:out value="${portletId}"/>";
			var portletName = "<c:out value="${portletName}"/>";
			ellipsisTitle (portletName, portletId);
		})
	</script>
	<article class="customBoard box_shadow">
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
					<c:out value="${portletName}"/>
				</dt>
			</dl>
			<ul id="connectionPortlet<c:out value='${portletId }'/>" class="portlet_list two_line portletPagingArea">
			</ul>
		</div>
		<div class="portletPageNav">
			<span class="portlet_list_nav prev"></span>
			<span class="portlet_list_nav next"></span>
		</div>
		<input type="hidden" value="<c:out value='${usedTheme }'/>" id="usedTheme${portletId}"/>
	</article>
</body>
</html>