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
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style type="text/css">
			.popup_noti_content table { 
				color: unset;
			}
		</style>
		<script type="text/javascript" ID="clientEventHandlersJS" >
		var RetValue;
	    var ReturnFunction;
    
	    function btn_OpinionOK_onclick() {
	        if (ReturnFunction != null) {
	            ReturnFunction(true);
	        } else {
	            window.returnValue = true;
	            window.close();
	        }
	    }
	    
	    window.onload = function () {
	        try {
		    	RetValue = parent.ezapralertlong_cross_dialogArguments[0];
	            ReturnFunction = parent.ezapralertlong_cross_dialogArguments[1];
	        } catch (e) {
	            try {
			    	RetValue = opener.ezapralertlong_cross_dialogArguments[0];
		            ReturnFunction = opener.ezapralertlong_cross_dialogArguments[1];
	            } catch (e) {
	                RetValue = window.dialogArguments;
	            }
	        }
            
	        document.getElementById("pMessageContent").innerHTML = RetValue;
	    }
		</script>
	</head>
	<body>
	
	 <!--  popup -->
	    <div class="popup_noti">
		 	<div class="popup_noti_content" style="overflow: auto; height: 235px;">
		        <div  style="padding:10px;">
		          <table>
		            <tr>
		              <td><span id="pMessageContent" style="font-size: 10pt; font-weight:bold; line-height: 15pt;"></span></td>
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