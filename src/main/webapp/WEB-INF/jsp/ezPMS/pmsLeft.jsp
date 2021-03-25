<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('ezPMS.e1', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript">
	    var mode = "${mode}";
	        $(function() {
	        	if (mode != "mail") {
	        		window.open("/ezPMS/pmsProjectListMain.do", "right");
	        	}
	    
	        	$("#pmsSetting").click(function() {
	        		window.open("/ezPMS/pmsSetting.do", "right");
	        	});
	        	
	        	$("#myTask").click(function() {
	        		window.open("/ezPMS/pmsMyTask.do", "right");
	        	});
	        	
	        	$("#projectList").click(function() {
	        		window.open("/ezPMS/pmsProjectListMain.do", "right");
	        	})
	        });
	    </script>
	</head>
	<body class="leftbody">
	    <div id="left">
	    	<div class="left_pims" title="ezPMS"><span><spring:message code='ezPMS.t8' /></span></div>
		    <h2 class="on"><span><spring:message code='ezPMS.t8' /></span></h2>
		    <ul>
		    	<li><span id="projectList" style="width:100%;display:inline-block;"><spring:message code='ezPMS.t8' /></span></li>
		    	<li><span id="myTask" style="width:100%;display:inline-block;"><spring:message code='ezPMS.t142' /></span></li>
		    </ul>
		    <h3><span id="pmsSetting" style="width:100%;display:inline-block;"><spring:message code='ezPMS.t144' /></span></h3>
		</div>
	    
	</body>
</html>