<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t108' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<script type="text/javascript">
			var ReturnFunction;
			var ReturnFunctionName;
			window.onload = function() {
// 				try {
//                     RetValue = parent.ezapropinion_cross_dialogArguments[0];
//                     ReturnFunction = parent.ezapropinion_cross_dialogArguments[1];
//                 } catch (e) {
//                     try {
//                         RetValue = opener.ezapropinion_cross_dialogArguments[0];
//                         ReturnFunction = opener.ezapropinion_cross_dialogArguments[1];
//                     } catch (e) {
//                         RetValue = window.dialogArguments;
//                     }
//                 }
                
				try {
			        document.getElementById("pMessageContent").innerHTML = parent.ezapropinion_cross_dialogArguments[0];
			        ReturnFunction = parent.ezapropinion_cross_dialogArguments[1];
			        ReturnFunctionName = parent.ezapropinion_cross_dialogArguments[2];
			    } catch (e) {
			        try {
			            document.getElementById("pMessageContent").innerHTML = opener.ezapropinion_cross_dialogArguments[0];
			            ReturnFunction = opener.ezapropinion_cross_dialogArguments[1];
			            ReturnFunctionName = opener.ezapropinion_cross_dialogArguments[2];
			        } catch (e) {
			            pMessageContent.innerHTML = dialogArguments;
			            window.returnValue = false;
			        }
			    }
			    
				var UserAgentState = navigator.userAgent.toLowerCase();
		        
		        if (CrossYN()) {
		        	if (UserAgentState.indexOf("chrome") > 0) {
		        		window.resizeTo(346, 270);
		        	} else {
		        		window.resizeTo(346, 270);
		        	}
		        } else {
		        	if (UserAgentState.indexOf("firefox") != -1) {
		                window.resizeTo(349, 279);
		            } else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
		                window.resizeTo(346, 243);
		            } else {
		            	window.resizeTo(346, 270);
		            }
		        }
		        
		        if (MACSAFARIYN()) {
		            window.resizeTo(330, 251);
		        }
			}
			
			function btn_OpinionOK_onclick() {
			    if (ReturnFunction != null) {
			        ReturnFunction(true, ReturnFunctionName);
			        window.close();
			    }
			    else {
			        window.returnValue = true;
			        window.close();
			    }
			}


			function btn_OpinionCANCEL_onclick() {
			    if (ReturnFunction != null) {
			        window.close();
			        ReturnFunction(false, ReturnFunctionName);
			    } else {
			        window.returnValue = false;
			        window.close();
			    }
			}
		</script>
	</head>
	<body style="overflow:hidden;">
		<div class="popup_noti">
	        <div class="popup_noti_title" style="height: 10px;">
	        	<span class="tl"></span>
	        	<span class="tr"></span>
	        </div>
	        
	        <div class="popup_noti_content">
	            <div style="padding: 10px;">
	                <table width="300">
	                    <tr>
	                        <td class="cimg"></td>
	                        <td class="ctxt" id="pMessageContent"></td>
	                    </tr>
	                </table>
	            </div>
	        </div>
	        
	        <div class="popup_noti_btnarea">
	            <div class="btnposition">
	                <input type="submit"  value="<spring:message code = 'ezCommunity.t108' />" id="btn_OpinionOK" onClick="return btn_OpinionOK_onclick()">
	                <input type="submit"  value="<spring:message code = 'ezCommunity.t109' />" id="btn_OpinionCANCEL" onClick="return btn_OpinionCANCEL_onclick()">
	            </div>
	            
	            <span class="bl"></span>
	            <span class="br"></span>
	        </div>
	    </div>
	</body>
</html>