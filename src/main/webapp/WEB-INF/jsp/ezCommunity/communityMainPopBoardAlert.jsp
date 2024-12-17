<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t108' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		
		<script type="text/javascript">
			 
			function btn_OpinionCANCEL_onclick() {
				window.close();
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
	                        <td class="ctxt" id="pMessageContent">
								<spring:message code="ezCommunity.t1102"/>
							</td>
	                    </tr>
	                </table>
	            </div>
	        </div>
	        
	        <div class="popup_noti_btnarea">
	            <div class="btnposition" style="padding-top:0px;">
	                <input type="submit"  value="<spring:message code = 'ezCommunity.t108' />" id="btn_OpinionCANCEL" onClick="return btn_OpinionCANCEL_onclick()">
	            </div>
	            
	            <span class="bl"></span>
	            <span class="br"></span>
	        </div>
	    </div>
	</body>
</html>