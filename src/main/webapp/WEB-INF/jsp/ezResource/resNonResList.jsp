<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t349"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezResource.e2"/>" type="text/css" />
	</head>
	<style type="text/css">
    		.warningbox01 { width:540px; margin:0 auto; border:1px solid #dedede; background:#f8f8fa;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}
			.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 15px 25px;}
			.warnintxt01 { position:relative; margin-bottom:10px;margin-top:20px}
			.warningimg { position:absolute; top:0px; left:0px;}
			.warningdl { padding:10px 10px 5px 115px; margin:0px; display:inline-block;}
			.warningdl dt { height:40px; padding-left:5px; margin-top:10px; margin-left:10px; text-align:left;}
			.warningdl dd { padding:0px 10px 0px 20px; margin:0px 0px 10px 0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left; word-break:break-all;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
	</style>
	<body class="mainbody">
		<h1></h1>
		<br/>				
		<br/>
			<div id="EmptyMsg">
    			<div class="warningbox01" style="margin-top:130px;">
        			<div class="warningbox02">
  	        			<div class="warnintxt01" style="text-align:left; display:inline-block;">
	        				<span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="64" height="64" style="margin:18px 0px 18px 34px;"></span>
	        				<dl class="warningdl">
	        				<dt><img src="/images/notify/warning01.gif" width="183" height="27"></dt>
	        					<dd>
	        						${accMessage}	
	        					</dd>
	        				</dl>
	        			</div>
	    			</div>
    			</div>
			</div>
	</body>
</html>