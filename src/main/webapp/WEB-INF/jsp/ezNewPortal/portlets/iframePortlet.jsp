<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<body>
	<script type="text/javascript">
		$(function() {
			var portletId = "<c:out value="${portletId}"/>";
			var portletName = "<c:out value="${portletName}"/>";
			ellipsisTitle (portletName, portletId);
		})
	</script>
	<article class="box_shadow">
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">${portletName}</dt>
				<dd class="portletPlus plus" onclick="window.open('${iframeUrl}')"></dd>
			</dl>
			<iframe id="iframePortlet${portletId}" src="${iframeUrl}" style="width: 100%; height: calc(100% - 53px); border: none;"></iframe>
		</div>
	</article>
</body>
</html>