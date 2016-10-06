<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value = '${clubName}' /> <spring:message code = 'ezCommunity.t1077' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<style type="text/css">
			.message {
                height:70px;
            }
		</style>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<script type="text/javascript">
			if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        }
		    }
			
			function join_OK() {
				window.location.href="/ezCommunity/agreeOk.do?code=<c:out value = '${no}' />";
			}
			
			window.onload = function () {
			    document.getElementById("pMessageContent").innerHTML = "<spring:message code = 'ezCommunity.t1078' />" + "<br />" + "<spring:message code = 'ezCommunity.t1079' />";
	
 				var UserAgentState = navigator.userAgent.toLowerCase();
		        
		        if (CrossYN()) {
		        	if (UserAgentState.indexOf("chrome") > 0) {
		        		window.resizeTo(340, 260);
		        	} else {
		        		window.resizeTo(346, 270);
		        	}
		        } else {
		        	if (UserAgentState.indexOf("firefox") != -1) {
		                window.resizeTo(349, 279);
		            } else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
		                window.resizeTo(346, 243);
		            } else {
		            	window.resizeTo(346, 240);
		            }
		        }
		        
		        if (MACSAFARIYN()) {
		            window.resizeTo(330, 251);
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
              				<td class="cimg"></td>
              				<td class="ctxt">
                  				<span id="pMessageContent"></span>
              				</td>
            			</tr>
     				</table>
 	    		</div>
        	</div>
        	
    		<div class="popup_noti_btnarea"> 
   	    		<div class="btnposition"> 
		            <input type="submit" value="<spring:message code = 'ezCommunity.t108' />" onclick="return join_OK()">
		            <input type="submit" value="<spring:message code = 'ezCommunity.t109' />" onclick="return self.close()">
			    </div>
			    
    			<span class="bl"></span>
    			<span class="br"></span>
    		</div>
    	</div>
	</body>
</html>