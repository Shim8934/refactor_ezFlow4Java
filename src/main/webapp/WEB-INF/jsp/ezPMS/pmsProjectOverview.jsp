<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t13' /> <spring:message code='ezPMS.t66' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezTask/circularProgressBar.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezTask/circularProgressBar.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>
<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 100;
var projectProgress = "${project.progress}";
var nowStatus = "${project.status}";
var strHTML = "";
var projectId = "${project.projectId}";
var kanbanOrder = "${kanbanOrder}";
var userRole = "${userRole}";
var progressColor = "${mainSetting.progressColor}";
var completeColor = "${mainSetting.completeColor}";
var overdueColor = "${mainSetting.overdueColor}";
var holdColor = "${mainSetting.holdColor}";
var deleteColor = "${mainSetting.deleteColor}";
var waitColor = "${mainSetting.waitColor}";
var startCount = 0;
var listNumber = 3;
var position = "overview";
var groupId = "${project.groupId}";
var headManagerId = "${project.headManagerId}";
var projectOverview = "<c:out value='${project.overview}'/>";

//내가 담당인 업무 완료/보류/진행 시키기 위한 변수
var beforePosition = "";
var afterPosition = "";


$(function() {
	initKanbanList();
	ableToChangeStatus();
	initProgressBar();
	setOverviewContent();
	
	$("#kanbanDraw").sortable({
		update : function(event, ui) {
			updateOrderStatus();
		}
	}).disableSelection();
	
	$(".overview_textbox").html(replaceString(projectOverview));
});

function initProgressBar() {
	var strStatus = "";
	var circleColor = "";
	
	switch (nowStatus) {
	case "P" :
		strStatus = "<spring:message code='ezPMS.t15' />";
		circleColor = progressColor;
		break;
	case "W" :
		strStatus = "<spring:message code='ezPMS.t16' />";
		circleColor = waitColor;
		break;
	case "L" :
		strStatus = "<spring:message code='ezPMS.t18' />";
		circleColor = overdueColor;
		break;
	case "S" :
		strStatus = "<spring:message code='ezPMS.t19' />";
		circleColor = holdColor;
		break;
	case "C" :
		strStatus = "<spring:message code='ezPMS.t17' />";
		circleColor = completeColor;
		break;
	case "D" :
		strStatus = "<spring:message code='ezPMS.t11' />";
		circleColor = deleteColor;
		break;
	}
	
	$("#circleProgress").circleProgress({
		value: Number(projectProgress * 0.01).toFixed(1),
		duration : 0,
		fill : {color : circleColor},
		size : 130
	}).on('circle-animation-progress', function(event, progress) {
		$(this).find('strong').html(Number(projectProgress).toFixed(1) + "%<br><div style='font-size:20px;'>" + strStatus + "</div>");
	});
}

function ableToChangeStatus() {	
	if (userRole == 1) {
		switch(nowStatus){
			case "L" :
			case "P" :
				strHTML += "<a class='imgbtn' style='margin-right:5px;'><span id='C' onclick='changeStatus(this)'>";
				strHTML += "<spring:message code='ezPMS.t13' /> <spring:message code='ezPMS.t17' />";
				strHTML += "</span></a> ";
				strHTML += "<a class='imgbtn'><span id='S' onclick='changeStatus(this)'>";
				strHTML += "<spring:message code='ezPMS.t13' /> <spring:message code='ezPMS.t19' />";
				strHTML += "</span></a>";
				break;
			case "W" :
				strHTML += "<a class='imgbtn' style='margin-right:5px;'><span id='P' onclick='changeStatus(this)'>";
				strHTML += "<spring:message code='ezPMS.t13' /> <spring:message code='ezPMS.t15' />";
				strHTML += "</span></a> ";
				strHTML += "<a class='imgbtn'><span id='S' onclick='changeStatus(this)'>";
				strHTML += "<spring:message code='ezPMS.t13' /> <spring:message code='ezPMS.t19' />";
				strHTML += "</span></a>";
				break;
			case "D" :
			case "S" :
				strHTML += "<a class='imgbtn' style='margin-right:5px;'><span id='P' onclick='changeStatus(this)'>";
				strHTML += "<spring:message code='ezPMS.t13' /> <spring:message code='ezPMS.t15' />";
				strHTML += "</span></a> ";	
				strHTML += "<a class='imgbtn'><span id='C' onclick='changeStatus(this)'>";
				strHTML += "<spring:message code='ezPMS.t13' /> <spring:message code='ezPMS.t17' />";
				strHTML += "</span></a>";
				break;
			case "C" :
				$(".btnStyle_center").css("margin-top", "6px");
				strHTML += "<li class='date'><p><span class='startBox' style='width:65px;'><spring:message code='ezPMS.t99' /></span>";
				strHTML += "${project.realStartDate}";
				strHTML += "</p>";
				strHTML += "<p><span class='endBox' style='width:65px;'><spring:message code='ezPMS.t100' /></span>";
				strHTML += "${project.realEndDate}</p></li>";
				break;
		}
		
		$(".btnStyle_center").html(strHTML);
	} 
}

