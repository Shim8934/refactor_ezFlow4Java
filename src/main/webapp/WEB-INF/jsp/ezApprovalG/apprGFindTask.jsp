<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title><spring:message code='ezApprovalG.t111'/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabCategoryInfo_Cross.js')}"></script>
	<script ID="clientEventHandlersJS" type="text/javascript">
	    var rtnVal = new Array();
	    window.onbeforeunload = window_onunload;
	    var RetValue;
	    var ReturnFunction;
	    window.onload = function () {
	        var ua = navigator.userAgent;
	        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	            KeEventControl(document.getElementById("txtTitle"));
	            KeEventControl(document.getElementById("txtCode"));
	        }

	        if (parent.findtask_cross_dialogArguments[1] != undefined) {
	            RetValue = parent.findtask_cross_dialogArguments[0];
	            ReturnFunction = parent.findtask_cross_dialogArguments[1];
	        } else {
	            try {
	                RetValue = opener.findtask_cross_dialogArguments[0];
	                ReturnFunction = opener.findtask_cross_dialogArguments[1];
	            } catch (e) {
	                RetValue = window.dialogArguments;
	            }
	        }
	        rtnVal[0] = "FALSE";
	    };
	    
	    function btnReset_onclick() {
	        document.getElementById("txtTitle").value = "";
	        document.getElementById("txtCode").value = "";
	    }
	    function btnOK_onclick() {
	        if ($("#txtTitle").val().trim() == "" && $("#txtCode").val().trim() == "") {
	            alert("<spring:message code='ezApprovalG.t1023'/>");
	        }
	        else {
	            rtnVal[0] = "TRUE";
	            rtnVal[1] = document.getElementById("txtTitle").value.trim();
	            rtnVal[2] = document.getElementById("txtCode").value.trim();
	            
	            if (ReturnFunction != null) {
	                ReturnFunction(rtnVal);
	                window.close();
	            }
	            else {
	                window.close();
	            }
	        }
	    }
	    function btnClose_onclick() {
	        rtnVal[0] = "FALSE";
	        if (ReturnFunction != null) {
	            ReturnFunction(rtnVal);
	            window.close();
	        }
	        else {
	            window.close();
	        }
	    }
	    
	    function enterkey(e) {
	        if (window.event) {
	            if (window.event.keyCode == 13) {
	            	btnOK_onclick();
	            }
	        }
	        else {
	            if (e.which == 13) {
	            	btnOK_onclick();
	            }
	        }
		}
	    
	    function window_onunload() {
	        if (!CrossYN())
	            window.returnValue = rtnVal;
	    }
	</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t111'/></h1>
		<div id="close">
            <ul>
                <li><span id="btnClose" onClick="return btnClose_onclick()"></span></li>
            </ul>
        </div>
		<h2 style="font-weight: normal;">▒ <spring:message code='ezApprovalG.t648'/></h2>
		<table class="content">
		  <tr>
		    <th><spring:message code='ezApprovalG.t649'/></th>
		    <td><input type="text" class="text" style="Width:100%; " name="txtTitle" id="txtTitle" onkeyup="enterkey(event)">
		    </td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t1024'/></th>
		    <td><input type="text" class="text" style="Width:100%; " name="txtCode" id="txtCode" onkeyup="enterkey(event)">
		    </td>
		  </tr>
		</table>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"><span id="btnReset" onClick="return btnReset_onclick()"><spring:message code='ezApprovalG.t621'/></span></a>
			<a class="imgbtn"><span id="btnOK" onClick="return btnOK_onclick()"><spring:message code='ezApprovalG.t111'/></span></a>
		</div>
	</body>
</html>
