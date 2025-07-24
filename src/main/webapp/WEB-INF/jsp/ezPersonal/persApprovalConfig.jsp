<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPersonal.t120'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS" type="text/javascript">
		    var AprPass ="${pwd}";
		    var rsa = new RSAKey();
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		        ChangeType();
		
		        if (AprPass == "")
		            document.getElementById("oldpassTR").style.display = "none";
		        else
		            document.getElementById("oldpassTR").style.display = "";
		    };
		    function CheckPassword(NewPassword, OldPassword) {
		    	var result = "";
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/confirmPassword.do",
		    		data : {
			    			newPassword  : NewPassword,
			    			oldPassword  : OldPassword,
			    			userID       : "${userID}"
		    				},
		    		success: function(text){
		    			result = text;
		    		}        			
		    	});
		        
		        return result;
		    }
		    function Change_Click() {
		        var pFlag = "";
			    //2018-08-20 김보미 - ie에서는 작동되지 않던 버그 수정
 		        //if (Form1.ApprovPwdN.checked)
		        if (document.getElementById("ApprovPwdN").checked)
		            pFlag = "N";
		        else
		            pFlag = "Y";
		
		        if (pFlag == "Y" && document.getElementById("pwdType").value == "A") {
		            if (document.getElementById("txtNewPassword").value.length < 3) {
		                alert("<spring:message code='ezPersonal.t945'/>");
		                document.getElementById("txtNewPassword").focus();
		                return;
		            }
		            if (document.getElementById("txtNewPassword").value != document.getElementById("txtNewPasswordConfirm").value) {
		                alert("<spring:message code='ezPersonal.t942'/>");
		                document.getElementById("txtNewPasswordConfirm").value = "";
		                document.getElementById("txtNewPasswordConfirm").focus();
		                return;
		            }
		
		            var CheckPwd = false;
		            if (AprPass != "") {
		
		                if (document.getElementById("txtOldPassword").value == "") {
		                    alert("<spring:message code='ezPersonal.t947'/>");
		                    document.getElementById("txtOldPassword").value = "";
		                    document.getElementById("txtOldPassword").focus();
		                    return;
		                }
		                
		                if (document.getElementById("txtOldPassword").value == document.getElementById("txtNewPassword").value) {
		                	alert("<spring:message code='ezPersonal.t194'/>");
		                	document.getElementById("txtNewPassword").value = "";
		                	document.getElementById("txtNewPassword").focus();
		                	return;
		                }
		                
		                if (CheckPassword(rsa.encrypt(document.getElementById("txtOldPassword").value), AprPass) == "OK") {
		                    CheckPwd = true;
		                } else {
		                    CheckPwd = false;
		                }
		            }
		            else {
		                CheckPwd = true;
		            }
		
		
		            if (!CheckPwd) {
		                alert("<spring:message code='ezPersonal.t946'/>");
		                document.getElementById("txtOldPassword").value = "";
		                document.getElementById("txtOldPassword").focus();
		                return;
		            }
		
		        }
				var pNewPWD = "";
				
		        if (pFlag == "Y" && document.getElementById("pwdType").value == "A") {
		        	pNewPWD = rsa.encrypt(document.getElementById("txtNewPassword").value);
		        }
		        else {
		            pNewPWD = "";
		        }
		
				var result = "";
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveConfig.do",
		    		data : {
			    			flag  : pFlag,
			    			newPWD  : pNewPWD,
			    			pwdType : document.getElementById("pwdType").value
		    				},
		    		success: function(text){
		    			result = text;
		    		}        			
		    	});
		        
		        if (result == "OK")
		            alert("<spring:message code='ezPersonal.t191'/>");
		        else
		            alert("<spring:message code='ezPersonal.t192'/>");
		
		        window.location.reload(true);
		    }
		
		    function OpenAlertUI(pAlertContent) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(330, 205);
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		    }
		
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
			
		    function change_press(evt) {
		        var Event = evt ? evt : window.event;
		
		        if (Event.keyCode == "13") {
		            if (Event == window.event)
		                Event.returnValue = false;
		            else
		                Event.preventDefault();
		
		            Change_Click();
		        }
		    }
			
		    function ChangeType() {
		        if (document.getElementById("pwdType").value == "L") {
		            document.getElementById("txtOldPassword").disabled = true;
		            document.getElementById("txtNewPassword").disabled = true;
		            document.getElementById("txtNewPasswordConfirm").disabled = true;
		            DivApprvalPass.style.display = "none";
		        }
		        else {
		            document.getElementById("txtOldPassword").disabled = false;
		            document.getElementById("txtNewPassword").disabled = false;
		            document.getElementById("txtNewPasswordConfirm").disabled = false;
		            document.getElementById("DivApprvalPass").style.display = "block";
		        }
		    }
		
		    function PassTypeView() {
		    	//2018-08-20 김보미 - ie에서는 작동되지 않던 버그 수정
 		        //if (Form1.ApprovPwdN.checked) {
		        if (document.getElementById("ApprovPwdN").checked) {
		            document.getElementById("DivPassType").style.display = "none";
		        }
		        else {
		            document.getElementById("DivPassType").style.display = "block";
		        }
		    }
		</script>
	</head>
	<body>
		<form id="Form1" method="post" >
			<br />
			<%-- <h2>▒&nbsp;<spring:message code='ezPersonal.t938'/></h2> --%>
			<span class="txt">▒ <spring:message code='ezPersonal.t938' /></span>
			<table class="content" style="width:450px;margin-top:10px">
		    	<tr>
		    		<th><spring:message code='ezPersonal.t513'/></th>
		    		<td>
				    	<c:if test="${flag != 'N'}">
							<div class="custom_radio">
								<input style="margin-top:0px;" type="radio" id="ApprovPwdY" name="ApprovPwd" checked='checked' onclick ="PassTypeView()" />
								<label for ="ApprovPwdY" style="cursor:pointer;vertical-align:middle"><spring:message code='ezPersonal.t937'/></label>
								<input style="margin-top:0px;" type="radio" id="ApprovPwdN" name="ApprovPwd" onclick="PassTypeView()"  />
								<label for ="ApprovPwdN" style="cursor:pointer;vertical-align:middle"><spring:message code='ezPersonal.t1000'/></label>
							</div>
				    	</c:if>
				    	<c:if test="${flag == 'N'}">
							<div class="custom_radio">
								<input style="margin-top:0px;" type="radio" id="ApprovPwdY" name="ApprovPwd" onclick ="PassTypeView()" />
								<label for ="ApprovPwdY" style="cursor:pointer;vertical-align:middle"><spring:message code='ezPersonal.t937'/></label>
								<input style="margin-top:0px;" type="radio" id="ApprovPwdN" name="ApprovPwd" checked='checked' onclick="PassTypeView()"  />
								<label for ="ApprovPwdN" style="cursor:pointer;vertical-align:middle"><spring:message code='ezPersonal.t1000'/></label>
							</div>
				    	</c:if>
				    </td>
		  		</tr>
		  	</table><br />
			<c:if test="${flag == 'N'}">
				<div id="DivPassType" style="display:none">
					<h2>▒&nbsp;<spring:message code='ezPersonal.t948'/>&nbsp;
					<select id="pwdType" onchange="ChangeType()">
						<c:choose>
							<c:when test="${pwdType == 'L' || pwdType == '' }">
								<option value ='L' selected><spring:message code='ezPersonal.t952'/></option>
							</c:when>
							<c:otherwise>
								<option value ='L'><spring:message code='ezPersonal.t952'/></option>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${pwdType == 'A'}">
								<option value ='A' selected><spring:message code='ezPersonal.t953'/></option>
							</c:when>
							<c:otherwise>
								<option value ='A'><spring:message code='ezPersonal.t953'/></option>
							</c:otherwise>
						</c:choose>
					</select>
					</h2>
			</c:if>
		  	<c:if test="${flag != 'N'}">
				<div id="DivPassType">
					<h2>▒&nbsp;<spring:message code='ezPersonal.t948'/>&nbsp;
							<!-- 2018-07-25 김보미 - div주석 -->
