<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t55' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
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
var projectName = "<c:out value='${project.projectName}'/>";
var writerName = "${userName}";
var writerDeptname = "${userDeptname}";
var weightInput = "${project.weightInput}";
var planStartDate = "${project.planStartDate}";
var planEndDate = "${project.planEndDate}";
var managerList = [];
var participantList = [];
var viewerList = [];
var projectOverview = "<c:out value='${project.overview}'/>";
var endAlamStatus = "${project.alamMailStatus}";
var headManagerId = "${project.headManagerId}";
var headManagerName = "${project.headManagerName}";
var headManagerDept = "${project.headManagerDeptname}";
var mode = "${mode}"
var projectId = "${project.projectId}";
//비교하여 새로 추가된 사용자에게 메일 보냄
var beforeHeadManagerId = "${project.headManagerId}";
var beforeManagerList = [];
var beforeParticipantList = [];
var beforeViewerList = [];
var groupId = "${groupId}";
var mailRepeat = "${project.mailRepeat}";
var headManagerObj = {};

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
		var memberListCount = memberList.length;
		managerList = [];
		participantList = [];
		viewerList = [];		
		
		for (var i = 0; i < memberListCount; i++) {
			var member = memberList[i];
			
			if (member.memberRoleId == 1) {
				// managerList에 관리자를 제외하고 집어넣는다
				if(member.userId != headManagerId) {
					managerList.push(member);
					beforeManagerList.push(member);
				}
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
		$("#projectName").val(replaceString(projectName));
		$("input[name=weightInput][value=" + calcType + "]").prop("checked", true);
		$("#mailRepeat").val(mailRepeat).attr("seleced", "selected");
		$("#Sdatepicker").val(planStartDate);
		$("#Edatepicker").val(planEndDate);
		$("#overview").val(replaceTextAreaString(replaceTextAreaString(projectOverview)));
		
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
	} else {
		headManagerObj.userId = parent.opener.userId;
		headManagerObj.userName = writerName;
   		headManagerObj.userDept = writerDeptname;
   		headManagerId = parent.opener.userId;
   		headManagerDept = writerDeptname;
   		headManagerName = writerName;
	}
	
	applyHeadManager();
	document.getElementById("projectName").focus();
 
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
 }
 
 function openOrganTree(type) {
	 var url = "/ezPMS/pmsSelectAuth.do?type=" + type.id;
	 //	url += "?companyId=" + companyId;
	 var width = type.id === "headManager" ? 700 : 980;
	 GetOpenWindow(url, "pmsSelectAuth", width, 650);
 }
 
 function addNewProject() {
	 projectName = $("#projectName").val().trim();
	 var calcType = $("input[name=weightInput]:checked").val();
	 planStartDate = $("#Sdatepicker").val();
	 planEndDate = $("#Edatepicker").val();
	 overview = revertString($("#overview").val().trim());
	 mailRepeat = $("#mailRepeat option:selected").val();
	 
	 //parent.userRole은 프로젝트 수정 때 사용.
	 if (mode == "edit" && parent.userRole != 1) {
		alert("<spring:message code='ezPMS.t9'/>");
		return;
	 }
	 
	 //프로젝트 이름 길이 제한
	 if (projectName.length == 0) {
		 alert("<spring:message code='ezPMS.t45' />");
		 return;
	 } else if (projectName.length > 100) {
		 alert("<spring:message code='ezPMS.t46' />");
		 return;
	 }
	 
	 if (headManagerId == null || headManagerId == "") {
		 alert("<spring:message code='ezPMS.t47' />");
		 return;
	 }
	 
	 if ($("#endAlam").prop("checked") == false) {
		 endAlamStatus = -1;
	 } else {
		 if ($("#daysBeforeAlam option:selected").text() == "<spring:message code='ezPMS.t60' />") {
			 endAlamStatus = $("#write").val();
			 
			 if (endAlamStatus.match(/[^0-9]/g) != null) {
				 alert("<spring:message code='ezPMS.t48' />");
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
	 
	//시작일 > 종료일은 불가능
	 if (startDateComp.getTime() > endDateComp.getTime()) {
		  alert("<spring:message code='ezPMS.t49' />");
		  return;
	  }
	
	//알람 메일 일자 지정 시 프로젝트 시작일 보다 긴 일자를 넣을 수 없음
	var betweenDate = (endDateComp.getTime() - startDateComp.getTime()) / 1000 / 60 / 60 / 24;
	
	if (endAlamStatus > betweenDate) {
		alert("<spring:message code='ezPMS.t325' />");
		return;
	}
	
	managerList.push({"userName" : headManagerName, "userId" : headManagerId, "memberRoleId" : 1, "userDeptname" : replaceString(headManagerDept), "userIdType" : "user"});
	
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
			groupId : groupId,
			mailRepeat : mailRepeat
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
					if (result.roleCheck == "permitted") {
						sendNotiMail(projectId, projectName);
						var logContent = "<spring:message code='ezPMS.t50' arguments='" + projectName + "'/>";
						addTaskLog(projectId, 2, groupId, null, logContent);
						alert ("<spring:message code='ezPMS.t52' />");
						parent.projectId = projectId;
						parent.parent.window.location.reload();
						popupClose();
					} else if (result.roleCheck == "rejected") {
						alert("<spring:message code='ezPMS.t365' />");
						popupClose();
					}
				} else {
					sendNotiMail(result.projectId, projectName);
					var logContent = "<spring:message code='ezPMS.t51' arguments='" + projectName + "'/>";
					addTaskLog(result.projectId, 1, result.groupId, null, logContent);
					alert("<spring:message code='ezPMS.t53' />");
					parent.opener.setProjectList(); 
					windowClose();
				}
				
			
			} catch (e) {
				alert("<spring:message code='ezPMS.t224' />");
				return;
			} 
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("<spring:message code='ezPMS.t224' />");
		}
	});
 }
 
 function popupClose() {
	 if (mode == "edit") {
			$("#blockLeft", parent.parent.parent.frames["left"].document).remove();
			$("#blockTop", parent.parent.parent.frames["right"].document).remove();
 		}
		parent.DivPopUpHidden();
 }
 function applyList() {
	 var managerNameList = "";
	 var participantNameList = "";
	 var viewerNameList = "";
	 
	 // 조직도에서는 stringify해서 넘어옴
	 if(typeof managerList != 'object' && typeof participantList != 'object' && typeof viewerList != 'object') {
		 managerList = JSON.parse(managerList);
		 participantList = JSON.parse(participantList);
		 viewerList = JSON.parse(viewerList);
	 }
	 
	 var manangerListCount = managerList.length;
	 var participantListCount = participantList.length;
	 var viewerListCount = viewerList.length;
	 
	 for (var i = 0; i < manangerListCount; i++) {
		if(managerList[i].userId !== headManagerId){
			managerNameList += managerList[i].userName;
			managerNameList += "(" + managerList[i].userDeptname + "), ";
		}
	 }
	 
	 for (var i = 0; i < participantListCount; i++) {
		participantNameList += participantList[i].userName;
		participantNameList += "(" + participantList[i].userDeptname + "), ";
	}
	 
	 for (var i = 0; i < viewerListCount; i++) {
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
 
 function applyHeadManager(){
	 var headManagerStr = headManagerObj.userName + "(" + headManagerObj.userDept + ")";
	 
	 if(!headManagerObj.userName){
		 headManagerStr = headManagerName + "(" + headManagerDept + ")";
	 }
	 
	 $("#headManager").html(headManagerStr);
 }
 
 function sendNotiMail(projectId, projectName) {
	 var data = {
			 headManagerId : headManagerId,
			 projectName : projectName,
			 managerList : managerList,
			 participantList : participantList,
			 viewerList : viewerList,
			 projectId : projectId,
			 beforeHeadManagerId : beforeHeadManagerId,
			 beforeManagerList : beforeManagerList,
			 beforeParticipantList : beforeParticipantList,
			 beforeViewerList : beforeViewerList,
			 mode : mode
		 }
	 
	 $.ajax({
		 type : "POST",
//		 ansync : false,
		 url : "/ezPMS/sendNotiMail.do",
		 contentType: "application/json; charset=UTF-8",
		 data : JSON.stringify(data),
		 success : function() {}
	 });
 }
 
 function close_Click(){
	 if(mode === "new"){
		 windowClose();
	 } else {
		 popupClose();
	 }
 }
</script>
</head>
<body class="popup">
	<h1>
		<c:choose>
			<c:when test="${mode eq 'new' }">
				<spring:message code='ezPMS.t55' />
			</c:when>
			<c:otherwise>
				<spring:message code='ezPMS.t56' />
			</c:otherwise>
		</c:choose>
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="close_Click()"></span>
			</li>
		</ul>
		</div>
	</h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th><spring:message code='ezPMS.t31' /></th>
				<td colspan="3">
					<input type="text" id="projectName" class="textInput" maxlength=100>
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t57' /></th>
				<td style="width:45%">${userName }</td>
				<th><spring:message code='ezPMS.t58' /></th>
				<td><form><input type="radio" name="weightInput" value="autoCalc" style="vertical-align:left; margin-top: 0px;" checked><spring:message code='ezPMS.t59' />  <input type="radio" name="weightInput" value="writeCalc" style="margin-top: 0px;"><spring:message code='ezPMS.t60' /></form></td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t61' /></th>
				<td style="width:45%"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
				<th><spring:message code='ezPMS.t62' /></th>
				<td><input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree(headManager)"><span><spring:message code='ezPMS.t330' /></span></a></th>
				<td class="nameList" colspan="3" style="height:70px;"><div style="overflow-y:auto; max-height:100%; width:100%" id="headManager"></div></td>
			<tr>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree(managers)"><span><spring:message code='ezPMS.t63' /></span></a></th>
				<td class="nameList" colspan="3" style="height:70px;"><div style="overflow-y:auto; max-height:100%; width:100%" id="managers"></div></td>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree(participants)"><span><spring:message code='ezPMS.t64' /></span></a></th>
				<td class="nameList" colspan="3" style="height:70px;"><div style="overflow-y:auto; max-height:100%; width:100%" id="participants"></div></td>
			<tr>
				<th><a class="imgbtn" onclick="openOrganTree(viewers)"><span><spring:message code='ezPMS.t65' /></span></a></th>
				<td class="nameList" colspan="3" style="height:70px;"><div style="overflow-y:auto; max-height:100%; width:100%" id="viewers"></div></td>
			<tr>
				<th><spring:message code='ezPMS.t66' /></th>
				<td colspan="3"><textarea id="overview" style="height:100px; width:98.5%; margin-top:2px; resize:none;"></textarea></td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t67' /></th>
				<td style="width:45%"><input type="checkbox" name="endAlam" value="endAlam" id="endAlam" checked><spring:message code='ezPMS.t68' /></td>
				<th><spring:message code='ezPMS.t69' /></th>
				<td><select name="daysBeforeAlam" id="daysBeforeAlam">
						<option value="1" selected>1</option>
						<option value="3">3</option>
						<option value="5">5</option>
						<option value="10">10</option>
						<option value="write"><spring:message code='ezPMS.t60' /></option>
					</select><input type="text" id="write" style="display:none; width:80px;"> <spring:message code='ezPMS.t70' />
					<select name="mailRepeat" id="mailRepeat" style="margin-left:10px;">
						<option value="0"><spring:message code='ezPMS.t331' /></option>
						<option value="1"><spring:message code='ezPMS.t332' /></option>
					</select>
				</td>
			</tr>
		</table>
		<table style="width:100%;">
			<tr>
				<td><div class="btnpositionNew"><a class="imgbtn" id="submit" onclick="addNewProject()"><span><spring:message code='ezPMS.t40' /></span></a></div></td>
			</tr>
		</table>
	</div>
</body>
</html>