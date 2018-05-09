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
<script type="text/javascript" src="/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezTask/circularProgressBar.js"></script>
<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 100;
var progress = "${project.progress}";
var nowStatus = "${project.status}";
var strHTML = "";
var projectId = "${project.projectId}";
var kanbanOrder = "${kanbanOrder}";
var projectName = "${project.projectName}";
var userRole = "${userRole}";
var progressColor = "${mainSetting.progressColor}";
var completeColor = "${mainSetting.completeColor}";
var overdueColor = "${mainSetting.overdueColor}";
var holdColor = "${mainSetting.holdColor}";

$(document).ready(function(){
	$(window).resize(function() {
		CurrentHeight = $(window).height()-100;
		$(".overview").css("height", CurrentHeight + "px");
		$(".kanban").css("height", CurrentHeight - 14 + "px");
	});
});

$(function() {
	setKanbanList();
	ableToChangeStatus();
	initProgressBar();
	
	CurrentHeight = $(window).height()-100;
	$(".overview").css("height", CurrentHeight + "px");
	$(".kanban").css("height", CurrentHeight - 14 + "px");
	
	
	$("#kanbanArea").sortable({
		update : function(event, ui) {
			var kanban = $(".kanban");
			var orderStatus = "";
			
			for (var i = 0; i < kanban.length; i++) {
				orderStatus += kanban.eq(i).attr("name") + ",";
			}
			
			orderStatus = orderStatus.slice(0,-1);
			
			 var data = {
				projectId : projectId,
				orderStatus : orderStatus
			}
			
			 $.ajax({
				type : "POST",
				url : "/ezPMS/changeKanbanOrder.do",
				contentType: "application/json; charset=UTF-8",
				data :JSON.stringify(data),
				success : function(result) {},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("error : " + textStatus);
				}
			});  
		}
	});
	$("#kanbanArea").disableSelection();
});

function initProgressBar() {
	var strStatus = "";
	var circleColor = "";
	
	switch(nowStatus){
	case "P" :
		strStatus = "진행";
		circleColor = progressColor;
		break;
	case "W" :
		strStatus = "대기";
		circleColor = "grey";
		break;
	case "L" :
		strStatus = "지연";
		circleColor = overdueColor;
		break;
	case "S" :
		strStatus = "보류";
		circleColor = holdColor;
		break;
	case "C" :
		strStatus = "완료";
		circleColor = completeColor;
		break;
	}
	
	$(".progress_graph").circleProgress({
		value: 0.4,
		fill : {color : circleColor},
		size : 134
	}).on('circle-animation-progress', function(event, progress) {
		$(this).find('strong').html(40 + "%<br><div style='font-size:20px'>" + strStatus + "</div>");
	});
}

function ableToChangeStatus() {	
	if (userRole == 1) {
		switch(nowStatus){
			case "L" :
			case "P" :
				strHTML += "<a class='imgbtn' style='margin-right:4px;'><span id='C' onclick='changeStatus(this)'>";
				strHTML += "프로젝트 완료";
				strHTML += "</span></a> ";
				strHTML += "<a class='imgbtn'><span id='S' onclick='changeStatus(this)'>";
				strHTML += "프로젝트 보류";
				strHTML += "</span></a>";
				break;
			case "W" :
				strHTML += "<a class='imgbtn' style='margin-right:4px;'><span id='P' onclick='changeStatus(this)'>";
				strHTML += "프로젝트 진행";
				strHTML += "</span></a> ";
				strHTML += "<a class='imgbtn'><span id='S' onclick='changeStatus(this)'>";
				strHTML += "프로젝트 보류";
				strHTML += "</span></a>";
				break;
			case "S" :
				strHTML += "<a class='imgbtn' style='margin-right:4px;'><span id='P' onclick='changeStatus(this)'>";
				strHTML += "프로젝트 진행";
				strHTML += "</span></a> ";	
				strHTML += "<a class='imgbtn'><span id='C' onclick='changeStatus(this)'>";
				strHTML += "프로젝트 완료";
				strHTML += "</span></a>";
				break;
			case "C" :
				strHTML += "실제 시작일 : ";
				strHTML += "${project.realStartDate}";
				strHTML += "<br>";
				strHTML += "실제 종료일 : ";
				strHTML += "${project.realEndDate}";
				break;
		}
		
		$("#changeStatus").html(strHTML);
	} 
}

function editProjectInfo() {
	addProjectPopup(5, 20, 845, 480, "/ezPMS/newProject.do?mode=" + "edit" + "&projectId=" + projectId);
}

function kanbanSetting() {
	addProjectPopup(18, 29, 500, 350, "/ezPMS/kanbanSetting.do?projectId=" + projectId);
}

