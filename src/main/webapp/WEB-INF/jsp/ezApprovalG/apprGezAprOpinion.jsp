<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t20'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<script type="text/javascript">
			var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            RetValue = parent.ezapropinion_cross_dialogArguments[0];
		            ReturnFunction = parent.ezapropinion_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.ezapropinion_cross_dialogArguments[0];
		                ReturnFunction = opener.ezapropinion_cross_dialogArguments[1];
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
		    function btn_OpinionOK_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction(true);
		            window.close();
		        }
		        else {
		            window.returnValue = true;
		            window.close();
		        }
		    }
		    function btn_OpinionCANCEL_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction("");
		            window.close();
		        }
		        else {
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
	            <input type="submit"  value="<spring:message code='ezApprovalG.t20'/>" name="btn_OpinionOK" id="Submit1" LANGUAGE=javascript onClick="return btn_OpinionOK_onclick()" > 
	            <input type="submit"  value="<spring:message code='ezApprovalG.t119'/>" name="btn_OpinionCANCEL" id="Submit2" language=javascript  onClick="return btn_OpinionCANCEL_onclick()" >
		    </div>
	        <span class="bl"> </span> <span class="br"></span>
	    </div>
	    </div>
	</body>
</html>