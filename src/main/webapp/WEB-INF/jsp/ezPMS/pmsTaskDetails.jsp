<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:choose>
	<c:when test="${target ne 'group'}">
		<title><spring:message code='ezPMS.t256' /></title>
	</c:when>
	<c:otherwise>
		<title><spring:message code='ezPMS.t257' /></title>
	</c:otherwise>
</c:choose>


<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezTask/circularProgressBar.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezTask/circularProgressBar.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>

<!-- time picker-->
<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>

<script type="text/javascript">
	var taskDetails = ${taskDetails};
	var nowStatus;
	var weightData;
	var progressColor = "${mainSetting.progressColor}";
	var completeColor = "${mainSetting.completeColor}";
	var overdueColor = "${mainSetting.overdueColor}";
	var holdColor = "${mainSetting.holdColor}";
	var target = "${target}";
	
	var projectId = taskDetails.projectId;
	var groupId = taskDetails.groupId;
	var taskId = taskDetails.taskId;
	var realProgress = taskDetails.realProgress;
	var userRoleId = "${userRoleId}";
	
	$(function(){
		if (target == null || target != "group") {
			weightData = JSON.parse('${weightData}');
		}
		
		setPlanProgress();
		setFrameParams();
		initProgressBar();
		tabFuncSetting();
		diffSetting();
		btnEvent();
		selToggleList(document.getElementById("menu"), "ul", "li", "0");
	});
	
	function setPlanProgress() {
		var planProgress;
		
		if(target == "group") {
			planProgress = $("tr[id$='g" + groupId + "']", opener.document).find("input[name='planProgress']").val();
		} else {
			planProgress = taskDetails.planProgress;
			planProgress = planProgress.toFixed(1);
		}
		
		$("#planProgress").text(planProgress + '%');
	}

	function initProgressBar() {
		if (taskDetails.status == null) {
			if(taskDetails.realProgress >= 100){
				nowStatus = "C";				
			} else {
				nowStatus = "P";
			}
		} else {
			nowStatus = taskDetails.status;
		}
		
		var strStatus = "";
		var circleColor = "";
		
		switch(nowStatus){
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
	
	function tabFuncSetting(){
		if (target == null || target != "group") {
			var taskId = "${taskDetails.taskId}"
			$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?projectId=" + projectId + "&taskId=" + taskId);
			$("#1tab0").addClass("tabon");
			
			$("#1tab0").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
				
				$("#taskUpdateBtn").css("display", "");
				$("#addBoardBtn").css("display", "none");
				//업무정보 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?projectId=" + projectId + "&taskId=" + taskId);
				
			});
			
			$("#1tab1").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
				
				$("#taskUpdateBtn").css("display", "none");
				$("#addBoardBtn").css("display", "");
				//관련 게시물 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getBoardListTab.do?projectId=" + projectId + "&taskId=" + taskId + "&groupId=" + groupId);
			});
			
			$("#1tab2").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				var currentPage = 1;
				changeTab(clickTabId, nowTabAttr);
				
				$("#taskUpdateBtn").css("display", "none");
				$("#addBoardBtn").css("display", "none");
				//작업이력 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskLogListTab.do?projectId=" + projectId + "&taskId=" + taskId + "&groupId=" + groupId);
			});
			
			$("#1tab3").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
				
				$("#taskUpdateBtn").css("display", "none");
				$("#addBoardBtn").css("display", "none");
				//의견 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getCommentListTab.do?projectId=" + projectId + "&taskId=" + taskId + "&groupId=" + groupId);
			});
		} else {
			$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?projectId=" + projectId + "&groupId=" + groupId);
			$("#1tab0").addClass("tabon");
				
			$("#1tab0").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
				
				$("#taskUpdateBtn").css("display", "");
				$("#addBoardBtn").css("display", "none");
				//업무정보 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskDetailsTab.do?projectId=" + projectId + "&groupId=" + groupId);
				
			});
				
			$("#1tab1").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
					
				$("#taskUpdateBtn").css("display", "none");
				$("#addBoardBtn").css("display", "");
				//관련 게시물 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getBoardListTab.do?projectId=" + projectId + "&groupId=" + groupId);
			});
				
			$("#1tab2").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				var currentPage = 1;
				changeTab(clickTabId, nowTabAttr);
				
				$("#taskUpdateBtn").css("display", "none");
				$("#addBoardBtn").css("display", "none");
				//작업이력 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getTaskLogListTab.do?projectId=" + projectId + "&groupId=" + groupId);
			});
				
			$("#1tab3").click(function(){
				var clickTabId = $(this).attr("id");
				var nowTabAttr = $(".tabon").attr("id");
				changeTab(clickTabId, nowTabAttr);
					
				$("#taskUpdateBtn").css("display", "none");
				$("#addBoardBtn").css("display", "none");
				//의견 탭
				$("#FBoard_ifrm").attr("src", "/ezPMS/getCommentListTab.do?projectId=" + projectId + "&groupId=" + groupId);
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
		window.close();
	}
	
	function taskUpdate(){
		var taskId = 0;
		
		if (target == null || target != "group") {
			taskId = "${taskDetails.taskId}";
			target = "task";
			
			DivPopUpShow(760, 480, "/ezPMS/goUpdateTaskInfo.do?projectId=" + projectId + "&taskId=" + taskId + "&target=" + target);
		} else {
			taskId = "${taskDetails.groupId}";
			
			DivPopUpShow(760, 490, "/ezPMS/goUpdateTaskInfo.do?projectId=" + projectId + "&taskId=" + taskId + "&target=" + target);
		}
	}
	
	function goAddBoard() {
		var feature = GetOpenPosition(790, 800);
		var taskId = taskDetails.taskId;
		var taskName = taskDetails.taskName;

		if(!taskId) {
			taskId = "";
		}
		
		if(!taskName) {
			taskName = taskDetails.groupName;
		}
		
		window.open("/ezPMS/goAddBoard.do?projectId=" + projectId + "&groupId=" + groupId + "&taskId=" + taskId + "&mode=new", 
					"", "width=790, height=800, resizable=no, scrollbars=no, status=no" + feature);
	}
	
	function getBoardList() {
		document.getElementById("FBoard_ifrm").contentWindow.getBoardList();
	}
	
	function taskStatusUpdate(){
		DivPopUpShow(500, 397, "/ezPMS/goUpdateTaskStatus.do");
	}
	
	function btnEvent(){
		document.getElementById("deleteBtn").onclick = delTaskFunc;
		document.getElementById("taskUpdateBtn").onclick = taskUpdate;
		document.getElementById("addBoardBtn").onclick = goAddBoard;
		
		if (target != "group") {
			document.getElementById("statusChgBtn").onclick = taskStatusUpdate;
		}
		
	}
	
	function setFrameParams(){
		document.querySelector("[name='frameParamTaskDetails']").value = JSON.stringify(taskDetails);
		document.querySelector("[name='frameParamWeight']").value = JSON.stringify(weightData);
	}
	
	function diffSetting(){
		var PSDate = new Date("<c:out value='${taskDetails.planStartDate}'/>");
		var PEDate = new Date("<c:out value='${taskDetails.planEndDate}'/>");
		var RSDate = new Date("<c:out value='${taskDetails.realStartDate}'/>");
		var REDate = new Date("<c:out value='${taskDetails.realEndDate}'/>");
		
		var planProg;
		
		if(target == 'group') {
			planProg = $("tr[id$='g" + groupId + "']", opener.document).find("input[name='planProgress']").val();
		} else {
			planProg = "<c:out value='${taskDetails.planProgress}'/>";
		}
		
		var realProg = "<c:out value='${taskDetails.realProgress}'/>";
		
		var SDateDiff = (RSDate.getTime() - PSDate.getTime()) / (60 * 60 * 24 * 1000);
		var EDateDiff = (REDate.getTime() - PEDate.getTime()) / (60 * 60 * 24 * 1000);
		var progDiff = Number(realProg - planProg).toFixed(1);
		
		document.getElementById("startDiff").innerText = SDateDiff > 0 ? "+" + SDateDiff : SDateDiff < 0 ? SDateDiff : "";
		document.getElementById("endDiff").innerText = EDateDiff > 0 ? "+" + EDateDiff : EDateDiff < 0 ? EDateDiff : "";
		document.getElementById("progressDiff").innerText = progDiff > 0 ? "+" + progDiff + "%" : progDiff < 0 ? progDiff + "%" : "";
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
	
	function delTaskFunc() {
		
		var url = "/ezPMS/deleteTask.do?projectId=" + projectId + "&taskId=" + taskId;
		
		if(!taskId) {
			delGroup();
			return;
		}
		
		if(!confirm("<spring:message code='ezPMS.t305' />")){
			return;
		}
		
		var data = {
				projectId : projectId,
				groupId : groupId,
				taskId : taskId	
		}
		
		$.ajax({
			type : "POST",
			url : url,
			dataType : "json",
			contentType: "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				
				if (result.checkPermission == "permitted") {
					alert("<spring:message code='ezPMS.t242' />");
					var logContent = "<spring:message code='ezPMS.t313' arguments='" + taskDetails.groupName + "," + taskDetails.taskName + "'/>";
   					addTaskLog(projectId, 3, groupId, null, logContent);
   					updateGroupRealStartEndDate(groupId);
   					opener.location.reload();
   					$("#projectProgress", opener.parent.document).text(result.projectProgress.toFixed(1) + '%');
   					window.close();
				} else {
					alert("<spring:message code='ezPMS.t184' />");
					return;
				}
				
				location.reload();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("<spring:message code='ezPMS.t213' />");
				location.reload();
			}
		});
	}
	
	function delGroup(){

		var data = {
				projectId : projectId,
				groupId : groupId
		}

		
		var taskIdAttr = "p" + projectId + "_g" + groupId + "_t";
		var hasTaskOrNot = $("[taskid^='" + taskIdAttr + "']", window.opener.document);
		
		if(!confirm("<spring:message code='ezPMS.t306' />")){
			return;
		}
		
		if(hasTaskOrNot.length) {
			alert("<spring:message code='ezPMS.t243' />")
			return;
		}
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/deleteGroup.do",
			dataType : "text",
			contentType: "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(data) {
				alert("<spring:message code='ezPMS.t196' />");
				var upperGroupIds = taskDetails.ancesterGroup.split(',');
				var upperGroupId = upperGroupIds[upperGroupIds.length - 2];
				var logContent = "<spring:message code='ezPMS.t283' arguments='" + taskDetails.upperGroupName + "," + taskDetails.groupName + "'/>";
				addTaskLog(projectId, 3, upperGroupId, null, logContent);
				opener.location.reload();
				window.close();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("<spring:message code='ezPMS.t213' />");
			}
		});
	}
