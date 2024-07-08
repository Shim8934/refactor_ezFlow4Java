<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezNewPortal.board.pgb05' /></title>
<link rel="stylesheet"  href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css">
<link rel="stylesheet"  href="${util.addVer('/js/dist/themes/default/style.min.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<link rel="SHORTCUT ICON" href="${util.addVer('/images/favicon/favicon.png')}">
<style type="text/css">
	.info-message {
		padding-left: 15px;
		display: inline-block;
	}
	#designate {
		width:100%;
	}
</style>
<script type="text/javascript">
	var portletId = "<c:out value='${portletId}'/>";
	
	function saveBtn() {
		var parentConn = window.opener.document.getElementById(portletId).querySelector(".connectionUrl");
		parentConn.value = URLParamsUtils(parentConn.value).put("fileName", document.getElementById("fileName").value);

		window.close();
	}
	
	function cancleBtn() {
		window.close();
	}
	
	function checkWord(obj){
	    var RegExp = /[`~!<>@#$%^&*|\\\"\';:\/?]/gi;
	    if (RegExp.test(obj.value)) {
	    	obj.value = obj.value.replace(RegExp , '');
	    	alert("<spring:message code='ezNewPortal.ljw01'/>");
	    }
	}

</script>
</head>
<body class="popup">
	<h1><spring:message code='ezNewPortal.board.pgb05' /></h1>
	<span class="info-message"><spring:message code='ezNewPortal.board.pgb06' /></span>
	<table class="content" style="width:95%; margin:auto; margin-top: 7px;">
		<tr>
			<th><spring:message code='ezNewPortal.board.pgb07' /></th>
			<td><input id="fileName" type="text" onkeyup="checkWord(this)" maxlength="40" value="<c:out value='${fileName}'/>"></td>
		</tr>
	</table>
	<div class="btnpositionNew" style="margin:0px">
	 	<a class="imgbtn"><span onclick="saveBtn()"><spring:message code='main.sp09'/></span></a>
	 	<a id="btn2" class="imgbtn" onClick="cancleBtn()"><span><spring:message code='main.t135'/></span></a> 	
	</div>
</body>
</html>