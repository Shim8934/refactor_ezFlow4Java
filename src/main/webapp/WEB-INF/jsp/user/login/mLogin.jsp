<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezMobile Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
		<link rel="stylesheet" type="text/css" href="/js/jquery.mobile/jquery.mobile-1.4.5.min.css" />
    	<link rel="stylesheet" type="text/css" href="/css/mobile/mobile.css" />				
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery.mobile/jquery.mobile-1.4.5.min.js"></script>
		<script type="text/javascript" src="/js/mobile/mobile.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
	</head>
	<body class="loginbody">
		<section id="login" data-role="page">     	
		    <form id="loginForm" name="loginForm" method="post" action="/mobile/user/login/login.do">
		    	<input type="hidden" name="publicModulus" value="${publicModulus}"/>
			    <input type="hidden" name="publicExponent" value="${publicExponent}"/>
			    <input type="hidden" name="idCheck" value="<spring:message code='main.jjs02'/>"/>
			    <input type="hidden" name="passCheck" value="<spring:message code='main.jjs01'/>"/>
			    <input type="hidden" name="failLogin" value="<spring:message code='fail.common.login'/>"/>			
			    <div id="wrap">
			        <div id="address">
			            <h1>GROUPWARE  MOBILE</h1>
			        </div>
			        <div id="login">
			            <div class="logo">
			                <img src="/images/mobile/login_logo.png" border="0" />
			            </div>
			            <div class="login_form">		            	           	
			            	<p>   
			                	<input type="text" placeholder="아이디를 입력하세요" id="uid" name="id" class="login_inp" data-clear-btn="true" onKeyPress="if(event.keyCode==13) actionLogin();"/>
			               	</p>		               	        
							<p style="margin-top:10px">
			                	<input type="password" placeholder="비밀번호를 입력하세요" id="upw" name="password" class="login_inp" data-clear-btn="true" maxlength="16" onKeyPress="if(event.keyCode==13) actionLogin();"/>
			               	</p>		               	
			               	<button type="button" style="height:70px;background-color:black;color:white;margin-top:10px;" onclick="javascript:actionLogin();">L O G I N</button>							                    	                
			                <div style="margin-top:10px;">
			                	<label for="checkId" style="color:black">ID SAVE</label>		             
			                	<input type="checkbox" value="" id="checkId" name="checkId" class="" />	                        
			                </div>		                
			                <input type="hidden" name="message" value="${message}" />	                
			            </div>
			        </div>
			    </div>
		    </form>	    
		    <div class="ui-content" id="popupAlert" style="min-width: 255px; max-width: 285px; height:70px; text-align:center" data-role="popup" data-overlay-theme="b" data-transition="pop">
			    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
			    <p>
					<a href="#" id="popupContent" data-rel="back" data-icon="alert" data-theme="a" data-role="button" style="max-width:95%;min-height:30px;font-weight:normal;background-color:#f2f2f2;font-size:12px;padding-top:20px"><spring:message code='main.jjs02'/></a>
				</p>			
			</div>
		</section>				
	</body>	
</html>
