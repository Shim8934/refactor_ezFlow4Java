<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			
		</script>
	</head>
	<body class="leftbody">
		<div id="left">
			<div class="left_admin" title="attitude"><img src="/images/admin/first.png" width="16px" height="16px"/>&nbsp;<spring:message code='ezAttitude.t1'/></div>
			<h2><span style="display:inline-block; width:100%;" onClick="goPage(1)"><spring:message code = 'ezAttitude.t10' /></span><ul></ul></h2>
			<h2><span style="display:inline-block; width:100%;" onClick="goPage(2)"><spring:message code = 'ezAttitude.t11' /></span><ul></ul></h2>
			<h2><span style="display:inline-block; width:100%;" onClick="goPage(3)"><spring:message code = 'ezAttitude.t12' /></span><ul></ul></h2>
			<h2><span style="display:inline-block; width:100%;" onClick="goPage(4)"><spring:message code = 'ezAttitude.t13' /></span><ul></ul></h2>
			<h2><span style="display:inline-block; width:100%;" onClick="goPage(4)"><spring:message code = 'ezAttitude.t14' /></span><ul></ul></h2>
		</div>
	</body>
</html>