function setKanbanList() {
	var kanbanOrderArr = kanbanOrder.split(",");
	var strHTML = "";

	for (var i = 0; i < kanbanOrderArr.length; i++) {
		strHTML += "<div id='kanban"+ (i + 1) +"' class='kanban'>";
		strHTML += "<h1></h1>";
		strHTML += "<div class='card'>";
		strHTML += "Hello";
		strHTML += "</div>";
		strHTML += "</div>";
	}
	
	$("#kanbanArea").html(strHTML);
	
	CurrentHeight = $(window).height()-100;
	$(".kanban").css("height", CurrentHeight - 14 + "px");
	
	for (var i = 0; i < kanbanOrderArr.length; i++) {
		$("#kanban" + (i + 1)).attr("name", kanbanOrderArr[i]);
		var title = "";
		
		if (kanbanOrderArr[i].indexOf("M") != -1) {
			title += "나의 ";
		}
		
		switch (kanbanOrderArr[i].slice(-1)) {
		case "A" : 
			title += "전체 업무";
			break;
		case "W" :
			title += "대기 중인 업무";
			break;
		case "P" :
			title += "진행 중인 업무";
			break;
		case "C" :
			title += "완료된 업무"
			break;
		case "S" :
			title += "보류된 업무";
			break;
		case "L" :
			title += "기한이 지난 업무";
			break;
		case "B" :
			title += "게시판";
			break;
		}
		
		$("#kanban" + (i + 1)).find("h1").text(title);
	}
}

function moveToPage(target) {
	if (target == "comment") {
		var clickTabId = "1tab5";
		var nowTabAttr = "1tab0";
		changeTab(clickTabId, nowTabAttr);
		$("#FBoard_ifrm", parent.document).attr("src", "/ezPMS/getComment.do");
	} else if (target == "taskLog") {
		var clickTabId = "1tab4";
		var nowTabAttr = "1tab0";
		changeTab(clickTabId, nowTabAttr);
		
		$("#FBoard_ifrm", parent.document).attr("src", "/ezPMS/getTaskLogList.do");
	}
}

function changeTab(clickTabId, nowTabAttr) {
	$("#"+nowTabAttr, parent.document).attr("class", "tab");
	$("#"+clickTabId, parent.document).attr("class", "tabon");
}

function changeStatus(status) {
	var changeStatus = $(status).attr("id");
	var response;
	
	if (changeStatus == "C") {
		response = confirm("프로젝트를 완료하면 하위 작업이 모두 완료됩니다. \n 진행하시곘습니까?");
	} else {
		response = confirm("프로젝트의 상태를 변경하시겠습니까?");
	}
	
	if (response == true) {
		data = {
				nowStatus : nowStatus,
				status : changeStatus,
				projectList : projectId
			}
			
			$.ajax({
				type : "POST",
				dataType: "text",
				contentType: "application/json; charset=UTF-8",
				url : "/ezPMS/updateProjectStatus.do",
				data :JSON.stringify(data),
				success : function(result) {
					if (result == "permitted") {
						if (changeStatus == "P") {
							alert("상태가 변경되었습니다. \n현재일보다 마감일이 빠른 프로젝트는 지연 프로젝트 상태로 변경됩니다.");
						} else {
							alert("상태가 변경되었습니다.");
						}
						
						window.location.reload();
					} else {
						alert("프로젝트 담당자만 상태를 변경할 수 있습니다.");
						return;
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
				}
			});
	}
}

function getProjectMember(roleId) {
	addProjectPopup(18, 29, 374, 350, "/ezPMS/getProjectMember.do?projectId=" + projectId + "&roleId=" + roleId);
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
	background-color : rgb(240, 240, 240);
}

.card {
	margin : 10px 5px;
	padding : 10px;
	position : relative;
	width : 85%;
	height : 100px;
	color : block;
	border : 1px solid black;
	background-color : rgb(255, 255, 255);
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
	
</div>

<div id="iconArea" class="rightPart">
		<div id="printReport" class="icon">출력</div>
		<c:if test="${userRole eq 1 }">
			<div id="editProjectInfo" class="icon" onclick="editProjectInfo()" style="cursor:pointer;"><img src="/images/ezLadder/icon_game03_no.png" style="width:40px; height:40px"></div>
		</c:if>
		<div id="setting" class="icon" style="cursor:pointer;" onclick="kanbanSetting()">환경설정</div>
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
			<td onclick="getProjectMember('1')" style="cursor:pointer;"><img src="/images/ezLadder/icon_defaultAttendant.png" width="30px" height="30px" align="middle"> 담당자보기 </td>
		</tr>
		<tr>
			<td onclick="getProjectMember('2')" style="cursor:pointer;"><img src="/images/ezLadder/icon_defaultAttendant.png" width="30px" height="30px" align="middle"> 참여자보기 </td>
			<td onclick="getProjectMember('3')" style="cursor:pointer;"><img src="/images/ezLadder/icon_defaultAttendant.png" width="30px" height="30px" align="middle"> 조회자보기 </td>
		</tr>
	</table>
	<br>
	<div id="commentDiv">
		의견<span style="float:right; font-size:20px; padding-right:15px; cursor:pointer;" onclick="moveToPage('taskLog')">+</span>
		<hr style="text-align:center;margin-left:0px;border-bottom:0px; width:95%">
	</div>
	<div id="logDiv">
		작업이력<span style="float:right; font-size:20px; padding-right:15px; cursor:pointer;" onclick="moveToPage('comment')">+</span>
		<hr style="text-align:center;margin-left:0px;border-bottom:0px; width:95%">
	</div>
</div>
<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>