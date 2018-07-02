<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
	<c:if test ="${approvalFlag =='G'}">
		<title><spring:message code='ezApprovalG.t308'/></title>
	</c:if>
	<c:if test = "${approvalFlag == 'S'}" >
		<title><spring:message code='ezApprovalG.G0009'/></title>
	</c:if>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AprDeptTempletName_Cross.js"></script>
		<script ID="clientEventHandlersJS" LANGUAGE="javascript">
		    var pUserID;
		    var pFormID;
		    var pDeptTempletName = "";
		    var ConnectFlag = true;
		    var Resultxml = createXmlDom();
		    var approvalFlag = "${approvalFlag}";
		    function btn_SaveAprDeptTempletName_onclick() {
		        var p_AprDeptTempletName = TxtAprDeptTempletName.value;
		
		        if (p_AprDeptTempletName == "") {
		            //var pAlertContent = "<spring:message code='ezApprovalG.t309'/>";
		            //parent.OpenAlertUI(pAlertContent);	
		           if(approvalFlag == "S") {
		            	alert("<spring:message code='ezApprovalG.t309'/>");
		           } else {
		        	   alert("<spring:message code='ezApprovalG.t311'/>");
		           }
		            
		            TxtAprDeptTempletName.focus();
		        }
		        else if (p_AprDeptTempletName.length > 7) {
		            //var pAlertContent = "<spring:message code='ezApprovalG.t310'/>";
		            //OpenAlertUI(pAlertContent);
		            alert("<spring:message code='ezApprovalG.t310'/>");
		            TxtAprDeptTempletName.focus();
		        } else {
		            AprDeptTempletNameCheck(p_AprDeptTempletName);
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
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("TxtAprDeptTempletName"));
		            }
		        }
		        catch (e) { }
		
		        try {
		            RetValue = parent.aprdepttempletname_cross_dialogArguments[0];
		            ReturnFunction = parent.aprdepttempletname_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.aprdepttempletname_cross_dialogArguments[0];
		                ReturnFunction = opener.aprdepttempletname_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        pUserID = RetValue[0];
		        pFormID = RetValue[1];
		        if (typeof (RetValue[2]) != "undefined") {
		            pDeptTempletName = RetValue[3];
		            TxtAprDeptTempletName.value = pDeptTempletName;
		        }
		        TxtAprDeptTempletName.focus();
		    }
		</script>
	</head>
	<body class="popup">
		<h1>	
			<c:if test ="${approvalFlag =='G'}">
				<spring:message code='ezApprovalG.t308'/></title>
			</c:if>
			<c:if test = "${approvalFlag == 'S'}" >
				<spring:message code='ezApprovalG.G0009'/>
			</c:if>
		</h1>
		<div id="close">
            <ul>
                <li><span onclick="return btn_CancelAprDeptTempletName_onclick()"></span></li>
            </ul>
        </div>
		<span>▒ <c:if test ="${approvalFlag =='G'}"><spring:message code='ezApprovalG.t311'/></c:if><c:if test ="${approvalFlag =='S'}"><spring:message code='ezApproval.t199'/></c:if></span>
		<div class="nobox" style="margin-top:7px">
		<input class="text" type="text" id="TxtAprDeptTempletName" name="TxtAprDeptTempletName" style="width:100%;border:1px solid #ccc;height:25px" maxlength="7">
		</div>
		<div class="btnposition btnpositionNew">
			<input type="submit" name="btn_SaveAprLineTempletName" id="btn_SaveAprLineTempletName" value="<spring:message code='ezApprovalG.t20'/>" onClick="return btn_SaveAprDeptTempletName_onclick()">
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>