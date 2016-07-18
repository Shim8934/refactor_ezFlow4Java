<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<title><spring:message code='ezApprovalG.t111'/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script ID="clientEventHandlersJS" type="text/javascript">
	    var rtnVal = new Array();
	    window.onload = window_load;
	    window.onbeforeunload = window_onunload;
	    var RetValue;
	    var ReturnFunction;
	    function window_load() {
	        var ua = navigator.userAgent;
	        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	            KeEventControl(document.getElementById("txtTitle"));
	            KeEventControl(document.getElementById("txtCode"));
	        }
	        try {
	            RetValue = parent.findtask_cross_dialogArguments[0];
	            ReturnFunction = parent.findtask_cross_dialogArguments[1];
	        } catch (e) {
	            try {
	                RetValue = opener.findtask_cross_dialogArguments[0];
	                ReturnFunction = opener.findtask_cross_dialogArguments[1];
	            } catch (e) {
	                RetValue = window.dialogArguments;
	            }
	        }
	        rtnVal[0] = "FALSE";
	    }
	    function btnReset_onclick() {
	        document.getElementById("txtTitle").value = "";
	        document.getElementById("txtCode").value = "";
	    }
	    function btnOK_onclick() {
	        if (document.getElementById("txtTitle").value == "" && document.getElementById("txtCode").value == "") {
	            alert("<spring:message code='ezApprovalG.t1023'/>");
	        }
	        else {
	            rtnVal[0] = "TRUE";
	            rtnVal[1] = document.getElementById("txtTitle").value;
	            rtnVal[2] = document.getElementById("txtCode").value;
	
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
	    function window_onunload() {
	        if (!CrossYN())
	            window.returnValue = rtnVal;
	    }
	</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t111'/></h1>
		<table class="content">
		  <tr>
		    <th><spring:message code='ezApprovalG.t649'/></th>
		    <td><input type="text" class="text" style="Width:98%; " name="txtTitle" id="txtTitle">
		    </td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezApprovalG.t1024'/></th>
		    <td><input type="text" class="text" style="Width:98%; " name="txtCode" id="txtCode">
		    </td>
		  </tr>
		</table>
		<div class="btnposition">
			<a class="imgbtn"><span id="btnReset" onClick="return btnReset_onclick()" style="width:40px;" ><spring:message code='ezApprovalG.t621'/></span></a>
			<a class="imgbtn"><span id="btnOK" onClick="return btnOK_onclick()" style="width:40px;" ><spring:message code='ezApprovalG.t111'/></span></a>
			<a class="imgbtn"><span id="btnClose" onClick="return btnClose_onclick()" style="width:40px;" ><spring:message code='ezApprovalG.t64'/></span></a>
		</div>
	</body>
</html>