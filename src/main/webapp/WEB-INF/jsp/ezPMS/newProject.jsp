<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>

<!-- date picker -->
<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>

<style type="text/css">
.textInput {
	width : 100%;
}
</style>
<script>
var projectName = "${project.projectName}";
var writerName = "${userName}";
var weightInput = "${project.weightInput}";
var planStartDate = "${project.planStartDate}";
var planEndDate = "${project.planEndDate}";
var managerList = null;
var participantList = null;
var viewerList = null;
var overview = "${project.overview}";
var endAlamStatus = "${project.alamMailStatus}";
var headManagerId = "${project.headManagerId}";
var mode = "${mode}"
var projectId = "${project.projectId}";
//비교하여 새로 추가된 사용자에게 메일 보냄
var beforeManagerList = [];
var beforeParticipantList = [];
var beforeViewerList = [];
var groupId = "${groupId}";

 $(function() {	
	getDatePicker();
	 
	$("#daysBeforeAlam").change(function() {
		var state = $("#daysBeforeAlam option:selected").val();
		if(state == "write") {
			$("#daysBeforeAlam").css("display", "none");
			$("#write").css("display", "");
		}
	});
	
	if (mode == "edit") {
		//사이즈 재정의
		$(".nameList").css("height", "58px");
		$("#overview").css("height", "60px");
		
		//참여 멤버 넣기
		var memberList = JSON.parse('${project.projectMember}');
		managerList = [];
		participantList = [];
		viewerList = [];		
		
		for (var i = 0; i < memberList.length; i++) {
			var member = memberList[i];
			
			if (member.memberRoleId == 1) {
				managerList.push(member);
				beforeManagerList.push(member);
			} else if (member.memberRoleId == 2) {
				participantList.push(member);
				beforeParticipantList.push(member);
			} else {
				viewerList.push(member);
				beforeViewerList.push(member);
			}
		}
		
		var calcType = "";
		if (weightInput == 0) {
			calcType = "autoCalc";
		} else {
			calcType = "writeCalc";
		}
		
		//newProject에 value넣어주기
		$("#projectName").val(projectName);
		$("input[name=weightInput][value="+calcType+"]").prop("checked", true);
		$("#Sdatepicker").val(planStartDate);
		$("#Edatepicker").val(planEndDate);
		$("#overview").val(overview);
		
		if (endAlamStatus == -1) {
			$("#endAlam").prop("checked", false);
		} else {
			$("#endAlam").prop("checked", true);
			
			if (endAlamStatus == 1 || endAlamStatus == 3 || endAlamStatus == 5 || endAlamStatus == 10) {
				$("#daysBeforeAlam").val(endAlamStatus).attr("seleced", "selected");
			} else {
				$("#daysBeforeAlam").css("display", "none");
				$("#write").css("display", "");
				$("#write").val(endAlamStatus);
			}
				
		}
		applyList();
	}
 
 });

 function getDatePicker() {
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
 		}
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
 		}
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
 }
 
 function openOrganTree(type) {
	 var url = "/ezPMS/pmsSelectAuth.do?type=" + type.id;
	 //	url += "?companyId=" + companyId;
	 GetOpenWindow(url, "pmsSelectAuth", 980, 610);
 }
 
 function addNewProject() {
	 projectName = $("#projectName").val().trim();
	 var calcType = $("input[name=weightInput]:checked").val();
	 planStartDate = $("#Sdatepicker").val();
	 planEndDate = $("#Edatepicker").val();
	 overview = convertString($("#overview").val().trim());
	 
	 //프로젝트 이름 길이 제한
	 if (projectName.length == 0) {
		 alert("프로젝트명을 입력해주세요.");
		 return;
	 } else if (projectName.length > 100) {
		 alert("프로젝트의 이름이 100자를 초과할 수 없습니다.");
		 return;
	 }
	 
	 if (headManagerId == null) {
		 alert("한 명의 총괄 담당자가 등록되어야 합니다.");
		 return;
	 }
	 
	 if ($("#endAlam").prop("checked") == false) {
		 endAlamStatus = -1;
	 } else {
		 if ($("#daysBeforeAlam option:selected").text() == "직접입력") {
			 endAlamStatus = $("#write").val();
			 
			 if (endAlamStatus.match(/[^0-9]/g) != null) {
				 alert("문자는 입력할 수 없습니다.");
				 return;
			 }
			 
		 } else {
			 endAlamStatus = $("#daysBeforeAlam option:selected").text(); 
		 }
	 }
	 
	 if (calcType == "writeCalc") {
		 weightInput = 1;
	 } else {
		 weightInput = 0;
	 }
	 
	 //날짜 제한
	 var startDateArr = planStartDate.split('-');
	 var endDateArr = planEndDate.split('-');
	 
	 var startDateComp = new Date(startDateArr[0], parseInt(startDateArr[1])-1, startDateArr[2]);
	 var endDateComp = new Date(endDateArr[0], parseInt(endDateArr[1])-1, endDateArr[2]);
	 
	 var today = new Date();
	 var todayComp = new Date(today.getFullYear(), today.getMonth()-1, today.getDay());
	 
	//1. 시작일 > 종료일은 불가능
	 if (startDateComp.getTime() > endDateComp.getTime()) {
		  alert("시작날짜가 종료날짜보다 늦을 수 없습니다.");
		  return;
	  }
	
	var data = {
			mode : mode,
			projectId : projectId,
			projectName : projectName,
			weightInput : weightInput,
			planStartDate : planStartDate,
			planEndDate : planEndDate,
			overview	 : overview,
			endAlamStatus : endAlamStatus,
			headManagerId : headManagerId,
			managerList : managerList,
			participantList : participantList,
			viewerList : viewerList,
			groupId : groupId
	}
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/addNewProject.do",
		dataType : "json",
		contentType: "application/json; charset=UTF-8",
		data :JSON.stringify(data),
		success : function(result) {
		 	try { 
				
				if (mode == "edit") {
					sendNotiMail(projectId, projectName);
					var logContent = "[" + projectName + "]의 정보가 수정되었습니다."
					addTaskLog(projectId, 2, groupId, null, logContent);
					alert ("프로젝트가 수정되었습니다.");
					parent.projectId = projectId;
					parent.window.location.reload();
				} else {
					sendNotiMail(result.projectId, projectName);
					var logContent = "[" + projectName + "](이)가 생성되었습니다."
					addTaskLog(result.projectId, 1, result.groupId, null, logContent);
					alert("새프로젝트가 추가되었습니다.");
					parent.setProjectList(); 
				}
				popupClose();
			
			} catch (e) {
				alert("error 발생");
				return;
			} 
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("error");
		}
	});
 }
 
 function applyList() {
	 var managerNameList = "";
	 var participantNameList = "";
	 var viewerNameList = "";
	 
	 for (var i = 0; i < managerList.length; i++) {
		if(headManagerId == managerList[i].userId) {
			managerNameList += "<b>"
			managerNameList += managerList[i].userName;
			managerNameList += "(" + managerList[i].userDeptname + ")</b>, ";
		} else {
			managerNameList += managerList[i].userName;
			managerNameList += "(" + managerList[i].userDeptname + "), ";
		}
		
	 }
	 
	 for (var i = 0; i < participantList.length; i++) {
		participantNameList += participantList[i].userName;
		participantNameList += "(" + participantList[i].userDeptname + "), ";
	}
	 
	 for (var i = 0; i < viewerList.length; i++) {
		viewerNameList += viewerList[i].userName;
		viewerNameList += "(" + viewerList[i].userDeptname + "), ";
	}
	 
	 managerNameList = managerNameList.substr(0, managerNameList.length - 2);
	 participantNameList = participantNameList.substr(0, participantNameList.length - 2);
	 viewerNameList = viewerNameList.substr(0, viewerNameList.length - 2);
	 
	 $("#managers").html(managerNameList);
	 $("#participants").html(participantNameList);
	 $("#viewers").html(viewerNameList);
 }
 
 function sendNotiMail(projectId, projectName) {
	 var data = {
			 projectName : projectName,
			 managerList : managerList,
			 participantList : participantList,
			 viewerList : viewerList,
			 projectId : projectId,
			 beforeManagerList : beforeManagerList,
			 beforeParticipantList : beforeParticipantList,
			 beforeViewerList : beforeViewerList,
			 mode : mode
		 }
	 
	 $.ajax({
		 type : "post",
		 ansync : false,
		 dataType : "json",
		 contentType: "application/json; charset=UTF-8",
		 data : JSON.stringify(data),
		 url : "/ezPMS/sendNotiMail.do",
		 success : function() {
			 console.log("sending mail works");
		 }
	 });
 }
