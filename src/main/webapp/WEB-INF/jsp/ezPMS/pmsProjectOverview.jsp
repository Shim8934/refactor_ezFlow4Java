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
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 100;
var progress = "${project.progress}";
var status = "${project.status}";
var strHTML = "";
var projectId = "${project.projectId}";

$(document).ready(function(){
	$(window).resize(function() {
		CurrentHeight = $(window).height()-100;
		$(".overview").css("height", CurrentHeight + "px");
		$(".kanban").css("height", CurrentHeight - 14 + "px");
	});
});

$(function() {
	CurrentHeight = $(window).height()-100;
	$(".overview").css("height", CurrentHeight + "px");
	$(".kanban").css("height", CurrentHeight - 14 + "px");
	
	ableToChangeStatus();
	initProgressBar();
	
});

function initProgressBar() {
	var strStatus = "";
	
	switch(status){
	case "P" :
		strStatus = "진행";
		break;
	case "W" :
		strStatus = "대기";
		break;
	case "L" :
		strStatus = "지연";
		break;
	case "S" :
		strStatus = "보류";
		break;
	case "C" :
		strStatus = "완료";
		break;
	}
	
	$(".progress_graph").circleProgress({
		value: 0.4,
		fill : {color : "blue"},
		size : 134
	}).on('circle-animation-progress', function(event, progress) {
		$(this).find('strong').html(40 + "%<br><div style='font-size:20px'>" + strStatus + "</div>");
	});
}

function ableToChangeStatus() {	
	switch(status){
		case "L" :
		case "P" :
			strHTML += "<a class='imgbtn' style='margin-right:4px;'><span onclick='changeStatus(C)'>";
			strHTML += "프로젝트 완료";
			strHTML += "</span></a> ";
			strHTML += "<a class='imgbtn'><span onclick='changeStatus(S)'>";
			strHTML += "프로젝트 보류";
			strHTML += "</span></a>";
			break;
		case "W" :
			strHTML += "<a class='imgbtn' style='margin-right:4px;'><span onclick='changeStatus(P)'>";
			strHTML += "프로젝트 진행";
			strHTML += "</span></a> ";
			strHTML += "<a class='imgbtn'><span onclick='changeStatus(S)'>";
			strHTML += "프로젝트 보류";
			strHTML += "</span></a>";
			break;
		case "S" :
			strHTML += "<a class='imgbtn' style='margin-right:4px;'><span onclick='changeStatus(P)'>";
			strHTML += "프로젝트 진행";
			strHTML += "</span></a> ";	
			strHTML += "<a class='imgbtn'><span onclick='changeStatus(C)'>";
			strHTML += "프로젝트 완료";
			strHTML += "</span></a>";
			break;
		case "C" :
			strHTML += "실제 시작일 : ";
			strHTML += "${realStartDate}";
			strHTML += "<br>";
			strHTML += "실제 종료일 : ";
			strHTML += "${realEndDate}";
			break;
	}
	
	$("#changeStatus").html(strHTML);
}

function editProjectInfo() {
	addProjectPopup(5, 20, 845, 480, "/ezPMS/newProject.do?mode=" + "edit" + "&projectId=" + projectId);
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
		<div id="editProjectInfo" class="icon" onclick="editProjectInfo()" style="cursor:pointer;"><img src="/images/ezLadder/icon_game03_no.png" style="width:40px; height:40px"></div>
		<div id="setting" class="icon">환경설정</div>
	</div>
<div id="overviewArea" class="overview rightPart">
	<div class="circle progress_graph" style="width:95%; top:15px;">
		<strong style="top:30px;"></strong>
	</div>
	<div style="text-align:center; font-size:30px; font-weight:bold;">D 
		<c:choose>
				<c:when test="${project.restDueday ge 0 }">- <c:out value="${project.restDueday }" /></c:when> <c:otherwise>+ <c:out value="${-project.restDueday }" /></c:otherwise>
		</c:choose>
	</div>
	<div style="text-align:center;">${project.planStartDate } ~ ${project.planEndDate }</div>
	<div id="changeStatus" style="text-align:center;"></div>
	<div id="overview" style="width:95%; padding:5px; border:1px solid gray; margin:5px 0">${project.overview }</div>
	<table style="width:95%; height:17%">
		<tr>
			<td><img src="/images/ezLadder/icon_defaultAttendant.png" width="30px" height="30px;" align="middle"><span>${project.headManagerName }</span></td>
			<td><img src="/images/ezLadder/icon_defaultAttendant.png" width="30px" height="30px" align="middle"> 담당자보기 </td>
		</tr>
		<tr>
			<td><img src="/images/ezLadder/icon_defaultAttendant.png" width="30px" height="30px" align="middle"> 참여자보기 </td>
			<td><img src="/images/ezLadder/icon_defaultAttendant.png" width="30px" height="30px" align="middle"> 조회자보기 </td>
		</tr>
	</table>
	<br>
	<div id="commentDiv">
		의견<span style="float:right; font-size:20px; padding-right:15px">+</span>
		<hr style="text-align:center;margin-left:0px;border-bottom:0px; width:95%">
	</div>
	<div id="logDiv">
		작업이력<span style="float:right; font-size:20px; padding-right:15px">+</span>
		<hr style="text-align:center;margin-left:0px;border-bottom:0px; width:95%">
	</div>
</div>
<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>