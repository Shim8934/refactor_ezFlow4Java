<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t89' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<!-- date picker -->
<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>

<style type="text/css">
.textInput {
	width : 100%;
}
</style>
<script>
var projectId = "${projectId}";
var projectName = null;
var writerId = "${writerId}";
var writerName = "${writerName}";
var writerDeptName = "${writerDeptName}";
var weight = null;
var projectStartDate = "${projectStartDate}";
var projectEndDate = "${projectEndDate}";
var planStartDate = "${planStartDate}";
var planEndDate = "${planEndDate}";
var managerList = [];
var overview = null;
var headManagerId = null;
var groupId = "";
var groupName = "";
var remainingWeight = "${remainingWeight}";
var weightInput = "${weightInput}";
// 소속 그룹의 뎁쓰
var treeDepth = 0;
var projectStatus = "${projectStatus}";

 $(function() {
	 $("#Sdatepicker").datepicker({
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

		$("#Edatepicker").datepicker({
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
		
		var SDate = new Date(planStartDate);
		var EDate = new Date(planEndDate);

		$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		$("#Sdatepicker").datepicker('setDate', SDate);
		
		$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		$("#Edatepicker").datepicker('setDate', EDate);
		
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
		  
		  setDefaultGroup();
		  document.getElementById("taskName").focus();
 
 });
 
function openMemberList() {
	var win;
		 
	if (groupId == "") {
		alert("<spring:message code='ezPMS.t85' />");
		return;
	}
	
	var feature = GetOpenPosition(760, 700);
	
	// 상위그룹으로 최상위 그룹인 프로젝트 자체를 선택했을 때는 groupId를 넘기지 않는다
	if (treeDepth == '0') {
		DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.95, 
				 "/ezPMS/goProjectMemberList.do?projectId=" + projectId + "&type=" + 'managers', "",
				 "height = 720px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
	} else {
		DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.95, 
				 "/ezPMS/goProjectMemberList.do?projectId=" + projectId + "&groupId=" + groupId + "&type=" + 'managers', "",
				 "height = 720px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
	}
	
}

function openGroupTree() {
	var win;
 	var feature = GetOpenPosition(760, 700);
 	DivPopUpShow($('body').prop('scrollWidth') * 0.4, $('body').prop('scrollHeight') * 0.8, "/ezPMS/goGroupTree.do?projectId=" + projectId, "",
		 	"height = 720px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}

function popupClose() {
	if(window.opener){
		window.close();
	} else {
		parent.DivPopUpHidden();
	}
}
 
function applyList() {
	var managerNameList = "";
 	var managerListCount = managerList.length;
 	
	for (var i = 0; i < managerListCount; i++) {
		managerNameList += managerList[i].userName;
		managerNameList += "(" + managerList[i].userDeptname + "), ";
	}
	 
	managerNameList = managerNameList.substr(0, managerNameList.length - 2);
	 
	$("#managers").html(managerNameList);
}
 
function setUpperGroup() {
	$("#upperGroup").html(MakeXMLString(groupName));
}

function addTask() {
	 taskName = $("#taskName").val().trim();
	 planStartDate = $("#Sdatepicker").val();
	 planEndDate = $("#Edatepicker").val();
	 weight = $("#weight").val();
	 overview = revertString($("#overview").val().trim());
	 
	 //업무 이름 길이 제한
	 if (taskName.length == 0) {
		 alert("<spring:message code='ezPMS.t90' />");
		 return;
	 } else if (taskName.length > 100) {
		 alert("<spring:message code='ezPMS.t91' />");
		 return;
	 }
	 
	 //날짜 제한
	 var startDateArr = planStartDate.split('-');
	 var endDateArr = planEndDate.split('-');
	 
	 var startDateComp = new Date(planStartDate);
	 var endDateComp = new Date(planEndDate);
	 
	 var today = new Date();
// 	 var todayComp = new Date(today.getFullYear(), today.getMonth()-1, today.getDay());
	 
	 var projectStartDateComp = new Date(projectStartDate);
	 var projectEndDateComp = new Date(projectEndDate);
	 
	 var changeDate = "";
	 
	//1. 시작일 > 종료일은 불가능
	 if (startDateComp.getTime() > endDateComp.getTime()) {
		  alert("<spring:message code='ezPMS.t49' />");
		  return;
	  }
	  
	//업무는 무조건 대기상태로 만들어지기 때문에 주석처리.
// 	//2. 종료일 < 현재일일 떄, 지연업무로 넘어갈 것이라는 confirm창 띄우기
// 	 if (endDateComp.getTime() < today.getTime()) {
// 		 var confCheck = confirm("<spring:message code='ezPMS.t93' />");
		 
// 		 if (confCheck != true) {
// 			 return;
// 		 }
// 	 }

	//3. 업무의 계획 시작일과 계획 종료일은 프로젝트 시작일과 종료일범위를 벗어날수 없음
	if (startDateComp.getTime() < projectStartDateComp.getTime()) {
		alert("<spring:message code='ezPMS.t94' />");
		return;
	}
	
	//프로젝트 상태가 완료인 경우 업무를 추가할 때 
	if (projectStatus == "C") {
		var result = confirm("<spring:message code='ezPMS.t320' />");
		
		if (result) {
			if (endDateComp.getTime() > projectEndDateComp.getTime()) {
				if (today.getTime() <= endDateComp.getTime()) {
					projectStatus = "P";
					changeDate = formatDate(endDateComp);
				} else {
					projectStatus = "L";
					changeDate = formatDate(endDateComp);
				}
			} else {
				if (today.getTime() <= projectEndDateComp.getTime()) {
					projectStatus = "P";
					changeDate = projectEndDate;
				} else {
					projectStatus = "L";
					changeDate = projectEndDate;
				}
			}
		} else {
			return;
		}
		
	} else {
		if (endDateComp.getTime() > projectEndDateComp.getTime()) {
			alert("<spring:message code='ezPMS.t95' />");
			return;
		}
	}
	
	// 담당자 검사
	if(managerList.length < 1) {
		// 1명 이상의 담당자가 등록되어야 함
		alert("<spring:message code='ezPMS.t169' />");
		return;
	}
	
	//상위그룹 미지정
	if(groupId == "") {
		alert("<spring:message code='ezPMS.t85' />");
		return;
	}
	
	// 가중치 검사
	if(weightInput == 1) {
		if(weight == ""){
			alert("<spring:message code='ezPMS.t96' />");
			return;
		}
		
		if(isNaN(weight)) {
			alert("<spring:message code='ezPMS.t248' />");
			return;
		}
		
		if(Number(weight) > remainingWeight) {
			alert("<spring:message code='ezPMS.t97' />");
			return;
		}
	} else {
		weight = 0;
	}
	
	var data = {
		taskName : taskName,
		projectId : projectId,
		groupId : groupId,
		planStartDate : planStartDate,
		planEndDate : planEndDate,
		overview	 : overview,
		headManagerId : headManagerId,
		managerList : managerList,
		weight : weight,
		writerId : writerId,
		// 소속 그룹의 뎁쓰보다 1커야함
		treeDepth : treeDepth + 1,
		projectStatus : projectStatus,
		projectPlanEndDate : projectEndDate,
		projectChangeDate : changeDate
	}
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/addTask.do",
		dataType : "json",
		contentType: "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(data) {
			alert("<spring:message code='ezPMS.t266' />");
			
			var upperGroupName = $("#upperGroup").text();
			var logContent = "<spring:message code='ezPMS.t315' arguments='" + upperGroupName + "," + taskName + "'/>";
			addTaskLog(projectId, 1, groupId, null, logContent);
			updateGroupRealStartEndDate(groupId);
			
			if (typeof(opener.setContentList) == "undefined") {
				opener.location.reload();
			} else {
				opener.getTaskTree();
				opener.setContentList();
			}
			
			$("#projectProgress", opener.parent.document).text(data.projectProgress.toFixed(1) + '%');

			popupClose();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("<spring:message code='ezPMS.t224' />");
		}
	});
}

//소속 그룹과 소속 그룹의 상위까지 실제 시작일 및 종료일을 업데이트 한다.
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

function formatDate(date) {
	var d = new Date(date);
	var month = '' + (d.getMonth() + 1);
	var day = '' + d.getDate();
	var year = d.getFullYear();
	
	if (month.length < 2) {
		month = '0' + month; 
	}
	
	if (day.length < 2) {
		day = '0' + day; 
	}
	
	return [year, month, day].join('-'); 
}

function setDefaultGroup(){
	var curTask = parent.opener.ge ? parent.opener.ge.currentTask : "";
	var curTreeGroup = parent.opener.$(".jstree-clicked");
	
	if(!curTask && !curTreeGroup.attr("id")){
		return;
	} else if (curTreeGroup.attr("id")){ //업무 목록에서 업무 추가 했을 경우
		groupId = parent.opener.groupDetail.groupId;
		groupName = parent.opener.groupDetail.groupName;
		treeDepth = parent.opener.groupDetail.treeDepth;
	} else { // 간트차트에서 업무 추가했을 경우
		if(curTask.id.indexOf("_t") != -1){ //업무를 선택했을 경우
			groupId = curTask.getParent().id.match(/g(\d+)/) ? curTask.getParent().id.match(/g(\d+)/)[1] : parent.opener.projectGroupId;
			groupName = replaceString(curTask.getParent().name);
			treeDepth = curTask.getParent().level;
		} else { // 그룹이나 프로젝트를 선택했을 경우
			groupId = curTask.id.match(/g(\d+)/) ? curTask.id.match(/g(\d+)/)[1] : parent.opener.projectGroupId;
			groupName = replaceString(curTask.name);
			treeDepth = curTask.level;
		}
	}
	
	setUpperGroup();
	
}

</script>
</head>
<body class="popup">
	<h1><spring:message code='ezPMS.t89' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="windowClose()"></span>
			</li>
		</ul>
		</div>
	</h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th><spring:message code='ezPMS.t98' /></th>
				<td colspan="3">
					<input type="text" id="taskName" class="textInput">
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t57' /></th>
				<td colspan="3"><c:out value='${writerName}(${writerDeptName})'/></td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t61' /></th>
				<td style="width:50%">
					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
				</td>
				<th><spring:message code='ezPMS.t62' /></th>
				<td>
					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openGroupTree()"><span><spring:message code='ezPMS.t42' /></span></a></th>
				<td colspan="3" style="height:70px;" id="upperGroup"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openMemberList()"><span><spring:message code='ezPMS.t63' /></span></a></th>
				<td class="nameList" colspan="3" style="height:70px"><div style="overflow-y:auto; max-height:100%; width:100%" id="managers"></div></td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t267' /></th>
				<c:choose>
      				<c:when test="${weightInput == 0}">
						<td colspan="3">
						<spring:message code='ezPMS.t267' /> <spring:message code='ezPMS.t59' />
						</td>
					</c:when>
      				<c:when test="${weightInput == 1}">
						<td style="width:50%">
						<input type="text" id="weight" value="0" style="width:40px;text-align:center"> % 
						</td>
						<th><spring:message code='ezPMS.t103' /></th>
						<td style="padding-left : 5px;"><fmt:formatNumber value="${remainingWeight }" pattern="0.0" /> %</td>
					</c:when>
   				</c:choose>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t104' /></th>
				<td colspan="3"><textarea id="overview" style="height:100px; width:98.5%; margin-top:2px; resize:none;"></textarea></td>
			</tr>
		</table>
		<table style="width:100%;">
			<tr>
				<td><div class="btnpositionNew"><a class="imgbtn" id="submit" onclick="addTask()"><span><spring:message code='ezPMS.t40' /></span></a></div></td>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>