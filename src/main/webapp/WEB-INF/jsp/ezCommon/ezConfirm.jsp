<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
			var ReturnArgs;
		    
		    window.onload = function () {
		        try {
		            RetValue = parent.ezCommon_cross_dialogArguments[0];
		            ReturnFunction = parent.ezCommon_cross_dialogArguments[1];
					ReturnArgs = parent.ezCommon_cross_dialogArguments[2];
		        } catch (e) {
		            try {
		                RetValue = opener.ezCommon_cross_dialogArguments[0];
		                ReturnFunction = opener.ezCommon_cross_dialogArguments[1];
						ReturnArgs = opener.ezCommon_cross_dialogArguments[2];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        document.getElementById("pMessageContent").innerHTML = RetValue;
		        document.getElementById("confirm_OK").focus();
				
		        if (MACSAFARIYN()) {
		            window.resizeTo(330, 251);
		        }
		        
		     	// 2025-03-12 조수빈 - 다국어의 경우 메세지가 길어져 하단의 버튼이 밀리는 결함 발생.
	            var thisFrame = window.parent.document.getElementById("iFrameLayer");
	            
	            // 현재의 iframe 높이가 내부의 높이보다 작을 때 맞추도록 분기처리
	            if (thisFrame && parseFloat(thisFrame.style.height) < document.body.clientHeight) {
	            	window.parent.document.getElementById("iFrameLayer").style.height = document.body.clientHeight + 'px';
	            }
		    };
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent)) {
		        window.resizeTo(347, 290);
		    }
		
		    if (navigator.userAgent.indexOf('Firefox') != -1) {
		        window.resizeTo(348, 287);
		    } else if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
		        window.resizeTo(348, 250);
		    }
		    
		    function btn_OK_onclick() {
		    	document.getElementById("confirm_OK").disabled = true;
				ReturnFunction(true);
		    }
			
		    function btn_CANCEL_onclick() {
				ReturnFunction(false);
		    }
		</script>
	</head>
	<body style="overflow:hidden;">
	   <!--  popup -->
	    <div class="popup_noti">
		    <div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
	 	<div class="popup_noti_content" style="height: 100%;">
	        <div  style="padding:10px;">
	          <table>
	            <tr>
	              <td  class="cimg"></td>
	              <td  class="ctxt" >
					  <span id="pMessageContent" ></span>
				  </td>
	            </tr>
	     </table>
	 	    </div>
	    </div>
	    <div class="popup_noti_btnarea"> 
	   	    <div class="btnposition"> 
				<input type="submit"  value="<spring:message code='ezApprovalG.t20'/>" name="btn_confirm_OK" id="confirm_OK" onClick="return btn_OK_onclick()" > 
				<input type="submit"  value="<spring:message code='ezApprovalG.t119'/>" name="btn_confirm_CANCEL" id="confirm_CANCEL" onClick="return btn_CANCEL_onclick()" >
		    </div>
	        <span class="bl"> </span> <span class="br"></span>
	    </div>
	    </div>
	</body>
</html>
