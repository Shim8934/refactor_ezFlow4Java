<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/Tab.css" type="text/css">
<link rel="stylesheet" href="/css/ezTask/circularProgressBar.css" type="text/css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezTask/circularProgressBar.js"></script>
<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 110;
var progress = "${project.progress}";

$(document).ready(function(){
	$(window).resize(function() {
		CurrentHeight = $(window).height()-110;
		$(".overview").css("height", CurrentHeight + "px");
		$(".kanban").css("height", CurrentHeight - 14 + "px");
	});
});

$(function() {
	CurrentHeight = $(window).height()-110;
	$(".overview").css("height", CurrentHeight + "px");
	$(".kanban").css("height", CurrentHeight - 10 + "px");
	initProgressBar();
});

function initProgressBar() {
	$(".progress_graph").circleProgress({
		value: 0.4,
		fill : {color : "blue"},
		size : 135
	}).on('circle-animation-progress', function(event, progress) {
		$(this).find('strong').html(40 + "%");
	});
}
</script>
<style type="text/css">
#kanbanArea {
	float : left;
	width : 80%;
	padding : 5px;
	border-right : 1px solid gray;
}
#overviewArea {
	width : 18%;
	overflow : auto;
}

.rightPart {
	float : right;
}

.kanban {
	display : table-cell;
	margin-right : 16px;
	border : 1px solid #666;
	padding : 5px;
	width : 22%;
	overflow : auto;
	float : left;
}

.card {
	margin : 10px 5px;
	padding : 10px;
	position : relative;
	width : 85%;
	height : 100px;
	color : block;
	border : 1px solid black;
}

.kanban > h1 {
	margin: 0;
	border-bottom: 1px solid #999;
	padding-bottom: 5px;
	font-size: 10pt;
	text-align: center;
}

.icon {
	width:40px;
	height:40px;
	border:2px solid blue;
	display:inline-block;
	float : right;
}
</style>
</head>
<body>
<div id="kanbanArea" class="overview">
	<div id="firstKanban" class="kanban">
		<h1>나의 업무</h1>
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
	</div>
	<div id="secondKanban" class="kanban">
		<h1>전체 업무</h1>
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
	</div>
	<div id="thirdKanban" class="kanban">
		<h1>완료된 업무</h1>
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
	</div>
	<div id="forthKanban" class="kanban">
		<h1>게시판</h1>
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
		<div class="card">hello
		</div>  
	</div>
</div>

<div id="iconArea" class="rightPart">
		<div id="printReport" class="icon">출력</div>
		<div id="editProjectInfo" class="icon"><img src="/images/ezLadder/icon_game03_no.png" style="width:40px; height:40px"></div>
		<div id="setting" class="icon">환경설정</div>
	</div>
<div id="overviewArea" class="overview rightPart">
	<div class="circle progress_graph" style="width:100%; top:15px;">
		<strong></strong>
	</div>
	${project.status }<br>
	${project.restDueday }<br>
	${project.planStartDate }<br>
	${project.planEndDate }<br>
	${project.overview }<br>
	${project.headManagerName }<br>
</div>
</body>
</html>