function editProjectInfo() {
	$("<div id='blockLeft' class='blockLeft' style='background:none rgba(0, 0, 0, 0.4)'></div>").appendTo(parent.parent.frames["left"].document.body);
	$("<div id='blockTop' class='blockTop' style='height:86px;background:none rgba(0, 0, 0, 0.4)'></div>").appendTo(parent.parent.frames["right"].document.body);
	addProjectPopup(5, 20, 845, 556, "/ezPMS/newProject.do?mode=" + "edit" + "&projectId=" + projectId + "&groupId=" + groupId);
}

function kanbanSetting() {
	$("<div id='blockLeft' class='blockLeft' style='background:none rgba(0, 0, 0, 0.4)'></div>").appendTo(parent.parent.frames["left"].document.body);
	$("<div id='blockTop' class='blockTop' style='height:86px;background:none rgba(0, 0, 0, 0.4)'></div>").appendTo(parent.parent.frames["right"].document.body);
	addProjectPopup(18, 29, 500, 370, "/ezPMS/kanbanSetting.do?projectId=" + projectId);
}

function initKanbanList() {
	var kanbanOrderArr = kanbanOrder.split(",");
	var strHTML = "";
	var kanbanOrderArrCount = kanbanOrderArr.length;
	
	for (var i = 0; i < kanbanOrderArrCount; i++) {
		strHTML += "<li id='kanban"+ (i + 1) +"' class='kanban' style='cursor : pointer'>";
		strHTML += "<div class='overview_section_list' style='height:740px;'>";
		strHTML += "<dl class='overview_section_listDL'>";
		strHTML += "</dl><div class='cardArea'></div>";
		strHTML += "</div></li>";
	}
	
	$(".project_overview_section").html(strHTML);
	
	for (var i = 0; i < kanbanOrderArrCount; i++) {
		var kanban = kanbanOrderArr[i];
		
		$("#kanban" + (i + 1)).attr("name", kanban);
		var title = "";
		
		if (kanban.indexOf("M") != -1) {
			title += "<spring:message code='ezPMS.t143' /> ";
		}
		
		switch (kanban.slice(-1)) {
		case "A" : 
			title += "<spring:message code='ezPMS.t269' />";
			break;
		case "W" :
			title += "<spring:message code='ezPMS.t140' />";
			break;
		case "P" :
			title += "<spring:message code='ezPMS.t138' />";
			break;
		case "C" :
			title += "<spring:message code='ezPMS.t34' />"
			break;
		case "S" :
			title += "<spring:message code='ezPMS.t277' />";
			break;
		case "L" :
			title += "<spring:message code='ezPMS.t35' />";
			break;
		case "B" :
			title += "<spring:message code='ezPMS.t141' />";
			break;
		}
		
		if (kanban.indexOf("M") == -1 && kanban.indexOf("B") == -1 && userRole != 3) {
			$("#kanban" + (i + 1)).find(".overview_section_listDL").html("<dd><img src='/images/ezPMS/icon_allwork.png' alt='"+ title +"' onclick='moreTaskList(\"M" + kanban + "\", \"kanban"+ (i + 1) +"\", 0, \"new\")'></dd><dt>" + title + "&nbsp;<span class='point_blue'></span></dt>");	
		} else if (kanban.indexOf("M") != -1 && kanban.indexOf("B") == -1 && userRole != 3) {
			$("#kanban" + (i + 1)).find(".overview_section_listDL").html("<dd><img src='/images/ezPMS/icon_mywork.png' alt='"+ title +"' onclick='moreTaskList(\"" + kanban.slice(-1) + "\", \"kanban"+ (i + 1) +"\", 0, \"new\")'></dd><dt>" + title + "&nbsp;<span class='point_blue'></span></dt>");
		} else {
			$("#kanban" + (i + 1)).find(".overview_section_listDL").html("<dt>" + title + "&nbsp;<span class='point_blue'></span></dt>");
		}
	}
	
	//칸반 내 업무 넣기
	var data = {
			projectId : projectId,
			kanbanOrder : kanbanOrder,
			limit : 10,
			startRow : 0,
			position : position,
			groupId : 0,
			taskId : 0,
			folderId : 0
	}
			
	$.ajax({
		type : "POST",
		dataType: "json",
		contentType: "application/json; charset=UTF-8",
		url : "/ezPMS/getTaskList.do",
		data :JSON.stringify(data),
		success : function(result) {
			var kanbanOrderArr = kanbanOrder.split(",");
			var totalTaskCNT = result.totalTaskCNT;
			
			if (kanbanOrderArr[0] != "B") {
				setTasksIntoKanban(result.kanbanTask1, "kanban1", result.kanbanTaskCount1, "new", false);
				$("#kanban1").find(".point_blue").append(result.kanbanTaskCount1 + " / " + totalTaskCNT);
			} else {
				setTasksIntoKanban(result.kanbanTask1, "kanban1", result.kanbanTaskCount1, "new", true);
				$("#kanban1").find(".point_blue").append(result.kanbanTaskCount1);
			}
			
			if (kanbanOrderArr[1] != "B") {
				setTasksIntoKanban(result.kanbanTask2, "kanban2", result.kanbanTaskCount2, "new", false);
				$("#kanban2").find(".point_blue").append(result.kanbanTaskCount2 + " / " + totalTaskCNT);
			} else {
				setTasksIntoKanban(result.kanbanTask2, "kanban2", result.kanbanTaskCount2, "new", true);
				$("#kanban2").find(".point_blue").append(result.kanbanTaskCount2);
			}
			
			if (kanbanOrderArr[2] != "B") {
				setTasksIntoKanban(result.kanbanTask3, "kanban3", result.kanbanTaskCount3, "new", false);
				$("#kanban3").find(".point_blue").append(result.kanbanTaskCount3 + " / " + totalTaskCNT);
			} else {
				setTasksIntoKanban(result.kanbanTask3, "kanban3", result.kanbanTaskCount3, "new", true);
				$("#kanban3").find(".point_blue").append(result.kanbanTaskCount3);
			}
			
			if (kanbanOrderArr[3] != "B") {
				setTasksIntoKanban(result.kanbanTask4, "kanban4", result.kanbanTaskCount4, "new", false);
				$("#kanban4").find(".point_blue").append(result.kanbanTaskCount4 + " / " + totalTaskCNT);
			} else {
				setTasksIntoKanban(result.kanbanTask4, "kanban4", result.kanbanTaskCount4, "new", true);
				$("#kanban4").find(".point_blue").append(result.kanbanTaskCount4);
			}
		},
		error : function(jqXHR, textStatus, errorThrown) {
		}
	});
}

