<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style type="text/css"></style>
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
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
		    var Rtnval;
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.form_check_ui_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.form_check_ui_cross_dialogArguments[1];
		            } catch (e) {
		            }
		        }
		        Rtnval = "cancel";
		        pMessageContent.innerHTML = "<spring:message code='ezApprovalG.t160'/>";
		    };
		    function btnOK_onclick() {
		        Rtnval = "ok";
		
		        if (ReturnFunction != null)
		            ReturnFunction(Rtnval);
		        window.close();
		    }
		    function btncancel_onclick() {
		        if (ReturnFunction != null)
		            ReturnFunction(Rtnval);
		        window.close();
		    }
		</script>
	</head>
	<body style="overflow:hidden;">
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
	               <input type="submit" name="btnOK" value="<spring:message code='ezApprovalG.t20'/>" onClick="return btnOK_onclick()">
		<input type="submit" name="btncancel" value="<spring:message code='ezApprovalG.t119'/>" onClick="return btncancel_onclick()">
		    </div>
	        <span class="bl"> </span> <span class="br"></span>
	    </div>
	    </div>
	</body>
</html>