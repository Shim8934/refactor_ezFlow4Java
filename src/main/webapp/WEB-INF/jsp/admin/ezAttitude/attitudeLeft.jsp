<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	</head>
	<body class="leftbody">
		<div id="left">
			<div class="left_admin" title="attitude"><img src="" width="16px" height="16px"/>&nbsp;<spring:message code='f'/></div>
			<h2><span style="display:inline-block; width:100%;" onClick="goPage(1)">1</span><ul></ul></h2>
			<h2><span style="display:inline-block; width:100%;" onClick="goPage(2)">2</span><ul></ul></h2>
			<h2><span style="display:inline-block; width:100%;" onClick="goPage(3)">3</span><ul></ul></h2>
			<h2><span style="display:inline-block; width:100%;" onClick="goPage(4)">4</span><ul></ul></h2>
		</div>
	</body>
</html>