<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
	var nowStatus;
	var progressColor = "${mainSetting.progressColor}";
	var completeColor = "${mainSetting.completeColor}";
	var overdueColor = "${mainSetting.overdueColor}";
	var holdColor = "${mainSetting.holdColor}";
	
	$(function(){
		taskDetails = ${taskDetails};
		initProgressBar();
		tabFuncSetting();
		document.getElementById("closeBtn").onclick = popupClose;
		document.getElementById("taskUpdateBtn").onclick = taskUpdate;
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
.statusDiv{width:165px;height:168px;float:left;border: 1px solid #ccc;border-right:0px;}
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
			<div class="statusDiv">
					<div class="circle progress_graph" style="width:150px;margin:6px 6px 0px 6px;">
						<strong style="top:30px;"></strong>
					</div>
					<div class="statusChgBtn">진행상태변경</div>
			</div>
		</div>
		<div class="mainBodyMid">
		</div>	
		<div class="mainBodyBot">
			<table class="tg">
			  <tr>
			    <th class="tg-031e" colspan="2"></th>
			    <th class="tg-yw4l" colspan="2"></th>
			    <th class="tg-yw4l"></th>
			  </tr>
			  <tr>
			    <th class="tg-031e"></th>
			    <td class="tg-031e"></td>
			    <th class="tg-yw4l"></th>
			    <td class="tg-yw4l"></td>
			    <td class="tg-yw4l"></td>
			  </tr>
			  <tr>
			    <th class="tg-031e"></th>
			    <td class="tg-031e"></td>
			    <th class="tg-yw4l"></th>
			    <td class="tg-yw4l"></td>
			    <td class="tg-yw4l"></td>
			  </tr>
			  <tr>
			    <th class="tg-031e"></th>
			    <td class="tg-031e"></td>
			    <th class="tg-yw4l"></th>
			    <td class="tg-yw4l"></td>
			    <td class="tg-yw4l"></td>
			  </tr>
			</table>
		</div>	
	</div>
</body>
</html>