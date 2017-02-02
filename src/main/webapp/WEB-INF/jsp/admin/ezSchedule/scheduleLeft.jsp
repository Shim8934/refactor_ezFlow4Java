<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>left_schedule</title>
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript">
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };

			function goPage(idx) {
				var url = "";
				switch(idx) {
					case 1:
						url = "/admin/ezSchedule/scheduleAdminShareManage.do";
						break;
					case 2:
						url = "/admin/ezSchedule/scheduleAdminShareManage.do";
						break;
				    case 3:
				        url = "/admin/ezSchedule/scheduleAdminHolidayManage.do";
				        break;
				    case 4:
				        url = "/admin/ezSchedule/scheduleAdminLunarUse.do";
				        break;
				    case 5:
				        url = "/admin/ezSchedule/scheduleAdminRegi.do";
				        break;    
				}			
				window.open(url,"right");
			}           
		</script>
	
	</head>
	<body class="leftbody">
		<div id="left">
  			<div class="left_admin" title="<spring:message code='ezSchedule.t14' />"><spring:message code='ezSchedule.t1010' /></div> 
  			<h2><span style="display:inline-block;width:100%;" onClick="goPage(2)"><spring:message code='ezSchedule.t36' /></span><ul></ul></h2>
  			<h2><span style="display:inline-block;width:100%;" onClick="goPage(3)"><spring:message code='ezSchedule.t4003' /></span><ul></ul></h2>
  			<h2><span style="display:inline-block;width:100%;" onClick="goPage(4)"><spring:message code='ezSchedule.t6000' /></span><ul></ul></h2>
  			<h2><span style="display:inline-block;width:100%;" onClick="goPage(5)"><spring:message code='ezSchedule.t6001' /></span><ul></ul></h2>
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>