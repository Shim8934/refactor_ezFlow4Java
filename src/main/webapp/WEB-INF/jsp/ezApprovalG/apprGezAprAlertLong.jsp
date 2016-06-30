<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t20'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS" >
		    function btn_OpinionOK_onclick() {
		        window.close();
		    }
		    window.onload = function () {
		        document.getElementById("pMessageContent").innerHTML = dialogArguments;
		    }
		</script>
	</head>
	<body>
	
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