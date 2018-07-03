<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t146' /></title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script>
	var treeData = "";
	$(document).ready(function() {
		treeData = ${data};
		treeData = JSON.parse(JSON.stringify(treeData));
		
		getProjectTaskTree("taskTree", treeData, false);
		
		$("#taskTree").on("dblclick", ".jstree-anchor", function(evt) {
			evt.preventDefault();
			evt.stopPropagation();
			register();
		});
	});
	
	function register() {
		var chosenTask = $("a.jstree-clicked");
		var taskName = chosenTask.text();
		
		// 작업명 옆에 게시판 갯수가 표시되었을 때 그것을 잘라냄
		if (taskName.indexOf('(') != -1) {
			taskName = taskName.substr(0, taskName.indexOf('('));
		}
		
		parent.document.getElementById("taskName").innerHTML = taskName;
		parent.taskName = taskName;
		
		if (chosenTask.parent().attr("id").charAt(0) == 't') { 
			parent.groupId = chosenTask.parents("li").eq(1).attr("id");
			parent.taskId  = chosenTask.parent().attr("id").substr(1);		
		} else {
			parent.groupId = chosenTask.parent().attr("id");
			parent.taskId  = null;
		}	
		popupClose();
	}	
</script>
<style>
.tree {
	overflow-x : hidden;
	overflow-y : auto;
	border: 1px solid silver;
	height: 198px;
}

.jstree-node > a {
   width: 200px;
   text-overflow: ellipsis;
   overflow: hidden;
}
</style>
</head>
<body class="popup">
	<h1><spring:message code='ezPMS.t146' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="popupClose()"></span>
			</li>
		</ul>
		</div>
	</h1>
	<div id="taskTree" class="tree"></div>
	<div style="margin-top: 8px; text-align: center;">
		<a class="imgbtn" onclick="register()">
			<span><spring:message code='ezPMS.t40' /></span>
		</a>
	</div>
</body>
</html>