<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='email.appr.title.pending' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
</head>
<body class="popup apprRejectPopUp">
	<h1 style="margin-bottom:0px;"><spring:message code='email.appr.reject' /></h1>
	<div id="close">
		<ul>
	    	<li><span onClick="btn_close()"></span></li>
	  	</ul>
	</div>
	
	<p style="font-size:15px;">※ <spring:message code='email.appr.pending.reject.confirm.sub' /></p>
	<div>
		<textarea id="memo" class="" style="width:98%; height: 100px; resize: none; word-break: break-all; overflow-y: auto; justify-content: center;" maxlength="200"></textarea>
		
		<div class="btnpositionNew" style="text-align:center;">
		    <a class="imgbtn"><span onClick="btn_ok_onclick()"><spring:message code='email.appr.reject' /></span></a>
		    <a class="imgbtn"><span onClick="btn_close()"><spring:message code='ezEmail.t39' /></span></a>
		</div>
	</div>

    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script>
		const P_COMPLETE_F = opener.appr_reject_arg.complete;
		function btn_ok_onclick() {
	           var memo = document.getElementById('memo').value;
	           P_COMPLETE_F(memo);
	           btn_close();
	       }
		
		function btn_close() {
			window.close();
		}
	</script>
</body>
</html>