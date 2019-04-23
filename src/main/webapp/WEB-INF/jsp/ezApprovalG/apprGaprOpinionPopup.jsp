<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t55'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Opinion_New_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script id="clientEventHandlersJS" type="text/javascript">
		var RetValue, ReturnFunction;
		var pOpinionMod, pOpinionContent;
		
		window.onload = function () {
			if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
			    KeEventControl(document.getElementById("txt_OpinionContent"));
			}
			
			try {
			    RetValue = parent.opinionPopup_cross_dialogArguments[0];
			    ReturnFunction = parent.opinionPopup_cross_dialogArguments[1];
			    
			    if (typeof(RetValue) == "undefined") {
			    	RetValue = opener.opinionPopup_cross_dialogArguments[0];
                    ReturnFunction = opener.opinionPopup_cross_dialogArguments[1];
			    }
			} catch (e) {
			    try {
			        RetValue = opener.opinionPopup_cross_dialogArguments[0];
			        ReturnFunction = opener.opinionPopup_cross_dialogArguments[1];
			    } catch (e) {
			        RetValue = window.dialogArguments;
			    }
			}
			
			pOpinionMod = RetValue[0];
			pOpinionContent = RetValue[1];
			
			if (pOpinionMod == "MOD") {
				document.getElementById("txt_OpinionContent").value = pOpinionContent;
			}
			
			document.getElementById("txt_OpinionContent").focus();
		};
		
		function btn_OpinionCancel_onclick() {
			if (ReturnFunction != null) {
				ReturnFunction("cancel");
			} else {
				window.returnValue = "cancel";
			}
		}
		
		function btn_OpinionSave_onclick() {
			var opinionContent = document.getElementById("txt_OpinionContent").value;
			
			if (opinionContent.trim() != "") {
				var returnValue = new Array();
				returnValue[0] = pOpinionMod;
				returnValue[1] = opinionContent;
				
				if (ReturnFunction != null) {
					ReturnFunction(returnValue);
				} else {
					window.returnValue = returnValue;
				}
			} else {
				var pAlertContent = strLang402;
	            OpenAlertUI(pAlertContent, btn_OpinionSave_onclick_complete);
	            return;
			}
		}
		
		function btn_OpinionSave_onclick_complete() {
			DivPopUpHidden();
			document.getElementById("txt_OpinionContent").focus();
		}
		</script>
		<style type="text/css">
		</style>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t423'/></h1>
	    
	    <div id="close">
            <ul><li><span onclick="return btn_OpinionCancel_onclick()"></span></li></ul>
        </div>
        
	    <textarea id="txt_OpinionContent" style="width:477px; height:255px; resize: none;"></textarea>
	    
	    <div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="bbtn_OpinionSave"><span id="btn_OpinionSave" onClick="return btn_OpinionSave_onclick()"><spring:message code='ezApprovalG.t1767'/></span></a>
	    </div>
	    
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
