<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t146' /></title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script>
	
	$(document).ready(function() {
		var treeData = ${data};
		treeData = JSON.parse(JSON.stringify(treeData));
		
		getProjectTaskTree("taskTree", treeData, "", 0);
		
		$("#taskTree").on("dblclick", ".jstree-anchor", function(evt) {
			evt.preventDefault();
			evt.stopPropagation();
		});
	});
	
	function moveBoards() {
		var chosenTask = $(".jstree-clicked");	
		var taskName = chosenTask.text();
		var folderId = chosenTask.parent().attr("id");
		
		// 작업명 옆에 게시판 갯수가 표시되었을 때 그것을 잘라냄
		if (taskName.indexOf('(') != -1) {
			taskName = taskName.substring(0, taskName.indexOf('('));
		}
		
		var data = {
			itemIds : parent.itemIds,
			projectId : parent.projectId,
			folderId : folderId
		}
		
		$.ajax({
			type : "PUT",
			url : "/ezPMS/moveBoards.do",
			dataType : "json",
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				if(result.data == 'success') {
					alert("<spring:message code='ezPMS.t145' />");
					popupClose();
					
					if(typeof parent.getBoardList == 'function') {
						
						/* for(i in parent.itemIds) {
							var deletedTR = parent.$("tr[data-itemid = " + parent.itemIds[i] + "]");
							var title = deletedTR.children("td.boardTitle").text();
							var beforeTaskName = deletedTR.children("td.taskName").text();
							var beforeGroupId = deletedTR.attr("data-groupId");
							var beforeTaskId = deletedTR.attr("data-taskId");
							
							addTaskLog(parent.projectId, 2, groupId, taskId, "[" + beforeTaskName.trim() + "<spring:message code='ezPMS.t206' /> " + "[" + title.trim() + "<spring:message code='ezPMS.t233' />" + taskName.trim() +  "<spring:message code='ezPMS.t234' />");
						} */
						
						parent.getBoardList();
						parent.getFolderTree();
					} else {
						var beforeTaskName = parent.folderName;
						/* addTaskLog(parent.projectId, 2, groupId, taskId, "[" + beforeTaskName.trim() + "<spring:message code='ezPMS.t206' /> " + "[" + parent.title.trim() + "<spring:message code='ezPMS.t233' />" + taskName.trim() +  "<spring:message code='ezPMS.t234' />"); */
						parent.location.reload();
						parent.opener.location.reload();
					}
					
				} else {
					alert("<spring:message code='ezPMS.t128' />");
				}	
			},
			error : function() {
				alert("<spring:message code='ezPMS.t228' />");
			}
		})
	}
	
	function popupClose() {
		
		if (parent.window.location.href.indexOf("Detail") == -1) {
			$("#blockLeft", parent.parent.parent.frames["left"].document).remove();
			$("#blockTop", parent.parent.parent.frames["right"].document).remove();
		}
		
		parent.DivPopUpHidden();
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
	<h1><spring:message code='ezPMS.t309' />
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
		<a class="imgbtn" onclick="moveBoards()">
			<span><spring:message code='ezPMS.t111' /></span>
		</a>
	</div>
</body>
</html>