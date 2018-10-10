<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i1', 'msg')}" type="text/css">
		<style>
			#left h2 span {
				display:inline-block;
				width:173px;
				overflow:hidden;
				text-overflow:ellipsis;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			window.onload = function() {
				moveToPage(1);
			}
			
			function moveToPage(idx)
			{
				var url = "";
				switch(idx)
				{
					case 1:
						url = "/admin/ezAttitude/attitudeConfig.do";
						break;
					case 2:
						url = "/admin/ezAttitude/attitudeTypeConfig.do";
						break;
					case 3:
						url = "/admin/ezAttitude/attitudeUserConf.do";
						break;
					case 4:
						url = "/admin/ezAttitude/manageAttModAppList.do";
						break;
					case 5:
						url = "/admin/ezAttitude/attitudeCheck.do";
						break;
					case 6:
						url = "/admin/ezAttitude/attitudeAbsented.do";
						break;
					case 7:
						url = "/admin/ezAttitude/attitudeAuthorManage.do";
						break;
				}
				window.open(url, "attitude_main");
			}
		</script>
	</head>
	<body class="leftbody">
		<div id="left">
			<div class="left_admin" title="attitude"><img src="/images/admin/first.png" width="13px" height="13px"/>&nbsp;<spring:message code='ezAttitude.t1'/></div>
			<h2><span onClick="moveToPage(1)"><spring:message code = 'ezAttitude.t2' /></span><ul></ul></h2>
			<h2><span onClick="moveToPage(2)"><spring:message code = 'ezAttitude.t3' /></span><ul></ul></h2>
			<h2><span onClick="moveToPage(3)"><spring:message code = 'ezAttitude.t4' /></span><ul></ul></h2>
			<h2><span onClick="moveToPage(4)"><spring:message code = 'ezAttitude.t7' /></span><ul></ul></h2>
			<h2><span onClick="moveToPage(5)"><spring:message code = 'ezAttitude.t5' /></span><ul></ul></h2>
			<h2><span onClick="moveToPage(6)"><spring:message code = 'ezAttitude.t6' /></span><ul></ul></h2>
			<h2><span onClick="moveToPage(7)"><spring:message code = 'ezAttitude.t8' /></span><ul></ul></h2>
		</div>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>