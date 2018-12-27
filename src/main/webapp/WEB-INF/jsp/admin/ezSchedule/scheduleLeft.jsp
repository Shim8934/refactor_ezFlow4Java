<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>left_schedule</title>
		<link rel="stylesheet" href="${util.addVer('ezSchedule.e3', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<style>
			#mCSB_1_container {
				margin-right: 0px;
			} 
		</style>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
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
				        url = "/admin/ezSchedule/scheduleAdminHolidayTab.do";
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
			
			$(document).ready(function() {
				leftResize();
		        $(".adminListBox").mCustomScrollbar({
		    		theme : "dark"
		    	});
			});
	        
	        function leftResize(){
	        	$(".adminListBox").height(window.innerHeight-58);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
	    	});
		</script>
	
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
  			<div class="admin_left_title" title="<spring:message code='ezSchedule.t14' />"><spring:message code='ezSchedule.t1010' /></div> 
  			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
	  			<h2><span style="display:inline-block;width:100%;" onClick="goPage(2)"><spring:message code='ezSchedule.t36' /></span></h2>
	  			<h2><span style="display:inline-block;width:100%;" onClick="goPage(3)"><spring:message code='ezSchedule.t4003' /></span></h2>
	  			<c:if test="${lang != 3}">
		  			<h2><span style="display:inline-block;width:100%;" onClick="goPage(4)"><spring:message code='ezSchedule.t6000' /></span></h2>
	  			</c:if>
	  			<h2><span style="display:inline-block;width:100%;" onClick="goPage(5)"><spring:message code='ezSchedule.t9990007' /></span></h2>
  			</div>
		</div>
	</body>
</html>