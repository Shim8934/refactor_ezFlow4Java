<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t349"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	</head>
	<style type="text/css">
		 .warningbox{margin:240px auto 0px auto; padding:40px 20px 0px 20px; width:625px; height:184px; border:1px solid #d6d6d6; box-sizing:border-box;}
		.warningbox .warningimg{margin:0px; padding:0px 0px 0px 40px; float:left;}
		.warningbox .warningDL{margin:0px; padding:0px 0px 0px 30px; float:left; overflow:hidden;}
		.warningbox .warningDL dt{margin:0px; padding:12px 0px 5px 0px; font-size:24px; font-weight:bold; color:#3d8fea; letter-spacing:-1px;}
		.warningbox .warningDL dd{margin:0px; padding:0px; font-size:20px; color:#333; letter-spacing:-1px;}
		.warningbox .warningDL dd span{ font-size:20px; font-weight:bold;}
	</style>
	<body class="mainbody">
    <div class="warningbox">
        <p class="warningimg"><img src="/images/notify/warning_resorce.png" width="105" height="89"></p>
        <dl class="warningDL">
        	<dt>WARNING</dt>
	        <dd>${accMessage}</dd>
        </dl>
    </div>
	</body>
</html>