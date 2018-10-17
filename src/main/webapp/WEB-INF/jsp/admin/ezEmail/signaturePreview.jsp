<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
	    <link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />	
	    <link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var signNo = '${signNo}';
			var content = '${content}';
			
			window.onload = function () {
				signPreviewChange();
			}
	        
	        function signPreviewChange() {
	        	var preTxt = $(".signPreViewTxt")[0];
	        	var preIframe = $(".signPreViewIframe");
	        	var txtDisplay = "block";
	        	var iframeDisplay = "none";
	        	var txtText = content;
	        	//var strLang = typeof(userLang) == "undefined" ? 1 : userLang;
	        	
	        	if (content !== undefined) {
	        		preTxt.style.textAlign = "justify";
	        		preTxt.style.position = "none";
	        		preTxt.style.top = "0";
	        		preTxt.style.transform = "none";
	        		preTxt.style.display = txtDisplay;
		        	preIframe[0].style.display = iframeDisplay;
		        	preTxt.innerHTML = txtText;
	        	}
	        	
	        }
		</script>
	
	</head>
	<body style="width:890px; height:660px;">
		<div class="signPreViewTxt" style="text-align:center;"></div>
		<iframe src="" class="signPreViewIframe" name="signPreViewIframe" style="display:none; border:none; width:100%; height:100%;" ></iframe>
	</body>
</html>



