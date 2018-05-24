<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>프로젝트 업무 상세 페이지</title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
<link rel="stylesheet" href="/css/ezTask/circularProgressBar.css" type="text/css">
<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
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
	
	$(function(){
		taskDetails = ${taskDetails};
		initProgressBar();
		document.getElementById("closeBtn").onclick = popupClose;
	});
	
	function popupClose() {
		parent.DivPopUpHidden();
	}
	
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
	
</script>
<style>
.popupHeader{
	height:34px;
}
button.PHBtn {
    margin-top: 5px;
}
#closeBtn{
	float:right;
}

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
				
			</div>
			<table>
				
			</table>
		</div>
		<div class="mainBodyMid"></div>	
		<div class="mainBodyBot"></div>	
	</div>
</body>
</html>