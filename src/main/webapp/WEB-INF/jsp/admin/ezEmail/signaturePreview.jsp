<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var signNo = '${signNo}';
			var content = '${content}';
			
			window.onload = function () {
				signPreviewChange();
			}
	        
	        function signPreviewChange() {
	        	var preIframe = $(".signPreViewIframe");
	        	var txtDisplay = "block";
	        	var iframeDisplay = "none";
	        	//var strLang = typeof(userLang) == "undefined" ? 1 : userLang;
	        	
	        	if (content !== undefined) {
		        	preIframe.get(0).contentWindow.document.body.innerHTML = content;
	        	}
	        	
	        }
		</script>
	
	</head>
	<body style="height:100%;">
		<iframe class="signPreViewIframe" name="signPreViewIframe" style="border:none; width:100%; height:650px;" ></iframe>
	</body>
</html>