</script>
</head>
<body class="popup">
	<h1>
		<c:choose>
			<c:when test="${mode eq 'new' }">
				새 프로젝트 추가
			</c:when>
			<c:otherwise>
				프로젝트 수정
			</c:otherwise>
		</c:choose>
	</h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th>프로젝트명</th>
				<td colspan="3">
					<input type="text" id="projectName" class="textInput">
				</td>
			</tr>
			<tr>
				<th>등록자</th>
				<td style="width:45%">${userName }</td>
				<th>가중치 설정</th>
				<td><form><input type="radio" name="weightInput" value="autoCalc" style="vertical-align:left" checked>자동 계산  <input type="radio" name="weightInput" value="writeCalc">직접입력</form></td>
			</tr>
			<tr>
				<th>시작일</th>
				<td style="width:45%"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
				<th>종료일</th>
				<td><input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree(managers)"><span>담당자</span></a></th>
				<td class="nameList" colspan="3" style="height:70px;"><div style="overflow-y:auto; height:100%; width:100%" id="managers"></div></td>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree(participants)"><span>참여자</span></a></th>
				<td class="nameList" colspan="3" style="height:70px;"><div style="overflow-y:auto; height:100%; width:100%" id="participants"></div></td>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree(viewers)"><span>조회자</span></a></th>
				<td class="nameList" colspan="3" style="height:70px;"><div style="overflow-y:auto; height:100%; width:100%" id="viewers"></div></td>
			<tr>
				<th>개요</th>
				<td colspan="3"><textarea id="overview" style="height:100px; width:98.5%; margin-top:2px; resize:none;"></textarea></td>
			</tr>
			<tr>
				<th>종료알림</th>
				<td style="width:45%"><input type="checkbox" name="endAlam" value="endAlam" id="endAlam" checked>프로젝트 작업 종료 알림메일 발송</td>
				<th>알림일</th>
				<td><select name="daysBeforeAlam" id="daysBeforeAlam">
						<option value="1" selected>1</option>
						<option value="3">3</option>
						<option value="5">5</option>
						<option value="10">10</option>
						<option value="write">직접입력</option>
					</select><input type="text" id="write" style="display:none; width:80px;"> 일 전
				</td>
			</tr>
		</table>
		<table style="margin-top : 10px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="addNewProject()"><span>등록</span></a></td>
				<td></td>
				<td><a class="imgbtn" id="cancel" onclick="popupClose()"><span>취소</span></a></td>
			</tr>
		</table>
	</div>
</body>
</html>