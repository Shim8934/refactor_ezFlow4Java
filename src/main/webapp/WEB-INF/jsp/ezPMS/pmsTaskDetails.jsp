<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>프로젝트 업무 상세 페이지</title>
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
	var nowStatus;
	var weightData;
	var progressColor = "${mainSetting.progressColor}";
	var completeColor = "${mainSetting.completeColor}";
	var overdueColor = "${mainSetting.overdueColor}";
	var holdColor = "${mainSetting.holdColor}";
	var target = "${target}";
	
	$(function(){
		taskDetails = ${taskDetails};
		
		if (target == null || target != "group") {
			weightData = '${weightData}';
		}
		
		setFrameParams();
		initProgressBar();
		tabFuncSetting();
		diffSetting();
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
	
	function tabFuncSetting(){
		console.log(target);
		if (target == null || target != "group") {
			var taskId = "${taskDetails.taskId}"
			var projectId = taskDetails.projectId;
			var groupId = taskDetails.groupId;
			$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?projectId=" + projectId + "&taskId=" + taskId);
			$("#1tab0").addClass("tabon");
			
			$("#1tab0").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
				//업무정보 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?projectId=" + projectId + "&taskId=" + taskId);
				
			});
			
			$("#1tab1").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
				
				//관련 게시물 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getBoardListTab.do?projectId=" + projectId + "&taskId=" + taskId + "&groupId=" + groupId);
			});
			
			$("#1tab2").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				var currentPage = 1;
				changeTab(clickTabId, nowTabAttr);
				
				//작업이력 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getLogListTab.do?projectId=" + projectId + "&taskId=" + taskId + "&groupId=" + groupId + "&currentPage=" + currentPage);
			});
			
			$("#1tab3").click(function(){
				alert("미구현");
				return;
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
				
				//의견 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getBoardMain.do?projectId=" + projectId + "&onlyGroup=false");
			});
		} else {
			var projectId = taskDetails.projectId;
			var groupId = taskDetails.groupId;
			$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?projectId=" + projectId + "&groupId=" + groupId);
			$("#1tab0").addClass("tabon");
				
			$("#1tab0").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
				//업무정보 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?projectId=" + projectId + "&groupId=" + groupId);
				
			});
				
			$("#1tab1").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
					
				//관련 게시물 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getBoardListTab.do?projectId=" + projectId + "&groupId=" + groupId);
			});
				
			$("#1tab2").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				var currentPage = 1;
				changeTab(clickTabId, nowTabAttr);
					
				//작업이력 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getLogListTab.do?projectId=" + projectId + "&groupId=" + groupId + "&currentPage=" + currentPage);
			});
				
			$("#1tab3").click(function(){
				alert("미구현");
				return;
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
					
				//의견 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getBoardMain.do?projectId=" + projectId + "&onlyGroup=false");
			});
		}
		
		$(".tab").hover(function(){
			$(this).addClass("tabover");
		},
			function(){
				$(this).removeClass("tabover");
		});
	}
	
	function changeTab(clickTabId, nowTabAttr) {
		$("#"+nowTabAttr).attr("class", "tab");
		$("#"+clickTabId).attr("class", "tabon");
	}
	
	function popupClose() {
		parent.DivPopUpHidden();
		parent.location.reload();
	}
	
	function taskUpdate(){
		var taskId = 0;
		var projectId = taskDetails.projectId;
		
		if (target == null || target != "group") {
			taskId = "${taskDetails.taskId}";
			target = "task";
		} else {
			taskId = "${taskDetails.groupId}";
		}
	 	
		DivPopUpShow(760, 500, "/ezPMS/goUpdateTaskInfo.do?projectId=" + projectId + "&taskId=" + taskId + "&target=" + target);
	}
	
	function addBoard(){
		//구현해야함.
	}
	
	function taskStatusUpdate(){
		DivPopUpShow(500, 370, "/ezPMS/goUpdateTaskStatus.do");
	}
	
	function btnEvent(){
		document.getElementById("closeBtn").onclick = popupClose;
		document.getElementById("taskUpdateBtn").onclick = taskUpdate;
		
		if (target != "group") {
			document.getElementById("statusChgBtn").onclick = taskStatusUpdate;
		}
		
	}
	
	function setFrameParams(){
		document.querySelector("[name='frameParamTaskDetails']").value = JSON.stringify(taskDetails);
		document.querySelector("[name='frameParamWeight']").value = JSON.stringify(taskDetails);
	}
	
	function diffSetting(){
		var PSDate = new Date("${taskDetails.planStartDate}");
		var PEDate = new Date("${taskDetails.planEndDate}");
		var RSDate = new Date("${taskDetails.realStartDate}");
		var REDate = new Date("${taskDetails.realEndDate}");
		var planProg = "${taskDetails.planProgress}";
		var realProg = "${taskDetails.realProgress}";
		
		var SDateDiff = (PSDate.getTime() - RSDate.getTime()) / (60 * 60 * 24 * 1000);
		var EDateDiff = (PEDate.getTime() - REDate.getTime()) / (60 * 60 * 24 * 1000);
		var progDiff = planProg - realProg;
		
		document.getElementById("startDiff").innerText = SDateDiff > 0 ? "+" + SDateDiff : SDateDiff < 0 ? SDateDiff : "";
		document.getElementById("endDiff").innerText = EDateDiff > 0 ? "+" + EDateDiff : EDateDiff < 0 ? EDateDiff : "";
		document.getElementById("progressDiff").innerText = progDiff > 0 ? "+" + progDiff + "%" : progDiff < 0 ? progDiff + "%" : "";
	}
	
