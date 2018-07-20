<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezEKP Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
		<link href="/css/login.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="<spring:message code='main.e15'/>" type="text/css">
		<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
		<style>
			.blocker {
				text-align: center;
			}
			.modal p {
				background:none;
			}			
			.warning_wrap{ overflow:hidden; width:600px; margin:auto}
			.warning_wrap p{ margin:0px; padding:0px; font-family:Malgun Gothic, Meiryo UI; text-align:center; float:left;}
			.warning_wrap dl{ margin:7px 0px 0px 20px;; padding:0px; font-family:Malgun Gothic, Meiryo UI; float:left; overflow:hidden;}
			.warning_wrap dt{ font-size:18px; color:#000; padding:0px 0px 5px 0px; margin:0px; font-weight:bold; border-bottom:1px solid #d7d7d7;}
			.warning_wrap dd.count{ color:#000; font-weight:normal; font-size:15px; padding:10px 0px;}
			.warning_wrap dd.count .pointRed{ color:#ff0000; font-weight:bold; display:inline-block; font-family: Malgun Gothic, Meiryo UI; font-size:15px;}
			.warning_wrap dd{color:#8e8e8e; font-size:12px; padding:0px 0px 2px 0px; margin:0px;letter-spacing:-1px;}
			
			.password_reset{ margin:0 auto; padding:0px; width:385px;}
			.password_reset .passwordTitle{ margin:0px; padding:0px; font-family:Malgun Gothic, Meiryo UI; font-size:17px; color:#000; text-align:center; line-height:25px;}
			.password_reset .passwordTitle span{ display:inline-block; color:#006be4; font-family:Malgun Gothic, Meiryo UI; font-size:17px;}
			.password_reset .passwordForm{ margin:15px 0px; padding:8px 5px; list-style:none; border-top:1px solid #000; border-bottom:1px solid #000;}
			.password_reset .passwordForm li{ margin:0px 0px 15px 0px; padding:5px 15px 0px; font-size:13px; clear:both; overflow:hidden;}
			.password_reset .passwordForm li .formText{ display:inline-block; line-height:35px; font-size:13px;}
			.password_reset .passwordForm li .formID{ display:inline-block; font-weight:bold;font-size:13px; float:right; width:199px; height:35px; line-height:35px; border:1px solid #d9d9d9; border-radius:2px; -webkit-border-radius:2px; -moz-border-radius:2px; text-align:center; box-sizing:border-box;}
			.password_reset .passwordForm li .formInput{ display:inline-block; float:right; font-size:13px;}
			.password_reset .passwordForm li .formInput input{font-size:13px; width:199px; height:35px; line-height:35px; border:1px solid #d9d9d9; border-radius:2px; -webkit-border-radius:2px; -moz-border-radius:2px; padding:0px 0px 0px 5px;}
			.password_reset .passwordForm li.grayText{ color:#8e8e8e; font-size:12px; margin:0px; padding:0px}
			#exDiv3 dl{margin-top: 20px;}
			#layerTitle{margin-bottom: 20px;}
		</style>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
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

					frm.encryptID.value = rsa.encrypt(frm.id.value.toLowerCase());
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
			    if ("${isWrongPass}" == "Y") {
			    	$("#imgMnt").html("<img src='/images/warning2.png'>");
			    	$("#exDiv2").modal();
			    }
			    else if (message != "") {
// 			        alert(message);
					$("#layerTitle").text(message);
					$("#imgMnt2").html("<img src='/images/warning2.png'>");
			        $("#exDiv3").modal();
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
		<div class="login_wrapper">
			<div class="login_layout">
        		<div class="login_form">	                
	                <form id="loginForm" name="loginForm" method="post">
	                	<input type="hidden" name="publicModulus" value="${publicModulus}"/>
	                	<input type="hidden" name="publicExponent" value="${publicExponent}"/>
	                	<input type="hidden" name="encryptID" />
	                	<input type="hidden" name="encryptPass"/>
	                	
	                    <fieldset>		                    	
	                    	<p class="logo"><img src="/images/kr/login/logo.gif"></p>   
	                        <p class="id">
	                        	<input id="uid" name="id" style="ime-mode:disabled;" class="input_text" type="text" onblur="if (this.value.length==0) {this.className='input_text'}else {this.className='input_text focusnot'};" onfocus="this.className='input_text focus'" onKeyPress="if(event.keyCode==13) actionLogin();" />
	                        </p>		                 
	                        <p class="pw">
	                        	<input id="upw" name="password" class="input_text" type="password" onchange="if(this.value.length!=0){this.className='input_text focus'}" onblur="if (this.value.length==0) {this.className='input_text'}else {this.className='input_text focusnot'};" onfocus="this.className='input_text focus'" onKeyPress="if(event.keyCode==13) actionLogin();" />
	                        </p>	                        
	                        <img src="/images/kr/login/btn_login.gif" id="LoginButton"  tabindex="3" border="0" class="btn_login" class="btn_login" onclick="javascript:actionLogin()" style="cursor:pointer">
	                        <p class="saveid">
	                        	<input type="checkbox" value="" id="checkId" name="checkId" class="inp_checkbox" />
	                        	<label for="checkId">
	                        		<span></span>
	                        		ID Save
	                        	</label>
	                        </p>	                        	                        
	                    </fieldset>
	                    <input type="hidden" name="message" value="${message}" />		                    
				    </form>
				</div>															
			</div>
			<footer><p style="font-family: Malgun Gothic, Meiryo UI">Copyright &copy; 2000-2018 KAONI  All Rights reserved</p></footer>
		</div>				
		<div class="noti_layer" style="position:absolute;top:295px;left:800px;display:none;" id="divCapsLock">
			<span class="arrow">
				<img src="/images/login/notilayer_bg_arrow.gif" width="7" height="6" style="vertical-align:top; z-index:10;" />
			</span>
			<p><span>[<strong class="yellow_txt">Caps Lock</strong>]?pCapsLockMsg?></span></p>
		</div>
		<div id="exDiv" style="display:none;margin-bottom:100px;padding:15px">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>			
			<div class="password_reset">
				<p class="passwordTitle" style="border-bottom:0px">
					<c:if test="${isFirstLogin == 'Y'}">
						<spring:message code='main.jjh07'/>
					</c:if>
					<c:if test="${isFirstLogin != 'Y'}">
						<spring:message code='fail.user.passwordExpired'/>
					</c:if>
					<br/>
					<span><spring:message code='main.jjh03'/></span>
				</p>
				<ul class="passwordForm">
					<li style="padding-top:10px"><span class="formText"><spring:message code='main.jjh09'/></span><span class="formID" id="chooseId">${userId}</span></li>
					<li><span class="formText"><spring:message code='ezPersonal.t949'/></span><span class="formInput"><input type="password" id="txtOldPassword" onKeyPress="if(event.keyCode==13) PassWordChange();"/></span></li>
					<li><span class="formText"><spring:message code='main.jjh05'/></span><span class="formInput"><input type="password" id="txtNewPassword" onKeyPress="if(event.keyCode==13) PassWordChange();"/></span></li>
					<li><span class="formText"><spring:message code='main.jjh06'/></span><span class="formInput"><input type="password" id="txtNewPasswordConfirm" onKeyPress="if(event.keyCode==13) PassWordChange();"/></span></li>
					<li style="padding-bottom:10px;padding-top:3px" class="grayText">▒ <spring:message code='main.jjh04'/></li>
				</ul>
			</div>
			<div class="btnpositionLayer" style="background-color: white;border:0px">
			    <a class="imgbtn" onClick="javascript:PassWordChange()" ><span><spring:message code='ezSchedule.t4' /></span></a>
			</div>			
			<%-- <div style="float:left">
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
			<div class="btnpositionLayer" style="background-color: white;border:0px">
			    <a class="imgbtn" onClick="javascript:PassWordChange()" ><span><spring:message code='ezSchedule.t4' /></span></a>
			</div> --%>			
		</div>
		
		<%-- 2018-05-24 홍승비 - 비밀번호 오류 시 레이어팝업 출력 --%>
		<div id="exDiv2" style="display:none;max-width:620px;height:190px;padding-top:27px;margin-bottom:100px">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>
			<div class="warning_wrap" style="padding-left:20px">
		    	<p style="border:0px" id="imgMnt"></p>
		        <dl>
		        	<dt>${message1}</dt>
		            <dd class="count">${message2}<span class="pointRed">${message3}</span>${message4}</dd>
		            <dd>${message5}</dd>
		            <dd>${message6}</dd>
		        </dl>
		    </div>
			<%-- <div style="height:150px;border:1px solid rgb(0, 72, 149);margin:5px;border-radius:10px">
				<div style="color:rgb(0, 72, 149);padding:18px 0px 10px 20px;font-size:12px;white-space: pre-wrap;">▒ ${message1}<span class="spanMsg">${message2}</span>${message3}
				</div>
			</div>		
			<div class="btnposition" style="margin-top:0px;">
			    <a class="imgbtn" rel="modal:close"><span><spring:message code='ezSchedule.t4' /></span></a>
			</div>	 --%>
		</div>

<!-- 		2018-07-20 강민석 존재하지 않는 ID를 입력했을 경우 alert -> layer 팝업으로 변경 -->
		<div id="exDiv3" style="display:none;max-width:620px;height:190px;padding-top:27px;margin-bottom:100px">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>
			<div class="warning_wrap" style="padding-left:20px">
				<p style="border:0px" id="imgMnt2"></p>
		        <dl>
					<dt id="layerTitle">${message1}</dt>
		            <dd><spring:message code='fail.common.login.warning1'/></dd>
		            <dd><spring:message code='fail.common.login.warning6'/></dd>
		        </dl>
		    </div>
		</div>

	</body>
</html>
