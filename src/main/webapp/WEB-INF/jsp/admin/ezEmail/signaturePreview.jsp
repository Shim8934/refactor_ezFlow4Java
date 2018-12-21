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
			var content = opener.message.GetEditorContent();
			var replaceContent = "";
			var userObj = ${userObj};
			
			window.onload = function () {
				reContent(); // 사용자 정보 replace

				signPreviewChange();
			}
	        
			function signPreviewChange() {
				var preIframe = $(".signPreViewIframe");
				
				if (content !== undefined) {
					preIframe.get(0).contentWindow.document.body.innerHTML = replaceContent;
				}
			}
			
			function reContent() {
				replaceContent = content.replace(/[$]/g, '&#36;');
				
				$.each(userObj, function(key, value){
				    var replaceKey = '&#36;{' + key + '}';
				    
				    replaceContent = replaceContent.replace(new RegExp(replaceKey,"gi"), value);
				});
			}
		</script>
	
	</head>
	<body style="height:100%;">
		<iframe class="signPreViewIframe" name="signPreViewIframe" style="border:none; width:100%; height:650px;" ></iframe>
	</body>
</html>



