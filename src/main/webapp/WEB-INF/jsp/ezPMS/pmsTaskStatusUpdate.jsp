<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>진행상태변경 페이지</title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/Tab.css" type="text/css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
<link rel="stylesheet" href="/css/ezTask/circularProgressBar.css" type="text/css">
<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/ezTask/circularProgressBar.js"></script>


<!-- time picker-->
<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script type="text/javascript">
	var taskDetails;
	var weightData;
	var nowStatus;
	var progressColor = "${mainSetting.progressColor}";
	var completeColor = "${mainSetting.completeColor}";
	var overdueColor = "${mainSetting.overdueColor}";
	var holdColor = "${mainSetting.holdColor}";
	
	$(function(){
		taskDetails = JSON.parse(parent.document.all["frameParamTaskDetails"].value);
		weightData = JSON.parse(parent.document.all["frameParamWeight"].value);
		initProgressBar();
		datepickerSetting();
		setProgress();
		setStatus();
		btnEvent();
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
		
		$("td.detailsTable-td[name='statusTd']").text(strStatus);
		
		$(".progress_graph").circleProgress({
			value: taskDetails.realProgress / 100,
			fill : {color : circleColor},
			size : 134
		}).on('circle-animation-progress', function(event, progress) {
			$(this).find('strong').html(taskDetails.realProgress + "%<br><div style='font-size:20px'>" + strStatus + "</div>");
		});
	}
	
	function changeTab(clickTabId, nowTabAttr) {
		$("#"+nowTabAttr).attr("class", "tab");
		$("#"+clickTabId).attr("class", "tabon");
	}
	
	function popupClose() {
		parent.DivPopUpHidden();
	}
	
	function taskUpdate(){
	 	var taskId = "${taskDetails.taskId}";
		DivPopUpShow(760, 500, "/ezPMS/goUpdateTaskInfo.do?taskId=" + taskId);
	}
	
	function setProgress(){
		var diff = 0;
		diff = Number(taskDetails.planProgress - taskDetails.realProgress).toFixed(1);
		document.querySelector("[name='realProgress']").value = Number(taskDetails.realProgress).toFixed(1) + "%";
		document.getElementById("planProgress").innerText = Number(taskDetails.planProgress).toFixed(1) + "%";
		document.getElementById("progDiff").innerText = (diff > 0 ? "+" + diff : (diff < 0 ? diff : "-")) + "%";
	}
	
	function setStatus(){
		var targetStatus = document.querySelector("option[value='" + taskDetails.status + "']");
		if(targetStatus){
			targetStatus.selected = true;
		}
	}
	
	function btnEvent(){
		document.getElementById("closeBtn").onclick = popupClose;
		document.getElementById("saveBtn").onclick = saveStatus;
	}
	
	function saveStatus(){
		var projectStartDate = weightData.planStartDate;
		var projectEndDate = weightData.planEndDate;
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
		
		var startDateComp = new Date(planStartDate);
		var endDateComp = new Date(planEndDate);
		
		var today = new Date();
		var todayComp = new Date(today.getFullYear(), today.getMonth()-1, today.getDay());
		
		var projectStartDateComp = new Date(projectStartDate);
		var projectEndDateComp = new Date(projectEndDate);
		
		//1. 시작일 > 종료일은 불가능
		if (startDateComp.getTime() > endDateComp.getTime()) {
		  	alert("시작날짜가 종료날짜보다 늦을 수 없습니다.");
		  	return;
		}
		 
		//2. 종료일 < 현재일일 떄, 지연업무로 넘어갈 것이라는 confirm창 띄우기
		if (endDateComp.getTime() < todayComp.getTime()) {
			var confCheck = confirm("종료일이 현재일보다 빠르기 때문에 업무의 상태가 지연으로 변경됩니다. 계속하시겠습니까?");
			 
			if (confCheck != true) {
				 return;
			}
		}
		
		//3. 업무의 계획 시작일과 계획 종료일은 프로젝트 시작일과 종료일범위를 벗어날수 없음
		if (startDateComp.getTime() < projectStartDateComp.getTime()) {
			alert(startDateComp.getTime() + " <<<<>>>> " + projectStartDateComp.getTime());
			alert("업무의 계획 시작일은 프로젝트의 시작일보다 이를 수 없습니다.");
			return;
		}
		if (endDateComp.getTime() > projectEndDateComp.getTime()) {
			alert("업무의 계획 종료일은 프로젝트의 종료일보다 늦을 수 없습니다.");
			return;
		}
		 
		// 가중치 검사
		realProgress = realProgress.match(/\d+/)[0];
		if (realProgress != taskDetails.realProgress) {
			if (realProgress == "") {
				alert("진행률을 입력해 주십시오.");
				return;
			}
			else if (isNaN(realProgress)) {
				alert("진행률은 숫자만 입력 가능합니다.");
				return;
			}
			else if (Number(realProgress) > 100) {
				alert("진행률은 100%를 초과할 수 없습니다.");
				return;
			}
			else if (Number(realProgress) < 0) {
				alert("진행률은 0보다 작을 수 없습니다.");
				return;
			}
		}

		
		data = {
				taskId : taskDetails.taskId + "",
				projectId : taskDetails.projectId + "",
				planStartDate : planStartDate,
				planEndDate : planEndDate,
				realStartDate : realStartDate,
				realEndDate : realEndDate,
				realProgress : realProgress,
				status : status
		}
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/updateTaskStatus.do",
			dataType : "json",
			contentType: "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(data) {
				alert("업무 상태를 변경하였습니다.");
				
				parent.location.reload();
				popupClose();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("error2");
			}
		});
	}
	
	function datepickerSetting(){
		var planStartDate = taskDetails.planStartDate;
		var planEndDate = taskDetails.planEndDate;
		var realStartDate = taskDetails.realStartDate;
		var realEndDate = taskDetails.realEndDate;
		
		$("#PSDatepicker, #RSDatepicker").datepicker({
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
			}
		});
		
		$("#PEDatepicker, #REDatepicker").datepicker({
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
			}
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
			diff = (PSDate.getTime() - RSDate.getTime()) / (60 * 60 * 24 * 1000);
			document.getElementById("sDiff").innerText = diff > 0 ? "+" + diff : (diff < 0 ? diff : "-") ;
		}
		
		$("#PEDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		$("#PEDatepicker").datepicker("setDate", PEDate);
		$("#REDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		if(realStartDate){
			$("#REDatepicker").datepicker("setDate", REDate);
			diff = (PEDate.getTime() - REDate.getTime()) / (60 * 60 * 24 * 1000);
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
.taskStatusChgDiv{float:left;margin: 65px 0px 0px 114px;padding:0px 7px;width:116px}
.taskUpdateBtn{display:inline-block;width:100px;height:16px;float:right;top:25px;position:relative;font-size:12px;text-align:center;border:1px solid #ddd;border-radius:6px;cursor:pointer;z-index:101;}
.mainBodyTSU .topThL{text-align:center;}
.mainBodyTSU .midTh{}
</style>
</head>
<body class="popup">
	<h1 style="display:inline-block; width:100px;">진행상태변경</h1>
	<div class="headerDiv">
		<a class="imgbtn" id="saveBtn"><span>저장</span></a>
		<a class="imgbtn" id="closeBtn"><span>취소</span></a>
	</div>
	<div id="mainBody" class="mainBodyTSU">
		<div class="mainBodyTop">
		</div>
		<div class="mainBodyMid">
			<div class="statusDiv">
					<div class="circle progress_graph" style="width:150px;margin:6px 6px 0px 6px;">
						<strong style="top:30px;"></strong>
					</div>
					<div class="taskStatusChgDiv">
						<span>업무상태</span>
						<select>
							<option value="W">대기</option>
							<option value="P">진행</option>
							<option value="C">완료</option>
							<option value="S">보류</option>
							<option value="L">지연</option>
						</select>
					</div>
			</div>
		</div>	
		<div class="mainBodyBot">
			<table class="content">
			  <tr>
			    <th class="topThL" colspan="2">계획</th>
			    <th class="topThL" colspan="2">실제</th>
			    <th class="topThL">오차</th>
			  </tr>
			  <tr>
			    <th class="midTh">시작일</th>
			    <td class="planTd">
				    <input type="text" id="PSDatepicker" style="width:80px;text-align:center" readonly >
			    </td>
			    <th class="midTh">시작일</th>
			    <td class="realTd">
			    	<input type="text" id="RSDatepicker" style="width:80px;text-align:center" readonly >
			    </td>
			    <td id="sDiff" class="sDiff"></td>
			  </tr>
			  <tr>
			    <th class="midTh">종료일</th>
			    <td class="planTd">
			    	<input type="text" id="PEDatepicker" style="width:80px;text-align:center" readonly >
			    </td>
			    <th class="midTh">종료일</th>
			    <td class="realTd">
			    	<input type="text" id="REDatepicker" style="width:80px;text-align:center" readonly >
			    </td>
			    <td id="eDiff" class="eDiff"></td>
			  </tr>
			  <tr>
			    <th class="midTh">진행률(%)</th>
			    <td id="planProgress" class="planTd"></td>
			    <th class="midTh">진행률(%)</th>
			    <td class="realTd"><input type="text" name="realProgress"></td>
			    <td id="progDiff" class="progDiff"></td>
			  </tr>
			</table>
		</div>	
	</div>
</body>
</html>