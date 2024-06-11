<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<body>
	<article class="box_shadow">
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">${portletName}</dt>
				<dd class="portletPlus" onclick="window.open('${iframeUrl}')"><img src="/images/ezNewPortal/portlet_Plus1.png"></dd>
			</dl>
			<iframe id="iframePortlet${portletId}" src="${iframeUrl}" style="width: 100%; height: 100%; border: none;"></iframe>
		</div>
	</article>
</body>
</html>