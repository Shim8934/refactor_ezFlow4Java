<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1757'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript">
	        var param = new Array();
	        
	        function btn_OpinionOK_onclick() {
	            if (pMessageContent.value == "") {
	                alert("<spring:message code='ezApprovalG.t1758'/>");
	            	return;
		        }
		        param[0] = true;
		        param[1] = pMessageContent.value;
		
		        window.returnValue = param;
		        window.close();
		    }
	        
		    function btn_OpinionCANCEL_onclick() {
		        window.close();
		    }
		    
		    window.onload = function () {
		        param[0] = false;
		        param[1] = "";
		
		        window.returnValue = param;
		    }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t1759'/></h1>
   	    <div id="close">
            <ul>
                <li><span onclick="return btn_OpinionCANCEL_onclick()"></span></li>
            </ul>
        </div>
	    <div class="nobox">
	        <textarea id="pMessageContent" class="textarea" style="Width: 100%; Height: 140px; font-size: 9pt" name="pMessageContent"></textarea>
	    </div>
	    <div class="btnposition">
	        <input type="button" value="<spring:message code='ezApprovalG.t1760'/>" name="btn_OpinionOK" id="btn_OpinionOK" onclick="return btn_OpinionOK_onclick()">
	        <input type="button" value="<spring:message code='ezApprovalG.t1761'/>" name="btn_OpinionCANCEL" id="btn_OpinionCANCEL" onclick="return btn_OpinionCANCEL_onclick()">
	    </div>
	</body>
</html>