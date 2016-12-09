<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t84'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script id="clientEventHandlersJS">
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	        if (new RegExp(/Chrome/).test(navigator.userAgent)) {
	            window.resizeTo(347, 270);
	        }
	        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            window.resizeTo(348, 271);
	        }
	        if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
	            window.resizeTo(345, 243);
	        }
	
	        var ReturnFunction;
	        var ReturnFunctionName;
	        var closeType = false;
	        window.onload = function () {
	            try
	            {
	                if ("<%= type %>" == "") {
	                    document.getElementById("pMessageContent").innerHTML = parent.ezapropinion_cross_dialogArgument[0];
	                    ReturnFunction = parent.ezapropinion_cross_dialogArgument[1];
	                    ReturnFunctionName = parent.ezapropinion_cross_dialogArgument[2];
	                }
	                else {
	                    document.getElementById("pMessageContent").innerHTML = opener.ezapropinion_cross_dialogArgument[0];
	                    ReturnFunction = opener.ezapropinion_cross_dialogArgument[1];
	                    ReturnFunctionName = opener.ezapropinion_cross_dialogArgument[2];
	                    closeType = true;
	                }
	                document.getElementById("Submit1").focus();
	            }
	            catch(e)
	            {
	                document.getElementById("pMessageContent").innerHTML = dialogArguments;
	                document.getElementById("Submit1").focus();
	                window.returnValue = false;
	            }
	
	            if (MACSAFARIYN())
	                window.resizeTo(330, 251);
	        }
	
	        function btn_OpinionOK_onclick() {
	            if (ReturnFunction != null)
	            {
	                if (closeType)
	                    window.close();
	
	                ReturnFunction(true, ReturnFunctionName);
	            }
	            else {
	                window.returnValue = true;
	                window.close();
	            }
	        }
	
	        function btn_OpinionCANCEL_onclick() {
	            if (ReturnFunction != null) {
	                if(closeType)
	                    window.close();
	
	                ReturnFunction(false, ReturnFunctionName);
	            }
	            else {
	                window.returnValue = false;
	                window.close();
	            }
	        }
	
	    </script>
	</head>
	<body style="overflow: hidden;">
	    <div class="popup_noti">
	        <div class="popup_noti_title" style="height: 10px;"><span class="tl"></span><span class="tr"></span></div>
	        <div class="popup_noti_content">
	            <div style="padding: 10px;">
	                <table>
	                    <tr>
	                        <td class="cimg"></td>
	                        <td class="ctxt"><span id="pMessageContent"></span></td>
	                    </tr>
	                </table>
	            </div>
	        </div>
	        <div class="popup_noti_btnarea">
	            <div class="btnposition">
	                <input type="submit" value="<spring:message code='ezApproval.t84'/>" name="btn_OpinionOK" id="Submit1" onclick="return btn_OpinionOK_onclick()">
	                <input type="submit" value="<spring:message code='ezApproval.t85'/>" name="btn_OpinionCANCEL" id="Submit2" onclick="return btn_OpinionCANCEL_onclick()">
	            </div>
	            <span class="bl"></span><span class="br"></span>
	        </div>
	    </div>
	     
	</body>
</html>