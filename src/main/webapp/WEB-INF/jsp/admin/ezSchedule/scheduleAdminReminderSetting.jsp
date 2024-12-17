<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t6000' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	    <script type="text/javascript">		    
		    $(document).ready(function() {	
			    $('#allDaySTimeForReminder').timepicker({ 
	    			timeFormat: 'H:i',
	    			step: 30,
	    			scrollbar: true
	    		});
			    
			    $('#allDaySTimeForReminder').val('<c:out value="${allDaySTimeForReminder}"/>');
		    });
		    
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
			
		    function cancelClick() {
		        window.location.reload(true);
		    }
			
		  //시간 체크
		    function checkPattern() {
				var timePattern = /^([01][0-9]|2[0-3]):([0-5][0-9])$/;
				
				if (timePattern.test($("#allDaySTimeForReminder").val())) {
					return true;
				} else {
					$("#allDaySTimeForReminder").focus();
					return false;
				}
			}

		    function saveReminderConfig() {
		    	if (!checkPattern()) {
	    			alert("<spring:message code='ezSchedule.admin.hth12' />");
	    			return;
	    		}
		    	
			  	$.ajax({
		          	type : "POST",
		          	url : "/admin/ezSchedule/updateAllDaySTimeForReminder.do",
		          	dataType : "text",
		          	data : {
		          			allDaySTimeForReminder : $("#allDaySTimeForReminder").val(),
		          	},
		          	success : function(resultStatus) {
		          		if (resultStatus == "ok") {
		           			alert("<spring:message code='ezAttitude.t155' />");
		          		} else {
		          			alert("<spring:message code='ezAttitude.t175' />");
		          		}
		          	},
		          	error : function() {
		          		alert("<spring:message code='ezAttitude.t175' />");
		          	}
			     });
		    	
		    	
		    }
		</script>
	</head>
	<body class="mainbody"> 
		<h1><spring:message code='ezSchedule.admin.hth10' /></h1>
		<table class="content" style="width: 250px;">
		    <tr>
		        <th><spring:message code='ezSchedule.admin.hth11' /></th>
		        <td>
		        	<input id="allDaySTimeForReminder" type="text" style="width:50px; ime-mode:disabled;" oninput="this.value=this.value.replace(/[^0-9.\:]/g, '')"/> 
		        </td>
		    </tr>
		</table>
		<div class="btnpositionJsp" style="width: 250px">
		    <a class="imgbtn" onclick="saveReminderConfig()"><span><spring:message code='ezSchedule.t157' /></span></a>
		    <a class="imgbtn" onclick="cancelClick()"><span><spring:message code='ezSchedule.t5' /></span></a>
		</div>
	</body>
</html>