function moveToPage(target) {
	if (target == "comment") {
		var clickTabId = "1tab5";
		var nowTabAttr = "1tab0";
		changeTab(clickTabId, nowTabAttr);
		$("#FBoard_ifrm", parent.document).attr("src", "/ezPMS/getCommentMain.do?projectId=" + projectId + "&onlyGroup=false");
	} else if (target == "taskLog") {
		var clickTabId = "1tab4";
		var nowTabAttr = "1tab0";
		changeTab(clickTabId, nowTabAttr);
		
		$("#FBoard_ifrm", parent.document).attr("src", "/ezPMS/getTaskLogMain.do?projectId=" + projectId + "&onlyGroup=false");
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
		response = confirm("<spring:message code='ezPMS.t159' />");
	} else {
		response = confirm("<spring:message code='ezPMS.t160' />");
	}
	
	if (response == true) {
		var data = {
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
						alert("<spring:message code='ezPMS.t161' />");
					} else {
						alert("<spring:message code='ezPMS.t10' />");
					}
					
					var projectName = $("#pjName", parent.document).text().trim();
					var nowStatusStr = getStatusStr(nowStatus);
					var statusStr 	 = getStatusStr(changeStatus);
					
					var logContent = "<spring:message code='ezPMS.t314' arguments='" + projectName + "," + nowStatusStr + "," + statusStr + "'/>"; 
					addTaskLog(projectId, 2, groupId, null, logContent);
					
					window.location.reload();
				} else {
					alert("<spring:message code='ezPMS.t9' />");
					return;
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
	}
}

