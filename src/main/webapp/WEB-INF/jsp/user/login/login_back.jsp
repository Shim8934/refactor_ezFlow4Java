<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="shortcut icon" href="/images/favicon.ico">		
		<link href="${util.addVer('/css/login.css')}" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<style>
			.blocker {
				text-align: center;
			} 
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript">		
			function actionLogin() {
			    if (document.loginForm.id.value =="") {
			        alert("<spring:message code='main.jjs02'/>");
			        return;
			    } else if (document.loginForm.password.value =="") {
			        alert("<spring:message code='main.jjs01'/>");
			        return;
			    } else {		    	
			    	var frm = document.loginForm;
			    	var rsa = new RSAKey();
					rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
					
					saveid(frm);

					frm.encryptID.value = rsa.encrypt(frm.id.value);
					frm.encryptPass.value = rsa.encrypt(frm.password.value);
					frm.id.value = "";
					frm.password.value = "";
					frm.action="<c:url value='/user/login/actionLogin.do'/>";        
					frm.submit();
			    }
			}
			
			function setCookie (name, value, expires) {
			    document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
			}
			
			function getCookie(Name) {
			    var search = Name + "="
			    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
			        offset = document.cookie.indexOf(search)
		   
			        if (offset != -1) { // 쿠키가 존재하면
			            offset += search.length
			            // set index of beginning of value
			            end = document.cookie.indexOf(";", offset);     
			            document.getElementById("uid").className = "input_text focus";
			            document.getElementById("upw").focus();
			            // 쿠키 값의 마지막 위치 인덱스 번호 설정
			            if (end == -1)
			                end = document.cookie.length
			            return unescape(document.cookie.substring(offset, end))
			        }
			    } else {			    	
					document.getElementById("uid").focus();
			    }
			    return "";
			}
			
			function saveid(form) {
			    var expdate = new Date();			    
			    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
			    if (form.checkId.checked)
			        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
			    else
			        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
			    setCookie("saveid", form.id.value, expdate);
			}
			
			function getid(form) {
			    form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
			}
			
			function fnInit() {
			    // 로그인 페이지가 로드된 프레임이 Top 프레임이 아니면 Top 프레임으로 로드시킨다.
                if (top != self) {
                    top.location.href = self.location.href;
                }			    		                 
			    
			    var message = document.loginForm.message.value;	    
			    if (message != "") {
			        alert(message);
			    }
			    getid(document.loginForm);
			    
				if ("${isExpireDate}" == "Y") {
					$("#exDiv").modal();
					$("#exDiv").show(function() {						
						$("#txtOldPassword").focus();
					});													
			    }				
			}
			
			function setting_click() {
			    var ver = navigator.userAgent;
			    window.open("/docs/usersetting_IE8.html", "", "height=768,width=1024, scrollbars=yes, status = yes, toolbar=yes, menubar=yes, location=yes, resizable=yes");
			}
			
			function PassWordChange() {
				if (document.getElementById('txtOldPassword').value == "") {
					alert("<spring:message code='ezPersonal.t947'/>");
				    document.all['txtOldPassword'].focus();
				    return;
				}
				if (document.getElementById('txtNewPassword').value == "") {
		            alert("<spring:message code='main.jjh01'/>");
			        document.all['txtNewPassword'].focus();
			        return;
			    }
				
				if (!CheckPassword(document.getElementById('txtNewPassword').value)) {
					alert("<spring:message code='main.jjh04'/>");
					document.all['txtNewPassword'].focus();
					return;
				};				
				
				if (document.getElementById('txtOldPassword').value == document.getElementById('txtNewPassword').value) {
		            alert("<spring:message code='ezPersonal.t194'/>");
			        document.all['txtNewPassword'].focus();
			        return;
			    }
		        if (document.getElementById('txtNewPassword').value != document.getElementById('txtNewPasswordConfirm').value) {
		            alert("<spring:message code='main.jjh02'/>");
			        document.all['txtNewPasswordConfirm'].focus();
			        return;
			    }
		        
		        var frm = document.loginForm;
		        var rsa = new RSAKey();
				rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "html",				    		
		    		async : false,
		    		data : {
		    			USERID : rsa.encrypt(document.getElementById("chooseId").innerHTML),
		    			OLDPASSWORD : rsa.encrypt(document.getElementById('txtOldPassword').value),
		    			NEWPASSWORD : rsa.encrypt(document.getElementById('txtNewPassword').value),
		    			NEWPASSWORDCONFIRM : rsa.encrypt(document.getElementById('txtNewPasswordConfirm').value)
		    		},
		    		url : "/user/login/changeExPassword.do",
		    		success: function(text){
		    			if (text == 'OK') {
		    				alert("<spring:message code='ezPersonal.t197'/>");			            	
		    			} else if (text == 'LOGINERROR') {
		    				alert("<spring:message code='ezPersonal.t946'/>");		    				
		    			} else {
		    				alert("<spring:message code='fail.common.login'/>");
		    			}
		    			window.top.location.href = '/user/login/login.do';
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezPersonal.t198'/>");
		    		}
		        });	        
		    }
		</script>
	</head>
	<body class="login_body" onload="fnInit()">
		<div class="login_warpper">
			<section class="login_layout">
				<div class="set1">
					<article class="login_form">		                
		                <p class="title"><img src="/images/kr/login/logo.png" alt="bizmeka그룹웨어" width="240" height="40"></p>
		                <form id="loginForm" name="loginForm" method="post">
		                	<input type="hidden" name="publicModulus" value="${publicModulus}"/>
		                	<input type="hidden" name="publicExponent" value="${publicExponent}"/>
		                	<input type="hidden" name="encryptID" />
		                	<input type="hidden" name="encryptPass"/>
		                    <fieldset>		                        
		                        <p class="id">
		                        	<input id="uid" name="id" style="ime-mode:disabled;" class="input_text" type="text" onblur="if (this.value.length==0) {this.className='input_text'}else {this.className='input_text focusnot'};" onfocus="this.className='input_text focus'" onKeyPress="if(event.keyCode==13) actionLogin();" />
		                        </p>		                 
		                        <p class="pw">
		                        	<input id="upw" name="password" class="input_text" type="password" onchange="if(this.value.length!=0){this.className='input_text focus'}" onblur="if (this.value.length==0) {this.className='input_text'}else {this.className='input_text focusnot'};" onfocus="this.className='input_text focus'" onKeyPress="if(event.keyCode==13) actionLogin();" />
		                        </p>
		                        <!-- <input type="image" name="LoginButton" id="LoginButton" tabindex="3" src="/images/kr/login/btn_login.png" border="0" class="btn_login" > -->
		                        <img src="/images/kr/login/btn_login.png" id="LoginButton"  tabindex="3" border="0" class="btn_login" class="btn_login" onclick="javascript:actionLogin()" style="cursor:pointer">
		                        <p class="saveid">
		                        	<input type="checkbox" value="" id="checkId" name="checkId" class="inp_checkbox" />
		                        	<label for="save_login">ID Save</label>
		                        </p>	                        	                        
		                    </fieldset>
		                    <input type="hidden" name="message" value="${message}" />		                    
					    </form>
					</article>
				</div>			  		            
			</section>
			<address><span>COPYRIGHT(C) KAONI. ALL RIGHTS RESERVED.</span></address>
		</div>		
		<div class="noti_layer" style="position:absolute;top:295px;left:800px;display:none;" id="divCapsLock">
			<span class="arrow">
				<img src="/images/login/notilayer_bg_arrow.gif" width="7" height="6" style="vertical-align:top; z-index:10;" />
			</span>
			<p><span>[<strong class="yellow_txt">Caps Lock</strong>]?pCapsLockMsg?></span></p>
		</div>
		<div id="exDiv" style="display:none">
			<div style="float:left">
				<c:if test="${isFirstLogin == 'Y'}"><img src="/images/hello.png" width="52" height="52"/></c:if>
				<c:if test="${isFirstLogin != 'Y'}"><img src="/images/warning.png" width="52" height="52"/></c:if>
			</div>
			<div style="float:right;color:rgb(0, 72, 149);width:360px">
				<c:if test="${isFirstLogin == 'Y'}">
					<div style="font-size:11px">▒ <spring:message code='main.jjh07'/></div>
				</c:if>
				<c:if test="${isFirstLogin != 'Y'}">
					<div style="font-size:11px">▒ <spring:message code='fail.user.passwordExpired'/></div>
				</c:if>				
				<div style="font-size:11px;margin-top:3px">▒ <spring:message code='main.jjh03'/></div>
				<div style="font-size:11px;margin-top:3px">▒ <spring:message code='main.jjh04'/></div>
			</div>
			<div style="clear:both"></div>
			<p style="border-top:1px solid rgb(0, 72, 149);margin-top:13px">
				<label style="color:rgb(0, 72, 149);"><spring:message code='main.jjh09'/> : </label>
				<span id="chooseId">${userId}</span>
			</p>
			<p>
				<label style="color:rgb(0, 72, 149);"><spring:message code='ezPersonal.t949'/> : </label>
				<input type="password" id="txtOldPassword" onKeyPress="if(event.keyCode==13) PassWordChange();"/>
			</p>
			<p>
				<label style="color:rgb(0, 72, 149);"><spring:message code='main.jjh05'/> : </label>
				<input type="password" id="txtNewPassword" onKeyPress="if(event.keyCode==13) PassWordChange();"/>
			</p>
			<p style="border-bottom:1px solid rgb(0, 72, 149)">
				<label style="color:rgb(0, 72, 149);"><spring:message code='main.jjh06'/> : </label>
				<input type="password" id="txtNewPasswordConfirm" onKeyPress="if(event.keyCode==13) PassWordChange();"/>
			</p>
			<div class="btnposition" style="margin:10px">
			    <a class="imgbtn" onClick="javascript:PassWordChange()" ><span><spring:message code='ezSchedule.t4' /></span></a>
			    <a class="imgbtn" rel="modal:close"><span><spring:message code='ezSchedule.t5' /></span></a>
			</div>			
		</div>
	</body>
</html>
