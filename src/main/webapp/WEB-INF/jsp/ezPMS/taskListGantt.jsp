<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPMS.t151' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE"/>
		
		<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezPMS/gantt/platform.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/ezPMS/gantt/libs/jquery/dateField/jquery.dateField.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezPMS/gantt/gantt.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezPMS/gantt/ganttPrint.css')}" type="text/css" media="print"/>
		<!-- default.css는 우선 순위때문에 css 중에서 가장 아래줄에 있어야 함. -->
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>

		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/jquery/jquery.livequery.1.1.1.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/jquery/jquery.timers.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/utilities.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/dialogs.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/forms.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/layout.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/date.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/i18nJs.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/jquery/dateField/jquery.dateField.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/jquery/JST/jquery.JST.js')}"></script>
  		
  		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/jquery/svg/jquery.svg.min.js')}"></script>
  		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/libs/jquery/svg/jquery.svgdom.1.8.js')}"></script>

		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/ganttUtilities.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/ganttTask.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/ganttDrawerSVG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/ganttZoom.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/ganttGridEditor.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/gantt/ganttMaster.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
		
		
	   	<script type="text/javascript">
	   		// 프로젝트 아이디
	   		var projectId = "<c:out value='${projectId}'/>";
	   			// 업무 목록
	   		var	taskList = ${taskList};
	   			// 프로젝트 세부정보
	   		var projectDetails = ${projectDetail};
	   			// 사용자 아이디
	   	 	var userId = "";
	   		var ganttData = {};
	   		var groupList = ${groupList};
	   		var ge = "";
	   		var projectStatus = "<c:out value='${projectDetail.status}'/>";
	   		var projectGroupId = "<c:out value='${projectDetail.groupId}'/>";
	   		var selectedPreTask = -1;
	   		var preTaskIndex = -1;
	   		var userRoleId = "${userRoleId}";
	   		var msgStr01 = "<spring:message code='ezEmail.t269' />";
	   		var holidayList = JSON.parse('${holidayList}');
	   		
			function setAllGanttItems(status) {
	   			
	   			var data = {
	   				projectId : projectId,
	   				status : status
	   			}
	   			
	   			$.ajax({
	   				type : "POST",
	   				contentType: "application/json; charset=UTF-8",
	   				dataType : "json",
	   				async : false,
	   				data : JSON.stringify(data),
	   				url : "/ezPMS/getAllGanttItems.do",
	   				success : function(result) {
	   					// console.log(JSON.stringify(result));
	   					groupList = result.groupList;
	   					taskList  = result.taskList;
	   					projectDetails = result.projectDetails;
	   					userRoleId = result.userRoleId;
	   					initValues();
	   					ge.loadTasks(ganttData.tasks);
	   					ge.redraw();
	   				}	
	   			});
	   		}
			
	   		function initValues() {	   			
	   			var tl = taskList;
	   			var pd = projectDetails;
	   			var roleName = ["<spring:message code='ezPMS.t63' />", "<spring:message code='ezPMS.t64' />", "<spring:message code='ezPMS.t65' />", "<spring:message code='ezPMS.t195' />"];
	   			var ganttStatus = {
	   					"P": "STATUS_ACTIVE",
	   					"S": "STATUS_SUSPENDED", 
	   					"C": "STATUS_DONE",
	   					"L": "STATUS_FAILED",
	   					"W": "STATUS_WAITING",
	   					"D": "STATUS_UNDEFINED",
	   					"G": "GROUP_STATUS"
	   			}
	   			
	   			//간트 데이터 세팅부분.
	   			matchProjectData(ganttData, pd);
	   			/*-------------------------간트 데이터 세팅 완료 ----------------------*/
	   			
	   			//프로젝트 인력 가공
	   			
	   			
	   			ganttData.canWrite = true;
	   			ganttData.canWriteOnParent = true;
	   			ganttData.selectedRow = 0;
	   			ganttData.deletedTaskIds = [];
	   			//간트 줌 설정 3d, 1w, 1M, 1Q, 2Q, 1y, 2y
	   			ganttData.zoom = "1M";
// 	   			ganttData.canAdd = true;
	   			preProcess();
	   			/*-------------------------기타 세팅 -----------------------*/
	   			
	   			//프로젝트 데이터를 간트 데이터에 입력.
	   			function matchProjectData(ganttData, pd){
	   				ganttData.tasks = [];
	   				ganttData.resources = [];
	   				ganttData.roles = [];
	   				/* if (!ganttData.tasks) {
		   				ganttData.tasks = [];
		   			}
	   				
	   				if (!ganttData.resources) {
		   				ganttData.resources = [];
		   			}
	   				
	   				if (!ganttData.roles) {
		   				ganttData.roles = [];
		   			} */
	   				
	   				var tempTask = {};
	   				tempTask.id = "p" + pd.projectId;
		   			tempTask.name = revertString(pd.projectName);
// 		   			tempTask.name = ReplaceText(pd.projectName, "\"", "&quot;");
		   			tempTask.code = "";
		   			tempTask.level = 0;
		   			tempTask.status = ganttStatus[pd.status];
		   			tempTask.statusPMS = pd.status;
		   			tempTask.start = new Date(pd.planStartDate).getTime();
		   			tempTask.end = new Date(pd.planEndDate).getTime();
		   			tempTask.duration = pd.workingday;
		   			tempTask.weight = Number(pd.weight).toFixed(1);
		   			tempTask.startIsMilestone = true;
		   			tempTask.endIsMilestone = true;
		   			tempTask.headManager = pd.headManagerId;
		   			tempTask.assigs = [];
		   			
		   			var projectMemberCount = pd.projectMember.length;
		   			
		   			for (var i = 0; i < projectMemberCount; i++) {
		   				var assig = {}, resource = {}, role = {};
			   			var projectMember = pd.projectMember[i];
			   			
		   				assig.resourceId = projectMember.userId;
		   				assig.id = projectMember.userId;
		   				assig.roleId = projectMember.memberRoleId;
		   				assig.name = projectMember.userName;
		   				assig.effort = "";
		   				
		   				tempTask.assigs.push(assig);
		   				
		   				//인력, 역할 부분
		   				resource.id = projectMember.userId;
		   				role.id = projectMember.userId;
		   				resource.name = projectMember.userName;
		   				role.name = roleName[projectMember.memberRoleId];
		   				
		   				ganttData.resources.push(resource);
		   				ganttData.roles.push(role);
		   			}
		   			
		   			tempTask.depends = "";
		   			tempTask.description = pd.overview.replace(/\"/g,"&quot;");
		   			tempTask.progress = Number(pd.progress).toFixed(1);
		   			tempTask.realProgress = Number(pd.progress).toFixed(1);
// 		   			tempTask.planProgress = Number(pd.planProgress).toFixed(1);
		   			tempTask.hasChild = "";
		   			tempTask.type = "p";
		   			
		   			ganttData.tasks.push(tempTask);
		   			
		   			//프로젝트 직속 업무 추가.
	   				var subTl = {};
	   				subTl = taskList.filter(function(task){
					    return task.groupId == pd.groupId;
					});
	   				
	   				if(subTl.length > 0){
	   					matchTaskData(ganttData ,subTl, "", "");
	   				}
	   				
		   			//그룹 리스트 가공부분.
		   			var gl = {};
	   				gl = groupList.filter(function(group){
					    return group.upperGroupId == pd.groupId;
					});
	   				
	   				matchGroupData(ganttData, gl);
	   				
	   				
	   				
	   				//프로젝트의 목표진행률은 계산으로 구해서 넣어준다.
	   				ganttData.tasks[0].planProgress = getPrjPlanProgress(ganttData);
	   				
	   				//그룹의 목표진행률은 계산으로 구해서 넣어준다.
	   				var ganttDataTasksCount = ganttData.tasks.length;
	   				
   					for(var i = 1; i < ganttDataTasksCount; i++) {
   						var ganttDataTask = ganttData.tasks[i];
	   					// 그룹인 경우
	   					if(ganttDataTask.id.indexOf('g') != -1 && ganttDataTask.id.indexOf('t') == -1) {
	   						var tmpLevel = ganttDataTask.level;
	   						var weightSum = 0;
	   						var progressSum = 0;
	   						
	   						for(var j = i + 1; j < ganttDataTasksCount; j++) {
	   							var ganttDataSubTask = ganttData.tasks[j];
	   							
	   							if(ganttDataSubTask.level > tmpLevel) {
	   								
	   								// 업무일 때만
	   								if(ganttData.tasks[j].id.indexOf('t') != -1) {
	   									progressSum += ganttDataSubTask.planProgress * ganttDataSubTask.weight;
	   									weightSum   += Number(ganttDataSubTask.weight);	
	   								}
	   							} else {
	   								break;
	   							}	
	   						}
	   						
	   						// console.log(progressSum);
							// console.log(weightSum);
							
	   						if(weightSum != 0) {
	   							ganttData.tasks[i].planProgress = Number(progressSum / weightSum).toFixed(1);
	   						} else {
	   							ganttData.tasks[i].planProgress = Number(0).toFixed(1);
	   						}
	   					}
	   				}
	   				
	   				ganttData = setDepends(ganttData);   				
		   		}
	   			
	   			function matchGroupData(ganttData, gl) {
	   				var glCount = gl.length;
	   				
		   			for (var i = 0; i < glCount; i++) {
		   				var tempTask = {};
		   				var glData = gl[i];
		   				var groupId = glData.groupId;
		   				var groupDepth = glData.treeDepth;
		   				
			   			tempTask.id = "p" + pd.projectId + "_g" + groupId;
			   			tempTask.name = revertString(glData.groupName);
			   			tempTask.code = glData.ancesterGroup;
			   			tempTask.level = groupDepth;
			   			tempTask.status = ganttStatus["G"];
			   			tempTask.statusPMS = glData.status;
			   			tempTask.start = new Date(glData.planStartDate).getTime();
			   			tempTask.end = new Date(glData.planEndDate).getTime();
			   			tempTask.duration = glData.workingday;
	 		   			tempTask.weight = Number(glData.weight).toFixed(1);
			   			tempTask.startIsMilestone = "";
			   			tempTask.endIsMilestone = "";
			   			tempTask.headManager = glData.headManagerId;
			   			tempTask.assigs = [];
			   			
			   			var glDataMemberCount = glData.groupMember.length;
			   			
			   			for (var j = 0; j < glDataMemberCount; j++) {
			   				var assig = {}, resource = {}, role = {};
				   			var glGroupMember = gl[i].groupMember[j];
				   			
			   				assig.resourceId = glGroupMember.userId;
			   				assig.id = glGroupMember.userId;
			   				assig.roleId = 1;
			   				assig.effort = "";
			   				
			   				tempTask.assigs.push(assig);
			   				
			   				//인력, 역할 부분
			   			 	resource.id = glGroupMember.userId;
			   				role.id = glGroupMember.userId;
			   				resource.name = glGroupMember.userName;
			   				role.name = 1;
			   				
			   				ganttData.resources.push(resource);
			   				ganttData.roles.push(role);
			   			}
			   			
			   			tempTask.depends = "";
			   			tempTask.pretask = glData.pretask != null ? "t" + glData.pretask : null || glData.pregroup != null ? "g" + glData.pregroup : null;
			   			tempTask.description = glData.overview.replace(/\"/g,"&quot;");
			   			tempTask.progress = Number(glData.realProgress).toFixed(1);
			   			tempTask.realProgress = Number(glData.realProgress).toFixed(1);
			   			// tempTask.planProgress = Number(glData.planProgress).toFixed(1);
			   			tempTask.hasChild = "";
			   			tempTask.type = "g";
		   				ganttData.tasks.push(tempTask);
		   				
		   				//그룹 업무 추가.
		   				var subTl = {};
		   				subTl = taskList.filter(function(task) {
						    return task.groupId == groupId;
						});
		   				
		   				if (subTl.length > 0) {
		   					matchTaskData(ganttData ,subTl, groupId, groupDepth);
		   				}
		   				
		   				//하위 그룹 추가. 
		   				if (groupDepth === 1) {
			   				var subGl = {};
			   				subGl = groupList.filter(function(group) {
							    return group.upperGroupId == groupId;
							});
			   				
			   				if (subGl.length > 0) {
			   					matchGroupData(ganttData ,subGl);
			   				}
		   				}
		   			}
		   		}
	   			
	   			function matchTaskData(ganttData, tl, groupId, groupDepth) {
	   				var tlCount = tl.length;
	   				
		   			for (var i = 0; i < tlCount; i++) {
		   				var tempTask = {};
		   				var tlData = tl[i];
		   				
		   				if (groupId !== "") {
				   			tempTask.id = "p" + projectId + "_g" + groupId + "_t" + tl[i].taskId;
				   			tempTask.level = groupDepth + 1;
				   			tempTask.groupId = groupId;
		   				} else {
				   			tempTask.id = "p" + projectId + "_t" + tl[i].taskId;
				   			tempTask.level = 1;
		   				}
		   				
			   			tempTask.name = revertString(tlData.taskName);
			   			tempTask.code = tlData.groupId;
			   			tempTask.status = ganttStatus[tlData.status];
			   			tempTask.statusPMS = tlData.status;
			   			tempTask.start = new Date(tlData.planStartDate).getTime();
			   			tempTask.end = new Date(tlData.planEndDate).getTime();
			   			tempTask.duration = tlData.realWorkingday;
			   			tempTask.weight = Number(tlData.weight).toFixed(1);
			   			tempTask.startIsMilestone = "";
			   			tempTask.endIsMilestone = "";
			   			tempTask.headManager = tlData.headManagerId;
			   			tempTask.assigs = [];
			   			
			   			var tlTaskMemberCount = tlData.taskMember.length;
			   			
			   			for (var j = 0; j < tlTaskMemberCount; j++) {
			   				var assig = {}, resource = {}, role = {};
				   			var tlTaskMember = tlData.taskMember[j];
				   			
			   				assig.resourceId = tlTaskMember.userId;
			   				assig.id = tlTaskMember.userId;
			   				assig.roleId = 1;
			   				assig.effort = "";
			   				assig.name = tlTaskMember.userName;
			   				
			   				tempTask.assigs.push(assig);
			   				
			   				//인력, 역할 부분
			   			 	resource.id = tlTaskMember.userId;
			   				role.id = tlTaskMember.userId;
			   				resource.name = tlTaskMember.userName;
			   				role.name = 1;
			   				
			   				ganttData.resources.push(resource);
			   				ganttData.roles.push(role);
			   			}
			   			
			   			tempTask.depends = "";
			   			tempTask.pretask = tlData.pretask != null ? "t" + tlData.pretask : null || tlData.pregroup != null ? "g" + tlData.pregroup : null ;
			   			tempTask.description = tlData.overview.replace(/\"/g,"&quot;");
			   			tempTask.progress = Number(tlData.realProgress).toFixed(1);
			   			tempTask.realProgress = Number(tlData.realProgress).toFixed(1);
			   			tempTask.planProgress = Number(tlData.planProgress).toFixed(1);
			   			tempTask.hasChild = "";
			   			tempTask.type = "t";
			   			
			   			ganttData.tasks.push(tempTask);
		   			}
		   		}
	   		}
	   		
	   		//테이블 헤더 넓이를 내용에 맞춤
	   		function headerWidthFitting() {
	   			var header = $(".ganttFixHead .gdfColHeader");
	   			header.each(function() { 
	   				$(this).dblclick();
	   			})
	   		}
	   		
	   		//기본 옵션 세팅
	   		function setDefOption(ganttMasterObj) {
	   			localStorage.TWPGanttGridState = '{"colSizes":[35,25,240,100,22,80,22,80,50,50,60,60,50,1000,35,25,240,100,22,80,22,80,50,50,60,60,50,1000]}';
	   		}
	   		
	   		function addTask() {
	   			goAddTask();
	   		}
	   		
	   		function addGroup() {
	   			goAddGroup();
	   		}
	   		
	   		//업무 추가
	   		function goAddTask() {
   				var feature = GetOpenPosition(845, 502);
   				window.open("/ezPMS/goAddTask.do?projectId=" + projectId, "", "width=845, height=502, resizable=no, scrollbars=no, status=no" + feature);
   			 
//    				DivPopUpShow(845, 485, "/ezPMS/goAddTask.do?projectId=" + projectId);
	   		}
	   		
	   		//업무 삭제
	   		function delTask(){
	   			var selectType = ge.currentTask.type;
	   			var url = "";
	   			var groupId = ge.currentTask.groupId;
	   			var groupName = "";
	   			var taskName = ge.currentTask.name;
	   			var taskId = "";
	   			var data = {};
	   			
	   			if (selectType !== "t") {
		   			alert("<spring:message code='ezPMS.t247' />");
		   			return;
	   			} else {
	   				if(!confirm("<spring:message code='ezPMS.t305' />")){
	   					return;
	   				}
	   				
	   				taskId = ge.currentTask.id.match(/t(\d+)/)[1];
	   			}
	   			
	   			// 프로젝트 직속 업무의 경우 groupId가 undefined
	   			if (groupId) {
	   				groupName = $("[id$='g" + groupId + "']").find("input[name='name']").val();
		   			
	   			} else {
	   				groupName = projectDetails.projectName;
	   				groupId = projectDetails.groupId;
	   			}
	   			
	   			
   				url = "/ezPMS/deleteTask.do?projectId=" + projectId + "&taskId=" + taskId;
	   			
	   			data = {
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
							var logContent = "<spring:message code='ezPMS.t313' arguments='" + replaceString(groupName) + "," + replaceString(taskName) + "'/>";
		   					addTaskLog(projectId, 3, groupId, null, logContent);
		   					updateGroupRealStartEndDate(groupId);
		   					$("#projectProgress", parent.document).text(result.projectProgress.toFixed(1) + '%');
						} else {
							alert("<spring:message code='ezPMS.t184' />");
							return;
						}
	   					
	   					location.reload();
	   				},
	   				error : function(jqXHR, textStatus, errorThrown) {
	   					alert("<spring:message code='ezPMS.t213' />");
	   					location.reload();
	   				},
	   			});
	   		}
	   		
	   		//그룹 추가
	   		function goAddGroup() {
				var feature = GetOpenPosition(700, 600);
   				window.open("/ezPMS/goAddGroup.do?projectId=" + projectId, "", "width=700, height=600, resizable=no, scrollbars=no, status=no" + feature);
   			 
//    				DivPopUpShow(700, 447, "/ezPMS/goAddGroup.do?projectId=" + projectId);
	   		}
	   		
	   		//그룹 삭제
	   		function delGroup() {
	   			var selectType = ge.currentTask.type;
	   			var url = "";
	   			var groupId = "";
	   			var groupName = ge.currentTask.name;
	   			var codeStr = ge.currentTask.code + "";
	   			var upperGroupIds = codeStr.split(',');
	   			// 바로 위 groupId
	   			var upperGroupId = upperGroupIds[upperGroupIds.length - 2];
	   			var upperGroupName = $("[id$='g" + upperGroupId + "']").find("input[name='name']").val();
	   			var data = {};
	   			var children = ge.currentTask.getChildren();
	   			var childTask = [];
	   			
	   			if (!upperGroupName) {
	   				upperGroupName = projectDetails.projectName;
	   			}
	   			
	   			if(selectType === "t"){
		   			alert("<spring:message code='ezPMS.t281' />");
		   			return;
	   			} else if (selectType === "p") {
	   				alert("<spring:message code='ezPMS.t307' />");
		   			return;
	   			} else {
	   				if(!confirm("<spring:message code='ezPMS.t306' />")){
	   					return;
	   				}
	   				
	   				groupId = ge.currentTask.id.match(/g(\d+)/)[1];
	   			}
	   			
	   			if (children) {
		   			childTask = children.filter(function(child){
		   				return child.id.indexOf("t") != -1;
		   			})
	   			}
	   			
	   			if (childTask && childTask.length > 0) {
	   				alert("<spring:message code='ezPMS.t243' />");
	   				return;
	   			}
	   			
	   			
	   			
	   			var data = {
	   					projectId : projectId,
	   					groupId : groupId
	   			}
	   			
	   			$.ajax({
	   				type : "POST",
	   				url : "/ezPMS/deleteGroup.do",
	   				dataType : "text",
	   				contentType: "application/json; charset=UTF-8",
	   				data : JSON.stringify(data),
	   				success : function(data) {
						alert("<spring:message code='ezPMS.t196' />");
						var logContent = "<spring:message code='ezPMS.t283' arguments='" + replaceString(upperGroupName) + "," + replaceString(groupName) + "'/>";
	   					addTaskLog(projectId, 3, upperGroupId, null, logContent);
	   					
	   					location.reload();
	   				},
	   				error : function(jqXHR, textStatus, errorThrown) {
	   					alert("<spring:message code='ezPMS.t213' />");
	   					location.reload();
	   				},
	   			});
	   		}
	   		
	   		function taskDetails() {
	   			var curTask = {};
	   			var taskId = 0;
	   			curTask = ge.currentTask;
	   			
	   			var feature = GetOpenPosition(835, 810);
	   			
	   			if (curTask.id.indexOf("_t") != -1) {
	   				taskId = curTask.id.match(/t(\d+)/)[1];
	   				window.open("/ezPMS/getTaskDetails.do?projectId=" + projectId + "&taskId=" + taskId + "&userIdType=user",
							"", "width=835, height=810, resizable=no, scrollbars=no, status=no" + feature);
	   			} else if (ge.currentTask.id && ge.currentTask.id.indexOf("_g") !== -1) {
		   			ge.editor.openFullEditor(curTask);
		   			return;
	   			} else if (curTask.id.indexOf("_g") != -1) {
	   				taskId = curTask.id.match(/g(\d+)/)[1];
	   				window.open("/ezPMS/getGroupDetails.do?projectId=" + projectId + "&groupId=" + taskId,
							"", "width=835, height=810, resizable=no, scrollbars=no, status=no" + feature);
	   			}
	   			
 	   			/* makeLayerPopup();
	   			var top = ($(window).height() - $(this).outerHeight()) / 2;
   			    var left = ($(window).width() - $(this).outerWidth()) / 2;
   				var feature = GetOpenPosition(top, left);
   			 
   				DivPopUpShow(845, 600, "/ezPMS/getTaskDetails.do?projectId=" + projectId + "&taskId=" + taskId + "&userIdType=user"); */	
	   		}
	   		
	   		function makeLayerPopup() {
	   			var targetFrame = frames.parent.parent.parent.document.getElementById("mainFrame");
	   			var htmlText = "<div style='width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;' id='mailPanel'>&nbsp;</div>"
	   							+ "<div class='layerpopup'  style='z-index: 2000; position: absolute;display: none;' id='iFramePanel'>"
	   							+ "<iframe src='/blank_kr.htm' style='border:none;' id='iFrameLayer'></iframe> </div>";
	   			$(targetFrame).append(htmlText);
	   		}
	   		
	   		function ganttChartAddFunc(){
	   			Ganttalendar.prototype.zoomReset = function() {
	   				var curLevel = "1M";
	   				var centerMillis = this.getCenterMillis();
	   				
	   				this.gridChanged = true;
	   			    this.zoom = curLevel;

	   			    this.storeZoomLevel();
	   			    this.redraw();
	   			    this.goToMillis(centerMillis);
	   			}
	   			
	   			Ganttalendar.prototype.zoomChange = function(zoom) {
	   				var curLevel = zoom;
	   				var centerMillis = this.getCenterMillis();
	   				
	   				this.gridChanged = true;
	   			    this.zoom = curLevel;

	   			    this.storeZoomLevel();
	   			    this.redraw();
	   			    this.goToMillis(centerMillis);
	   			}
	   		}
	   		
	   		function ganttChartModifyFunc() {
	   			//기간 변경
	   			GanttMaster.prototype.changeTaskDates = function (task, start, end) {
	   			  if (typeof(start) == "number") {
	   				  start = new Date(start);
	   			  }
	   			  
	   			  if (typeof(end) == "number") {
	   				  end = new Date(end);
	   			  }
		   			 
	   		/* 	  var startDate = dateToYYYYMMDD(start);
	   			  var endDate = dateToYYYYMMDD(end);
	   			  var taskId = task.id.match(/t(\d+)/) != null? task.id.match(/t(\d+)/)[1] : null;
	   			  var projectId = task.id.match(/p(\d+)/)[1];
	   			  var groupId = -1;
	   			  
	   			  if (task.id.match(/g(\d+)/) != null) {
	   				groupId = task.id.match(/g(\d+)/)[1];
	   			  } else {
	   				groupId = projectGroupId;
	   			  }
	   			  
	   			  var progress = task.progress;
	   			  var fullId = task.id;
	   			  var endTime = end.getTime();
	   			  var rowIndex = $("#tid_" + task.id).find(".taskRowIndex").text();
	   			  var newEndTime = end.getTime();
	   			  var taskName = task.name;
	   			  
	   			  if (end.getDay() == 6) { 
	   				newEndTime = end.getTime() + (2 * 24 * 60 * 60 * 1000);
	   				endTime = new Date(newEndTime);
					endDate = dateToYYYYMMDD(endTime);
	   			  } else if (end.getDay() == 0) {
	   				newEndTime = end.getTime() + (1 * 24 * 60 * 60 * 1000);
	   				endTime = new Date(newEndTime);
		   			endDate = dateToYYYYMMDD(endTime);	
	   			  } */
	   			  
	   			  ge.taskIsChanged();
	   			  /* changeDate(task, fullId, taskId, projectId, startDate, endDate, progress, newEndTime, rowIndex, groupId, taskName); */
	   			  
	   			  var taskId = task.id.match(/t(\d+)/) != null? task.id.match(/t(\d+)/)[1] : null;
	   			  var projectId = task.id.match(/p(\d+)/)[1];
	   			  var groupId = -1;
	   			  var taskName = task.name;
	   			  
	   			  if (task.id.match(/g(\d+)/) != null) {
	   				groupId = task.id.match(/g(\d+)/)[1];
	   			  } else {
	   				groupId = projectGroupId;
	   			  }
	   			  
	   			  var orgStart = task.start;
	   			  var orgEnd   = task.end;
	   			  
	   			  if(userRoleId == '1') {
	   				
	   				if(task.setPeriod(start, end)) {
	   					
	   				 	// 이전과 변화가 없을 때는 바로 true return
	     				if(orgStart == task.start && orgEnd == task.end) {
	     					return true;
	     				}
	   				 	
		   				saveAllSchedules();
		   				var logContent = "<spring:message code='ezPMS.t239' arguments='" + replaceString(taskName) + "," + dateToYYYYMMDD(new Date(task.start)) + " ~ " + dateToYYYYMMDD(new Date(task.end)) + "'/>";
		   				var toastText  = "<spring:message code='ezPMS.t240' arguments='" + dateToYYYYMMDD(new Date(task.start)) + " ~ " + dateToYYYYMMDD(new Date(task.end)) + "'/>";
		   				
		   				toastPopupShow(toastText);				
				   		addTaskLog(projectId, 2, groupId, taskId, logContent);
		   				setAllGanttItems();
		   				return true;
	   			  	} else {
	   					return false;
	   			  	}
	   			  } else {
	   				  alert("<spring:message code='ezPMS.t9' />");
	   				  return false;
	   			  } 
	   			};
	   			
	   			//기간은 그대로, 날짜만 이동
	   			GanttMaster.prototype.moveTask = function (task, newStart) {
	   			  //선행작업 유효성 체크
	   			  if (!preTaskValidChk(ge.currentTask, "move", newStart)) {
	   				  alert("<spring:message code='ezPMS.t282' />");
	   				  location.reload();
	   			  }
	   			
		   		  if (typeof(newStart) == "number") {
		   			newStart = new Date(newStart);
		   		  }

	   			 /*  changeDate(task, task.id, taskId, projectId, startDate, endDate, task.progress, newEndTime, rowIndex, groupId, taskName); */
	   			 
		   		  var taskId = task.id.match(/t(\d+)/) != null? task.id.match(/t(\d+)/)[1] : null;
	   			  var projectId = task.id.match(/p(\d+)/)[1];
	   			  var groupId = -1;
	   			  var taskName = task.name;
	   			  
	   			  if (task.id.match(/g(\d+)/) != null) {
	   				groupId = task.id.match(/g(\d+)/)[1];
	   			  } else {
	   				groupId = projectGroupId;
	   			  }
	   			  
	   			  var orgStart = task.start;
	   			  var orgEnd   = task.end;
	   			  
	   			  if(userRoleId == '1') {
	   				  
	   				if(task.moveTo(newStart, true,true)) {
	   					
		   				// 이전과 변화가 없을 때는 바로 true return
		   				if(orgStart == task.start && orgEnd == task.end) {
		   					return true;
		   				}
		   				
		   				saveAllSchedules();
		   				
		   				var logContent = "<spring:message code='ezPMS.t239' arguments='" + replaceString(taskName) + "," + dateToYYYYMMDD(new Date(task.start)) + " ~ " + dateToYYYYMMDD(new Date(task.end)) + "'/>";
		   				var toastText  = "<spring:message code='ezPMS.t240' arguments='" + dateToYYYYMMDD(new Date(task.start)) + " ~ " + dateToYYYYMMDD(new Date(task.end)) + "'/>";
		   				
		   				toastPopupShow(toastText);				
				   		addTaskLog(projectId, 2, groupId, taskId, logContent);
		   				setAllGanttItems();
		   				return true;
		   			  } else {
		   				return false;
		   			  } 
	   			  } else {
	   				  alert("<spring:message code='ezPMS.t9' />");
	   				  return false;
	   			  } 
	   			};
	   			
	   			//선행작업 지정
	   			GanttMaster.prototype.changeTaskDeps = function (task) {
	   				/* console.log("changeTaskDeps", task, dateToYYYYMMDD(new Date(task.start)), dateToYYYYMMDD(new Date(task.end))); */
	   			  	
	   				var taskDepends = task.depends.split(",");
	   				var taskDepend = taskDepends[taskDepends.length - 1];
	   				var preTask = ge.tasks[taskDepend - 1];		
/* 	   				var taskStartDate = dateToYYYYMMDD(new Date(task.start));
	   				var taskEndDate   = dateToYYYYMMDD(new Date(task.end));
	   			  	var taskDuration = task.duration; */
	   			  	var taskId = task.id.match(/t(\d+)/) != null? task.id.match(/t(\d+)/)[1] : null;
	   			  	var groupId = task.id.match(/g(\d+)/) != null? task.id.match(/g(\d+)/)[1] : projectGroupId;
	   			  	var preTaskId = preTask.id.match(/t(\d+)/) != null ? preTask.id.match(/t(\d+)/)[1] : null;
	   			  	var preGroupId = preTask.id.match(/g(\d+)/) != null ? preTask.id.match(/g(\d+)/)[1] : null;
	   			  	var progress = task.progress;
	   			  	var preTaskRowName = $(".taskEditRow").eq(taskDepend - 1).find("input[name='name']").val();
	   			  	var projectId = task.id.match(/p(\d+)/)[1];
	   			    
	   			  	/* if(taskId == null || preTaskId == null) {
	   			  		alert("<spring:message code='ezPMS.t300' />");
	   			  		throw "It is not allowed to set Group as Pretask";
	   			  		return;
	   			  	} */
	   			  	
	   			  	/* if(new Date(preTask.end) > new Date(task.start)) {
	   				  
	   				  	if(confirm("<spring:message code='ezPMS.t291' />") == false) {
	   				  		throw "";
	   					  	return;
	   				  	}
	   			  	} */
	   			  	var projectTask = ge.tasks[0];
	   			  	var taskEnd = new Date(task.end);
	   			  	var taskStart = new Date(task.start);
	   			  	var preTaskEnd = new Date(preTask.end);
	   			  	var taskGap = Math.round((taskEnd.getTime() - taskStart.getTime()) / (1000* 60 * 60 * 24));
	   			  	
	   			  	var totalEndDate = preTaskEnd.setDate(preTaskEnd.getDate() + taskGap);
	   			  	
	   			  	if (totalEndDate > projectTask.end) {
	   			  		alert("<spring:message code='ezPMS.t127' />");
	   			  		location.reload();
	   			  		return false;
	   			  	}
	   			  	
	   			  	if (addPreTaskRel(projectId, taskId, preTaskId, progress, task.name, preTaskRowName, groupId, preGroupId) == true) {
	   			  		// 후행작업의 기간이 정상적으로 조정된 후, 화면의 정보를 바탕으로 기간 정보를 DB에 업데이트
	   			  		if(task.moveTo(task.start,false,true,true)) {
	   			  			saveAllSchedules();
	   			  			setAllGanttItems();
	   			  		} else {  			
	   			  			location.reload();
	   			  			return false;
	   			  		};
	   			  		
	   			  	} else {
	   			  		location.reload();
	   			  		return false;
	   			  	}
	   			};
	   			
	   			//depth에 따른 들여쓰기 조절하기 위해 재정의
	   			GridEditor.prototype.refreshTaskRow = function (task) {
	   			  var canWrite=this.master.permissions.canWrite || task.canWrite;

	   			  var row = task.rowElement;

	   			  row.find(".taskRowIndex").html(task.getRow() + 1);
	   			  row.find(".indentCell").css("padding-left", task.level * 15 + 18);
	   			  //컬럼명에 &quot;가 문자열로  찍히는 문제 때문에 val부분 제거
// 	   			  row.find("[name=name]").val(task.name).prop("readonly", false).css({"color":"black", "width":"calc(100% - 28px)"});
	   			  row.find("[name=name]").prop("readonly", false).css({"color":"black", "width":"calc(100% - 28px)"});
	   			  row.find("[name=code]").val(task.code);
	   			  row.find("[status]").attr("status", task.status);

// 	   			  row.find("[name=duration]").val(durationToString(task.duration)).prop("readonly",!canWrite || task.isParent() && task.master.shrinkParent);
	   			  row.find("[name=duration]").val(durationToString(task.duration)).prop("readonly", true).css({"text-align":"right"});
	   			  row.find("[name=progress]").val(task.progress).prop("readonly",!canWrite || task.progressByWorklog==true).css({"text-align":"right"});
	   			  row.find("[name=weight]").prop("readonly", task.type !== "t" || projectDetails.weightInput === 0).css({"text-align":"right"});
	   			  row.find("[name=planProgress]").prop("readonly", true).css({"text-align":"right"});
	   			  row.find("[name=realProgress]").prop("readonly", task.type !== "t" || task.statusPMS === "W" || task.statusPMS === "S").css({"text-align":"right"});
	   			  row.find("[name=startIsMilestone]").prop("checked", task.startIsMilestone);
	   			  var startReadonly = !canWrite || !(task.canWrite  || this.master.permissions.canWrite) || task.type !== "t" || task.statusPMS === "C";
	   			  row.find("[name=start]").val(new Date(task.start).format()).updateOldValue().prop("readonly", startReadonly); // called on dates only because for other field is called on focus event
	   			  row.find("[name=endIsMilestone]").prop("checked", task.endIsMilestone);
	   			  var endReadonly = !canWrite || task.isParent() && task.master.shrinkParent || task.type === "g" || task.statusPMS === "C";
	   			  row.find("[name=end]").val(new Date(task.end).format()).prop("readonly", endReadonly).updateOldValue();
	   			  row.find("[name=depends]").val(task.depends).css({"text-align":"right"}).attr("readonly", "readonly");
	   			  row.find(".taskAssigs").html(task.getSimpleAssigsStr());
				  
	   			  //프로젝트 상태가 대기, 보류, 삭제일 때 실제 진행률 변경 못하게 함
	   			  if (projectStatus == "W" || projectStatus == "S" || projectStatus == "D" || projectStatus == "C") {
	   				row.find("[name=realProgress]").prop("readonly", true); 
	   			  }
	   			  
	   			  //manage collapsed
	   			  if (task.collapsed) {
	   			    row.addClass("collapsed");
	   			  } else {
	   			    row.removeClass("collapsed");
	   			  }

	   			  //Enhancing the function to perform own operations
	   			  this.master.element.trigger('gantt.task.afterupdate.event', task);
	   			  //profiler.stop();
	   			  
	   			};
	   			
	   			//그래프쪽 디자인 수정하기 위해 재정의
	   			Ganttalendar.prototype.redrawTasks = function (drawAll) {
	   			  var self=this;

	   			  self.element.find("table.ganttTable").height(self.master.editor.element.height());

	   			  var collapsedDescendant = this.master.getCollapsedDescendant();

	   			  var startRowAdd=self.master.firstScreenLine-self.master.rowBufferSize;
	   			  var endRowAdd =self.master.firstScreenLine+self.master.numOfVisibleRows+self.master.rowBufferSize;

	   			  $("#linksGroup,#tasksGroup").empty();
	   			  var gridGroup=$("#gridGroup").empty().get(0);

	   			  //add missing ones
	   			  var row=0;
	   			  self.master.firstVisibleTaskIndex=-1;
	   			  var selfMasterTasksCount = self.master.tasks.length;
	   			  
	   			  for (var i = 0; i < selfMasterTasksCount; i++) {
	   			    var task=self.master.tasks[i];
	   			    
	   			    if (collapsedDescendant.indexOf(task)>=0){
	   			      continue;
	   			    }
	   			    
	   			    if (drawAll || (row>=startRowAdd && row<endRowAdd)) {
	   				  this.drawTask(task);
	   			      self.master.firstVisibleTaskIndex = self.master.firstVisibleTaskIndex == -1? i : self.master.firstVisibleTaskIndex;
	   			      self.master.lastVisibleTaskIndex = i;
	   			    }
	   			    
	   			    row++
	   			  }

	   			  //creates rows grid
	   			  for (var i = 40; i <= self.master.editor.element.height(); i += self.master.rowHeight)
	   			    self.svg.rect(gridGroup, 0.5, i + 0.5, "100%", self.master.rowHeight, {class: "ganttLinesSVG"});

	   			  // drawTodayLine
	   			  if (new Date().getTime() > self.startMillis && new Date().getTime() < self.endMillis) {
	   			    var x = Math.round(((new Date().getTime()) - self.startMillis) * self.fx);
	   			    self.svg.line(gridGroup, x, 0, x, "100%", {class: "ganttTodaySVG"});
	   			  }
	   			};
	   			
	   			Task.prototype.getSimpleAssigsStr = function () {
	   			  var ret = "";
	   			  
	   			  var headManagerId = this.headManager;
// 	   			  var res = this.master.getResource(headManagerId);
	   			  var res = this.master.getResource(this.assigs.length > 0 ? this.assigs[0].id : "");
	   			  
	   			  /*if (res) {
	   			  	ret = res.name;
	   			  } */
	   			  
	   			  if (this.assigs.length > 1) {
	   				ret = "<spring:message code='ezPMS.t349' arguments='" + res.name + "," + (this.assigs.length - 1) +"'/>"
	   			  } else {
	   				if(res){
		   				ret = res.name;
	   				}
	   			  }
	   			 
	   			  return ret;
	   			};
	   		}
	   		
	   		function banGroupFromPretask() {
	   			alert("<spring:message code='ezPMS.t300' />");
	   		}
	   		
	   		function deletePretaskRel(pretaskFullId, taskFullId) {
	   			
	   			var pretaskId    = pretaskFullId.match(/t(\d+)/) != null ? pretaskFullId.match(/t(\d+)/)[1] : null;
	   			var taskId  = taskFullId.match(/t(\d+)/) != null ? taskFullId.match(/t(\d+)/)[1] : null;
	   			// 프로젝트 직속 업무의 경우 groupId가 넘어오지 않기 때문에 projectDetails에서 직접 얻는다
	   			var groupId = taskFullId.match(/g(\d+)/) != null ? taskFullId.match(/g(\d+)/)[1] : projectDetails.groupId;
	   			
	   			if (confirm("<spring:message code='ezPMS.t107' />") == true) {
	   				var data = {
	   						projectId : projectId,
		   					pretaskId : pretaskId,
		   					taskId : taskId
		   			}

		   			$.ajax({
		   				type : "DELETE",
		   				data : JSON.stringify(data),
		   				dataType: "json",
		   				contentType: "application/json; charset=UTF-8",
		   				url : "/ezPMS/deletePretaskRel.do",
		   				success : function(result) {
		   					if (result.roleCheck == 'permitted') {
		   						$('#workSpace').trigger('deleteFocused.gantt');
			   					var pretaskName = $(".taskEditRow[taskid=" + pretaskFullId + "]").find("input[name='name']").val();
			   					var taskName 	= $(".taskEditRow[taskid=" + taskFullId + "]").find("input[name='name']").val();
								var logContent = "<spring:message code='ezPMS.t308' arguments='" + replaceString(pretaskName) + "," + replaceString(taskName) + "'/>";
			   					addTaskLog(projectId, 3, groupId, taskId, logContent);
			   					toastPopupShow(logContent);
		   					} else {
		   						$("g").removeClass("focused");
		   						alert("<spring:message code='ezPMS.t321' />");
		   					}
		   					
		   				}
		   			});
	   			}
	   		}
	   		
	   		// 화면상 데이터를 기준으로 모든 Gantt item들의 일정이 DB에 적용
	   		function saveAllSchedules() {	   			
	   			var allGanttItems = ge.saveProject().tasks;
		  		var allTasks = [];
		  		var allGroups = [];
		  		  		
		  		function TaskSchedule(taskId, start, end, duration) {
		  			this.taskId = taskId;
		  			this.start = start;
		  			this.end = end;
		  			this.duration = duration;
		  		}; 
		  		
		  		function GroupSchedule(groupId, start, end, duration) {
		  			this.groupId = groupId;
		  			this.start = start;
		  			this.end = end;
		  			this.duration = duration;
		  		}; 
		  		
		  		var allGanttItemsCount = allGanttItems.length;
		  		
		  		for(var i = 0; i < allGanttItemsCount; i++) {
		  			var allGanttItem = allGanttItems[i];
		  			
		  			var taskId    = allGanttItem.id.match(/t(\d+)/) != null ? allGanttItem.id.match(/t(\d+)/)[1] : null;
		  			var groupId   = allGanttItem.id.match(/g(\d+)/) != null ? allGanttItem.id.match(/g(\d+)/)[1] : null;
		  			var newStart  = dateToYYYYMMDD(new Date(allGanttItem.start));
		  			var newEnd    = dateToYYYYMMDD(new Date(allGanttItem.end));
		  			var duration  = allGanttItem.duration;
		  			
		  			/* console.log("newStart : " + newStart + ", newEnd : " + newEnd); */
		  			
		  			if(taskId != null) {
		  				allTasks.push(new TaskSchedule(taskId, newStart, newEnd, duration));
		  			} else if(groupId != null){
		  				allGroups.push(new GroupSchedule(groupId, newStart, newEnd, duration));
		  			}
		  		}
		  		
		  		/* console.log(JSON.stringify(allTasks)); */
		  		
		  		data = {
		  			allTasks : allTasks,
		  			allGroups : allGroups,
		  			projectId : projectId
		  		};
		  		
		  		$.ajax({
  			  		type : "PUT",
  					url : "/ezPMS/updateAllSchedules.do",
  					async : false,
  					dataType : "json",
  					contentType : "application/json; charset=UTF-8",
  					data : JSON.stringify(data),
  					success : function(result) {
  						$("#projectProgress", parent.document).text(result.projectProgress.toFixed(1) + '%');
  					}
		  		});
	   		}
	   		
	   		function addPreTaskRel (projectId, taskId, preTaskId, progress, taskName, preTaskRowName, groupId, preGroupId) {
	   			
	   			var type;
	   			var taskIdParam = taskId;
	   			var returnVal = false;
	   			
	   			// 선행작업 지정 종류
	   			if (taskId != null && preTaskId != null) {
	   				type = "task2task"; 
	   			} else if(taskId != null && preTaskId == null) {
	   				type = "group2task";
	   				preTaskId = preGroupId;
	   			} else if(taskId == null && preTaskId != null) {
	   				type = "task2group";
	   				taskId = groupId;
	   			} else if(taskId == null && preTaskId == null) {
	   				type = "group2group";
	   				taskId = groupId;
	   				preTaskId = preGroupId;
	   			}
	   			
	   			var data = {
	   					projectId : projectId,
	   					taskId : taskId,
	   					// task가 속한 group의 Id
	   					groupId : groupId, 
	   					preTaskId : preTaskId,
	   					realProgress : progress,
	   					type : type
	   			}
	   			
	   			$.ajax({
	   				type : "POST",
	   				dataType: "text",
	   				contentType: "application/json; charset=UTF-8",
	   				url : "/ezPMS/addPreTaskRel.do",
	   				data :JSON.stringify(data),
	   				async : false,
	   				success : function(result) {
	   					if (result == "permitted") {
	   						var logContent = "<spring:message code='ezPMS.t241' arguments='" + replaceString(preTaskRowName) + "," + replaceString(taskName) + "'/>";
	   						toastPopupShow(logContent);
	   						addTaskLog(projectId, 1, groupId, taskIdParam, logContent);
	   						returnVal = true;
	   					} else {
	   						alert("<spring:message code='ezPMS.t321' />");
	   					}
	   				},
	   				error : function(jqXHR, textStatus, errorThrown) {
	   					alert ("<spring:message code='ezPMS.t54' />");
	   				}
	   			});
	   			
	   			return returnVal;
	   		}
	   		
	   		/* function changeDate(task, fullId, taskId, projectId, startDate, endDate, progress, endTime, rowIndex, groupId, taskName) {
	   			  //선행작업 유효성 체크
	   			  if(!preTaskValidChk(ge.currentTask, "", startDate)){
	   				  alert("<spring:message code='ezPMS.t282' />");
	   				  location.reload();
	   			  }
	   			
	   			var data = {
	   					  taskId : taskId,
	   					  projectId : projectId,
	   					  planStartDate : startDate,
	   					  planEndDate : endDate,
	   					  realProgress : progress,
	   					  endTime : endTime,
	   					  rowIndex : rowIndex,
	   					  groupId : groupId
	   			  } 
	   			  
	   			$.ajax({
	   				type : "POST",
	   				dataType: "json",
	   				contentType: "application/json; charset=UTF-8",
	   				url : "/ezPMS/updateTaskDate.do",
	   				data :JSON.stringify(data),
	   				success : function(result) {
	   					if (result.roleCheck == "permitted") {
	   						ge.tasks.filter(function(task){
	   							return task.id == fullId
	   						})[0].end = endTime;
	   						
	   						toastPopupShow("[" + startDate + " ~ " + endDate + "<spring:message code='ezPMS.t240' />");
	   						addTaskLog(projectId, 2, groupId, taskId, "[" + taskName + "<spring:message code='ezPMS.t239' />" + startDate + " ~ " + endDate + "<spring:message code='ezPMS.t240' />");
	   						//ge.refresh();
	   					} else {
	   						alert("<spring:message code='ezPMS.t184' />");
	   						location.reload();
	   					}
	   				},
	   				error : function(jqXHR, textStatus, errorThrown) {
	   					alert ("<spring:message code='ezPMS.t54' />");
	   				}
	   				});
	   		} */
	   		
	   		//위치 지정해주기
	   		function toastPopupShow(toastContent) {
   				$(".toastArea").html(toastContent).show();
   				
   				setTimeout(function(){
	   					$(".toastArea").fadeOut();
	   			}, 1000);
	   		}
	   		
	   		function dateToYYYYMMDD(date){
	   		    function pad(num) {
	   		        num = num + '';
	   		        return num.length < 2 ? '0' + num : num;
	   		    }
	   		    
	   		    return date.getFullYear() + '-' + pad(date.getMonth()+1) + '-' + pad(date.getDate());
	   		}

	   		
	   		function preProcess(){
	   			//간트 차트 테이블 날짜 형식 세팅. i18nJs.js 의 내용에 덮어 씌움.
	   			Date.defaultFormat = "yyyy/MM/dd";
	   			Date.monthNames = ('<spring:message code="ezPMS.t246" />').split(";");
	   			Date.monthAbbreviations = ('<spring:message code="ezPMS.t246" />').split(";");
	   			Date.dayNames =('<spring:message code="ezPMS.t245" />').split(";");
	   			Date.dayAbbreviations =('<spring:message code="ezPMS.t244" />').split(";");
	   		}
	   		
	   		function eventSetting(){
	   			document.getElementById("pmsGanttRowDelBtn").onclick = delTask;
		   		document.getElementById("pmsGanttRowNewBtn").onclick = addTask;
// 		   		document.getElementById("pmsGanttTaskDetails").onclick = taskDetails;
		   		document.getElementById("pmsGanttAddGroup").onclick = addGroup;
		   		document.getElementById("pmsGanttDelGroup").onclick = delGroup;

		   		$(".gdfTable tbody").sortable({
		   			items : 'tr:not(.project)',
		   			activate : function(event, ui) {
		   				preTaskIndex = $("#" + ui.item[0].id).find(".taskRowIndex").text();
		   				selectedPreTask = ui.item[0].id;
		   			},
		   			update : function(event, ui) {
		   				var upperTaskId = $("#" + ui.item[0].id).prev("tr").attr("taskId");
		   				var upperTaskLevel = $("#" + ui.item[0].id).prev("tr").attr("level");
		   				var groupId = -1;
		   				
		   				if (upperTaskId.indexOf("_t") != -1) {
		   					groupId = upperTaskId.substring(0, upperTaskId.indexOf("_t"));
		   				} else {
		   					groupId = upperTaskId;
		   				}
		   				
						var selectedTaskId = ui.item[0].id.substring(ui.item[0].id.lastIndexOf("_"));
						var selectedGroupId = ui.item[0].id.substring(4, ui.item[0].id.lastIndexOf("_"));
						
						var targetTaskId = -1;
						var toGroupId = -1;
						
						if(ui.item[0].id.indexOf("_t") != -1) {
							targetTaskId = ui.item[0].id.match(/t(\d+)/)[1];
						} 
						
						if (groupId != selectedGroupId) {
							if (groupId.indexOf("_g") != -1) {
								toGroupId = groupId.match(/g(\d+)/)[1];
							} else {
								toGroupId = projectGroupId;
							}
						}
		   				
						if(ui.item[0].id.indexOf("_t") != -1) {
							$("#" + ui.item[0].id).attr("taskid", "" + groupId + selectedTaskId);
							$("#" + ui.item[0].id).attr("id", "tid_" + groupId + selectedTaskId);
							$("#" + ui.item[0].id).attr("level", upperTaskLevel + 1);
						} else {
							$("#" + ui.item[0].id).attr("level", upperTaskLevel + 1);
						}
						
						// console.log("targetTaskId : " + targetTaskId);
						// console.log("toGroupId : " + toGroupId);
						// console.log("selectedGroupId : " + selectedGroupId);
						
		   				var isPermitted = changeGanttOrder(targetTaskId, toGroupId, selectedGroupId);
		   				
		   				if (isPermitted == "false") {
		   					$(this).sortable("cancel");
		   					
			   				var revertUpperTaskId = $("#" + ui.item[0].id).prev("tr").attr("taskId");
			   				var revertGroupId = -1;
			   				
			   				if (revertUpperTaskId.indexOf("_t") != -1) {
			   					revertGroupId = revertUpperTaskId.substring(0, revertUpperTaskId.indexOf("_t"));
			   				} else {
			   					revertGroupId = revertUpperTaskId;
			   				}
			   				
							$("#" + ui.item[0].id).attr("taskid", "" + revertGroupId + selectedTaskId);
							$("#" + ui.item[0].id).attr("id", "tid_" + revertGroupId + selectedTaskId);
		   				} else {
			   				ge.taskIsChanged();
		   				}
		   			}
		   		}).disableSelection();
		   		
		   		document.querySelector("#pmsGanttZoomBtn select").onchange = function(){ge.gantt.zoomChange(this.value);}
		   		document.querySelector("#pmsGanttViewBtn select").onchange = function(){setMyTaskList(this.value);}
		   		$(document).on("change", "input[name='weight']", function(){ updateWeight(this); });
		   		$(document).on("change", "input[name='realProgress']", function(){ updateProgress(this); });
		   		$(document).on("change", "input[name='name']", function(){ updateTaskName(this); });
		   	}
	   		
	   		function changeGanttOrder(targetTaskId, toGroupId, fromGroupId) {
	   			var groupArr = [];
	   			var taskArr = [];
	   			var treeDepth = 0;
	   			
	   			$(".group").each(function(index, element){
   					groupArr.push({"projectId" : element.id.match(/p(\d+)/)[1], "groupId" : element.id.match(/g(\d+)/)[1], "order" : index});
	   			});
	   			
	   			$(".isParent").each(function(index, element){
	   				if (index != 0) {
	   					$(".taskEditRow[id^='" + element.id + "_t']").each(function(idx, elem) {
	   						if ($("#" + elem.id).find("input[name='depends']").val() == preTaskIndex) {
	   							var newPreTask = $("#" + selectedPreTask).index() + 1;		
	   							taskArr.push({"groupId" : element.id.match(/g(\d+)/)[1], "taskId" : elem.id.match(/t(\d+)/)[1], "order" : idx, "depends" : newPreTask});
	   						} else {
	   							taskArr.push({"groupId" : element.id.match(/g(\d+)/)[1], "taskId" : elem.id.match(/t(\d+)/)[1], "order" : idx, "depends" : -1});
	   						}
		   				});
	   				} else if (index == 0) {
	   					$(".taskEditRow[id^='" + element.id + "_t']").each(function(idx, elem) {
	   						if ($("#" + elem.id).find("input[name='depends']").val() == preTaskIndex) {
	   							var newPreTask = $("#" + selectedPreTask).index() + 1;
	   							
	   							taskArr.push({"groupId" : projectGroupId, "taskId" : elem.id.match(/t(\d+)/)[1], "order" : idx, "depends" : newPreTask});
	   						} else {						
	   							taskArr.push({"groupId" : projectGroupId, "taskId" : elem.id.match(/t(\d+)/)[1], "order" : idx, "depends" : -1});
	   						}
		   				});
	   				}
	   				
	   			});
	   			
	   			//옮기고자 하는 task의 멤버들이 옮겨진 groupMember가 모두 포함되어있는지 확인
	   			if (toGroupId != -1) {
		   			var groupMember = $("#tid_p" + projectId + "_g" + toGroupId).find(".taskAssigs").attr("title");
// 		   			var targetGroupId = $(".taskEditRow[taskid$='t" + targetTaskId + "']").attr("taskid");
		   			fromGroupId = fromGroupId.match(/g(\d+)/) != null ? fromGroupId.match(/g(\d+)/)[1] : projectGroupId;
		   			var groupTreeDepth = $("#tid_p" + projectId + "_g" + toGroupId).attr("level");
		   			
		   			if (fromGroupId.indexOf(toGroupId) != -1) {
			   			if (groupMember != undefined) {
				   			treeDepth = parseInt(groupTreeDepth) + 1;
				   			
			   				var targetTaskMember = $(".taskEditRow[taskid$='t" + targetTaskId + "']").find(".taskAssigs").attr("title").split(",");
			   				
			   				for (var i = 0; i < targetTaskMember.length; i++) {
			   					var member = targetTaskMember[i].trim();
			   					
			   					if (groupMember.indexOf(member) == -1) {
			   						alert("<spring:message code='ezPMS.t323'/>");
			   						return "false";
			   					}
			   				}
			   				
		   				} 
		   			} else {
	   					groupTreeDepth = $("#tid_p" + projectId).attr("level");
	   					treeDepth = parseInt(groupTreeDepth) + 1;
	   				}
	   			}
	   			
	   			 var data = {
	   				projectId : projectId,
	   				groupArr : groupArr,
	   				taskArr : taskArr,
	   				targetTaskId : targetTaskId,
	   				toGroupId : toGroupId,
	   				fromGroupId : fromGroupId,
	   				treeDepth : treeDepth
	   			}
	   			
	   			$.ajax({
	   				type:"post",
	   				dataType: "text",
	   				contentType: "application/json; charset=UTF-8",
	   				url:"/ezPMS/changeGanttOrder.do",
	   				data:JSON.stringify(data),
	   				success: function(result){
	   					if (result == "rejected") {
	   						alert("<spring:message code='ezPMS.t184' />");
	   						return "false";
	   					} else {
	   						console.log(targetTaskId);
	   						console.log(toGroupId);
	   						console.log(fromGroupId);
	   						
	   						// 체인지 간트의 대상이 업무일 때
	   						if(targetTaskId != -1) {
	   							
	   							// 그룹안의 순서 변경이 아닌, 그룹의 변경일 때
	   							if(toGroupId != -1 && fromGroupId != -1 && toGroupId != fromGroupId) {
	   								updateGroupRealStartEndDate(toGroupId);
	   								updateGroupRealStartEndDate(fromGroupId);
	   							}
	   						}
	   						
							location.reload();
	   						return "true";		
	   					}
	   				},
	   				error : function(jqXHR, textStatus, errorThrown) {
	   					alert("<spring:message code='ezPMS.t54' />");
	   				}
	   			});
	   		}
	   		
	   		function updateWeight(obj) {
	   			var curTask = ge.currentTask;
	   			var newWeight = obj.value;
	   			var validFlag = false;
	   			var taskId = 0;
	   			var groupId = 0;
	   			var prjWeight = getPrjWeight(curTask, newWeight);
	   			var prevTasks = Array.prototype.slice.call(ge.tasks);
	   			
	   			taskId = curTask.id.match(/t(\d+)/) != null ? curTask.id.match(/t(\d+)/)[1] : "";
	   			groupId = curTask.id.match(/g(\d+)/) != null ? curTask.id.match(/g(\d+)/)[1] : "";
	   			
	   			if (taskId === "") {
	   				alert("<spring:message code='ezPMS.t247' />");
	   			} else if (newWeight == "") {
	   				//가중치 검사
   					alert("<spring:message code='ezPMS.t96' />");
   				} else if (isNaN(newWeight)) {
   					alert("<spring:message code='ezPMS.t248' />");
   				} else if (prjWeight > 100) {
   					alert("<spring:message code='ezPMS.t284' />" + ge.tasks[0].weight + "<spring:message code='ezPMS.t285' />" + (100 - ge.tasks[0].weight));
   				} else {
   					validFlag = true;
   				}
	   			
	   			if (!validFlag) {
	   				ge.loadTasks(prevTasks);
   					ge.redraw();
	   				return;
	   			}
//    				if(Number(newWeight) > remainingWeight) {
//    					alert("가중치는 프로젝트의 잔여가중치를 초과할 수 없습니다.");
//    					return;
//    				}

				var data = {
						taskName : curTask.name,
						taskId : taskId,
						projectId : projectId,
						groupId : groupId,
						weight : newWeight
				}
				
				$.ajax({
					type : "POST",
					url : "/ezPMS/updateTaskWeight.do",
					dataType : "json",
					contentType: "application/json; charset=UTF-8",
					data : JSON.stringify(data),
					success : function(data) {
// 						alert("<spring:message code='ezPMS.t280' />");
						
						location.reload();
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezPMS.t54' />");
					}
				});
	   		}
	   		
	   		function updateProgress(obj) {
	   			var curTask = ge.currentTask;
	   			var newProgress = obj.value;
	   			var status = curTask.statusPMS;
	   			var validFlag = false;
	   			var taskId = 0;
	   			var groupId = 0;
	   			var prevTasks = Array.prototype.slice.call(ge.tasks);
	   			var planEndDate = new Date(curTask.end);
	   			var today = new Date();
	   			
	   			//선행작업 유효성 체크할 때 어느 함수에서 넘어온건지 확인하기 위해 사용.
	   			var mode = "update";
	   			
	   			taskId = curTask.id.match(/t(\d+)/) != null ? curTask.id.match(/t(\d+)/)[1] : "";
	   			groupId = curTask.id.match(/g(\d+)/) != null ? curTask.id.match(/g(\d+)/)[1] : "";
	   			
	   			if (taskId === "") {
	   				alert("<spring:message code='ezPMS.t247' />");
	   			} else if (!preTaskValidChk(curTask, mode)) {
	   				//선횅작업과의 유효성 체크
// 	   				$(".gdfTable tbody tr").eq(curTask.depends - 1).trigger("click");
	   				alert("<spring:message code='ezPMS.t286' />");
	   			} else if (newProgress == "") {
	   				//가중치 검사
   					alert("<spring:message code='ezPMS.t189' />");
   				} else if (isNaN(newProgress)) {
   					alert("<spring:message code='ezPMS.t248' />");
   				} else {
   					validFlag = true;
   				}
	   			
	   			if (!validFlag) {
	   				ge.loadTasks(prevTasks);
   					ge.redraw();
	   				return;
	   			}
				  			
	   			if (status == 'C' && newProgress < 100 && today > planEndDate) {
	   				status = 'L';
	   			} else if(status == 'C' && newProgress < 100) {
	   				status = 'P';
	   			} else if (newProgress >= 100) {
	   				status = 'C';
	   			}
	   			
				var data = {
						taskName : curTask.name,
						taskId : taskId,
						projectId : projectId,
						groupId : groupId,
						progress : newProgress,
						status : status
				}
				
				$.ajax({
					type : "POST",
					url : "/ezPMS/updateTaskProgress.do",
					dataType : "json",
					contentType: "application/json; charset=UTF-8",
					data : JSON.stringify(data),
					success : function(data) {
// 						alert("<spring:message code='ezPMS.t280' />");
						
						var logContent = "<spring:message code='ezPMS.t317' arguments='" + replaceString(curTask.name) + "," + curTask.progress + "," + new Number(newProgress).toFixed(1) + "'/>"; 
	   					addTaskLog(projectId, 2, groupId, taskId, logContent);
	   					
	   					// status값이 바뀌었을 때만 실행
	   					if(curTask.statusPMS != status) {
	   						updateGroupRealStartEndDate(groupId);
	   					}
	   					
	   					$("#projectProgress", parent.document).text(data.projectProgress.toFixed(1) + '%');
						location.reload();
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezPMS.t54' />");
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
	   		
	   		//선행작업 관련 유효성 검사.
	   		//파라미터 : 현재작업, 동작유형(수정, 이동), 현재작업의 새 시작일.
	   		function preTaskValidChk(curTask, mode, startDate) {
	   			var flags = true;
	   			var preTask = ge.tasks[curTask.depends - 1];
	   			var newStart = typeof startDate == "number" ? startDate : typeof startDate == "object" ? startDate.getTime() : new Date(startDate).getTime();
	   			
	   			if (preTask) {
		   			if (mode === "update") {
			   			//선행작업의 실제진행률이 100퍼센트가 되었는지 검사.
			   			if (preTask.realProgress != 100) {
			   				flags = false;
			   			}
		   			} else if(mode === "move"){
		   			} else {
		   				
		   			}
		   			
	   				//선행작업이 후행작업의 시작일보다 늦게 종료되는지 검사.
		   			if(newStart < preTask.end){
		   				flags = false;
		   			}
	   			}
	   			
	   			//flags가 true이면 패스, false이면 에러
	   			return flags;
	   		}
	   		
	   		//프로젝트의 목표진행률을 계산해서 넣어줌.
	   		function getPrjPlanProgress(ganttData) {
	   			var prjPlanProg = 0.0;
	   			var tasks = ganttData.tasks;
	   			var taskCount = tasks.length;
	   			
	   			for (var i = 0; i < taskCount; i++) {
	   			    var task = tasks[i];
	   			    
	   			    if (task.type === "t") {
	   			        prjPlanProg += task.planProgress * task.weight / 100
	   			    }
	   			}
	   			return Number(prjPlanProg).toFixed(1);
	   		}
	   		
	   		//프로젝트 가중치를 계산.
	   		function getPrjWeight(curTask, newWeight) {
	   			var prjWeight = 0.0;
	   			var tasks = ge.tasks;
	   			var taskCount = tasks.length;
	   			
	   			for (var i = 0; i < taskCount; i++) {
	   			    var task = tasks[i];
	   			    
	   			    if (task == curTask) {
	   			    	prjWeight += Number(newWeight);
	   			    } else if(task.type === "t"){
	   			    	prjWeight += Number(task.weight);
	   			    }
	   			}
	   			
	   			return Number(prjWeight).toFixed(1);
	   		}
	   		
	   		//선행작업 아이디값을 갖고 행값을 넣어준다.
	   		function setDepends(ganttData){
	   			var len = ganttData.tasks.length;
	   			
	   			for(var i = 0; i < len; i++){
   					var pretask = ganttData.tasks[i].pretask;
   					var type = pretask ? pretask.match(/\w/)[0] : "";
	   				if(pretask){ //선행작업이 있는 업무이면.
	   					
	   					var pretaskArr = pretask.split(",");
	   					var dependencies = "";
	   					var pretaskNames = "";
	   					
	   					for(var k = 0; k < pretaskArr.length; k++) {
	   						pretask = pretaskArr[k];
	   						
	   						for(var j = 0; j < len; j++){
		   						var task = ganttData.tasks[j];
		   						
		   						//업무중에 선행작업 아이디와 타입이 일치하는 업무 또는 그룹을 찾음.
	   							if(task.id.indexOf(pretask) != -1 && task.type === type){
	   								//찾은 업무의 행번호를 넣어줌.
			   						dependencies += (j + 1) + ",";
			   						pretaskNames += task.name + "\n";
	   							}
		   					}
	   					}
	   					
	   					if(dependencies.lastIndexOf(",") != -1) {
	   						dependencies = dependencies.substring(0, dependencies.lastIndexOf(","));
	   					}
	   					
	   					ganttData.tasks[i].depends = dependencies;
	   					ganttData.tasks[i].pretaskName = pretaskNames;
	   				}
	   			}
	   			return ganttData;
	   		}
	   		
	   		//업무 상태 필터 기능.
	   		function setMyTaskList(status) {
	   			var status = status;
	   			setAllGanttItems(status);
	   		}
	   		
	   		//간트차트 생성 후 CSS를 바꿈.
	   		function ganttRedesign(){
	   			$("#TWGanttArea").css({"padding":0, "overflow-y":"auto", "overflow-x":"hidden","position":"relative","border":"1px solid #d1d1d1"});
	   		}
	   		
	   		
	   		(function() {
	   			//간트차트 높이 조절.
	   			window.onresize = function() {
	   				$("#TWGanttArea").height(parent.innerHeight - 155);
	   			};
	   			
		   		initValues();
		   		ganttChartAddFunc();
		   		ganttChartModifyFunc();
		   		
// 		   		ge = new GanttMaster();
// 		   		ge.init($("#workSpace"));
	   		})();
	   		
	   		window.onload = function() {
	   			//툴팁 위치 지정
	   			var positionTooltip = function(event) {
	   				var tPosX = event.pageX - 5;
	   				var tPosY = event.pageY + 15;
	   				$(".tooltipBox").css({top:tPosY, left : tPosX});
	   			};
				
	   			//토스트팝업 위치 지정
	   			var positionToast = function(event) {
	   				var tPosX = event.pageX - 10;
	   				var tPosY = event.pageY - 30;
	   				$(".toastArea").css({top:tPosY, left : tPosX});
	   			}
	   			
	   			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	   			
	   			$(document).on("mouseover", ".taskBox" ,function (event) {
	   				//마우스 오버했을 때 툴팁위치와 토스트팝업 위치 지정해줌
	   				positionTooltip(event);
	   				positionToast(event);
	   				
	   				var taskId = $(this).attr("taskid");
	   				var isGroup = taskId.substring(taskId.lastIndexOf("_") + 1, taskId.lastIndexOf("_") + 2);
	   				
	   				//선택한 작업이 업무/그룹/프로젝트 인지 구분.
		   			if(taskId.indexOf("_t") !== -1){
		   				isGroup = "t";
		   			}
		   			else if(taskId.indexOf("_g") !== -1){
		   				isGroup = "g";
		   			}
		   			else if(taskId){
		   				isGroup = "p";
		   			}
	   				
	   				var infoHTML = "";
	   				
	   				if(isGroup !== "p"){
	   					var geTasksCount = ge.tasks.length;
	   					
	   					for (var i = 0; i < geTasksCount; i++) {
	   						var geTask = ge.tasks[i];
	   						
	   						if (geTask.id == taskId) {
	   							var start = dateToYYYYMMDD(new Date(geTask.start));
	   		   					var end = dateToYYYYMMDD(new Date(geTask.end));
	   		   					
	   							infoHTML += "<div class='tooltipTitle'>" + geTask.name + "</div>";
	   							infoHTML += "<div class='tooltipText'>";
	   							infoHTML += "<spring:message code='ezPMS.t61' /> : " + start + "<br>";
	   							infoHTML += "<spring:message code='ezPMS.t62' /> : " + end + "<br>";
	   							infoHTML += "<spring:message code='ezPMS.t352' /> : " + geTask.duration + "<br>";
	   							infoHTML += "<spring:message code='ezPMS.t250' /> : " + geTask.progress + "%";
	   							infoHTML += "</div>";
	   						}
	   					}
	   				} else {
	   					var start = dateToYYYYMMDD(new Date(ge.tasks[0].start));
	   					var end = dateToYYYYMMDD(new Date(ge.tasks[0].end));
	   					
						infoHTML += "<div class='tooltipTitle'>" + ge.tasks[0].name + "</div>";
						infoHTML += "<div class='tooltipText'>";
						infoHTML += "<spring:message code='ezPMS.t61' /> : " + start + "<br>";
						infoHTML += "<spring:message code='ezPMS.t62' /> : " + end + "<br>";
						infoHTML += "<spring:message code='ezPMS.t352' /> : " + ge.tasks[0].duration + "<br>";
						infoHTML += "<spring:message code='ezPMS.t250' /> : " + ge.tasks[0].progress + "<br>";
						infoHTML += "</div>";
	   				}
	   				
	   				$(".tooltipBox").html(infoHTML);
	                $('.tooltipBox').show();
	            }).on("mouseout", ".taskBox", function(event) {
	            	positionTooltip(event);
	            	$('.tooltipBox').hide();
            	});
	   			
	   			eventSetting();
	   			ganttRedesign();
	   			//기존 키다운 이벤트를 없앰.
	   			$("body").off("keydown.body");
	   			ge.splitter.resize(50);
// 		   		document.getElementById("pmsGanttRowSaveBtn").onclick = saveTask;

	   		};
	   		
	   		$(document).ready(function() {	   			
	   			$(".tooltipBox").hide();

	   			GridEditor.prototype.openFullEditor = function (task, editOnlyAssig) {
	   			  var self = this;

	   			  if (!self.master.permissions.canSeePopEdit) {
	   				return;  
	   			  }
	   			  
	   			  var taskRow = task.rowElement;
	   			  var taskId = taskRow.attr("taskId");
	   			  var onlyTaskId = taskId.substring(task.id.lastIndexOf("_") + 2);
	   			  var projectId = taskId.match(/p(\d+)/)[1];
	   			  var feature = GetOpenPosition(835, 810);
	   			  
	   			  if (task.id.substring(1).indexOf("t") != -1) {
	   				window.open("/ezPMS/getTaskDetails.do?projectId=" + projectId + "&taskId=" + onlyTaskId + "&userIdType=user",
								"", "width=835, height=810, resizable=no, scrollbars=no, status=no" + feature);
	   				/* var feature = GetOpenPosition(0, 0);
		   			DivPopUpShow(845, 600, "/ezPMS/getTaskDetails.do?projectId=" + projectId + "&taskId=" + onlyTaskId + "&userIdType=user"); */
	   			  } else if (task.id.substring(1).indexOf("g") != -1) {
	   				window.open("/ezPMS/getGroupDetails.do?projectId=" + projectId + "&groupId=" + onlyTaskId,
								"", "width=835, height=810, resizable=no, scrollbars=no, status=no" + feature);
	   			/* 	var feature = GetOpenPosition(0, 0);
		   			DivPopUpShow(845, 600, "/ezPMS/getGroupDetails.do?projectId=" + projectId + "&groupId=" + onlyTaskId);   */
	   			  }
	   			//var top = ($(window).height() - $(this).outerHeight()) / 2;
	   			//var left = ($(window).width() - $(this).outerWidth()) / 2;
	   		     };
	   		     
	   			//필터일 경우 셀렉트의 값을 변경해준다.
	   			var taskStatus = "<c:out value='${taskStatus}'/>";
	   			
	   			if (taskStatus !== "") {
		   			document.querySelector("#pmsGanttViewBtn select").value = taskStatus;
	   			}
	   			document.querySelector("#pmsGanttZoomBtn select").value = ganttData.zoom;
	   			
	   			if (userRoleId == 1) {
	   				$("#pmsGanttRowNewBtn").css("display", "");
	   				$("#pmsGanttAddGroup").css("display", "");
	   				$("#pmsGanttRowDelBtn").css("display", "");
	   				$("#pmsGanttDelGroup").css("display", "");
	   				
	   			}
	   		})

	   		function getMemberSchedule() {
   				var top = 10;
   			    var left = ($(window).width() - $(this).outerWidth()) / 2;
   				var feature = GetOpenPosition(top, left);
   			 	

   		        document.getElementById("iFrameLayer").src = "/ezPMS/getMemberSchedule.do?projectId=" + projectId;
   		        document.getElementById("iFramePanel").style.top = "5%";
   		        document.getElementById("iFramePanel").style.left = "6%";
   		        document.getElementById("iFramePanel").style.height = "77%";
   		        document.getElementById("iFramePanel").style.width = "91%";
   		        document.getElementById("iFrameLayer").style.width = "100%";
   		        document.getElementById("iFrameLayer").style.height = "100%";
   		        document.getElementById("mailPanel").style.display = "";
   		        document.getElementById("iFramePanel").style.display = "";

   				$("<div id='blockLeft' class='blockLeft' style='background:none rgba(0, 0, 0, 0.4)'></div>").appendTo(parent.parent.frames["left"].document.body);
   				$("<div id='blockTop' class='blockTop' style='height:86px;background:none rgba(0, 0, 0, 0.4)'></div>").appendTo(parent.parent.frames["right"].document.body);
   				//DivPopUpShow(1500, 636, "/ezPMS/getMemberSchedule.do?projectId=" + projectId);
	   		}
	   		
	   		function DivMemberSchedulePopUpHidden() {
	   		    try {
	   		        document.getElementById("mailPanel").style.display = "none";
	   		        document.getElementById("iFramePanel").style.display = "none";
	   		     	document.getElementById("iFramePanel").style.width = "";
	   		        document.getElementById("iFrameLayer").src = "/blank.htm";
	   				$("#blockLeft", parent.parent.frames["left"].document).remove();
	   				$("#blockTop", parent.parent.frames["right"].document).remove();
	   		    } catch (e) {}
	   		}
	   		
	   		//엑셀 저장
	   		function exportExcel() {
	   			var tasks = $(".taskEditRow").not(".emptyRow");
	   			
	   			var taskId = "";
	   			var taskLevel = "";
	   			var taskCount = tasks.length;
	   			
	   			for (var i = 0; i < taskCount; i++) {
	   				taskId += $("#" + tasks[i].id).attr("taskid") + ",";
	   				taskLevel += $("#" + tasks[i].id).attr("level") + ",";
	   			}
	   			
	   			taskId = taskId.substring(0, taskId.length - 1);
	   			taskLevel = taskLevel.substring(0, taskLevel.length - 1);
	   			
	   			$("input[name='taskId']").val(taskId);
	   			$("input[name='taskLevel']").val(taskLevel);
	   			$("input[name='projectId']").val(projectId);
	   			
	   			document.exportGantt.action = "/ezPMS/exportGanttExcel.do";
	   			document.exportGantt.method = "POST";
	   			document.exportGantt.submit();
			}
	   		
	   		function updateTaskName(elem){
	   			var curTask = ge.currentTask;
		   		var newTaskName = elem.value.trim();
		   		var prevTaskName = curTask.name;
		   		var taskType = curTask.type;
		   		var taskId = getIdAndgroupId(curTask,taskType).id;
		   		var prevTasks = Array.prototype.slice.call(ge.tasks);
		   		var upperGroupId = getIdAndgroupId(curTask,taskType).groupId;
		   		var flag = true;
		   		
		   		if (newTaskName === prevTaskName) {
		   			return;
		   		}
		   		
		   		//업무 이름 길이 제한
		   		if (newTaskName.length == 0) {
		   			alert("<spring:message code='ezPMS.t90' />");
		   			flag = false;
		   		} else if (newTaskName.length > 100) {
		   			alert("<spring:message code='ezPMS.t91' />");
		   			flag = false;
		   		}
		   		
		   		if (!flag) {
		   			ge.loadTasks(prevTasks);
   					ge.redraw();
	   				return;
		   		}
	   			
		   		var data = {
						taskName : newTaskName,
						taskType : taskType,
						taskId : taskId,
						projectId : projectId,
						groupId : upperGroupId
				}
		   		
				$.ajax({
					type : "POST",
					url : "/ezPMS/updateTaskName.do",
					dataType : "text",
					contentType: "application/json; charset=UTF-8",
					data : JSON.stringify(data),
					success : function(data) {
						if(data !== "rejected"){
							var logContent = ""; 
							
		   					if(taskType == "p"){
								logContent = "<spring:message code='ezPMS.t364' arguments='" + replaceString(prevTaskName) + "," + replaceString(newTaskName) +"'/>"; 
								addTaskLog(projectId, 2, projectGroupId, null, logContent);
		   					} else if(taskType == "t") {
								logContent = "<spring:message code='ezPMS.t351' arguments='" + replaceString(prevTaskName) + "," + replaceString(newTaskName) +"'/>"; 
								addTaskLog(projectId, 2, upperGroupId, taskId, logContent);
		   					} else {
								logContent = "<spring:message code='ezPMS.t363' arguments='" + replaceString(prevTaskName) + "," + replaceString(newTaskName) +"'/>"; 
		   						var groupId = taskId;
								addTaskLog(projectId, 2, groupId, null, logContent);
		   					}
						} else {
							ge.currentTask.name = prevTaskName;
							alert("<spring:message code='ezPMS.t322'/>");
				   			ge.loadTasks(prevTasks);
		   					ge.redraw();
			   				return;
						}
	   					
					}
				});
	   		
	   		}
	   		
	   		function getIdAndgroupId(task, taskType){
	   			var targetId = "";
	   			var groupId = "";
	   			
	   			if (taskType === "p") {
	   				targetId = task.id.match(/p(\d+)/)[1];
	   				groupId = projectGroupId;
		   		} else if(taskType === "t") {
		   			targetId = task.id.match(/t(\d+)/)[1];
		   			
		   			if (task.id.indexOf("g") == -1) {
		   				groupId = projectGroupId;
		   			} else {
		   				groupId = task.id.match(/g(\d+)/)[1];
		   			}
		   		} else {
		   			targetId = task.id.match(/g(\d+)/)[1];
		   			var ancestorGroupArr = task.code.split(",");
		   			groupId = ancestorGroupArr[ancestorGroupArr.indexOf(targetId) - 1];
		   		}
	   			
	   			return {"id" : targetId, "groupId" : groupId}
	   		}
	   		
		</script>
		<style>
		/* 		  달력 깨지지 않게 하기위함. */
		  .calBox span{
		  	clear: none;
		  }
		  
		  li.pmsGanttZoomBtn {
		  	float: right;
		  	list-style: none;
		  }
		  
		  .gdfCell {
		    overflow: hidden;
		    padding: 0px 5px;
		    border-bottom: 1px solid #eee;
		    border-right: 1px solid #eee;
	      }
	      
	      .gdfCell input[readonly]{
	      	cursor: default;
	      }
		  
		  th{
		  	padding: 0px
		  }
		  
		  .gdfTable td, .gdfTable th {
		    font-size: 12px;
		  }
		  
		  .taskEditRow input, .columnWidthTest {
		    font-size: 12px;
		  }
		  
		  .pmsGanttZoomBtn{
		  	margin: 0px 0px 0px 30px;
		  }
		  
		  #ndo{
		  	display:none;
		  }
		  .tooltipBox {
		  	position:absolute;
		  	width:200px;
		  	border:1px solid #4e4e46;
		  }
		  
		  .tooltipBox .tooltipTitle { 
		  	height: 33px; 
		  	line-height: 33px; 
		  	padding: 0px 10px; 
		  	background: #f0f6ff; 
		  	border: 1px solid #d1ddec; 
		  	font-size:14px; 
		  	white-space: nowrap; 
		  	text-overflow: ellipsis; 
		  	overflow: hidden; 
		  }
		  
		  .tooltipBox .tooltipText {
		    padding:10px; 
		    background:#fff; 
		    font-size:12px; 
		    line-height:22px;
		    }
		  
		  .toastArea {
		  	position : absolute;
		  	background : #ffffa8;
		  	border : 1px solid #d1d1d1;
			display : none;
		  }

		  .taskEditRow .typeImgDiv {
		  	display: inline-block;
		    width: 16px;
		    height: 16px;
		    position: relative;
		    top: 3px;
		    vertical-align: top;
		    margin-left: -3px;
		  }
		  
		  .taskEditRow.project .typeImgDiv, .taskEditRow.group .typeImgDiv{
		  	background-image: url(/images/OrganTree_cross/fldr.gif);
		  }
		  
		  .taskEditRow.task .typeImgDiv{
		  	background-image: url(/images/ezPMS/icon_project.png);
		  }
		  
		  .taskAssigs{cursor:default;}
		  
		</style>
	</head>
	<body style="background-color: #fff; margin:10px 10px 0px 10px;">
		<div id="mainmenu" class="pmsMenuDiv" style="height: 30px;">
			<ul class="pmsGanttMenuUl">
		        <li id="pmsGanttRowNewBtn" class="pmsGanttMenuLi" style="display:none;"><span><spring:message code='ezPMS.t89' /></span></li>
		        <!-- <li id="pmsGanttRowSaveBtn" class="pmsGanttMenuLi">save</li> -->
		        <!--  <li id="pmsGanttTaskDetails" class="pmsGanttMenuLi">details</li> -->
		        <li id="pmsGanttAddGroup" class="pmsGanttMenuLi" style="display:none;"><span><spring:message code='ezPMS.t82' /></span></li>
		        <li id="pmsGanttRowDelBtn" class="pmsGanttMenuLi" style="display:none;"><span><spring:message code='ezPMS.t287' /></span></li>
		        <li id="pmsGanttDelGroup" class="pmsGanttMenuLi" style="display:none;"><span><spring:message code='ezPMS.t288' /></span></li>
		        <li><span onclick="getMemberSchedule()"><spring:message code='ezPMS.t290' /></span></li>
		        <li onclick="exportExcel()"><span><spring:message code='ezPMS.t350' /></span></li>
		        <div style="float:right">
		        <li id="pmsGanttViewBtn" class="pmsGanttZoomBtn">
					<select>
						<option value="A"><spring:message code='ezPMS.t14' />&nbsp<spring:message code='ezPMS.t137' /></option>
						<option value="W"><spring:message code='ezPMS.t16' />&nbsp<spring:message code='ezPMS.t137' /></option>
						<option value="P"><spring:message code='ezPMS.t15' />&nbsp<spring:message code='ezPMS.t137' /></option>
						<option value="C"><spring:message code='ezPMS.t17' />&nbsp<spring:message code='ezPMS.t137' /></option>
						<option value="S"><spring:message code='ezPMS.t19' />&nbsp<spring:message code='ezPMS.t137' /></option>
						<option value="L"><spring:message code='ezPMS.t18' />&nbsp<spring:message code='ezPMS.t137' /></option>
					</select>
		        </li>
		        <li id="pmsGanttZoomBtn" class="pmsGanttZoomBtn">
					<select>
						<option value="3d"><spring:message code='ezPMS.t251' /></option>
						<option value="1w"><spring:message code='ezPMS.t252' /></option>
						<option value="1M"><spring:message code='ezPMS.t289' /></option>
						<option value="1Q"><spring:message code='ezPMS.t253' /></option>
						<option value="1y"><spring:message code='ezPMS.t254' /></option>
					</select>
		        </li>
		        </div>
		    </ul>
		</div>
		
		<div id="workSpace" style="padding:0px; overflow-y:auto; overflow-x:hidden; position:relative;"></div>
		
		<style>
		  .resEdit {
		    padding: 15px;
		  }
		
		  .resLine {
		    width: 95%;
		    padding: 3px;
		    margin: 5px;
		    border: 1px solid #d0d0d0;
		  }
		
		  body {
		    overflow: hidden;
		  }
		
		  .ganttButtonBar h1{
		    color: #000000;
		    font-weight: bold;
		    font-size: 28px;
		    margin-left: 10px;
		  }
		</style>
		
		<form id="gimmeBack" style="display:none;" action="../gimmeBack.jsp" method="post" target="_blank"><input type="hidden" name="prj" id="gimBaPrj"></form>
		
		<script type="text/javascript">
			var ge;
			$(function() {
			  var canWrite = true; //this is the default for test purposes
			
			  // here starts gantt initialization
			  ge = new GanttMaster();
			  ge.set100OnClose = true;
			  ge.shrinkParent = true;
// 			  ge.showBaselines = true;
			
			  ge.init($("#workSpace"));
			  loadI18n(); //overwrite with localized ones
			
			  //in order to force compute the best-fitting zoom level
			  delete ge.gantt.zoom;
			
			  var project = getGanttProject();
			
			  if (!project.canWrite)
			    $(".ganttButtonBar button.requireWrite").attr("disabled","true");
			
			  ge.loadProject(project);
			  ge.checkpoint(); //empty the undo stack
			});
			
			
			
			function getGanttProject(){
				ret = ganttData;	
			    //전체 업무 날짜에 offset을 더해줌.
// 			    var offset = new Date().getTime() - ret.tasks[0].start;
			    var offset = 0;
			    var retTasksCount = ret.tasks.length;
			    
			    for (var i = 0; i < retTasksCount; i++) {
			      ret.tasks[i].start = ret.tasks[i].start + offset;
			    }
			  return ret;
			}
			
			
			
			function loadGanttFromServer(taskId, callback) {
			
			  //this is a simulation: load data from the local storage if you have already played with the demo or a textarea with starting demo data
			  var ret = loadFromLocalStorage();
			
			  //this is the real implementation
			  /*
			  //var taskId = $("#taskSelector").val();
			  var prof = new Profiler("loadServerSide");
			  prof.reset();
			
			  $.getJSON("ganttAjaxController.jsp", {CM:"LOADPROJECT",taskId:taskId}, function(response) {
			    //console.debug(response);
			    if (response.ok) {
			      prof.stop();
			
			      ge.loadProject(response.project);
			      ge.checkpoint(); //empty the undo stack
			
			      if (typeof(callback)=="function") {
			        callback(response);
			      }
			    } else {
			      jsonErrorHandling(response);
			    }
			  });
			  */
			
			  return ret;
			}
			
			
			function saveGanttOnServer() {
			
			  //this is a simulation: save data to the local storage or to the textarea
			  saveInLocalStorage();
			
			  /*
			  var prj = ge.saveProject();
			
			  delete prj.resources;
			  delete prj.roles;
			
			  var prof = new Profiler("saveServerSide");
			  prof.reset();
			
			  if (ge.deletedTaskIds.length>0) {
			    if (!confirm("TASK_THAT_WILL_BE_REMOVED\n"+ge.deletedTaskIds.length)) {
			      return;
			    }
			  }
			
			  $.ajax("ganttAjaxController.jsp", {
			    dataType:"json",
			    data: {CM:"SVPROJECT",prj:JSON.stringify(prj)},
			    type:"POST",
			
			    success: function(response) {
			      if (response.ok) {
			        prof.stop();
			        if (response.project) {
			          ge.loadProject(response.project); //must reload as "tmp_" ids are now the good ones
			        } else {
			          ge.reset();
			        }
			      } else {
			        var errMsg="Errors saving project\n";
			        if (response.message) {
			          errMsg=errMsg+response.message+"\n";
			        }
			
			        if (response.errorMessages.length) {
			          errMsg += response.errorMessages.join("\n");
			        }
			
			        alert(errMsg);
			      }
			    }
			
			  });
			  */
			}
			
			function newProject(){
			  clearGantt();
			}
			
			
			function clearGantt() {
			  ge.reset();
			}
			
			//-------------------------------------------  Get project file as JSON (used for migrate project from gantt to Teamwork) ------------------------------------------------------
			function getFile() {
			  $("#gimBaPrj").val(JSON.stringify(ge.saveProject()));
			  $("#gimmeBack").submit();
			  $("#gimBaPrj").val("");
			
			  /*  var uriContent = "data:text/html;charset=utf-8," + encodeURIComponent(JSON.stringify(prj));
			   neww=window.open(uriContent,"dl");*/
			}
			
			
			function loadFromLocalStorage() {
			  var ret;
			  
			  if (localStorage) {
			    if (localStorage.getObject("teamworkGantDemo")) {
			      ret = localStorage.getObject("teamworkGantDemo");
			    }
			  }
			
			  //if not found create a new example task
			  if (!ret || !ret.tasks || ret.tasks.length == 0){
			    ret=getGanttProject();
			  }
			  
			  return ret;
			}
			
			
			function saveInLocalStorage() {
			  var prj = ge.saveProject();
			  if (localStorage) {
			    localStorage.setObject("teamworkGantDemo", prj);
			  }
			}
			
			
			//-------------------------------------------  Open a black popup for managing resources. This is only an axample of implementation (usually resources come from server) ------------------------------------------------------
			function editResources(){
			
			  //make resource editor
			  var resourceEditor = $.JST.createFromTemplate({}, "RESOURCE_EDITOR");
			  var resTbl = resourceEditor.find("#resourcesTable");
			
			  for (var i=0 ; i < ge.resources.length; i++){
			    var res = ge.resources[i];
			    resTbl.append($.JST.createFromTemplate(res, "RESOURCE_ROW"))
			  }
			
			
			  //bind add resource
			  resourceEditor.find("#addResource").click(function(){
			    resTbl.append($.JST.createFromTemplate({id:"new",name:"resource"}, "RESOURCE_ROW"))
			  });
			
			  //bind save event
			  resourceEditor.find("#resSaveButton").click(function(){
			    var newRes = [];
			    //find for deleted res
			    for (var i = 0; i < ge.resources.length; i++){
			      var res = ge.resources[i];
			      var row = resourceEditor.find("[resId=" + res.id + "]");
			      if (row.length > 0){
			        //if still there save it
			        var name = row.find("input[name]").val();
			        if (name && name!="")
			          res.name = name;
			        newRes.push(res);
			      } else {
			        //remove assignments
			        for (var j = 0; j < ge.tasks.length; j++){
			          var task = ge.tasks[j];
			          var newAss = [];
			          for (var k = 0; k < task.assigs.length; k++){
			            var ass = task.assigs[k];
			            if (ass.resourceId != res.id)
			              newAss.push(ass);
			          }
			          task.assigs = newAss;
			        }
			      }
			    }
			
			    //loop on new rows
			    var cnt = 0;
			    resourceEditor.find("[resId=new]").each(function(){
			      cnt++;
			      var row = $(this);
			      var name = row.find("input[name]").val();
			      if (name && name != "")
			        newRes.push (new Resource("tmp_" + new Date().getTime() + "_" + cnt, name));
			    });
			
			    ge.resources = newRes;
			
			    closeBlackPopup();
			    ge.redraw();
			  });
			
			
			  var ndo = createModalPopup(400, 500).append(resourceEditor);
			}
			
			function initializeHistoryManagement(){
			
			  //si chiede al server se c'è della hisory per la root
			  $.getJSON(contextPath + "/applications/teamwork/task/taskAjaxController.jsp", {CM: "GETGANTTHISTPOINTS", OBJID:10236}, function (response) {
			
			    //se c'è
			    if (response.ok == true && response.historyPoints && response.historyPoints.length>0) {
			
			      //si crea il bottone sulla bottoniera
			      var histBtn = $("<button>").addClass("button textual icon lreq30 lreqLabel").attr("title", "SHOW_HISTORY").append("<span class=\"teamworkIcon\">&#x60;</span>");
			
			      //al click
			      histBtn .click(function () {
			        var el = $(this);
			        var ganttButtons = $(".ganttButtonBar .buttons");
			
			        //è gi�  in modalit�  history?
			        if (!ge.element.is(".historyOn")) {
			          ge.element.addClass("historyOn");
			          ganttButtons.find(".requireCanWrite").hide();
			
			          //si carica la history server side
			          if (false) return;
			          showSavingMessage();
			          $.getJSON(contextPath + "/applications/teamwork/task/taskAjaxController.jsp", {CM: "GETGANTTHISTPOINTS", OBJID: ge.tasks[0].id}, function (response) {
			            jsonResponseHandling(response);
			            hideSavingMessage();
			            if (response.ok == true) {
			              var dh = response.historyPoints;
			              //ge.historyPoints=response.historyPoints;
			              if (dh && dh.length > 0) {
			                //si crea il div per lo slider
			                var sliderDiv = $("<div>").prop("id", "slider").addClass("lreq30 lreqHide").css({"display":"inline-block","width":"500px"});
			                ganttButtons.append(sliderDiv);
			
			                var minVal = 0;
			                var maxVal = dh.length - 1 ;
			
			                $("#slider").show().mbSlider({
			                  rangeColor : '#2f97c6',
			                  minVal     : minVal,
			                  maxVal     : maxVal,
			                  startAt    : maxVal,
			                  showVal    : false,
			                  grid       :1,
			                  formatValue: function (val) {
			                    return new Date(dh[val]).format();
			                  },
			                  onSlideLoad: function (obj) {
			                    this.onStop(obj);
			
			                  },
			                  onStart    : function (obj) {},
			                  onStop     : function (obj) {
			                    var val = $(obj).mbgetVal();
			                    showSavingMessage();
			                    $.getJSON(contextPath + "/applications/teamwork/task/taskAjaxController.jsp", {CM: "GETGANTTHISTORYAT", OBJID: ge.tasks[0].id, millis:dh[val]}, function (response) {
			                      jsonResponseHandling(response);
			                      hideSavingMessage();
			                      if (response.ok ) {
			                        ge.baselines=response.baselines;
			                        ge.showBaselines=true;
			                        ge.baselineMillis=dh[val];
			                        ge.redraw();
			                      }
			                    })
			
			                  },
			                  onSlide    : function (obj) {
			                    clearTimeout(obj.renderHistory);
			                    var self = this;
			                    obj.renderHistory = setTimeout(function(){
			                      self.onStop(obj);
			                    }, 200)
			
			                  }
			                });
			              }
			            }
			          });
			
			
			          // quando si spenge
			        } else {
			          //si cancella lo slider
			          $("#slider").remove();
			          ge.element.removeClass("historyOn");
			          if (ge.permissions.canWrite)
			            ganttButtons.find(".requireCanWrite").show();
			
			          ge.showBaselines=false;
			          ge.baselineMillis=undefined;
			          ge.redraw();
			        }
			
			      });
			      $("#saveGanttButton").before(histBtn);
			    }
			  })
			}
			
			function showBaselineInfo (event,element){
			  //alert(element.attr("data-label"));
			  $(element).showBalloon(event, $(element).attr("data-label"));
			  ge.splitter.secondBox.one("scroll",function(){
			    $(element).hideBalloon();
			  })
			}
			
			</script>
			
			
			
			
			
			<div id="gantEditorTemplates" style="display:none;">
			<div class="__template__" type="GANTBUTTONS"><!--
			  <div class="ganttButtonBar noprint" style="display:none">
			    <div class="buttons">
			      <button onclick="$('#workSpace').trigger('undo.gantt');return false;" class="button textual icon requireCanWrite" title="undo"><span class="teamworkIcon">&#39;</span></button>
			      <button onclick="$('#workSpace').trigger('redo.gantt');return false;" class="button textual icon requireCanWrite" title="redo"><span class="teamworkIcon">&middot;</span></button>
			      <span class="ganttButtonSeparator requireCanWrite requireCanAdd"></span>
			      <button onclick="$('#workSpace').trigger('addAboveCurrentTask.gantt');return false;" class="button textual icon requireCanWrite requireCanAdd" title="insert above"><span class="teamworkIcon">l</span></button>
			      <button onclick="$('#workSpace').trigger('addBelowCurrentTask.gantt');return false;" class="button textual icon requireCanWrite requireCanAdd" title="insert below"><span class="teamworkIcon">X</span></button>
			      <span class="ganttButtonSeparator requireCanWrite requireCanInOutdent"></span>
			      <button onclick="$('#workSpace').trigger('outdentCurrentTask.gantt');return false;" class="button textual icon requireCanWrite requireCanInOutdent" title="un-indent task"><span class="teamworkIcon">.</span></button>
			      <button onclick="$('#workSpace').trigger('indentCurrentTask.gantt');return false;" class="button textual icon requireCanWrite requireCanInOutdent" title="indent task"><span class="teamworkIcon">:</span></button>
			      <span class="ganttButtonSeparator requireCanWrite requireCanMoveUpDown"></span>
			      <button onclick="$('#workSpace').trigger('moveUpCurrentTask.gantt');return false;" class="button textual icon requireCanWrite requireCanMoveUpDown" title="move up"><span class="teamworkIcon">k</span></button>
			      <button onclick="$('#workSpace').trigger('moveDownCurrentTask.gantt');return false;" class="button textual icon requireCanWrite requireCanMoveUpDown" title="move down"><span class="teamworkIcon">j</span></button>
			      <span class="ganttButtonSeparator requireCanWrite requireCanDelete"></span>
			      <button onclick="$('#workSpace').trigger('deleteFocused.gantt');return false;" class="button textual icon delete requireCanWrite" title="Elimina"><span class="teamworkIcon">&cent;</span></button>
			      <span class="ganttButtonSeparator"></span>
			      <button onclick="$('#workSpace').trigger('expandAll.gantt');return false;" class="button textual icon " title="EXPAND_ALL"><span class="teamworkIcon">6</span></button>
			      <button onclick="$('#workSpace').trigger('collapseAll.gantt'); return false;" class="button textual icon " title="COLLAPSE_ALL"><span class="teamworkIcon">5</span></button>
			
			    <span class="ganttButtonSeparator"></span>
			      <button onclick="$('#workSpace').trigger('zoomMinus.gantt'); return false;" class="button textual icon " title="zoom out"><span class="teamworkIcon">)</span></button>
			      <button onclick="$('#workSpace').trigger('zoomPlus.gantt');return false;" class="button textual icon " title="zoom in"><span class="teamworkIcon">(</span></button>
			    <span class="ganttButtonSeparator"></span>
			      <button onclick="$('#workSpace').trigger('print.gantt');return false;" class="button textual icon " title="Print"><span class="teamworkIcon">p</span></button>
			    <span class="ganttButtonSeparator"></span>
			      <button onclick="ge.gantt.showCriticalPath=!ge.gantt.showCriticalPath; ge.redraw();return false;" class="button textual icon requireCanSeeCriticalPath" title="CRITICAL_PATH"><span class="teamworkIcon">&pound;</span></button>
			    <span class="ganttButtonSeparator requireCanSeeCriticalPath"></span>
			      <button onclick="ge.splitter.resize(.1);return false;" class="button textual icon" ><span class="teamworkIcon">F</span></button>
			      <button onclick="ge.splitter.resize(50);return false;" class="button textual icon" ><span class="teamworkIcon">O</span></button>
			      <button onclick="ge.splitter.resize(100);return false;" class="button textual icon"><span class="teamworkIcon">R</span></button>
			      <span class="ganttButtonSeparator"></span>
			      <button onclick="$('#workSpace').trigger('fullScreen.gantt');return false;" class="button textual icon" title="FULLSCREEN" id="fullscrbtn"><span class="teamworkIcon">@</span></button>
			      <button onclick="ge.element.toggleClass('colorByStatus' );return false;" class="button textual icon"><span class="teamworkIcon">&sect;</span></button>
			
			    <button onclick="editResources();" class="button textual requireWrite" title="edit resources"><span class="teamworkIcon">M</span></button>
			      &nbsp; &nbsp; &nbsp; &nbsp;
			    <button onclick="saveGanttOnServer();" class="button first big requireWrite" title="Save">Save</button>
			    <button onclick='newProject();' class='button requireWrite newproject'><em>clear project</em></button>
			    <button class="button login" title="login/enroll" onclick="loginEnroll($(this));" style="display:none;">login/enroll</button>
			    <button class="button opt collab" title="Start with Twproject" onclick="collaborate($(this));" style="display:none;"><em>collaborate</em></button>
			    </div></div>
			  --></div>
			
			<div class="__template__" type="TASKSEDITHEAD"><!--
			  <table class="gdfTable" cellspacing="0" cellpadding="0">
			    <thead>
			    <tr style="height:40px">
			      <th class="gdfColHeader" style="width:35px; border-right: none"></th>
			      <th class="gdfColHeader" style="width:25px; display:none;"></th>
			      <th class="gdfColHeader gdfResizable" style="width:240px;"><spring:message code='ezPMS.t98'/></th>
			      <th class="gdfColHeader gdfResizable" style="width:100px; display:none;">code/short name</th>
			      <th class="gdfColHeader"  align="center" style="width:17px; display:none;" title="Start date is a milestone."><span class="teamworkIcon" style="font-size: 8px;">^</span></th>
			      <th class="gdfColHeader gdfResizable" style="width:80px;"><spring:message code='ezPMS.t61'/></th>
			      <th class="gdfColHeader"  align="center" style="width:17px; display:none;" title="End date is a milestone."><span class="teamworkIcon" style="font-size: 8px;">^</span></th>
			      <th class="gdfColHeader gdfResizable" style="width:80px;"><spring:message code='ezPMS.t62'/></th>
			      <th class="gdfColHeader gdfResizable" style="width:50px;"><spring:message code='ezPMS.t352'/></th>
			      <th class="gdfColHeader gdfResizable" style="width:50px;"><spring:message code='ezPMS.t267'/></th>
			      <th class="gdfColHeader gdfResizable" style="width:60px;"><spring:message code='ezPMS.t178'/><spring:message code='ezPMS.t250'/></th>
			      <th class="gdfColHeader gdfResizable" style="width:60px;"><spring:message code='ezPMS.t177'/><spring:message code='ezPMS.t250'/></th>
			      <th class="gdfColHeader gdfResizable requireCanSeeDep" style="width:50px;"><spring:message code='ezPMS.t181'/></th>
			      <th class="gdfColHeader gdfResizable" style="width:1000px; text-align: left; padding-left: 10px;"><spring:message code='ezPMS.t63'/></th>
			    </tr>
			    </thead>
			  </table>
			  --></div>
			
			<div class="__template__" type="TASKROW"><!--
			  <tr id="tid_(#=obj.id#)" taskId="(#=obj.id#)" class="taskEditRow (#=obj.isParent()?'isParent':''#) (#=obj.collapsed?'collapsed':''#) (#=obj.type == 'p' ? 'project' : obj.type == 'g' ? 'group' : 'task'#)" level="(#=level#)">
			    <td class="gdfCell edit" align="right" style="cursor:pointer;"><span class="taskRowIndex">(#=obj.getRow()+1#)</span> </td>
			    <td class="gdfCell noClip" style="display:none" align="center"><div class="taskStatus cvcColorSquare" status="(#=obj.status#)"></div></td>
			    <td class="gdfCell indentCell" style="padding-left:(#=obj.level*10+22#)px;">
			      <div class="exp-controller" align="center"></div>
			      <div class="typeImgDiv" align="center"></div>
			      <input type="text" name="name" value="(#=obj.name#)" placeholder="<spring:message code='ezPMS.t264'/>" title="(#=obj.name#)" >
			    </td>
			    <td class="gdfCell" style="display:none"><input type="text" name="code" value="(#=obj.code?obj.code:''#)" placeholder="code/short name"></td>
			    <td class="gdfCell" style="display:none" align="center"><input type="checkbox" name="startIsMilestone"></td>
			    <td class="gdfCell"><input type="text" name="start"  value="" class="date"></td>
			    <td class="gdfCell" style="display:none" align="center"><input type="checkbox" name="endIsMilestone"></td>
			    <td class="gdfCell"><input type="text" name="end" value="" class="date"></td>
			    <td class="gdfCell"><input type="text" name="duration" autocomplete="off" value="(#=obj.duration#)"></td>
			    <td class="gdfCell"><input type="text" name="weight" autocomplete="off" value="(#=obj.weight#)"></td>
			    <td class="gdfCell"><input type="text" name="realProgress" class="validated" entrytype="PERCENTILE" autocomplete="off" value="(#=obj.realProgress?obj.realProgress:''#)" (#=obj.progressByWorklog?"readOnly":""#)></td>
			    <td class="gdfCell"><input type="text" name="planProgress" class="validated" entrytype="PERCENTILE" autocomplete="off" value="(#=obj.planProgress?obj.planProgress:''#)" (#=obj.progressByWorklog?"readOnly":""#)></td>
			    <td class="gdfCell requireCanSeeDep"><input type="text" name="depends" autocomplete="off" value="(#=obj.depends#)" (#=obj.hasExternalDep?"readonly":""#) title="(#=obj.pretaskName#)"></td>
			    <td class="gdfCell taskAssigs" title="(#=obj.getAssigsString()#)">(#=obj.getSimpleAssigsStr()#)</td>
			  </tr>
			  --></div>
			
			<div class="__template__" type="TASKEMPTYROW"><!--
			  <tr class="taskEditRow emptyRow" >
			    <td class="gdfCell" align="right"></td>
			    <td class="gdfCell noClip" align="center"></td>
			    <td class="gdfCell"></td>
			    <td class="gdfCell"></td>
			    <td class="gdfCell"></td>
			    <td class="gdfCell"></td>
			    <td class="gdfCell"></td>
			    <td class="gdfCell"></td>
			    <td class="gdfCell"></td>
			    <td class="gdfCell"></td>
			    <td class="gdfCell"></td>
			    <td class="gdfCell requireCanSeeDep"></td>
			    <td class="gdfCell"></td>
			  </tr>
			  --></div>
			
			<div class="__template__" type="TASKBAR"><!--
			  <div class="taskBox taskBoxDiv" taskId="(#=obj.id#)" >
			    <div class="layout (#=obj.hasExternalDep?'extDep':''#)">
			      <div class="taskStatus" status="(#=obj.status#)"></div>
			      <div class="taskProgress" style="width:(#=obj.progress>100?100:obj.progress#)%; background-color:(#=obj.progress>100?'red':'rgb(153,255,51);'#);"></div>
			      <div class="milestone (#=obj.startIsMilestone?'active':''#)" ></div>
			
			      <div class="taskLabel"></div>
			      <div class="milestone end (#=obj.endIsMilestone?'active':''#)" ></div>
			    </div>
			  </div>
			  --></div>
			
			
			<div class="__template__" type="CHANGE_STATUS"><!--
			    <div class="taskStatusBox">
			    <div class="taskStatus cvcColorSquare" status="STATUS_ACTIVE" title="Active"></div>
			    <div class="taskStatus cvcColorSquare" status="STATUS_DONE" title="Completed"></div>
			    <div class="taskStatus cvcColorSquare" status="STATUS_FAILED" title="Failed"></div>
			    <div class="taskStatus cvcColorSquare" status="STATUS_SUSPENDED" title="Suspended"></div>
			    <div class="taskStatus cvcColorSquare" status="STATUS_WAITING" title="Waiting" style="display: none;"></div>
			    <div class="taskStatus cvcColorSquare" status="STATUS_UNDEFINED" title="Undefined"></div>
			    </div>
			  --></div>
			
			
			
			
			<div class="__template__" type="TASK_EDITOR"><!--
			  <div class="ganttTaskEditor">
			    <h2 class="taskData">Task editor</h2>
			    <table  cellspacing="1" cellpadding="5" width="100%" class="taskData table" border="0">
		          <tr>
			        <td width="200" style="height: 80px"  valign="top">
			          <label for="code">code/short name</label><br>
			          <input type="text" name="code" id="code" value="" size=15 class="formElements" autocomplete='off' maxlength=255 style='width:100%' oldvalue="1">
			        </td>
			        <td colspan="3" valign="top"><label for="name" class="required">name</label><br><input type="text" name="name" id="name"class="formElements" autocomplete='off' maxlength=255 style='width:100%' value="" required="true" oldvalue="1"></td>
		          </tr>
			
			
			      <tr class="dateRow">
			        <td nowrap="">
			          <div style="position:relative">
			            <label for="start">start</label>&nbsp;&nbsp;&nbsp;&nbsp;
			            <input type="checkbox" id="startIsMilestone" name="startIsMilestone" value="yes"> &nbsp;<label for="startIsMilestone">is milestone</label>&nbsp;
			            <br><input type="text" name="start" id="start" size="8" class="formElements dateField validated date" autocomplete="off" maxlength="255" value="" oldvalue="1" entrytype="DATE">
			            <span title="calendar" id="starts_inputDate" class="teamworkIcon openCalendar" onclick="$(this).dateField({inputField:$(this).prevAll(':input:first'),isSearchField:false});">m</span>          </div>
			        </td>
			        <td nowrap="">
			          <label for="end">End</label>&nbsp;&nbsp;&nbsp;&nbsp;
			          <input type="checkbox" id="endIsMilestone" name="endIsMilestone" value="yes"> &nbsp;<label for="endIsMilestone">is milestone</label>&nbsp;
			          <br><input type="text" name="end" id="end" size="8" class="formElements dateField validated date" autocomplete="off" maxlength="255" value="" oldvalue="1" entrytype="DATE">
			          <span title="calendar" id="ends_inputDate" class="teamworkIcon openCalendar" onclick="$(this).dateField({inputField:$(this).prevAll(':input:first'),isSearchField:false});">m</span>
			        </td>
			        <td nowrap="" >
			          <label for="duration" class=" ">Days</label><br>
			          <input type="text" name="duration" id="duration" size="4" class="formElements validated durationdays" title="Duration is in working days." autocomplete="off" maxlength="255" value="" oldvalue="1" entrytype="DURATIONDAYS">&nbsp;
			        </td>
			      </tr>
			
			      <tr>
			        <td  colspan="2">
			          <label for="status" class=" ">status</label><br>
			          <select id="status" name="status" class="taskStatus" status="(#=obj.status#)"  onchange="$(this).attr('STATUS',$(this).val());">
			            <option value="STATUS_ACTIVE" class="taskStatus" status="STATUS_ACTIVE" >active</option>
			            <option value="STATUS_WAITING" class="taskStatus" status="STATUS_WAITING" >suspended</option>
			            <option value="STATUS_SUSPENDED" class="taskStatus" status="STATUS_SUSPENDED" >suspended</option>
			            <option value="STATUS_DONE" class="taskStatus" status="STATUS_DONE" >completed</option>
			            <option value="STATUS_FAILED" class="taskStatus" status="STATUS_FAILED" >failed</option>
			            <option value="STATUS_UNDEFINED" class="taskStatus" status="STATUS_UNDEFINED" >undefined</option>
			          </select>
			        </td>
			
			        <td valign="top" nowrap>
			          <label>progress</label><br>
			          <input type="text" name="progress" id="progress" size="7" class="formElements validated percentile" autocomplete="off" maxlength="255" value="" oldvalue="1" entrytype="PERCENTILE">
			        </td>
			      </tr>
			
			          </tr>
			          <tr>
			            <td colspan="4">
			              <label for="description">Description</label><br>
			              <textarea rows="3" cols="30" id="description" name="description" class="formElements" style="width:100%"></textarea>
			            </td>
			          </tr>
			        </table>
			
			    <h2>Assignments</h2>
			  <table  cellspacing="1" cellpadding="0" width="100%" id="assigsTable">
			    <tr>
			      <th style="width:100px;">name</th>
			      <th style="width:70px;">Role</th>
			      <th style="width:30px;">est.wklg.</th>
			      <th style="width:30px;" id="addAssig"><span class="teamworkIcon" style="cursor: pointer">+</span></th>
			    </tr>
			  </table>
			
			  <div style="text-align: right; padding-top: 20px">
			    <span id="saveButton" class="button first" onClick="$(this).trigger('saveFullEditor.gantt');">Save</span>
			  </div>
			
			  </div>
			  --></div>
			
			
			
			<div class="__template__" type="ASSIGNMENT_ROW"><!--
			  <tr taskId="(#=obj.task.id#)" assId="(#=obj.assig.id#)" class="assigEditRow" >
			    <td ><select name="resourceId"  class="formElements" (#=obj.assig.id.indexOf("tmp_")==0?"":"disabled"#) ></select></td>
			    <td ><select type="select" name="roleId"  class="formElements"></select></td>
			    <td ><input type="text" name="effort" value="(#=getMillisInHoursMinutes(obj.assig.effort)#)" size="5" class="formElements"></td>
			    <td align="center"><span class="teamworkIcon delAssig del" style="cursor: pointer">d</span></td>
			  </tr>
			  --></div>
			
			
			
			<div class="__template__" type="RESOURCE_EDITOR"><!--
			  <div class="resourceEditor" style="padding: 5px;">
			
			    <h2>Project team</h2>
			    <table  cellspacing="1" cellpadding="0" width="100%" id="resourcesTable">
			      <tr>
			        <th style="width:100px;">name</th>
			        <th style="width:30px;" id="addResource"><span class="teamworkIcon" style="cursor: pointer">+</span></th>
			      </tr>
			    </table>
			
			    <div style="text-align: right; padding-top: 20px"><button id="resSaveButton" class="button big">Save</button></div>
			  </div>
			  --></div>
			
			
			
			<div class="__template__" type="RESOURCE_ROW"><!--
			  <tr resId="(#=obj.id#)" class="resRow" >
			    <td ><input type="text" name="name" value="(#=obj.name#)" style="width:100%;" class="formElements"></td>
			    <td align="center"><span class="teamworkIcon delRes del" style="cursor: pointer">d</span></td>
			  </tr>
			  --></div>
			
			
			</div>
			<div class="tooltipBox" style="display:hide;"></div>
			<div class="toastArea"></div>
			<script type="text/javascript">
			  $.JST.loadDecorator("RESOURCE_ROW", function(resTr, res){
			    resTr.find(".delRes").click(function(){$(this).closest("tr").remove()});
			  });
			
			  $.JST.loadDecorator("ASSIGNMENT_ROW", function(assigTr, taskAssig){
			    var resEl = assigTr.find("[name=resourceId]");
			    var opt = $("<option>");
			    resEl.append(opt);
			    for(var i=0; i< taskAssig.task.master.resources.length;i++){
			      var res = taskAssig.task.master.resources[i];
			      opt = $("<option>");
			      opt.val(res.id).html(res.name);
			      if(taskAssig.assig.resourceId == res.id)
			        opt.attr("selected", "true");
			      resEl.append(opt);
			    }
			    var roleEl = assigTr.find("[name=roleId]");
			    for(var i=0; i< taskAssig.task.master.roles.length;i++){
			      var role = taskAssig.task.master.roles[i];
			      var optr = $("<option>");
			      optr.val(role.id).html(role.name);
			      if(taskAssig.assig.roleId == role.id)
			        optr.attr("selected", "true");
			      roleEl.append(optr);
			    }
			
			    if(taskAssig.task.master.permissions.canWrite && taskAssig.task.canWrite){
			      assigTr.find(".delAssig").click(function(){
			        var tr = $(this).closest("[assId]").fadeOut(200, function(){$(this).remove()});
			      });
			    }
			
			  });
			
			  function isHoliday(date) {
				  var friIsHoly =false;
				  var satIsHoly =true;
				  var sunIsHoly =true;
				  
				  var pad = function (val) {
				    val = "0" + val;
				    return val.substr(val.length - 2);
				  };

				  var holidays = "##";
				 
				  for (var i = 0; i < holidayList.length; i++) {
					  var holiday = holidayList[i];
					  holiday = holiday.replace(/-/g, "_");
					  holidays += "#" + holiday + "#";
				  }
				  
				  var ymd = "#" + date.getFullYear() + "_" + pad(date.getMonth() + 1) + "_" + pad(date.getDate()) + "#";
				  var day = date.getDay();
				  
				  return  (day == 5 && friIsHoly) || (day == 6 && satIsHoly) || (day == 0 && sunIsHoly) || holidays.indexOf(ymd) > -1;
			  }
			  
			  function loadI18n(){
				// 메시지 영역
			    GanttMaster.messages = {
			      "CANNOT_WRITE":"No permission to change the following task:",
			      "CHANGE_OUT_OF_SCOPE":"Project update not possible as you lack rights for updating a parent project.",
			      "START_IS_MILESTONE":"<spring:message code='ezPMS.t94' />",
			      "END_IS_MILESTONE":"<spring:message code='ezPMS.t95' />",
			      "TASK_HAS_CONSTRAINTS":"Task has constraints.",
			      "GANTT_ERROR_DEPENDS_ON_OPEN_TASK":"Error: there is a dependency on an open task.",
			      "GANTT_ERROR_DESCENDANT_OF_CLOSED_TASK":"Error: due to a descendant of a closed task.",
			      "TASK_HAS_EXTERNAL_DEPS":"This task has external dependencies.",
			      "GANNT_ERROR_LOADING_DATA_TASK_REMOVED":"GANNT_ERROR_LOADING_DATA_TASK_REMOVED",
			      "CIRCULAR_REFERENCE":"<spring:message code='ezPMS.t304' />",
			      "CANNOT_DEPENDS_ON_ANCESTORS":"Cannot depend on ancestors.",
			      "INVALID_DATE_FORMAT":"The data inserted are invalid for the field format.",
			      "GANTT_ERROR_LOADING_DATA_TASK_REMOVED":"An error has occurred while loading the data. A task has been trashed.",
			      "CANNOT_CLOSE_TASK_IF_OPEN_ISSUE":"Cannot close a task with open issues",
			      "TASK_MOVE_INCONSISTENT_LEVEL":"You cannot exchange tasks of different depth.",
			      "CANNOT_MOVE_TASK":"CANNOT_MOVE_TASK",
			      "PLEASE_SAVE_PROJECT":"PLEASE_SAVE_PROJECT",
			      "GANTT_SEMESTER":"<spring:message code='ezPMS.t303' />",
			      "GANTT_SEMESTER_SHORT":"s.",
			      "GANTT_QUARTER":"<spring:message code='ezPMS.t302' />",
			      "GANTT_QUARTER_SHORT":"q.",
			      "GANTT_WEEK":"<spring:message code='ezCommunity.t591' />",
			      "GANTT_WEEK_SHORT":"<spring:message code='ezCommunity.t591' />",
			      "START_CANNOT_BE_LATER_THAN_END":"<spring:message code='ezPMS.t49' />",
			      "CANNOT_CREATE_SAME_LINK":"<spring:message code='ezPMS.t297' />"
			    };
			  }
			
			
			
			  function createNewResource(el) {
			    var row = el.closest("tr[taskid]");
			    var name = row.find("[name=resourceId_txt]").val();
			    var url = contextPath + "/applications/teamwork/resource/resourceNew.jsp?CM=ADD&name=" + encodeURI(name);
			
			    openBlackPopup(url, 700, 320, function (response) {
			      //fillare lo smart combo
			      if (response && response.resId && response.resName) {
			        //fillare lo smart combo e chiudere l'editor
			        row.find("[name=resourceId]").val(response.resId);
			        row.find("[name=resourceId_txt]").val(response.resName).focus().blur();
			      }
			
			    });
			  }
		</script>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<form id="exportGantt" name="exportGantt" method="POST" style="display:none;">
			<input name="projectId">
			<input name="taskId">
			<input name="taskLevel">
		</form>
	</body>
</html>