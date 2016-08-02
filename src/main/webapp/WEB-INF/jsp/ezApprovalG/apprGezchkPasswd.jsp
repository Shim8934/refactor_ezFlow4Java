<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1744'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/rsa/asn1.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var gUserID = "";
		    var rsa = new RSAKey();
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    function btn_OpinionOK_onclick() {
		        var rtnVal = "cancel";
		        if (trim(document.getElementById("inpPassword").value).length == 0) {
		            alert("<spring:message code='ezApprovalG.t1746'/>");
		            document.getElementById("inpPassword").focus();
		            return;
		        }
		        else {
		            rtnVal = chkPasswd();
		        }
		
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		            window.close();
		        }
		        else {
		            window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    function btn_OpinionCANCEL_onclick() {
		        if (ReturnFunction != null) {
		            window.close();
		            ReturnFunction("cancel");            
		        }
		        else {
		            window.returnValue = "cancel";
		            window.close();
		        }
		    }
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        var ua = navigator.userAgent;
		        rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		        
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		            KeEventControl(document.getElementById("inpPassword"));
		        }
		        try {
		            RetValue = parent.ezchkpasswd_cross_dialogArguments[0];
		            ReturnFunction = parent.ezchkpasswd_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.ezchkpasswd_cross_dialogArguments[0];
		                ReturnFunction = opener.ezchkpasswd_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        gUserID = RetValue;
		    };
		
		    function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
		        {
		            return;
		            //useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            //if (parseInt(useragt) > 5) {
		            //    return;
		            //}
		        }
		        obj.onkeydown = function () {
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
		                return false;
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }
		
		    function chkPasswd() {
		        try {
		        	var result = "";
		        	
		        	$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezApprovalG/chkPasswd.do",
						data : { passWd   : rsa.encrypt(document.all("inpPassword").value),
								 userID   : rsa.encrypt(gUserID)
								},
						success: function(text){
							result = text;
						}        			
					});
		        	
		            return result;
		        } catch (e) {
		            alert(e.description);
		        }
		    }
		    function trim(parm_str) {
		        return rtrim(ltrim(parm_str));
		    }
		    function ltrim(parm_str) {
		        str_temp = parm_str;
		        while (str_temp.length != 0) {
		            if (str_temp.substring(0, 1) == " ") {
		                str_temp = str_temp.substring(1, str_temp.length);
		            } else {
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
		    function rtrim(parm_str) {
		        str_temp = parm_str;
		        while (str_temp.length != 0) {
		            int_last_blnk_pos = str_temp.lastIndexOf(" ");
		            if ((str_temp.length - 1) == int_last_blnk_pos) {
		                str_temp = str_temp.substring(0, str_temp.length - 1);
		            } else {
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
		
		    function password_OnKeyPress(e) {
		        if (e.keyCode == "13") {
		            btn_OpinionOK_onclick();
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1745'/></h1>		
		<h2><spring:message code='ezApprovalG.t1746'/></h2>
		<div class="nobox"><input type="password" class="textarea" id="inpPassword" name="inpPassword" style="WIDTH:100%" onkeypress="password_OnKeyPress(event)"></div>
		
		<div class="btnposition">
		    <a class="imgbtn" id="btn_OpinionOK" onClick="return btn_OpinionOK_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
		    <a class="imgbtn" id="btn_OpinionCANCEL" onClick="return btn_OpinionCANCEL_onclick()"><span><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
	</body>
</html>