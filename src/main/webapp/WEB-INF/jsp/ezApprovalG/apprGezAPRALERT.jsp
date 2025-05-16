<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t20'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
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
		            ReturnFunction(closeParent);
		            
		            if (winFlag) {
		            	window.close();
		            }
	            } else {
		        	window.returnValue = true;
		            window.close();
	            }
		    }
		    var ReturnFunction;
		    var winFlag;
			var closeParent = false;
		    window.onload = function () {
		        try {
		            if (isParentCommonArgsUsed()) {
						RetValue = parent.ezCommon_cross_dialogArguments[0];
						ReturnFunction = parent.ezCommon_cross_dialogArguments[1];
						winFlag = parent.ezCommon_cross_dialogArguments[2];
						closeParent = parent.ezCommon_cross_dialogArguments[3];
					} else {
						RetValue = parent.ezapralert_cross_dialogArguments[0];
						ReturnFunction = parent.ezapralert_cross_dialogArguments[1];
						winFlag = parent.ezapralert_cross_dialogArguments[2];
					}
		        } catch (e) {
		            try {
		                RetValue = opener.ezapralert_cross_dialogArguments[0];
		                ReturnFunction = opener.ezapralert_cross_dialogArguments[1];
			            winFlag = opener.ezapralert_cross_dialogArguments[2];
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
// 		    window.resizeTo(330+ (window.outerWidth - window.innerWidth), 205+ (window.outerHeight - window.innerHeight));
		</script>
	</head>
	<body style="overflow:hidden;">
	    <!--  popup -->
	    <div class="popup_noti">
		    <div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
	 	<div class="popup_noti_content">
	        <div  style="padding:10px 10px 0px 10px;">
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
