<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
	    <link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />	
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/letterList.js')}"></script>
		<script type="text/javascript">
			var letterNo = '<c:out value="${letterNo}"/>';
			var isDivPopUp = false;
			var letterNoMsg = "<spring:message code='ezEmail.letter16'/>"; // 존재하지 않는 편지지 입니다.
			var previewMsg = "<spring:message code='ezBoard.t431'/>"; // 미리보기 
			var dataNoMsg= "<spring:message code='main.t00026'/>"; // 데이터가 없습니다.
			
			window.onload = function () {
				isDivPopUp = true;
				letterPreView(letterNo);
			}
		</script>
	
	</head>
	<body style="width:890px; height:660px;">
		<div class="lmPreViewTxt" style="text-align:center; padding-top: 30%;"></div>
		<iframe src="" class="lmPreViewIframe" onload="onloadPreview(this)" name="lmPreViewIframe" style="display:none; border:none; width:100%; height:100%;" ></iframe>
	</body>
</html>



