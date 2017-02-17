<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t20'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    if (new RegExp(/Chrome/).test(navigator.userAgent)) {
		        window.resizeTo(330+ (window.outerWidth - window.innerWidth), 205+ (window.outerHeight - window.innerHeight));
		    }
		    if (navigator.userAgent.indexOf('Firefox') != -1) {
		        window.resizeTo(348, 277);
		    }
		    else if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
		        window.resizeTo(348, 240);
		    }
		    function btn_OpinionOK_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction();
		            window.close();
		        }
		        else
	        	   if( document.getElementById("pMessageContent").innerHTML == "<spring:message code='ezApprovalG.t146'/>")
	            	{
			            window.returnValue = true;
	            	}
		            window.close();
		    }
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            RetValue = parent.ezapralert_cross_dialogArguments[0];
		            ReturnFunction = parent.ezapralert_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.ezapralert_cross_dialogArguments[0];
		                ReturnFunction = opener.ezapralert_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        try{
		            document.getElementById("Submit1").focus();
		        }
		        catch (e) { }
		        document.getElementById("pMessageContent").innerHTML = RetValue;
		
		        if (MACSAFARIYN())
		            window.resizeTo(330, 251);
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
	               <input type="submit"  value="<spring:message code='ezApprovalG.t20'/>" id="Submit1" name="btn_OpinionOK" onClick="return btn_OpinionOK_onclick()" >
		    </div>
	        <span class="bl"> </span> <span class="br"></span>
	    </div>
	    </div>
	</body>
</html>