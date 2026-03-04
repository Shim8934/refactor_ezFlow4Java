<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t20' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
		var ReturnFunction;
		var callback;
		var ezapralert_cross_dialogArguments = new Array();
		window.onload = function () {
			if (opener != null) {
				pMessageContent.innerHTML = opener.ezapralert_cross_dialogArguments[0];
			} else {
				pMessageContent.innerHTML = parent.ezapralert_cross_dialogArguments[0];
				ReturnFunction = parent.ezapralert_cross_dialogArguments[1];
			}
			//IE 이외에 브라우져에서 창크기 다시 조절
			var UserAgentState = navigator.userAgent.toLowerCase();

			if (!CrossYN()) {
				if (UserAgentState.indexOf("firefox") != -1) {
					window.resizeTo(349, 279);
				} else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
					window.resizeTo(346, 243);
				} else {
					window.resizeTo(346, 269);
				}
			}
		}

		function btn_OpinionOK_onclick() {
			if (ReturnFunction != null) {
				ReturnFunction(callback);
				if (parent.outreason != null) {
					parent.outreason.focus();
				}
			} else {
				window.close();
				window.parent.parent.close();
			}
		}
		</script>
	</head>
	<body style="overflow:hidden;">
		<div class="popup_noti">
	        <div class="popup_noti_title" style="height: 10px;"><span class="tl"></span><span class="tr"></span></div>
	        
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
	                <input type="button" value="<spring:message code = 'ezCommunity.t108' />" id="btn_OpinionOK" onclick="btn_OpinionOK_onclick()">
	            </div>
	            <span class="bl"></span>
	            <span class="br"></span>
	        </div>
	    </div>
	</body>
</html>