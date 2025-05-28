<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<title>::: ezFlow Java :::</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="shortcut icon" href="/images/icon/gilfavicon.ico">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
<style>
body {
	position: absolute;
	top: 0;
	left: 0;
	height: 100%;
	width: 100%;
	display: table;
	overflow: hidden;
}

body>div {
	display: table-cell;
	vertical-align: middle;
	padding-bottom: 150px;
}

.password_reset {
	margin: 0 auto;
	padding: 0px;
	width: 550px;
}

.password_reset .passwordTitle {
	margin: 0px;
	padding: 0px;
	font-family: Malgun Gothic, Meiryo UI;
	font-size: 20px;
	color: #000;
	text-align: center;
	line-height: 25px;
}

.password_reset .passwordTitle span {
	display: inline-block;
	color: #006be4;
	font-family: Malgun Gothic, Meiryo UI;
	font-size: 20px;
}

.password_reset .passwordForm {
	margin: 15px 0px;
	padding: 8px 5px;
	list-style: none;
	border-top: 1px solid #000;
	border-bottom: 1px solid #000;
}

.password_reset .passwordForm li {
	margin: 0px 0px 15px 0px;
	padding: 5px 15px 0px;
	font-size: 13px;
	clear: both;
	overflow: hidden;
}

.password_reset .passwordForm li .formText {
	display: inline-block;
	line-height: 35px;
	font-size: 14px;
}

.password_reset .passwordForm li .formID {
	display: inline-block;
	font-weight: bold;
	font-size: 13px;
	float: right;
	width: 321.5px;
	height: 35px;
	line-height: 35px;
	border: 1px solid #d9d9d9;
	border-radius: 2px;
	-webkit-border-radius: 2px;
	-moz-border-radius: 2px;
	text-align: center;
	box-sizing: border-box;
}

.password_reset .passwordForm li .formInput {
	display: inline-block;
	float: right;
	font-size: 13px;
}

.password_reset .passwordForm li .formInput input {
	font-size: 13px;
	width: 120px;
	height: 35px;
	line-height: 35px;
	border: 1px solid #d9d9d9;
	border-radius: 2px;
	-webkit-border-radius: 2px;
	-moz-border-radius: 2px;
	padding: 0px 0px 0px 5px;
}

.password_reset .passwordForm li.grayText {
	color: #8e8e8e;
	font-size: 13px;
	margin: 0px;
	padding: 0px
}

#exDiv3 dl {
	margin-top: 20px;
}

.warning_wrap .layerTitle {
	margin-bottom: 20px;
}

#email-input {
	/* 	margin-right: 5px; */
	
}

#checkmsg {
	padding-top: 5px;
	transition: 0.2s all;
	font-size: 14px;
}

.btnpositionLayer a.imgbtn span {
	font-size: 13px;
}
</style>
</head>
<body style="opacity: 0; transition: 0.5s all;">
	<div>
		<div class="password_reset">
			<p class="passwordTitle" style="border-bottom: 0px">
				<br /> <span><spring:message code='email.alias.login.title' /></span>
			</p>
			<ul class="passwordForm">
				<li style="padding-top: 10px;"><span class="formText"><spring:message code='main.jjh09' /></span> <span class="formID" id="loginId">${loginId}</span></li>
				<li><span class="formText"><spring:message code='email.alias.login.emailid' /></span><span id="inputContainer" class="formInput"><input type="text" id="email-input" maxlength="20" spellcheck="false" style="ime-mode: disabled;" /> <span style="font-size: 14px;">@${domainName}</span>
						<div class="btnpositionLayer" style="display: inline-block; margin: 0px; padding: 0px; padding-left: 5px; background: none; border: none; vertical-align: middle;">
							<a class="imgbtn" id="email-check"><span><spring:message code='email.alias.button' /></span></a>
						</div>
						<div id="checkmsg">
							<br>
						</div></span></li>
				<li style="padding-bottom: 10px; padding-top: 3px" class="grayText"><spring:message code='email.alias.login.warn' /></li>
			</ul>
		</div>
		<div class="btnpositionLayer" style="background-color: white; border: 0px">
			<a class="imgbtn" id="email-submit"><span><spring:message code='ezSchedule.t4' /></span></a>
		</div>
	</div>
	<script type="text/javascript" src="${util.addVer('email.alias.lang', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email-check.js')}"></script>
	<script>
		document.getElementById("loginId").style.width = document.getElementById("inputContainer").clientWidth + "px";
		document.body.style.opacity = 1;
	</script>
</body>
</html>