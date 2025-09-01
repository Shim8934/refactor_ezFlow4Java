<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html class="frame_main">
	<head>		
		<title><spring:message code="ezBoard.t84" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">        
		<link rel="shortcut icon" href="/images/favicon.ico">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
	</head>
	<script type="text/javascript">
	    function reloadLoginPage(multiLoginFlag, url) {
	    	var frm = "";
	    	
	    	frm = "<form action='" + url + "' method='post' style='display:none;' id='reloadLogin' onsubmit='return false;'>";
	    	if(!!multiLoginFlag) {
	    		frm += "<input type='hidden' name='multiLoginFlag' value='" + multiLoginFlag + "'>";
	    	}
	    	frm += "</form>";
	    	
	    	var wrapper = document.createElement("div");
	    	wrapper.innerHTML = frm;
	    	document.body.appendChild(wrapper);
	    	document.getElementById("reloadLogin").submit();
	    	
	    }
	    
	    function bottomFrameLoad() {
	    	var bottomFrame = window.frames["bottom"];
	    	if (typeof bottomFrame != "undefined") {
	    		var bottomFrameSrc = bottomFrame.location.href;
		    
		    	if (bottomFrameSrc.indexOf("admin/accessBlockToAdmin.do") != -1) {
		    		window.location.reload();
		    	}	    		
	    	}
	    }
	</script>
	<body class="body_frame_main">
	<iframe id="topFrame" src="/admin/top.do" name="top"></iframe>
	<iframe id="bottomFrame" onload="bottomFrameLoad()" src="/admin/ezBoard/boardLeft.do" name="bottom"></iframe>
	</body>
</html>

