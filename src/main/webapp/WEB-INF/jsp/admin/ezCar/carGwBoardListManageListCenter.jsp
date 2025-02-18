<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>managelist_center</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	   <style type="text/css">
    		.warningbox01 { width:540px; margin:0 auto; border:1px solid #cccaca; background:#e8e8e8;}
    		.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}
    		.warnintxt01 { position:relative ;padding-bottom:10px;margin-top:15px}
    		.warningimg { position:absolute; top:0px; left:0px;}
    		.warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}
    		.warningdl dt { height:40px; margin-top:10px;text-align:left;}
    		.warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left;}
    		.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
		</style>
		<script type="text/javascript" id="clientEventHandlersJS" >
			document.onselectstart = function () {
	        	if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
	        	} else {
		            return true;
	        	}
	    	};	
		</script>
	</head>
	<body class="mainbody">	
    	<form name="brds">
        	<input type="hidden" id="proc" name="proc" value="MOD">
    	</form>
	</body>
</html>