//status 알파벳을 문자열로 반환
function getStatusStr(status) {
	
	switch(status) {
	case 'P': // 진행
		return "<spring:message code='ezPMS.t15'/>"
		break;
	case 'W': // 대기
		return "<spring:message code='ezPMS.t16'/>"
		break;
	case 'C': // 완료
		return "<spring:message code='ezPMS.t17'/>"
		break;
	case 'L': // 지연
		return "<spring:message code='ezPMS.t18'/>"
		break;
	case 'S': // 보류
		return "<spring:message code='ezPMS.t19'/>"
		break;
	case 'D': // 삭제
		return "<spring:message code='ezPMS.t11'/>"
		break;
	}
}

function getProjectMember(roleId) {
	$("<div id='blockLeft' class='blockLeft' style='background:none rgba(0, 0, 0, 0.4)'></div>").appendTo(parent.parent.frames["left"].document.body);
	$("<div id='blockTop' class='blockTop' style='height:86px;background:none rgba(0, 0, 0, 0.4)'></div>").appendTo(parent.parent.frames["right"].document.body);
	addProjectPopup(18, 29, 374, 370, "/ezPMS/getProjectMember.do?projectId=" + projectId + "&roleId=" + roleId);
}

function setTasksIntoKanban(taskList, targetPosition, taskCount, taskType, isBoard) {
	if (taskList != null) {
		var kanbanHTML = "";
		
		if (taskCount == 0 && taskType != "add") {
			$("#" + targetPosition).find(".cardArea").html("");
			return;
		}
		
		var taskListCount = taskList.length;
		
		for (var i = 0; i < taskListCount; i++) {
			var task = taskList[i];
			
			if (!isBoard) {
				var taskStatus = "";
				var statusColor = "";
				var className = "";
				
				switch (task.status) {
				case "P" :
					taskStatus = "<spring:message code='ezPMS.t15' />";
					statusColor = progressColor;
					className = "progress";
					break;
				case "W" :
					taskStatus = "<spring:message code='ezPMS.t16' />";
					statusColor = "#a5a5a5";
					className = "standby";
					break;
				case "L" :
					taskStatus = "<spring:message code='ezPMS.t18' />";
					statusColor = overdueColor;
					className = "delay";
					break;
				case "S" :
					taskStatus = "<spring:message code='ezPMS.t19' />";
					statusColor = holdColor;
					className = "hold";
					break;
				case "C" :
					taskStatus = "<spring:message code='ezPMS.t17' />";
					statusColor = completeColor;
					className = "complete";
					break;
				}
				
				kanbanHTML += "<div id='" + targetPosition + task.taskId + "' class='overview_list card' onclick='selectedTR(this)' ondblclick='getTaskDetails(this)'>";
				kanbanHTML += "<p class='overview_list_title'><span class='situation_" + className + "' style='background-color:" + statusColor + "'>" + taskStatus + "</span>" + revertString(task.taskName) + "</p>";
				kanbanHTML += "<div class='progressArea" + task.taskId + " progressArea_new'></div>";
				kanbanHTML += "<div class='date'><p><span class='startBox'>START</span>" + task.planStartDate + "</p>";
				kanbanHTML += "<p><span class='endBox'>END</span>" + task.planEndDate + "</p></div>";
				kanbanHTML += "</div>";
			} else {
				kanbanHTML += "<div id='B" + task.itemId + "' class='overview_list card' onclick='selectedTR(this)' ondblclick='getBoardDetails(this)'>";
				kanbanHTML += "<p class='overview_list_title'>" + revertString(task.title) + "</p>";

				if (task.imageFilePath == null) {
					kanbanHTML += "<div class='boardArea_new'>" + task.writeContent + "</div>";
				} else {
					kanbanHTML += "<div class='boardArea_new'><img style='width:100%; height:100%;' src='" + task.imageFilePath + "'></div>";
				}
				
				kanbanHTML += "</div>"
			}
		}
		
		if (taskType == "add") {
			$("#" + targetPosition).find(".cardArea").append(kanbanHTML);
		} else {
			$("#" + targetPosition).find(".cardArea").html(kanbanHTML);
		}
		
		for (var i = 0; i < taskListCount; i++) {
			var task = taskList[i];
			var statusColor = "";
			
			switch (task.status) {
			case "P" :
				statusColor = progressColor;
				break;
			case "W" :
				statusColor = "#a5a5a5";
				break;
			case "L" :
				statusColor = overdueColor;
				break;
			case "S" :
				statusColor = holdColor;
				break;
			case "C" :
				statusColor = completeColor;
				break;
			}
			
			if (!(task.status == "B")) {
				$("#" + targetPosition).find(".progressArea" + task.taskId).LineProgressbar({
					percentage : Number(task.realProgress).toFixed(1),
					fillBackgroundColor : statusColor,
					duration : 0,
					height : '15px',
					radius : '15px',
					width : '50%'
				});
			}
		}
		
		var targetStatus = $("#" + targetPosition).attr("name");
		var startRow = $("#" + targetPosition).find(".overview_list").length;
		
		if (taskListCount >= 10) {
			if (!isBoard) {
				$("#" + targetPosition).find(".overview_section_list").append("<div class='moreBtn' name='" + targetStatus + "' onclick='moreTaskList(\"" + targetStatus + "\", \"" + targetPosition + "\", " + startRow + ", \"add\")'><span><spring:message code='ezPMS.t276' /></span></div>");
			} else {
				$("#" + targetPosition).find(".overview_section_list").append("<div class='moreBtn' name='" + targetStatus + "' onclick='moreTaskList(\"" + targetStatus + "\", \"" + targetPosition + "\", " + startRow + ", \"add\")'><span><spring:message code='ezPMS.t276' /></span></div>");
			}
			
		}
	}
}

