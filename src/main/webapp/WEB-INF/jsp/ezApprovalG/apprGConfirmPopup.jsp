<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t20'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script> 
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		
		<script type="text/javascript">
			var RetValue;
		    var ReturnFunction;
		    var winFlag;
		    
		    window.onload = function () {
		        try {
		            RetValue = parent.confirmInfo[0];
		            ReturnFunction = parent.confirmInfo[1];
		        } catch (e) {
		            try {
		                RetValue = opener.confirmInfo[0];
		                ReturnFunction = opener.confirmInfo[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        
		        document.getElementById("pMessageContent").innerHTML = RetValue;
		        document.getElementById("Submit1").focus();
		
		        if (MACSAFARIYN()) {
		            window.resizeTo(330, 251);
		        }
		    };
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent)) {
		        window.resizeTo(347, 270);
		    }
		
		    if (navigator.userAgent.indexOf('Firefox') != -1) {
		        window.resizeTo(348, 277);
		    }
		    else if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
		        window.resizeTo(348, 240);
		    }
		    
		    function confirm_OK() {
		        if (ReturnFunction != null) {
		            ReturnFunction(true);
		            
		            if (winFlag) {
			            window.close();
		            }
		        } else {
		            window.returnValue = true;
		            window.close();
		        }
		    }
		    function confirm_Cancel() {
		        if (ReturnFunction != null) {
		            ReturnFunction(false);
		            
		            if (winFlag) {
			            window.close();
		            }
		        } else {
		            window.returnValue = false;
		            window.close();
		        }
		    }
		</script>
	</head>
	<body style="overflow:hidden;">
	   <!--  popup -->
	    <div class="popup_noti">
		    <div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
	 	<div class="popup_noti_content">
	        <div  style="padding:10px;">
	          <table>
	            <tr>
	              <td  class="cimg"></td>
	              <td  class="ctxt" ><span id="pMessageContent" ></span></td>
	            </tr>
	     </table>
	 	    </div>
	    </div>
	    <div class="popup_noti_btnarea"> 
	   	    <div class="btnposition"> 
	            <input type="submit"  value="<spring:message code='ezApprovalG.t20'/>" id="Submit1" onClick="return confirm_OK()" > 
	            <input type="submit"  value="<spring:message code='ezApprovalG.t119'/>" id="Submit2" onClick="return confirm_Cancel()" >
		    </div>
	        <span class="bl"> </span> <span class="br"></span>
	    </div>
	    </div>
	</body>
</html>
