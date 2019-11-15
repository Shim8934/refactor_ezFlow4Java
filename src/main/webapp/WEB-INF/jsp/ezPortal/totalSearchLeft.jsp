<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <link rel="stylesheet" href="<spring:message code='main.e15' />" type="text/css">
	</head>
	<style type="text/css">
	.wrap-loading {
		position : fixed;
		left : 0;
		right : 0;
		top : 0;
		bottom : 0;
		background: rgba(0,0,0,0.5);
	}
	.loading_layer {
		z-index: 6000; 
		position: absolute; 
		top: 400px; 
		left: 500px; 
	}
	.display_none {
		display: none;
	}	
	</style>
	<body class="leftbody">
	    <div id="left">
	    	<!-- 일반 회람판하고 같은 아이콘으로 설정. -->
	        <div class="left_circular" title='<spring:message code="ezTotalSearch.t0001" />'><span><spring:message code='ezTotalSearch.t0001' /></span></div>
	    </div>
	    <ul class="on">
			<li style="border-top:1px solid #eaeaea" evt="0" class="off"><span id="" onclick="" style="width:100%;display:inline-block;">&nbsp;<spring:message code='ezTotalSearch.t0001' /></span></li>
		</ul>	    
<!-- 	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    <xml id="RootFolderXML" style="display: none;"></xml> -->
	</body>
	<div class="wrap-loading display_none">
		<span class="loading_layer" id="loadingLayer"></span>
	</div>	
</html>