</script>
<style>
.popupHeader{
	height:38px;
}
button.PHBtn {
    margin-top: 5px;
}
#closeBtn{
	float:right;
}
.detailsTable{border-collapse:collapse;border-spacing:0;width:652px;height:167px;}
.detailsTable td{padding:5px 5px;border:1px solid #ccc;overflow:hidden;}
.detailsTable th{border:1px solid #ccc;overflow:hidden;}
.detailsTable .detailsTable-th{background-color:#f8f8fa;}
.detailsTable .dateTd{width:180px}
.mainBodyTop{margin-top:8px;width:818px;}
.mainBodyMid{height:320px;}
.statusDivBrd{width:165px;height:168px;float:left;border: 1px solid #ccc;border-right:0px;}
.statusChgBtn{float:left;margin:3px 25px;border:1px solid #ddd;border-radius:5px; padding:0px 7px; cursor:pointer;}
.taskUpdateBtn{display:inline-block;width:100px;height:16px;float:right;top:25px;position:relative;font-size:12px;text-align:center;border:1px solid #ddd;border-radius:6px;cursor:pointer;z-index:101;}
</style>
</head>
<body class="popup">
	<div class="popupHeader">
	    <button id="deleteBtn" class="PHBtn">삭제</button>
   		<button id="closeBtn" class="PHBtn">닫기</button>
	</div>
	<div id="mainBody">
		<div class="mainBodyTop">
			<div class="statusDivBrd">
					<div class="circle progress_graph" style="width:150px;margin:6px 6px 0px 6px;">
						<strong style="top:30px;"></strong>
					</div>
					<c:if test="${empty target }">
					<div id="statusChgBtn" class="statusChgBtn">진행상태변경</div>
					</c:if>
			</div>
			<table class="detailsTable" style="clear:none">
			  <tr>
			  <c:choose>
			  <c:when test="${empty target }">
			    <th class="detailsTable-th" style="width:60px">업무명</th>
			    <td class="detailsTable-td" colspan="4">${taskDetails.taskName}</td>
			  </c:when>
			  <c:otherwise>
			    <th class="detailsTable-th" style="width:60px">그룹명</th>
			    <td class="detailsTable-td" colspan="4">${taskDetails.groupName}</td>
			  </c:otherwise>
			  </c:choose>
			  </tr>
			  <tr>
			    <th class="detailsTable-th">담당자</th>
			    <td class="detailsTable-td" colspan="4">${taskDetails.headManagerName}</td>
			  </tr>
			  <tr>
			    <th class="detailsTable-th">상태</th>
			    <td class="detailsTable-td" name="statusTd" colspan="4"></td>
			  </tr>
			  <tr>
			    <th class="detailsTable-th" colspan="2">계획</th>
			    <th class="detailsTable-th" colspan="2">실제</th>
			    <th class="detailsTable-th">오차</th>
			  </tr>
			  <tr>
			    <th class="detailsTable-th">시작일</th>
			    <td class="detailsTable-td dateTd">${taskDetails.planStartDate}</td>
			    <th class="detailsTable-th" style="width:60px">시작일</th>
			    <td class="detailsTable-td dateTd">${taskDetails.realStartDate == null ? "-" : taskDetails.realStartDate}</td>
			    <td id="startDiff" class="detailsTable-td" name="startDiff"></td>
			  </tr>
			  <tr>
			    <th class="detailsTable-th">종료일</th>
			    <td class="detailsTable-td">${taskDetails.planEndDate}</td>
			    <th class="detailsTable-th">종료일</th>
			    <td class="detailsTable-td">${taskDetails.realEndDate == null ? "-" : taskDetails.realEndDate}</td>
			    <td id="endDiff" class="detailsTable-td" name="endDiff"></td>
			  </tr>
			  <tr>
			    <th class="detailsTable-th">진행률</th>
			    <td class="detailsTable-td">${taskDetails.planProgress}</td>
			    <th class="detailsTable-th">진행률</th>
			    <td class="detailsTable-td">${taskDetails.realProgress}</td>
			    <td id="progressDiff" class="detailsTable-td" name="progressDiff"></td>
			  </tr>
			</table>
		</div>
		<div class="mainBodyMid">
			<div id="taskUpdateBtn" class="taskUpdateBtn">업무정보수정</div>
			<div class="portlet_tabpart01" style="margin-bottom: 10px">
			   <div class="portlet_tabpart01_top" id="tab1">
			   		<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab">업무정보</span></p>
			  	 	<p id="FBoard_sub1"><span id="1tab1" divname="FBoard_div0" class="tab">관련게시물</span></p>
			  	 	<p id="FBoard_sub2"><span id="1tab2" divname="FBoard_div0" class="tab">작업이력</span></p>
			   		<p id="FBoard_sub3"><span id="1tab3" divname="FBoard_div0" class="tab">의견</span></p>
			   </div>
			</div>
			<iframe id="FBoard_ifrm" style="width: 100%; height: 100%;" frameborder="0"></iframe>
		</div>	
		<div class="mainBodyBot"></div>	
	</div>
	<input type="hidden" name="frameParamTaskDetails" value="">
	<input type="hidden" name="frameParamWeight" value="">
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>