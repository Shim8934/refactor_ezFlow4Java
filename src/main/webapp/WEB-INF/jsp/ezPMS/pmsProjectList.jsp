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
function getTest() {
	$.ajax({
		type : "POST",
		url : "/ezPMS/addNewProject.do",
		dataType : "json",
		data : {
			projectName : "eunjeong Test"
		},
		success : function(result) {
			console.log(result);
			$("#test").text(result.status);
		},
		error : function() {
			$("#test").text("error");
		}
	})	
}

function goToProjectDetails() {
	window.open("/ezPMS/getProjectDetails.do", "right");
}
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
</body>
</html>