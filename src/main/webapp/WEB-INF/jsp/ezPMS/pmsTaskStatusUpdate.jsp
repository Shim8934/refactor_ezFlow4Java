<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t175' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezTask/circularProgressBar.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezTask/circularProgressBar.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>

<!-- time picker-->
<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>

<script type="text/javascript">
	var taskDetails;
	var weightData;
	var nowStatus;
	var progressColor = parent.progressColor;
	var completeColor = parent.completeColor;
	var overdueColor = parent.overdueColor;
	var holdColor = parent.holdColor;
	var projectStatus = "";
	
	$(function() {
		taskDetails = JSON.parse(parent.document.all["frameParamTaskDetails"].value);
		weightData = JSON.parse(parent.document.all["frameParamWeight"].value);
		projectStatus = weightData.projectStatus;
		
		initProgressBar();
		datepickerSetting();
		setProgress();
		setStatus();
		btnEvent();
		
		var realStartDate = taskDetails.realStartDate;
		var realEndDate = taskDetails.realEndDate;
		
		$("#RSDatepicker").val(realStartDate);
		$("#REDatepicker").val(realEndDate);	
	});
	
	function popupClose() {
		parent.DivPopUpHidden();
	}
	
	function initProgressBar() {
		if (taskDetails.status == null) {
			nowStatus = "P";
		} else {
			nowStatus = taskDetails.status;
		}
		
		var strStatus = "";
		var circleColor = "";
		
		switch (nowStatus) {
		case "P" :
			strStatus = "<spring:message code='ezPMS.t15' />";
			circleColor = progressColor;
			break;
		case "W" :
			strStatus = "<spring:message code='ezPMS.t16' />";
			circleColor = "#d1d1d1";
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
		}
		
		$("td.detailsTable-td[name='statusTd']").text(strStatus);
		
		$(".progress_graph").circleProgress({
			value: taskDetails.realProgress / 100,
			fill : {color : circleColor},
			size : 134
		}).on('circle-animation-progress', function(event, progress) {
			$(this).find('strong').html(Number(taskDetails.realProgress).toFixed(1) + "%<br><div style='font-size:20px'>" + strStatus + "</div>");
		});
	}
	
	function changeTab(clickTabId, nowTabAttr) {
		$("#"+nowTabAttr).attr("class", "tab");
		$("#"+clickTabId).attr("class", "tabon");
	}
	
	function popupClose() {
		parent.DivPopUpHidden();
	}
	
	function taskUpdate() {
	 	var taskId = "${taskDetails.taskId}";
		DivPopUpShow(760, 500, "/ezPMS/goUpdateTaskInfo.do?taskId=" + taskId);
	}
	
	function setProgress() {
		var diff = 0;
		diff = Number(taskDetails.realProgress - taskDetails.planProgress).toFixed(1);
		document.querySelector("[name='realProgress']").value = Number(taskDetails.realProgress).toFixed(1) + "%";
		document.getElementById("planProgress").innerText = Number(taskDetails.planProgress).toFixed(1) + "%";
		document.getElementById("progDiff").innerText = diff == 0 ? "" : (diff > 0 ? "+" + diff : (diff < 0 ? diff : "-")) + "%";
	}
	
	function setStatus() {
		
		var statusOption = "";
		
		switch(taskDetails.status) {
		case 'P':
			statusOption = "<option value='P'><spring:message code='ezPMS.t15' /></option>"
						 + "<option value='C'><spring:message code='ezPMS.t17' /></option>"
						 + "<option value='S'><spring:message code='ezPMS.t19' /></option>";
			break;
		case 'W':
			statusOption = "<option value='P'><spring:message code='ezPMS.t15' /></option>"
						 + "<option value='W'><spring:message code='ezPMS.t16' /></option>"
						 + "<option value='S'><spring:message code='ezPMS.t19' /></option>";
			break;
		case 'C':
			statusOption = "<option value='C'><spring:message code='ezPMS.t17' /></option>";
			break;
		case 'L':
			statusOption = "<option value='C'><spring:message code='ezPMS.t17' /></option>"
						 + "<option value='L'><spring:message code='ezPMS.t18' /></option>"
						 + "<option value='S'><spring:message code='ezPMS.t19' /></option>";
			break;
		case 'S':
			statusOption = "<option value='P'><spring:message code='ezPMS.t15' /></option>"
						 + "<option value='C'><spring:message code='ezPMS.t17' /></option>"
						 + "<option value='S'><spring:message code='ezPMS.t19' /></option>";
			break;
		}		
				 
		$("#statusOption").html(statusOption);
		
		if (projectStatus == "W" || projectStatus == "C" || projectStatus == "S" || projectStatus == "D") {
			$(".taskStatusChgDiv").css("display", "none");
		} else {
			var targetStatus = document.querySelector("option[value='" + taskDetails.status + "']");
			
			if (targetStatus) {
				targetStatus.selected = true;
			}
		}
	}
	
	function btnEvent() {
		document.getElementById("saveBtn").onclick = saveStatus;
	}
	
	function saveStatus() {
		var projectStartDate = weightData.projectStartDate;
		var projectEndDate = weightData.projectEndDate;
		var planStartDate = document.getElementById("PSDatepicker").value;
		var planEndDate = document.getElementById("PEDatepicker").value;
		var realStartDate = document.getElementById("RSDatepicker").value;
		var realEndDate = document.getElementById("REDatepicker").value;
		var realProgress = document.querySelector("[name='realProgress']").value.trim();
		var statusSelect = document.querySelector(".taskStatusChgDiv select");
		var status = statusSelect.options[statusSelect.selectedIndex].value;
		
		//날짜 제한
		var startDateArr = planStartDate.split('-');
		var endDateArr = planEndDate.split('-');
		
		var startDateComp = planStartDate.replace(/-/g, "");
		var endDateComp = planEndDate.replace(/-/g, "");
// 		endDateComp.setHours(23, 59, 59, 999);
		
// 		var today = new Date();
		var today = TimeToStr(new Date()).replace(/-/g, "");
// 		var todayComp = new Date(today.getFullYear(), today.getMonth()-1, today.getDay());
		
// 		var projectStartDateComp = new Date(projectStartDate);
// 		var projectEndDateComp = new Date(projectEndDate);
		
		var projectStartDateComp = projectStartDate.replace(/-/g, "");
		var projectEndDateComp = projectEndDate.replace(/-/g, "");
		
		//1. 시작일 > 종료일은 불가능
		if (startDateComp > endDateComp) {
		  	alert("<spring:message code='ezPMS.t49' />");
		  	return;
		}
		
		// 대기에서 바로 지연으로 넘어가는 경우에도 realStartDate가 필요하기 때문에 status값을 바꾸기 전에 이 로직이 필요함
		if (status === "P") {
			if (!realStartDate) {
				realStartDate = TimeToStr(new Date());
			}
		}
		
		//2. 종료일 < 현재일일 떄, 지연업무로 넘어갈 것이라는 confirm창 띄우기
		if ((endDateComp < today) && nowStatus !== "L" && status === "P") {
			var confCheck = confirm("<spring:message code='ezPMS.t93' />");
			 
			if (confCheck != true) {
				 return;
			} else {
				status = "L";
			}
		}
		
		//업무가 지연 상태일때 오늘날짜보다 종료날짜가 뒤로 변경되면 상태를 진행으로 변경
		if (status == "L" && (endDateComp > today)) {
			status = "P";
		}
		
		//3. 업무의 계획 시작일과 계획 종료일은 프로젝트 시작일과 종료일범위를 벗어날수 없음
		if (startDateComp < projectStartDateComp) {
			alert("<spring:message code='ezPMS.t94' />");
			return;
		}
		
		if (endDateComp > projectEndDateComp) {
			alert("<spring:message code='ezPMS.t95' />");
			return;
		}
		 
		// 진행률 검사
		realProgress = realProgress.replace(/%/,"");
		
		if (realProgress != taskDetails.realProgress) {
			if (realProgress == "") {
				alert("<spring:message code='ezPMS.t189' />");
				return;
			}
			else if (isNaN(Number(realProgress))) {
				alert("<spring:message code='ezPMS.t249' />");
				return;
			}
			else if (Number(realProgress) > 100) {
				alert("<spring:message code='ezPMS.t190' />");
				return;
			}
			else if (Number(realProgress) < 0) {
				alert("<spring:message code='ezPMS.t191' />");
				return;
			}
		}
		
		//상태만 변경할 경우 처리.
		if (nowStatus != "C" && status === "C") {
			realEndDate = TimeToStr(new Date());			
			realProgress = 100;
			
			if (!realStartDate) {
				realStartDate = TimeToStr(new Date());
			}
		}
		
		//진행률을 100%로 변경했을 경우 status는 C로 변경하여 자동 완료처리
		if (realProgress == 100) {
			status = "C";
			
			//진행률을 100%로 변경했을 경우 실제 종료일이 realEndDate에 들어가야함
			if (!realEndDate) {
				realEndDate = TimeToStr(new Date());
			}
			
			if (!realStartDate) {
				realStartDate = TimeToStr(new Date());
			}
		} else if (nowStatus != "L" && (realProgress > 0 && realProgress < 100)) {
			if (nowStatus == status) {
				//업무 상태가 보류, 진행, 대기, 완료인 경우 진행률을 수정하면 업무가 진행상태로 변경됨
				status = "P";
				realEndDate = "";				
				
				if (!realStartDate) {
					realStartDate = TimeToStr(new Date());
				}
				
			}
			
		}
		
		var data = {
				taskId : taskDetails.taskId + "",
				projectId : taskDetails.projectId + "",
				planStartDate : planStartDate,
				planEndDate : planEndDate,
				realStartDate : realStartDate,
				realEndDate : realEndDate,
				realProgress : realProgress,
				status : status,
				groupId : taskDetails.groupId
		}
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/updateTaskStatus.do",
			dataType : "json",
			contentType: "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(data) {
				alert("<spring:message code='ezPMS.t280' />");
				
				var nowStatusStr = getStatusStr(nowStatus);
				var statusStr 	 = getStatusStr(status);
				var taskName 	 = $("#taskName", parent.document).text();
				var projectId 	 = taskDetails.projectId;
				var groupId 	 = taskDetails.groupId;
				var taskId 	 	 = taskDetails.taskId;
				
				// 이전과 달라진 값에 대해서만 작업이력을 남긴다
				if (nowStatus != status) {	
					var logContent = "<spring:message code='ezPMS.t314' arguments='" + taskName + "," + nowStatusStr + "," + statusStr + "'/>"; 
					addTaskLog(projectId, 2, groupId, taskId, logContent);
					updateGroupRealStartEndDate(groupId);
				}
				
				console.log('status    : ' + status);
				console.log('nowStatus : ' + nowStatus);
				
				/* // 대기/보류 -> 진행, 특정상태 -> 완료, 완료 -> 특정상태일 때만 실행
				if(((nowStatus == "W" || nowStatus == "S") && status == "P") || (nowStatus != "C" && status == "C") || (nowStatus == "C" && status != "C")) {
					// 소속 그룹과 소속 그룹의 상위까지 실제 시작일 및 종료일을 업데이트 한다.
					updateGroupRealStartEndDate(groupId);
				} */
				
				if (taskDetails.realProgress != realProgress) {
					var logContent = "<spring:message code='ezPMS.t317' arguments='" + taskName + "," + new Number(taskDetails.realProgress).toFixed(1) + "," + new Number(realProgress).toFixed(1) + "'/>"; 
   					addTaskLog(projectId, 2, groupId, taskId, logContent);
				}
				
				if (taskDetails.planStartDate != planStartDate || taskDetails.planEndDate != planEndDate) {					
					var logContent = "<spring:message code='ezPMS.t239' arguments='" + taskName + "," + planStartDate + " ~ " + planEndDate + "'/>";
					addTaskLog(projectId, 2, groupId, taskId, logContent);
				}
				
				parent.location.reload();
				parent.opener.location.reload();
				$("#projectProgress", parent.opener.parent.document).text(data.projectProgress.toFixed(1) + '%');
				popupClose();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("<spring:message code='ezPMS.t208' />");
			}
		});
	}
	
	// 소속 그룹과 소속 그룹의 상위까지 실제 시작일 및 종료일을 업데이트 한다.
	function updateGroupRealStartEndDate(groupId) {
		var data = {groupId : groupId};
		
		$.ajax({
			type : "PUT",
			url : "/ezPMS/updateGroupRealStartEndDate.do",
			dataType : "json",
			contentType: "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function() {}
		});
	}
	
	function datepickerSetting(){
		
		if (projectStatus == "W" || projectStatus == "C" || projectStatus == "S" || projectStatus == "D" || nowStatus == "W" || nowStatus == "S") {
			$("input[name='realProgress']").prop("readonly", true);
		}
				
		var planStartDate = taskDetails.planStartDate;
		var planEndDate = taskDetails.planEndDate;
		var realStartDate = taskDetails.realStartDate;
		var realEndDate = taskDetails.realEndDate;
		
		$("#PSDatepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			autoSize: true,
			showOn: "both",
			buttonImage: "/images/ImgIcon/calendar-month.gif",
			buttonImageOnly: true,
			beforeShow: function (input) {
				var i_offset = $(input).offset();
				setTimeout(function () {
					//$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
				})
			},
			/* beforeShowDay : function (date) {
				var day = date.getDay();
				return [(day != 0 && day != 6)];
			} */
		});
		
		$("#PEDatepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			autoSize: true,
			showOn: "both",
			buttonImage: "/images/ImgIcon/calendar-month.gif",
			buttonImageOnly: true,
			beforeShow: function (input) {
				var i_offset = $(input).offset();
				setTimeout(function () {
					//$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
  			})
			},
			/* beforeShowDay : function (date) {
				var day = date.getDay();
				return [(day != 0 && day != 6)];
			} */
		});
		
		var PSDate = new Date(planStartDate);
		var RSDate = new Date(realStartDate);
		var PEDate = new Date(planEndDate);
		var REDate = new Date(realEndDate);
		var diff = 0;

		$("#PSDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		$("#PSDatepicker").datepicker("setDate", PSDate);
		$("#RSDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		if(realStartDate){
			$("#RSDatepicker").datepicker("setDate", RSDate);
			diff = (RSDate.getTime() - PSDate.getTime()) / (60 * 60 * 24 * 1000);
			document.getElementById("sDiff").innerText = diff > 0 ? "+" + diff : (diff < 0 ? diff : "-") ;
		}
		
		$("#PEDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		$("#PEDatepicker").datepicker("setDate", PEDate);
		$("#REDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		if(realEndDate){
			$("#REDatepicker").datepicker("setDate", REDate);
			diff = (REDate.getTime() - PEDate.getTime()) / (60 * 60 * 24 * 1000);
			document.getElementById("eDiff").innerText = diff > 0 ? "+" + diff : (diff < 0 ? diff : "-");
		}
		
		$.datepicker.regional["<spring:message code='main.t0619' />"] = {
				closeText: "<spring:message code='main.t3' />",
				prevText: "<spring:message code='main.t0604' />",
				nextText: "<spring:message code='main.t0605' />",
				currentText: "<spring:message code='main.t0606' />",
				monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
				           "<spring:message code='main.t0627' />"],
				dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                "<spring:message code='main.t0627' />"],
				dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				              "<spring:message code='main.t0627' />"],
				weekHeader: "Wk",
				dateFormat: "yy-mm-dd",
				firstDay: 0,
				isRTL: false,
				duration: 200,
				showAnim: "show",
				showMonthAfterYear: true
		  };
		  
		  $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
	}
	
	// status 알파벳을 문자열로 반환
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
</script>
<style>
.headerDiv {
    width: 120px;
    float: right;
    text-align: center;
    margin-top: 7px;
}
button.PHBtn {
    margin-top: 5px;
}
#closeBtn{
	float:right;
}
.detailsTable{border-collapse:collapse;border-spacing:0;width:659px;height:167px;}
.detailsTable td{padding:5px 5px;border:1px solid #ccc;overflow:hidden;}
.detailsTable th{border:1px solid #ccc;overflow:hidden;}
.detailsTable .detailsTable-th{background-color:#f8f8fa;}
.mainBodyTSU .mainBodyBot .dateTd{width:100px;}
.mainBodyTSU .mainBodyBot .planTd{width:40%;}
.mainBodyTSU .mainBodyBot .realTd{width:40%;}
.mainBodyTSU .mainBodyTop{margin-top:8px;width:100%;}
.mainBodyTSU .mainBodyMid{height:160px;padding: 0px 30px;}
.mainBodyTSU input[name="realProgress"]{width:80px;}
.statusDiv{height:168px;float:left;}
.taskStatusChgDiv{float:left;margin: 65px 0px 0px 71px;padding:0px 7px;width:116px}
.taskUpdateBtn{display:inline-block;width:100px;height:16px;float:right;top:25px;position:relative;font-size:12px;text-align:center;border:1px solid #ddd;border-radius:6px;cursor:pointer;z-index:101;}
.mainBodyTSU .topThL{text-align:center;}
.mainBodyTSU .midTh{}
</style>
</head>
<body class="popup">
	<h1 style="display:inline-block; width:100px;"><spring:message code='ezPMS.t175' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="popupClose()"></span>
			</li>
		</ul>
		</div>
	</h1>
	<div id="mainBody" class="mainBodyTSU">
		<div class="mainBodyTop">
		</div>
		<div class="mainBodyMid">
			<div class="statusDiv">
					<div class="circle progress_graph" style="width:150px;margin:6px 6px 0px 6px;">
						<strong style="top:30px;"></strong>
					</div>
					<div class="taskStatusChgDiv">
						<span><spring:message code='ezPMS.t137' /> <spring:message code='ezPMS.t38' /></span>
						<select id="statusOption">
							
						</select>
					</div>
			</div>
		</div>	
		<div class="mainBodyBot">
			<table class="content">
			  <tr>
			    <th class="topThL" colspan="2"><spring:message code='ezPMS.t177' /></th>
			    <th class="topThL" colspan="2"><spring:message code='ezPMS.t178' /></th>
			    <th class="topThL"><spring:message code='ezPMS.t176' /></th>
			  </tr>
			  <tr>
			    <th class="midTh"><spring:message code='ezPMS.t61' /></th>
			    <td class="planTd">
				    <input type="text" id="PSDatepicker" style="width:80px;text-align:center" readonly >
			    </td>
			    <th class="midTh"><spring:message code='ezPMS.t61' /></th>
			    <td class="realTd">
			    	<input type="text" id="RSDatepicker" style="width:80px;text-align:center" readonly >
			    </td>
			    <td id="sDiff" class="sDiff"></td>
			  </tr>
			  <tr>
			    <th class="midTh"><spring:message code='ezPMS.t62' /></th>
			    <td class="planTd">
			    	<input type="text" id="PEDatepicker" style="width:80px;text-align:center" readonly >
			    </td>
			    <th class="midTh"><spring:message code='ezPMS.t62' /></th>
			    <td class="realTd">
			    	<input type="text" id="REDatepicker" style="width:80px;text-align:center" readonly >
			    </td>
			    <td id="eDiff" class="eDiff"></td>
			  </tr>
			  <tr>
			    <th class="midTh"><spring:message code='ezPMS.t250' />(%)</th>
			    <td id="planProgress" class="planTd"></td>
			    <th class="midTh"><spring:message code='ezPMS.t250' />(%)</th>
			    <td class="realTd"><input type="text" name="realProgress"></td>
			    <td id="progDiff" class="progDiff"></td>
			  </tr>
			</table>
			<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
				<tr>
					<td><a class="imgbtn" id="saveBtn" onclick="saveStatus()"><span><spring:message code='ezPMS.t265' /></span></a></td>
				</tr>
			</table>
		</div>	
	</div>
</body>
</html>