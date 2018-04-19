<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />"
	type="text/css">
<script type="text/javascript">

function goToProjectDetails() {
	window.open("/ezPMS/getProjectDetails.do", "right");
}

function addNewProject(){
	var top = ($(window).height() - $(this).outerHeight()) / 2;
    var left = ($(window).width() - $(this).outerWidth()) / 2;
	var feature = GetOpenPosition(top, left);
 
	DivPopUpShow(845, 555, "/ezPMS/newProject.do");
};
</script>
</head>
<body>
	mainPage
	<br>
	<br> status = ${status}
	<br> ============================
	<br>
	<button onclick="getTest()">click</button>
	<div id="test">Hi</div>
	<button onclick="goToProjectDetails()">project</button>
	<br><br>
	<button id="newProject" onclick="addNewProject()">new project</button>
	
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>