<!-- 						<div style="margin-top:10px;">						 -->
							<select id="pwdType" onchange="ChangeType()">
								<c:choose>
									<c:when test="${pwdType == 'L' || pwdType == '' }">
										<option value ='L' selected>
											<spring:message code='ezPersonal.t952'/>
										</option>
									</c:when>
									<c:otherwise>
										<option value ='L'>
											<spring:message code='ezPersonal.t952'/>
										</option>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${pwdType == 'A'}">
										<option value ='A' selected>
											<spring:message code='ezPersonal.t953'/>
										</option>
									</c:when>
									<c:otherwise>
										<option value ='A'>
											<spring:message code='ezPersonal.t953'/>
										</option>
									</c:otherwise>
								</c:choose>
							</select>
<!-- 						</div> -->
					</h2>
			</c:if>
			<br />
				<div id="DivApprvalPass" style="display:none">
					<h2>▒&nbsp;<spring:message code='ezPersonal.t954'/></h2>
					<span class="txt">▒&nbsp;<spring:message code='ezPersonal.lhm30'/></span>
				    	<table class="content" style="margin-top:10px;width:450px">
					        <tr id="oldpassTR">
					            <th><spring:message code='ezPersonal.t949'/></th>
					            <td ><input type="password" id="txtOldPassword" size="25" onKeyPress="change_press(event)"  disabled=true maxlength="50" autocomplete="off"> </td>               
					        </tr>
					        <tr>
					            <th><spring:message code='ezPersonal.t950'/></th>
					            <td><input type="password" id="txtNewPassword" size="25" onKeyPress="change_press(event)" disabled=true maxlength="50" autocomplete="off"></td>               
					        </tr>
					        <tr>
					            <th><spring:message code='ezPersonal.t951'/></th>
					            <td><input type="password" id="txtNewPasswordConfirm" size="25" onKeyPress="change_press(event)" disabled=true maxlength="50" autocomplete="off"></td>               
					        </tr>
					    </table>  
			   	 </div>
			</div>
			<div class="btnpositionJsp" style="width:436px">
			    <a class="imgbtn" onClick="Change_Click()" ><span><spring:message code='ezPersonal.t34'/></span></a>
			    <a class="imgbtn" onClick="Cancel_Click()" ><span><spring:message code='ezPersonal.t13'/></span></a>
			</div>
			<input id="publicModulus" value="${publicModulus}" type="hidden"/>
			<input id="publicExponent" value="${publicExponent}" type="hidden"/>
		</form>
	</body>
</html>