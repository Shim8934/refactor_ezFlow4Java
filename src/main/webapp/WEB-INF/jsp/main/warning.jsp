<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>warning</title>
		<style type="text/css">
			.warningbox01 { width:540px; margin-top:200px; margin-left:110px; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}
			.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}
			.warnintxt01 { position:relative ;padding-bottom:10px;}
			.warningimg { position:absolute; top:0px; left:0px;}
			.warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}
			.warningdl dt { height:40px; margin-top:10px;}
			.warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
		</style>
	</head>
	<body>
	<div class="warningbox01">
	  <div class="warningbox02">
	  	<div class="warnintxt01">
			<span class="warningimg"><img src="/images/warning02.gif" width="136" height="112"></span>
		<dl class="warningdl">
			<dt><img alt="" src="/images/warning01.gif" width="183" height="27"></dt>
			<dd><spring:message code='main.t00001' /><br/>
			</dd>
		</dl>
		</div>
		<!-- 삽입할 내용이 없으신경우 아래 <p></p> 태그를 삭제해주세요 -->
		</div>
	</div>
	</body>
</html>