function selectedTR(elem){
	var selectElem = elem.id;
	
	$(".card").removeClass("selectTR");
	$("#" + selectElem).addClass("selectTR");
}

function menuQst_DetailUserInfo(pUserID) {
	var feature = GetOpenPosition(420, 450);
    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
}

function moreTaskList(targetStatus, targetPosition, startRow, taskType) {
	$("#" + targetPosition).find(".moreBtn").remove();
	
	var data = {
		projectId : projectId,
		targetPosition : targetPosition,
		kanbanOrder : targetStatus,
		limit : 10,
		startRow : startRow,
		position : position
	}
	
	$.ajax({
		type : "POST",
		dataType: "json",
		contentType: "application/json; charset=UTF-8",
		url : "/ezPMS/getTaskList.do",
		data :JSON.stringify(data),
		success : function(result) {
			$("#" + targetPosition).attr("name", targetStatus);

			if (result.kanbanTask1 != null) {
				if (targetStatus == "B") {
					setTasksIntoKanban(result.kanbanTask1, "" + targetPosition, result.kanbanTask1.length, "" + taskType, true);
				} else {
					setTasksIntoKanban(result.kanbanTask1, "" + targetPosition, result.kanbanTask1.length, "" + taskType, false);
				}
			} else {
				$("#" + targetPosition).find(".cardArea").html("");
			}

			var title = "";
			
			if (targetStatus.indexOf("M") != -1) {
				title += "<spring:message code='ezPMS.t143' /> ";
			}
			
			switch (targetStatus.slice(-1)) {
			case "A" : 
				title += "<spring:message code='ezPMS.t269' />";
				break;
			case "W" :
				title += "<spring:message code='ezPMS.t140' />";
				break;
			case "P" :
				title += "<spring:message code='ezPMS.t138' />";
				break;
			case "C" :
				title += "<spring:message code='ezPMS.t34' />"
				break;
			case "S" :
				title += "<spring:message code='ezPMS.t277' />";
				break;
			case "L" :
				title += "<spring:message code='ezPMS.t139' />";
				break;
			case "B" :
				title += "<spring:message code='ezPMS.t141' />";
				break;
			}

			if (targetStatus.indexOf("M") == -1 && targetStatus.indexOf("B") == -1 && userRole != 3) {
				$("#" + targetPosition).find(".overview_section_listDL").html("<dd><img src='/images/ezPMS/icon_allwork.png' alt='"+ title +"' onclick='moreTaskList(\"M" + targetStatus + "\", \""+ targetPosition +"\", 0, \"new\")'></dd><dt>" + title + "&nbsp;<span class='point_blue'></span></dt>");

				var totalTaskCNT = result.totalTaskCNT;
				$("#" + targetPosition).find(".point_blue").append(result.kanbanTaskCount1 + " / " + totalTaskCNT);
			} else if (targetStatus.indexOf("M") != -1 && targetStatus.indexOf("B") == -1 && userRole != 3) {
				$("#" + targetPosition).find(".overview_section_listDL").html("<dd><img src='/images/ezPMS/icon_mywork.png' alt='"+ title +"' onclick='moreTaskList(\"" + targetStatus.slice(-1) + "\", \"" + targetPosition +"\", 0, \"new\")'></dd><dt>" + title + "&nbsp;<span class='point_blue'></span></dt>");

				var totalTaskCNT = result.totalTaskCNT;
				$("#" + targetPosition).find(".point_blue").append(result.kanbanTaskCount1 + " / " + totalTaskCNT);
			} else {
				$("#" + targetPosition).find(".overview_section_listDL").html("<dt>" + title + "&nbsp;<span class='point_blue'></span></dt>");
				$("#" + targetPosition).find(".point_blue").append(result.kanbanTaskCount1);
			}
			
			
			updateOrderStatus();	
		},
		error : function(jqXHR, textStatus, errorThrown) {
		}
	});
	
}

