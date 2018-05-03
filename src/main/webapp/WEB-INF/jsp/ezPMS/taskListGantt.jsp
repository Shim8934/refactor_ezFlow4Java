<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>gantt Chart</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css" />
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	   	<script type="text/javascript">
	   	

	   		$(document).ready(function() {
		   		
   			});
	   		
	   		// 프로젝트 아이디
	   		var projectId = "${projectId}";
	   		// 업무 목록
	   		var taskList;
	   		// 프로젝트 세부정보
	   		var projectDetails;
	   		// 사용자 아이디
	   		var userId = "";
	   		var ganttData = {};
   			
	   		function initValues(){
	   			taskList = ${taskList};
	   			var tl = taskList;
	   			projectDetails = ${projectDetail};
	   			var pd = projectDetails;
	   			
	   			ganttData.tasks = [{}];
	   			//프로젝트 데이터 가공부분.
	   			ganttData.tasks[0].id = pd.projectId;
	   			ganttData.tasks[0].name = pd.projectName;
	   			ganttData.tasks[0].code = "";
	   			ganttData.tasks[0].level = 0;
	   			ganttData.tasks[0].status = pd.status;
	   			ganttData.tasks[0].start = pd.planStartDate;
	   			ganttData.tasks[0].end = pd.planEndDate;
	   			ganttData.tasks[0].duration = pd.workingday;
	   			ganttData.tasks[0].startIsMilestone = "";
	   			ganttData.tasks[0].endIsMilestone = "";
	   			ganttData.tasks[0].assigs = [{}];
	   			
	   			for(var i = 0; i < pd.projectMember.length; i++){
	   				ganttData.tasks[0].assigs[i].resourceId = pd.projectMember[i].memberId;
	   				ganttData.tasks[0].assigs[i].id = pd.projectMember[i].userId;
	   				ganttData.tasks[0].assigs[i].roleId = pd.projectMember[i].memberRoleId;
	   				ganttData.tasks[0].assigs[i].effort = "";
	   			}
	   			
	   			ganttData.tasks[0].depends = "";
	   			ganttData.tasks[0].description = pd.overview;
	   			ganttData.tasks[0].progress = pd.progress;
	   			
	   			
	   			//업무 리스트 가공부분.
	   			for(var i = 0; i < tl.length; i++){
		   			ganttData.tasks[i + 1].id = tl[i].projectId + "-" + tl[i].taskId;
		   			ganttData.tasks[i + 1].name = tl[i].taskName;
		   			ganttData.tasks[i + 1].code = "";
		   			ganttData.tasks[i + 1].level = 1;
		   			ganttData.tasks[i + 1].status = tl[i].status;
		   			ganttData.tasks[i + 1].start = tl[i].planStartDate;
		   			ganttData.tasks[i + 1].end = tl[i].planEndDate;
		   			ganttData.tasks[i + 1].duration = tl[i].workingday;
		   			ganttData.tasks[i + 1].startIsMilestone = "";
		   			ganttData.tasks[i + 1].endIsMilestone = "";
		   			ganttData.tasks[i + 1].assigs = [{}];
		   			
		   			for(var j = 0; j < tl.taskMember.length; i++){
		   				ganttData.tasks[i + 1].assigs[j].resourceId = pd.projectMember[i + 1].memberId;
		   				ganttData.tasks[i + 1].assigs[j].id = pd.projectMember[i + 1].userId;
		   				ganttData.tasks[i + 1].assigs[j].roleId = pd.projectMember[i + 1].memberRoleId;
		   				ganttData.tasks[i + 1].assigs[j].effort = "";
		   			}
		   			
		   			ganttData.tasks[i + 1].depends = "";
		   			ganttData.tasks[i + 1].description = pd.overview;
		   			ganttData.tasks[i + 1].progress = pd.progress;
	   			}
	   			
	   		}
	   		
		</script>
		<style>
		</style>
	</head>
	<body>
		<div>test</div>
	</body>
</html>