</script>
<style>
.popupHeader{
	height:38px;
}
button.PHBtn {
    margin-top: 5px;
}

.detailsTable{border-collapse:collapse;border-spacing:0;width:652px;height:170px;table-layout:fixed;}
.detailsTable td{padding:5px 5px;border:1px solid #ccc;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
.detailsTable th{border:1px solid #ccc;overflow:hidden;}
.detailsTable .detailsTable-th{background-color:#f8f8fa;}
.detailsTable .dateTd{width:180px}
.mainBodyTop{margin-top:8px;width:818px;}
.mainBodyMid{height:510px;}
.statusDivBrd{width:165px;height:168px;float:left;border: 1px solid #ccc;border-right:0px;}
.statusChgBtn{float:left !important; margin-left:35px; margin-top:2px !important;}
.imgbtn {float:right; margin-top:1px;}
</style>
</head>
<body class="popup">
	<div id="menu">
	<c:if test="${userRoleId eq 1 }">
	    <ul>
	    <li><span id="deleteBtn" class="PHBtn"><spring:message code='ezPMS.t11'/></span></li>
   		</ul>
	</c:if>
	</div>
	<div id="close" style="float:right">
		<ul><li>
				<span id="cancel" onclick="window.close()"></span>
		</li></ul>
	</div>
	<div id="mainBody">
		<div class="mainBodyTop">
			<div class="statusDivBrd">
					<div class="circle progress_graph" style="width:150px;margin:6px 6px 0px 6px;">
						<strong style="top:30px;"></strong>
					</div>
					<c:if test="${empty target }">
					<a id="statusChgBtn" class="imgbtn imgbck statusChgBtn"><span><spring:message code='ezPMS.t175' /></span></a>
					</c:if>
			</div>
			<table class="detailsTable" style="clear:none">
				<colgroup>
					<col style="width:80px;">
					<col>
					<col style="width:80px;">
					<col>
				</colgroup>
			  <tr>
			  <c:choose>
			  <c:when test="${empty target }">
			    <th class="detailsTable-th"><spring:message code='ezPMS.t98' /></th>
			    <td id="taskName" class="detailsTable-td" colspan="4"><c:out value="${taskDetails.taskName}"/></td>
			  </c:when>
			  <c:otherwise>
			    <th class="detailsTable-th"><spring:message code='ezPMS.t87' /></th>
			    <td id="taskName" class="detailsTable-td" colspan="4"><c:out value="${taskDetails.groupName}"/></td>
			  </c:otherwise>
			  </c:choose>
			  </tr>
<!-- 			  <tr> -->
<%-- 			    <th class="detailsTable-th"><spring:message code='ezPMS.t32' /></th> --%>
<%-- 			    <td class="detailsTable-td" colspan="4"><c:out value="${taskDetails.headManagerName}"/></td> --%>
<!-- 			  </tr> -->
			  <tr>
			    <th class="detailsTable-th"><spring:message code='ezPMS.t38' /></th>
			    <td class="detailsTable-td" name="statusTd" colspan="4"></td>
			  </tr>
			  <tr>
			    <th class="detailsTable-th" colspan="2"><spring:message code='ezPMS.t177' /></th>
			    <th class="detailsTable-th" colspan="2"><spring:message code='ezPMS.t178' /></th>
			    <th class="detailsTable-th"><spring:message code='ezPMS.t176' /></th>
			  </tr>
			  <tr>
			    <th class="detailsTable-th"><spring:message code='ezPMS.t61' /></th>
			    <td class="detailsTable-td dateTd"><c:out value="${taskDetails.planStartDate}"/></td>
			    <th class="detailsTable-th"><spring:message code='ezPMS.t61' /></th>
			    <td class="detailsTable-td dateTd"><c:out value="${taskDetails.realStartDate == null ? '-' : taskDetails.realStartDate}"/></td>
			    <td id="startDiff" class="detailsTable-td" name="startDiff"></td>
			  </tr>
			  <tr>
			    <th class="detailsTable-th"><spring:message code='ezPMS.t62' /></th>
			    <td class="detailsTable-td"><c:out value="${taskDetails.planEndDate}"/></td>
			    <th class="detailsTable-th"><spring:message code='ezPMS.t62' /></th>
			    <td class="detailsTable-td"><c:out value="${taskDetails.realEndDate == null ? '-' : taskDetails.realEndDate}"/></td>
			    <td id="endDiff" class="detailsTable-td" name="endDiff"></td>
			  </tr>
			  <tr>
			    <th class="detailsTable-th"><spring:message code='ezPMS.t250' /></th>
			    <td class="detailsTable-td" id="planProgress"></td>
			    <th class="detailsTable-th"><spring:message code='ezPMS.t250' /></th>
			     <td class="detailsTable-td">
			    	<c:choose>
			    		<c:when test="${taskDetails.realProgress == ''|| taskDetails.realProgress eq null}">
					    	0.0%
			    		</c:when>
			    		<c:otherwise>
					    	<fmt:formatNumber value="${taskDetails.realProgress}" pattern=".0"/>%
			    		</c:otherwise>
			    	</c:choose>
			    </td>
			    <td id="progressDiff" class="detailsTable-td" name="progressDiff"></td>
			  </tr>
			</table>
		</div>
		<div class="mainBodyMid">
			<div class="portlet_tabpart01" style="margin-bottom: 10px">
			<c:if test="${userRoleId eq 1 }">
			<a id="taskUpdateBtn" class="imgbtn imgbck">
				<span><c:choose>
					<c:when test="${target eq 'group'}"><spring:message code='ezPMS.t279' /></c:when>
					<c:otherwise><spring:message code='ezPMS.t179' /></c:otherwise>
				</c:choose>
				</span>
			</a>
			</c:if>
			<c:if test="${userRoleId ne 3 }">
				<div id="addBoardBtn" class="taskUpdateBtn" style="display: none;"><spring:message code='ezPMS.t278' /></div>
			</c:if>
			   <div class="portlet_tabpart01_top" id="tab1">
			   	<c:choose>
				  <c:when test="${empty target }">
				  	<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t256' /></span></p>
				  </c:when>
			   	  <c:otherwise>
			   	  	<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t185' /></span></p>
			   	  </c:otherwise>
			   	 </c:choose>	
			  	 	<%-- <p id="FBoard_sub1"><span id="1tab1" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t180' /></span></p> --%>
			  	 	<p id="FBoard_sub2"><span id="1tab2" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t153' /></span></p>
			   		<p id="FBoard_sub3"><span id="1tab3" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t154' /></span></p>
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