function updateOrderStatus() {
	var kanban = $(".kanban");
	var orderStatus = "";
	var kanbanCount = kanban.length;
	
	for (var i = 0; i < kanbanCount; i++) {
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
		data : JSON.stringify(data),
		success : function(result) {},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("error : " + textStatus);
		}
	});  
}

function setOverviewContent() {
	var data = {
		projectId : projectId,
		startCount : startCount,
		listNumber : listNumber,
		startRow : startCount,
		limit : listNumber,
		groupId : groupId,
		orderWhat : "init",
		location : "overview"
	}
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/getOverviewContent.do",
		dataType : "json",
		contentType : "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(overviewList) {
			 var logList = overviewList.logList;
			 var logHTML = "";
			 
			 if (logList == null || logList.length == 0) {
				 
				 logHTML += "<li>" + "<span><spring:message code='ezPMS.t30' /><span>" + "</li>";
				 
			 } else {
				 var logListCount = logList.length;
				 
				 for (var i = 0; i < logListCount; i++) {
					 var logDetail = logList[i];
					 
					 switch (logDetail.logStatus) {
					 case 1 : 
						 logHTML += "<li><span class='situation_registration'><spring:message code='ezPMS.t40' /></span>";
						 break;
						 
					 case 2 : 
						 logHTML += "<li><span class='situation_modify'><spring:message code='ezPMS.t110' /></span>";
						 break;
						 
					 case 3 : 
						 logHTML += "<li><span class='situation_delet'><spring:message code='ezPMS.t11' /></span>";
						 break;
					 }
					 
					 logHTML += "<span class='text'>" + revertString(logDetail.logContent) + "</span>";
					 logHTML += "</li>";
				 }
			 }
			 
			 $("#logContentArea").html(logHTML);
			 
			 var commentList = overviewList.commentList;
			 var commentHTML = ""; 
			 
			 if (commentList == null || commentList.length == 0) {
				 commentHTML += "<li><span class='text'>" + "<spring:message code='ezPMS.t30' />" + "</span></li>";
			 } else {
				 var commentListCount = commentList.length;
				 
				 for (var i = 0; i < commentListCount; i++) {	
					 var comment = commentList[i];
					 
					 commentHTML += "<li>";
					 commentHTML += "<span class='name'>" + comment.writerName + "</span>";
					 commentHTML += "<span class='text'>" + revertString(comment.commentContent) + "</span>";
					 commentHTML += "</li>";
				 }
			 }
			  
			 $("#commentContentArea").html(commentHTML);
		}
	})
}

function getBoardDetails(elem) {
	var itemId = elem.id.slice(1);
	window.open("/ezPMS/getBoardDetail.do?projectId=" + projectId + "&itemId=" + itemId, "", "width=790, height=800, resizable=no, scrollbars=no, status=no;");
}

