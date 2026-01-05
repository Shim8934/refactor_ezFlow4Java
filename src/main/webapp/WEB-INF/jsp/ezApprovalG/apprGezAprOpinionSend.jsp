<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t10018'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/sendMail_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var rvalue = new Array();
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.ezmailquestion_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.ezmailquestion_cross_dialogArguments[1];
		            } catch (e) {
		            }
		        }
		   
		    };
		
		    function all_click() {
		    	rvalue[0] = "Y";
		    	if(opi.checked == true){
		    		rvalue[0] = "T";	
		    	}
		 
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        }
		        else {
		            window.returnValue = rvalue;
		            window.close();
		        }
		        
		    }
		
		    function Cancel() {
		        rvalue[0] = "0";
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        }
		    }
		
		    window.onbeforeunload = function () {
		        if (rvalue[0] == null) {
		            rvalue[0] = "0";
		        }
		
		        if (!CrossYN()) {
		            window.returnValue = rvalue;
		            window.close();
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.hyh01' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="return Cancel()"></span></li>
            </ul>
        </div>
		<span>▒ <spring:message code='ezApprovalG.hyh02' /></span>
		<span id=pMessageContent></span>
		<table class="content" style="margin-top:10px">
			<tr><th><div class='custom_checkbox'><input id='doc' name ='doc' type='checkbox' checked="checked" disabled="disabled"></div></th>
			<td><span id="ext2"><spring:message code='ezApprovalG.hyh03'/></span></td></tr> 
			<tr><th><div class='custom_checkbox'><input id='opi' name ='opi' type='checkbox' ></div></th>
			<td><span id="ext2"><spring:message code='ezApprovalG.t10020'/></span></td></tr>
		</table>
		<div class="btnposition btnpositionNew">
			<a id="Submit1" class="imgbtn" onClick="return all_click()"><span><spring:message code='ezApprovalG.t1760'/></span></a> 
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>