<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t104' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ErrorHandler.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/rsa/asn1.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var gUserID = "";
			var rtnVal = "cancel";
			var ReturnFunction;
			var rsa = new RSAKey();
			
			function ReplaceText( orgStr, findStr, replaceStr ) {
				var re = new RegExp( findStr, "gi" );
				return ( orgStr.replace( re, replaceStr ) );
			}
			
			function btn_OpinionOK_onclick(){
				if (inpPassword.value == "") {
					alert("<spring:message code = 'ezCommunity.t105' />");
					return;
				}
				
				 $.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommunity/confirmPassword.do",
						data : { newPassword   : rsa.encrypt(document.getElementById("inpPassword").value),
								 itemID : "${itemID}"	
								},
						success: function(result){
							rtnVal = result;
						}
					});
	
			    window.close();
			}
	
			window.onunload = function () {
				if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
				} else {
					window.returnValue = rtnVal;
				}
		    }
	
			function btn_OpinionCANCEL_onclick() {
			  	window.returnValue = "cancel";
				window.close();
			}
	
			window.onload = function() {
		        try {
		            ReturnFunction = opener.checkpassword_dialogArguments[1];
		        } catch (e) { }
	
		        rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
				window.returnValue = "cancel";
	
			    try {
			        var ua = navigator.userAgent;
			        
			        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
			            KeEventControl(document.getElementById("inpPassword"));
			        }
			    }
			    catch (e) { }
			    
			}
	
			function KeEventControl(obj) {
			    useragt = navigator.userAgent.toUpperCase();
			    
			    if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) {
			        useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
			        
			        if (parseInt(useragt) > 5) {
			            return;
			        }
			    }
			    
			    obj.onkeydown = function () {
			        if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126) {
			            return false;
			        }
			        
			        if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
			                parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
			                parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
			                parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
			                parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32) {
			            return false;
			        }
			    };
			}
	
			function chkPasswd() {
				try{
					var objRoot;
					var objNode;
					
					var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
					
					xmlhttp.open("POST","/myoffice/ezApproval/aspx/chkPasswd.aspx",false);
					xmlhttp.send(xmlpara);
					
					return xmlhttp.responseText ;
			  	}catch(e){
					alert(e.description);
			  	}
			}
		</script>
	</head>
	<body class="popup">
		<table width="100%" cellspacing="0" cellpadding="0" class="iconbg">
			<tr>
		    	<td>
		    		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		        		<tr>
		        			<td class="subtitle"><h1><spring:message code = 'ezCommunity.t106' /></h1></td>
		        		</tr>
		      		</table>
		      	</td>
		  	</tr>
		</table>
		
		<table width="300" border="0" cellpadding="3" cellspacing="0" bordercolor="b6b6b6" style="border-collapse:collapse;margin-top:10px;margin-left:10px"> 
			<tr> 
		    	<td class="subtxt"><spring:message code = 'ezCommunity.t107' /></td> 
		  	</tr> 
		</table> 
		
		<table width="300" border="1" cellpadding="3" cellspacing="0" bordercolor="b6b6b6" bgcolor="f5f5f5" style="border-collapse:collapse;margin-left:10px;margin-bottom:10px"> 
			<tr> 
		    	<td align="center"><INPUT type="password" class="textarea" id="inpPassword" name="inpPassword" style="WIDTH:100%"> </td> 
		  	</tr> 
		</table> 
				
		<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
			<tr>
				<td  class="btnposition">
					<input type="submit"  value="<spring:message code = 'ezCommunity.t108' />" name="btn_OpinionOK" id="btn_OpinionOK" onClick="return btn_OpinionOK_onclick()">
					<input type="submit"  value="<spring:message code = 'ezCommunity.t109' />" name="btn_OpinionCANCEL" id="btn_OpinionCANCEL" onClick="return btn_OpinionCANCEL_onclick()">
				</td>
			</tr>
		</table>
		
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent }" type="hidden"/>
	</body>
</html>