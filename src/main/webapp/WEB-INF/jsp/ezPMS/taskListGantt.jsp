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
	   			
	   			ganttData.tasks = {};
	   			ganttData.tasks.id = projectId;
	   			ganttData.tasks.name = pd.creatorName;
	   			ganttData.tasks.code = "";
	   			ganttData.tasks.level = 0;
	   			ganttData.tasks.status = pd.status;
	   			ganttData.tasks.start = pd.planStartDate;
	   			ganttData.tasks.end = pd.planEndDate;
	   			ganttData.tasks.duration = pd.workingday;
	   			ganttData.tasks.startIsMilestone = "";
	   			ganttData.tasks.endIsMilestone = "";
	   			ganttData.tasks.assigs = {};
	   			for(var assig in pd.projectMember){
	   				ganttData.tasks.assigs;
	   			}
	   			ganttData.tasks.assign = pd.projectMember;
	   			
	   			
	   		}
	   		
		</script>
		<style>
		</style>
	</head>
	<body>
		<div>test</div>
	</body>
</html>