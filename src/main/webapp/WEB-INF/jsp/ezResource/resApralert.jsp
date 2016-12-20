<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t15"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezResource.e2"/>" type="text/css" />
		<script type="text/javascript" id="clientEventHandlersJS" >
			if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	        	window.onblur = function () {
	            	window.focus();
	        	}
	    	}

	    	var ReturnFunction;    

	    	function btn_OpinionOK_onclick() {
	        	if (ReturnFunction != null) {
	        		ReturnFunction();	
	        	} else {
		        	window.close();
		        }
		    }

		    window.onload = function () {
	    	    try {
	        	    dialogArguments = parent.apralert_cross_dialogArguments[0];
		            ReturnFunction = parent.apralert_cross_dialogArguments[1];
	        	} catch (e) { }

	        	document.getElementById("pMessageContent").innerHTML = dialogArguments;

	        	var UserAgentState = navigator.userAgent.toLowerCase();
	        	var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	        	
	        	if (!browserIE) {
		            if (UserAgentState.indexOf("firefox") != -1) {
		                window.resizeTo(349, 279);
	            	} else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
	                	window.resizeTo(346, 243);
	            	} else {
	            		window.resizeTo(346, 269);	
	            	}
		        }
	    	}
		</script>
	</head>
	<body style="overflow:hidden;">
		<div class="popup_noti">
			<div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
 			<div class="popup_noti_content">
       			<div  style="padding:10px;">
      				<table>
        				<tr>
          					<td  class="cimg"></td>
          					<td  class="ctxt" id= "pMessageContent" ></td>
        				</tr>
 					</table>
 				</div>
    		</div>
			<div class="popup_noti_btnarea"> 
   	  			<div class="btnposition"> 
            		<input type='button' id='0' style='' value="<spring:message code="ezResource.t15"/>" onclick='btn_OpinionOK_onclick()'>     
				</div>
				<span class="bl"> </span> <span class="br"></span>
			</div>
		</div>
	</body>
</html>