function getTaskDetails(elem) {
	var taskId = elem.id.substring(7);
	var feature = GetOpenPosition(835, 810);
	
	window.open("/ezPMS/getTaskDetails.do?projectId=" + projectId + "&taskId=" + taskId + "&userIdType=user",
			"", "width=835, height=810, resizable=no, scrollbars=no, status=no" + feature);
}
</script>
<style type="text/css">
.project_overview_right .overview_textbox {
	overflow : auto;
	height : 132px;
	word-wrap : break-word;
}

.boardArea_new p img {
	width : 100%;
	height : 73px;
}
</style>
</head>
<body>
<div class="project_overview" style="margin : 10px 10px 0px 10px;">
<ul class="contentlayout" style="height:740px;">
	<li class="contentlayout_right" style="height:740px;"><!--우측정보-->
		<div class="project_overview_right" style="height:740px;">
			<div class="overview_graphinfoBox">
				<ul class="overview_btnBox">
					<c:if test="${userId eq project.headManagerId}">
					<li onclick="editProjectInfo()" id="editProject"><img src="/images/ezPMS/icon_project_modify.png" alt="<spring:message code='ezPMS.t110'/>" /></li>
					</c:if>
					<li onclick="kanbanSetting()" id="kanbanSetting"><img src="/images/ezPMS/icon_project_setting.png" alt="<spring:message code='ezPMS.t144'/>" /></li>
				</ul>
				<ul class="contentlayout overview_graphinfo">
					<li class="contentlayout_left overview_graph_canvas" id="circleProgress"><strong></strong></li>
					<li class="contentlayout_none date">
						<p class="project_Dday">D <span class="point_red"><c:out value="${project.restDueday - 1 < 0 ? '+ '.concat(-(project.restDueday - 1)) : '- '.concat(project.restDueday - 1) }"/></span>
						</p>
						<p><span class="startBox">START</span><c:out value="${project.planStartDate }"/></p>
						<p><span class="endBox">END</span><c:out value="${project.planEndDate }"/></p>
					</li>
				</ul>
				<div class="btnStyle_center"></div>
			</div>
			<div class="overview_textbox"></div>
			<ul class="overview_infomationBox">
				<li onclick="menuQst_DetailUserInfo('${project.headManagerId }')"><img src="/images/ezPMS/icon_defaultAttendant.png" alt="${project.headManagerName }"/><c:out value="${project.headManagerName }"/></li>
				<li onclick="getProjectMember('1')"><img src="/images/ezPMS/icon_defaultAttendant.png" alt="<spring:message code='ezPMS.t63' /><spring:message code='ezPMS.t156' />" /><spring:message code='ezPMS.t63' /><spring:message code='ezPMS.t156' /></li>
				<li onclick="getProjectMember('2')"><img src="/images/ezPMS/icon_defaultAttendant.png" alt="<spring:message code='ezPMS.t64' /><spring:message code='ezPMS.t156' />" /><spring:message code='ezPMS.t64' /><spring:message code='ezPMS.t156' /></li>
				<li onclick="getProjectMember('3')"><img src="/images/ezPMS/icon_defaultAttendant.png" alt="<spring:message code='ezPMS.t65' /><spring:message code='ezPMS.t156' />" /><spring:message code='ezPMS.t65' /><spring:message code='ezPMS.t156' /></li>
			</ul>
			<div class="project_portlet_opinion">
				<dl class="project_portlet_title">
					<dd onclick="moveToPage('comment')"><spring:message code='ezPMS.t276' /></dd>
					<dt><spring:message code='ezPMS.t154' /></dt>
				</dl>
				<ul class="project_portlet_list" id="commentContentArea"></ul>
			</div>
			<div class="project_portlet_workhistory">
				<dl class="project_portlet_title">
					<dd onclick="moveToPage('taskLog')"><spring:message code='ezPMS.t276' /></dd>
					<dt><spring:message code='ezPMS.t153' /></dt>
				</dl>
				<ul class="project_portlet_list" id="logContentArea"></ul>
			</div>
		</div>
	</li>
	<li class="contentlayout_none" style="height:740px;"><!--좌측리스트-->
		<ul class="project_overview_section" id="kanbanDraw"></ul>
	</li>
</ul>
</div>
<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>