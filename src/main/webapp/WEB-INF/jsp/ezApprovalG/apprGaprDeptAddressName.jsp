<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t338'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
	        var pUserID;
	        var pFormID;
	        var ConnectFlag = true;
	        var Resultxml = createXmlDom();
	        function btn_SaveAprDeptTempletName_onclick() {
	            var p_AprDeptTempletName = TxtAprDeptTempletName.value;
	            if (p_AprDeptTempletName == "") {
	                var pAlertContent = "<spring:message code='ezApprovalG.t339'/>";
	            OpenAlertUI(pAlertContent);
	
	            TxtAprDeptTempletName.focus();
		        } else {
		            if (ReturnFunction != null) {
		                ReturnFunction(p_AprDeptTempletName);
		            }
		            else {
		                window.returnValue = p_AprDeptTempletName;
		                window.close();
		            }
		        }
		    }
		    function btn_CancelAprDeptTempletName_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction("cancel");
		        }
		        else {
		            window.returnValue = "cancel";
		            window.close();
		        }
		    }
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        document.getElementById('TxtAprDeptTempletName').focus();
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("TxtAprDeptTempletName"));
		            }
		        }
		        catch (e)
		        { }
		
		        try {
		            RetValue = parent.aprdeptaddressname_cross_dialogArguments[0];
		            ReturnFunction = parent.aprdeptaddressname_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.aprdeptaddressname_cross_dialogArguments[0];
		                ReturnFunction = opener.aprdeptaddressname_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		    }
		
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		
		    function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) {
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
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
		<h1><spring:message code='ezApprovalG.t338'/></h1>
	    <h2><spring:message code='ezApprovalG.t340'/></h2>
	    <div class="nobox" id="Table2">
	        <input class="text" type="text" id="TxtAprDeptTempletName" name="TxtAprDeptTempletName" style="width: 100%">
	    </div>
	    <div class="btnposition">
	        <input type="submit" name="btn_SaveAprLineTempletName" id="btn_SaveAprLineTempletName" value="<spring:message code='ezApprovalG.t20'/>" onclick="return btn_SaveAprDeptTempletName_onclick()">
	        <input type="submit" name="btn_CancelAprLineTempletName" id="btn_CancelAprLineTempletName" value="<spring:message code='ezApprovalG.t119'/>" onclick="return btn_CancelAprDeptTempletName_onclick()">
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="/myoffice/blank.htm" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>