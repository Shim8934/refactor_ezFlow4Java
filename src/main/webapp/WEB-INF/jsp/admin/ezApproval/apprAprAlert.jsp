<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t84'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	        if (new RegExp(/Chrome/).test(navigator.userAgent)) {
	            window.resizeTo(348, 271);
	        }
	        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            window.resizeTo(348, 271);
	        }
	        if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
	        {
	            window.resizeTo(345, 243);
	        }
	
	        function btn_OpinionOK_onclick() {
	            if (ReturnFunction != null) {
	                if (parent.ezapralert_cross_dialogArgument != undefined)
	                    ReturnFunction();
	                else {
	                    window.close();
	                }
	            }
	            else
	                window.close();
	        }
	
	        var ReturnFunction;
	        var ReturnFunctionName;
	        var closeType = false;
	        window.onload = function () {
	            try {
	                dialogArguments = parent.ezapralert_cross_dialogArgument[0];
	                ReturnFunction = parent.ezapralert_cross_dialogArgument[1];
	            } catch (e) {
	                try {
	                    dialogArguments = opener.ezapralert_cross_dialogArgument[0];
	                    ReturnFunction = opener.ezapralert_cross_dialogArgument[1];
	                } catch (e) { }
	            }
	
	            document.getElementById("pMessageContent").innerHTML = dialogArguments;
	
	            if (MACSAFARIYN())
	                window.resizeTo(330, 251);
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
	                        <td class="ctxt">
	                            <span id="pMessageContent"></span>
	                        </td>
	                    </tr>
	                </table>
	            </div>
	        </div>
	        <div class="popup_noti_btnarea">
	            <div class="btnposition">
	                <input type="submit" value="<spring:message code='ezApproval.t84'/>" id="btn_OpinionOK" name="btn_OpinionOK" onclick="return btn_OpinionOK_onclick()">
	            </div>
	            <span class="bl"></span><span class="br"></span>
	        </div>
	    </div>
	</body>
</html>