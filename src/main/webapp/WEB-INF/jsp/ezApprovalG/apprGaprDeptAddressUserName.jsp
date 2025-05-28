<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t341'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script ID="clientEventHandlersJS" LANGUAGE="javascript">
		    var pUserID;
		    var pFormID;
		    var ConnectFlag = true;
		    var Resultxml = createXmlDom();
		    function btn_SaveAprDeptTempletName_onclick() {
		        var p_AprDeptTempletName = document.getElementById("TxtAprDeptTempletName").value;
		        if (p_AprDeptTempletName == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t342'/>";
		            OpenAlertUI(pAlertContent);
		            document.getElementById("TxtAprDeptTempletName").focus();
		        }
		        else {
		            if (!CheckLen(document.getElementById("TxtAprDeptTempletName"), 100)) {
		                return;
		            }
		
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
		        try {
		            RetValue = parent.aprdeptaddressusername_cross_dialogArguments[0];
		            ReturnFunction = parent.aprdeptaddressusername_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.aprdeptaddressusername_cross_dialogArguments[0];
		                ReturnFunction = opener.aprdeptaddressusername_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        document.getElementById("TxtAprDeptTempletName").value = RetValue;
		        document.getElementById("TxtAprDeptTempletName").focus();
		    };
		    window.onunload = function () {
		    };
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
		
		    function CheckLen(pObj, pSize) {
		        var ch;
		        var count = 0;
		        var pKoreanLen = parseInt(parseInt(pSize) / 2, 10);
		        var nlen = pObj.value.length;
		        for (var k = 0; k < nlen; k++) {
		            ch = pObj.value.charAt(k);
		            if (escape(ch).length > 4)
		                count += 2;
		            else
		                count++;
		        }
		        if (parseInt(count) > parseInt(pSize)) {
		            alert("<spring:message code='ezApprovalG.t343'/>" + pSize + " byte <spring:message code='ezApprovalG.t344'/>" + pKoreanLen + " <spring:message code='ezApprovalG.t345'/>");
		            pObj.focus();
		            return false;
		        }
		        else
		            return true;
		
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t341'/></h1>
		<div id="close">
            <ul>
                <li><span name="btn_CancelAprLineTempletName" id="btn_CancelAprLineTempletName" onclick="return btn_CancelAprDeptTempletName_onclick()"></span></li>
            </ul>
        </div>
		<h2><spring:message code='ezApprovalG.t346'/></h2>
		<div ID="Table2"  class="nobox"> 
		<input class="text" type="text" id="TxtAprDeptTempletName" style="width:100%">
		</div>
		<div class="btnposition btnpositionNew" ID="Table3">
			<a class="imgbtn" name="btn_SaveAprLineTempletName" id="btn_SaveAprLineTempletName" onClick="return btn_SaveAprDeptTempletName_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>