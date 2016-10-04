<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1742'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
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
		        window.resizeTo(348, 271);
		    }
		    function btn_OpinionOK_onclick(tempID) {
		        if (ReturnFunction != null)
		            ReturnFunction(tempID);
		        else
		            window.returnValue = tempID;
		        window.close();
		    }
		    var ReturnFunction;
		    window.onload = function () {
		        document.getElementById("pMessageContent").innerHTML = "<spring:message code='ezApprovalG.t1743'/>";
		
		        try {
		            ReturnFunction = parent.ezaprallalert_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.ezaprallalert_cross_dialogArguments[1];
		            } catch (e) {
		            }
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
	            <input type="submit" value="<spring:message code='ezApprovalG.t1'/>" id="Submit4" name="btn_OpinionOK" onClick="return btn_OpinionOK_onclick('0')" >
	            <input type="submit" value="<spring:message code='ezApprovalG.t50'/>" id="Submit5" name="btn_OpinionOK" onClick="return btn_OpinionOK_onclick('1')" >
	            <input type="submit" value="<spring:message code='ezApprovalG.t367'/>" id="Submit6" name="btn_OpinionOK" onClick="return btn_OpinionOK_onclick('2')" >
	            <input type="submit" value="<spring:message code='ezApprovalG.t119'/>" id="Submit7" name="btn_OpinionOK" onClick="return btn_OpinionOK_onclick('3')" >
		    </div>
	        <span class="bl"> </span> <span class="br"></span>
	    </div>
	    </div>
	</body>
</html>