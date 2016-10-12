<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t384'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AprLineTempletName_Cross.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var pUserID;
		    var pFormID;
		    var ConnectFlag = true;
		    var Resultxml = createXmlDom();
		    var g_TemplateSN = "";
		    var g_TemplateName = "";
		    var NonActiveX = "YES";
		
		    function btn_SaveAprLineTempletName_onclick() {
		        var p_AprLineTempletName = document.getElementById("TxtAprLineTempletName").value;
		        if (p_AprLineTempletName == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t387'/>";
		            OpenAlertUI(pAlertContent);
		            if (!CrossYN())
		                document.getElementById("TxtAprLineTempletName").focus();
		
		        } else {
		            AprLineTempletNameCheck(p_AprLineTempletName);
		        }
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		    function btn_CancelAprLineTempletName_onclick() {
		        if (ReturnFunction != null)
		            ReturnFunction("cancel");
		        else
		            window.returnValue = "cancel";
		        window.close();
		    }
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("TxtAprLineTempletName"));
		            }
		        }
		        catch (e)
		        { }
		
		        try {
		            RetValue = parent.aprlinetempletname_cross_dialogArguments[0];
		            ReturnFunction = parent.aprlinetempletname_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.aprlinetempletname_cross_dialogArguments[0];
		                ReturnFunction = opener.aprlinetempletname_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        pUserID = RetValue[0];
		        pFormID = RetValue[1];
		        g_TemplateSN = RetValue[2];
		        g_TemplateName = RetValue[3];
		        if (g_TemplateName != "")
		            document.getElementById("TxtAprLineTempletName").value = g_TemplateName;
		
		        if (!CrossYN())
		            window.returnValue = "cancel";
		
		        document.getElementById("TxtAprLineTempletName").focus();
		    };
		
		    function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
		        {
		            return;
		        }
		        obj.onkeydown = function () {
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
		                return false;
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t384'/></h1>
		<h2><spring:message code='ezApprovalG.t2107'/></h2>
		<div class="nobox">
		<input type="text" class="text" style="width:100%" id="TxtAprLineTempletName" name="TxtAprLineTempletName" maxlength="7">
		</div>		
			
		<div class="btnposition">
		<input type="submit" value="<spring:message code='ezApprovalG.t20'/>" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName" onClick="return btn_SaveAprLineTempletName_onclick()">
		<input type="submit" value="<spring:message code='ezApprovalG.t119'/>" id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName" onClick="return btn_CancelAprLineTempletName_onclick()">
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
