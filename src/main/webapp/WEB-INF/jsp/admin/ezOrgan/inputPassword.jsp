<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t228" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var ReturnFunction;
			var confirmStr;
			var companyID;

			$(document).ready(function(){
				try {
					ReturnFunction = opener.inputpassword_dialogArguments[1];
					companyID = opener.userComId
					
					var windowH = window.outerHeight;
					var windowW = window.outerWidth;
					var pwPolicyExplainH = $("#pwPolicyExplain").height();
					window.resizeTo(windowW, windowH + pwPolicyExplainH);
					
				} catch (e) {console.log(e);}
			});		

			function OK_Click(){
				if (NewPassword.value.trim() == "") {
					alert("<spring:message code='ezOrgan.t229' />"); 
					document.getElementById('NewPassword').focus();
					return;
				}
				
				var checkPw = checkPasswordPolicy({
					"pw" : NewPassword.value,
					"chkCompanyId" : companyID,
					"userId" : "<c:out value='${userId}'/>"
				});
				
		        if (!checkPw){
		        	document.getElementById('NewPassword').focus();
		        	return;
		        }

				if (NewPassword.value != ConfirmPassword.value) { 
					alert("<spring:message code='ezOrgan.t230' />");
					document.getElementById('ConfirmPassword').focus();
					return;
				}

				if (ReturnFunction != null) {
					ReturnFunction(NewPassword.value); 
				} else {
					window.returnValue = NewPassword.value;
				}
				window.close();
			}

			function enterCheck(event) {
				if (event.keyCode == "13") {
					OK_Click();
				} 
			}
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code="ezOrgan.t231" /></h1>
		<div id="close">
			<ul>
				<li><span onclick="window.close()"></span></li>
			</ul>
		</div>
		<div id="pwPolicyExplain" style="margin-top: 5px; color: #393939;"><span>${pwPolicyExplain }</span></div> <!-- el로 값 통째로 넣어줌 -->
		<table class="content" style="margin-top: 3px"> 
			<tr>
				<th><spring:message code="ezOrgan.t232" /></th>
				<td><input id=NewPassword type=password style="width:98%" maxlength="50"></td>
			</tr>
			<tr> 
				<th><spring:message code="ezOrgan.t233" /></th>
				<td><input id=ConfirmPassword type=password style="width:98%" maxlength="50" onkeydown="enterCheck(event)"></td>
			</tr>
		</table>
		<div class="btnpositionNew">
			<a class="imgbtn" onClick="OK_Click()"><span><spring:message code="ezOrgan.t124" /></span></a>
		</div>
	</body>
</html>