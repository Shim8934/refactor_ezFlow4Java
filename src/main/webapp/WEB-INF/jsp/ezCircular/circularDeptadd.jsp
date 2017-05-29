<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t40' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circular_write_Cross.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
	    <!-- data picker-->		
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	    <script type="text/javascript">
	    	var userid = "";
    		var circularBMId = "${circularBMId}";
    		
	    	window.onload = function() {
	    		window.resizeTo(450 + (window.outerWidth - window.innerWidth), 275 + (window.outerHeight - window.innerHeight));
	    		try {
	                ReturnFunction = opener.schedule_admin_popup_sharedept_dialogArguments[1];
	            } catch (e) {}
	    	}	
	    
	    	function save_info() {
	    		if ($("#title").val().length < 1) {
	    			alert("<spring:message code='ezCircular.t52'/>")
	    			return;
	    		}
	    		
	    		if (g_attendant == null) {
	    			alert("<spring:message code='ezCircular.t53'/>")
	    			return;
	    		}
	    		
	    		var title = document.getElementById("title").value;
	    		var memberListStr = new Array();
	    		
	    		for (var i=0; i<g_attendant["id"].length; i++) {
	    			memberListStr[i] = g_attendant["id"][i];
	    		}	    
	    		
	    		var url = ""
	    		
	    		if (circularBMId != "") {
	    			url = "/ezCircular/circularDeptSave.do?circularBMId=" + circularBMId;
	    		} else {
	    			url = "/ezCircular/circularDeptSave.do";
	    		}
	    		
	    		$.ajax({
	    			method : "POST",
	    			dataType : "text",
	    			async : false,
	    			url : url,
	    			data : {
	    				title : title,
	    				memberListStr : memberListStr
	    			},
	    			success : function() {
						alert("<spring:message code='ezCircular.t63' />");
	        			
		                if (ReturnFunction != null) {
		                    ReturnFunction("OK");
		                } else {
		                    window.returnValue = "OK";
		                }	                
		                window.close();
	    			},
	    			error : function(err) {
	    				alert("<spring:message code='ezCircular.t64' />");
	    			}
	    			
	    		})
	    		
	    		opener.location.reload();
	    	}
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezCircular.t36' /></h1>
	    <table class="content">
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezCircular.t37' /></th>
	            <td>
	                <input id="title" type="text" style="margin-bottom:2px; width:100%;"/>
	            </td>
	        </tr>
	        <tr>
	            <th style="width:200px; text-align:center"><spring:message code='ezCircular.t38' /></th>
	            <td>
	            	<input type="hidden" name="Input" id="receiverinput" style="WIDTH: 30%;-moz-box-sizing:border-box;box-sizing:border-box;" onkeyup="return _on_keydown(event)">
	                <a href="#" id="imgbutton" class="imgbtn"><span id="clickbtn" onclick="_manage_attendant()"><spring:message code='ezCircular.t39' /></span></a>
	            </td>
	        </tr>
	        <tr>
	        	<th style="width:200px; text-align:center"><spring:message code='ezCircular.t38' /></br><spring:message code='ezCircular.t42' /></th>
	        	<td>
		        	<div id="receiverlist" style="OVERFLOW-Y: auto; HEIGHT: 100px"/></div>
		        	<div id="receiverID" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
	        	</td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="save_info()" ><spring:message code='ezCircular.t25' /></span></a>
	        <a class="imgbtn"><span onclick="window.close()"><spring:message code='ezCircular.t26' /></span></a>      
	    </div>
	</body>
</html>