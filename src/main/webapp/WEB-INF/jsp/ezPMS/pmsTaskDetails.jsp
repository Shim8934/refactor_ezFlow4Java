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
	
	$(function(){
		taskDetails = ${taskDetails};
		weightData = ${weightData};
		setFrameParams();
		initProgressBar();
		tabFuncSetting();
		btnEvent();
		
	});
	
	function popupClose() {
		parent.DivPopUpHidden();
	}
	
	function initProgressBar() {
		nowStatus = taskDetails.status;
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
			value: 0.4,
			fill : {color : circleColor},
			size : 134
		}).on('circle-animation-progress', function(event, progress) {
			$(this).find('strong').html(40 + "%<br><div style='font-size:20px'>" + strStatus + "</div>");
		});
	}
	
	function tabFuncSetting(){
		var taskId = "${taskDetails.taskId}"
		var projectId = taskDetails.projectId;
		var groupId = taskDetails.groupId;
		$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?taskId=" + taskId);
		$("#1tab0").addClass("tabon");
		
		$("#1tab0").click(function(){
			var clickTabId = $(this).attr("id");
			var nowTabAttr = $(".tabon").attr("id");
			changeTab(clickTabId, nowTabAttr);
			//업무정보 탭
			$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?taskId=" + taskId);
			
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
			changeTab(clickTabId, nowTabAttr);
			
			//작업이력 탭
			$("#FBoard_ifrm").attr("src", "/ezPMS/getLogListTab.do?projectId=" + projectId + "&taskId=" + taskId + "&groupId=" + groupId);
		});
		
// 		$("#1tab3").click(function(){
// 			var clickTabId = $(this).attr("id");
// 			var nowTabAttr = $(".tabon").attr("id");
// 			changeTab(clickTabId, nowTabAttr);
			
// 			//게시판으로 가는 부분 url 수정하기
// 			$("#FBoard_ifrm").attr("src", "/ezPMS/getBoardMain.do?projectId=" + projectId + "&onlyGroup=false");
// 		});
		
// 		$("#1tab4").click(function(){
// 			var clickTabId = $(this).attr("id");
// 			var nowTabAttr = $(".tabon").attr("id");
// 			changeTab(clickTabId, nowTabAttr);
			
// 			$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskLogMain.do?projectId=" + projectId + "&onlyGroup=false");
// 		});
		
// 		$("#1tab5").click(function(){
// 			var clickTabId = $(this).attr("id");
// 			var nowTabAttr = $(".tabon").attr("id");
// 			changeTab(clickTabId, nowTabAttr);
			
// 			//의견으로 가는 부분 url 수정하기
// 			$("#FBoard_ifrm").attr("src", "/ezPMS/getComment.do");
// 		});
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
	}
	
	function taskUpdate(){
	 	var taskId = "${taskDetails.taskId}";
		DivPopUpShow(760, 500, "/ezPMS/goUpdateTaskInfo.do?taskId=" + taskId);
	}
	
	function taskStatusUpdate(){
		DivPopUpShow(500, 370, "/ezPMS/goUpdateTaskStatus.do");
		
	}
	
	function btnEvent(){
		document.getElementById("closeBtn").onclick = popupClose;
		document.getElementById("taskUpdateBtn").onclick = taskUpdate;
		document.getElementById("statusChgBtn").onclick = taskStatusUpdate;
	}
	
	function setFrameParams(){
		document.querySelector("[name='frameParamTaskDetails']").value = JSON.stringify(taskDetails);
		document.querySelector("[name='frameParamWeight']").value = JSON.stringify(taskDetails);
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
.detailsTable{border-collapse:collapse;border-spacing:0;width:659px;height:167px;}
.detailsTable td{padding:5px 5px;border:1px solid #ccc;overflow:hidden;}
.detailsTable th{border:1px solid #ccc;overflow:hidden;}
.detailsTable .detailsTable-th{background-color:#f8f8fa;}
.detailsTable .dateTd{width:180px}
.mainBodyTop{margin-top:8px;width:825px;}
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
					<div id="statusChgBtn" class="statusChgBtn">진행상태변경</div>
			</div>
			<table class="detailsTable" style="clear:none">
			  <tr>
			    <th class="detailsTable-th" style="width:60px">업무명</th>
			    <td class="detailsTable-td" colspan="4">${taskDetails.taskName}</td>
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
			    <td class="detailsTable-td" name="startDiff"></td>
			  </tr>
			  <tr>
			    <th class="detailsTable-th">종료일</th>
			    <td class="detailsTable-td">${taskDetails.planEndDate}</td>
			    <th class="detailsTable-th">종료일</th>
			    <td class="detailsTable-td">${taskDetails.realEndDate == null ? "-" : taskDetails.realEndDate}</td>
			    <td class="detailsTable-td" name="endDiff"></td>
			  </tr>
			  <tr>
			    <th class="detailsTable-th">진행률</th>
			    <td class="detailsTable-td">${taskDetails.planProgress}</td>
			    <th class="detailsTable-th">진행률</th>
			    <td class="detailsTable-td">${taskDetails.realProgress}</td>
			    <td class="detailsTable-td" name="realProgressDiff"></td>
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