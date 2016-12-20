<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
	<head>
		<title>로그인</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
		<link href="/css/common.css" rel="stylesheet" type="text/css" />
		<link href="/css/login.css" rel="stylesheet" type="text/css" />		
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript">
		
			function actionLogin() {				
			    if (document.loginForm.id.value =="") {
			        alert("아이디를 입력하세요");
			        return;
			    } else if (document.loginForm.password.value =="") {
			        alert("비밀번호를 입력하세요");
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
			            document.getElementById("TextUserID").className = "input_text focus";
			            // 쿠키 값의 마지막 위치 인덱스 번호 설정
			            if (end == -1)
			                end = document.cookie.length
			            return unescape(document.cookie.substring(offset, end))
			        }
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
			}
			function setting_click() {
			    var ver = navigator.userAgent;
			    window.open("/docs/usersetting_IE8.html", "", "height=768,width=1024, scrollbars=yes, status = yes, toolbar=yes, menubar=yes, location=yes, resizable=yes");
			}
		</script>
	</head>
	<body class="login_body" onload="fnInit()">
		<div class="login_warpper">
			<section class="login_layout">
				<div class="set1">             
					<article class="login_flash">
	                    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="464" height="309">
	                        <param name="movie" value="/images/kr/login/login_flash.swf" />
	                        <param name="wmode" value="transparent"> 
	                        <object type="application/x-shockwave-flash" data="/images/kr/login/login_flash.swf"  width="464" height="309">
	                            <param name="movie" value="/images/kr/login/login_flash.swf" />
	                            <param name="wmode" value="transparent"> 
	                            <a><img src="/images/kr/login/loginimg.gif" width="464" height="309"></a>
	                        </object>
	                    </object>
	                </article>
					<article class="login_form">
		                <p class="title"><img src="/images/kr/login/form_title.gif" alt="Groupware login" width="235" height="28"></p>
		                <form id="loginForm" name="loginForm" method="post">
		                	<input type="hidden" name="publicModulus" value="${publicModulus}"/>
		                	<input type="hidden" name="publicExponent" value="${publicExponent}"/>
		                	<input type="hidden" name="encryptID" />
		                	<input type="hidden" name="encryptPass"/>
		                    <fieldset>		                        
		                        <p class="id"><input id="TextUserID" name="id" style="ime-mode:disabled;" class="input_text" type="text" onblur="if (this.value.length==0) {this.className='input_text'}else {this.className='input_text focusnot'};" onfocus="this.className='input_text focus'" onKeyPress="if(event.keyCode==13) actionLogin();" /></p>
		                        <p class="pw"><input id="TextPassword" name="password" class="input_text" type="password" onchange="if(this.value.length!=0){this.className='input_text focus'}" onblur="if (this.value.length==0) {this.className='input_text'}else {this.className='input_text focusnot'};" onfocus="this.className='input_text focus'" onKeyPress="if(event.keyCode==13) actionLogin();" /></p>	                        
		                        <img src="/images/kr/login/btn_login.gif" id="LoginButton"  tabindex="3" border="0" class="btn_login" onclick="javascript:actionLogin()" style="cursor:pointer">
		                        <p class="saveid"><input type="checkbox" value="" id="checkId" name="checkId" /><label for="save_login"> ID Save</label></p>	                        	                        
		                    </fieldset>
		                    <input type="hidden" name="message" value="${message}" />
					    </form>
					</article>
				</div>
	             
			  <div class="set2">
					<article class="login_logo"><img src="/images/kr/login/logo.gif" alt="ezEKP그룹웨어" width="417" height="80"></article>
					<!-- 2016-10-12 지정석 / IE11세팅, 유저가이드 필요할 때 까지 주석 -->
	                <!-- <article class="login_banner">
		                <dl>
		                	<dd><img src="/images/kr/login/banner01.gif" width="140" height="55" alt="User Guide" onclick="setting_click()" /></dd>
		                </dl>
		                <dl>
		                	<dd><img src="/images/kr/login/banner02.gif" width="140" height="55" alt="IE Setting" /></dd>
		                </dl>
	                </article> -->
			  </div>
			  <address><span>COPYRIGHT(C) KAONI. ALL RIGHTS RESERVED.</span></address>
	            <div style="color:white;font-size:large;text-align:center;"></div>
			</section>
		</div>		
		<div class="noti_layer" style="position:absolute;top:295px;left:800px;display:none;" id="divCapsLock">
			<span class="arrow">
				<img src="/images/login/notilayer_bg_arrow.gif" width="7" height="6" style="vertical-align:top; z-index:10;" />
			</span>
			<p><span>[<strong class="yellow_txt">Caps Lock</strong>]?pCapsLockMsg?></span></p>
		</div>			
	</body>
</html>
