<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script>

	var treeData = JSON.parse('${data}');
	
	$(document).ready(function() {
		getProjectTaskTree("taskTree", treeData, false);
		
		$("#taskTree").on("dblclick", ".jstree-anchor", function(evt) {
			evt.preventDefault();
			evt.stopPropagation();
		});
	});
	
	function moveBoards() {
		var groupId = 0;
		var taskId = 0;
		var chosenTask = $("a.jstree-clicked");	
		var taskName = chosenTask.text();
		
		// 작업명 옆에 게시판 갯수가 표시되었을 때 그것을 잘라냄
		if(taskName.indexOf('(') != -1) {
			taskName = taskName.substring(0, taskName.indexOf('('));
		}
		
		if(chosenTask.parent().attr("id").charAt(0) == 't') { 
			groupId = chosenTask.parents("li").eq(1).attr("id");
			taskId  = chosenTask.parent().attr("id").substr(1);		
		} else {
			groupId = chosenTask.parent().attr("id");
			taskId  = null;
		}
		
		data = {
			itemIds : parent.itemIds,
			projectId : parent.projectId,
			groupId : groupId,
			taskId  : taskId
		}
		
		$.ajax({
			type : "PUT",
			url : "/ezPMS/moveBoards.do",
			dataType : "json",
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				if(result.data == 'success') {
					alert("이동에 성공했습니다.");
					popupClose();
					
					if(typeof parent.getBoardList == 'function') {
						
						for(i in parent.itemIds) {
							var deletedTR = parent.$("tr[data-itemid = " + parent.itemIds[i] + "]");
							var title = deletedTR.children("td.boardTitle").text();
							var beforeTaskName = deletedTR.children("td.taskName").text();
							var beforeGroupId = deletedTR.attr("data-groupId");
							var beforeTaskId = deletedTR.attr("data-taskId");
							
							addTaskLog(parent.projectId, 2, groupId, taskId, "[" + beforeTaskName.trim() + "]의 " + "[" + title.trim() + "] 게시물을 [" + taskName.trim() +  "](으)로 이동하였습니다.");
						}
						
						parent.getBoardList();
					} else {
						var beforeTaskName = parent.taskName;
						addTaskLog(parent.projectId, 2, groupId, taskId, "[" + beforeTaskName.trim() + "]의 " + "[" + parent.title.trim() + "] 게시물을 [" + taskName.trim() +  "](으)로 이동하였습니다.");
						parent.location.reload();
					}
					
				} else {
					alert('수정은 프로젝트 담당자나 게시자만 할 수 있습니다.');
				}	
			},
			error : function() {
				alert("수정에 실패했습니다.");
			}
		})
	}
</script>
<style>
.tree {
	overflow: auto;
	border: 1px solid silver;
	height: auto;
}
</style>
</head>
<body class="popup">
	<h1>업무 목록</h1>
	<div id="close">
		<ul>
			<li><span onclick="moveBoards()">이동</span></li>
			<li><span onclick="popupClose()">닫기</span></li>
		</ul>
	</div>
	<div id="taskTree" class="tree"></div>
</body>
</html>