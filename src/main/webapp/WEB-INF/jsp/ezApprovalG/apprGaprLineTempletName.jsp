<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<c:if test="${type !=''}">
			<title><spring:message code='ezApprovalG.t6000'/></title>
		</c:if>
		<c:if test="${type ==''}">
			<title><spring:message code='ezApprovalG.t384'/></title>
		</c:if>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AprLineTempletName_Cross.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var pUserID;
		    var pFormID;
		    var ConnectFlag = true;
		    var Resultxml = createXmlDom();
		    var g_TemplateSN = "";
		    var g_TemplateName = "";
		    var type = "<c:out value ='${type}'/>";
		    var approvalFlag = "<c:out value ='${approvalFlag}'/>";
		    
		    function btn_SaveAprLineTempletName_onclick() {
		        var p_AprLineTempletName = document.getElementById("TxtAprLineTempletName").value;
		        if (p_AprLineTempletName.trim() == "") {
		        	var pAlertContent;
		        	if (type == "") {
	                    alert("<spring:message code='ezApprovalG.t2107'/>");
		        	} else {
		        		if (approvalFlag == "G") {
			        		alert("<spring:message code='ezApprovalG.t6003'/>");
		        		} else {
			        		alert("<spring:message code='ezApprovalG.hyj10'/>");
		        		}
		        	}
		        	
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
		        if (ReturnFunction != null) {
		            ReturnFunction("cancel");
		        } else {
		            window.returnValue = "cancel";
			        window.close();
		        }
		    }
		    
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {		
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
		        
		        // 한글 입력시 maxlength + 1이 입력되는 현상 제어
			    $("#TxtAprLineTempletName").keyup( function(e){
			    	var maxlength = $(this).prop("maxlength");
			    	if ($(this).val().length >= maxlength) {
			    		$(this).val($(this).val().substr(0, maxlength));
			    	}
			    });
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
		<c:if test="${type == ''}">			
			<c:if test="${mode == ''}">
				<h1><spring:message code='ezApprovalG.t384'/></h1>
				<span>▒ <spring:message code='ezApprovalG.t2107'/></span>
			</c:if>
			<c:if test="${mode == 'modify'}">
				<h1><spring:message code='ezApprovalG.lineMod.mjs01'/></h1>
				<span>▒ <spring:message code='ezApprovalG.lineMod.mjs02'/></span>
			</c:if>
		</c:if>
		<c:if test="${type != ''}">
			<c:if test="${approvalFlag == 'G'}">
				<h1><spring:message code='ezApprovalG.t6000'/></h1>
				<span>▒ <spring:message code='ezApprovalG.t6003'/></span>
			</c:if>
			<c:if test="${approvalFlag == 'S'}">
				<h1><spring:message code='ezApprovalG.hyj07'/></h1>
				<span>▒ <spring:message code='ezApprovalG.hyj10'/></span>
			</c:if>
		</c:if>
		<div id="close">
            <ul>
                <li><span onclick="return btn_CancelAprLineTempletName_onclick()"></span></li>
            </ul>
        </div>
		<div class="nobox" style="margin-top:10px">
		<input type="text" class="text" style="width:100%;height:25px;border:1px solid #ccc" id="TxtAprLineTempletName" name="TxtAprLineTempletName" maxlength="20">
		</div>		
			
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName" onClick="return btn_SaveAprLineTempletName_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
