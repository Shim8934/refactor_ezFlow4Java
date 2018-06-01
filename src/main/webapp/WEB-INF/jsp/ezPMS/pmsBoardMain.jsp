<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script>
 	var projectId = ${projectId};
 	var projectName = null;
	var groupId = null;
	var taskId = null;
	var taskName = null;
	var currentPage = 1;
	var treeData = JSON.parse('${data}');
	var itemIds;
	
	$(document).ready(function() {
		
		currentHeight = $(window).height()-100;
		$("#taskTree").css("height", currentHeight + "px");
		$("#projectContent").css("height", currentHeight + "px");
		$("#contentList").css("height", (currentHeight - 50) + "px");
		
		getProjectTaskTree("taskTree", treeData, false);
		getBoardList();
		
		$("#taskTree").on("click", ".jstree-anchor", function() {
			taskName = $(this).text();
			// 작업명 옆에 게시판 갯수가 표시되었을 때 그것을 잘라냄
			if(taskName.indexOf('(') != -1) {
				taskName = taskName.substr(0, taskName.indexOf('('));
			}
			if($(this).parent().attr("id").charAt(0) == 't') { 
				groupId = $(this).parents("li").eq(1).attr("id");
				taskId = $(this).parent().attr("id").substr(1);
			} else {
				groupId = $(this).parent().attr("id");
				taskId = null;
			}
			currentPage = 1;
			getBoardList();
		});
		
		// 트리가 모두 로드된 다음 실행
	 	$("#taskTree").on("ready.jstree", function() {
			var project = $("li[role='treeitem'][aria-level='1']").last();
			
			groupId = project.attr("id");
			projectName = project.children("a").text();
			project.children("a").click();
			
			if(projectName.indexOf('(') != -1) {
				projectName = projectName.substr(0, projectName.indexOf('('));
			}
			
			taskName = projectName;
		});
	});
	
	function goAddBoard() {
		var feature = GetOpenPosition(790, 800);
		window.open("/ezPMS/goAddBoard.do?projectName=" + projectName + "&projectId=" + projectId + "&groupId=" + groupId 
										 + "&taskName=" + taskName  + "&taskId=" + taskId + "&mode=new", 
					"", "width=790, height=800, resizable=no, scrollbars=no, status=no" + feature);
	}
	
	function getBoardList() {
		var data = {
			projectId : projectId,
			groupId : groupId,
			taskId : taskId,
			currentPage : currentPage
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			dataType : "html",
			data : JSON.stringify(data),
			url : "/ezPMS/getBoardList.do",
			success : function(contentList) {
				$("#contentList").html(contentList);
			}	
		});
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page) {
		currentPage = page;
		getBoardList();
	}
	
	// 메인에서 체크박스로 선택 후 삭제할 때
	function deleteBoardsAction(itemIds) {
		data = {
			itemIds : itemIds,
			projectId : projectId
		}
		
		$.ajax({
			type : "DELETE",
			url : "/ezPMS/deleteBoard.do",
			dataType : "json",
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				if(result.data == 'success') {
					alert("삭제되었습니다.");
					
					for(i in itemIds) {
						var deletedTR = $("tr[data-itemid = " + itemIds[i] + "]");
						var title = deletedTR.children("td.boardTitle").text();
						var taskName = deletedTR.children("td.taskName").text();
						var groupId = deletedTR.attr("data-groupId");
						var taskId = deletedTR.attr("data-taskId");
						
						addTaskLog(projectId, 3, groupId, taskId, "[" + taskName + "]의 " + "[" + title + "] 게시물이 삭제되었습니다.");
					}
					
					getBoardList();
				} else {
					alert('삭제는 프로젝트 담당자나 게시자만 할 수 있습니다.');
				}	
			},
			error : function() {
				alert("삭제에 실패했습니다.");
			}
		})
	}
</script>

<style>
	#taskTree {
		margin-right : 5px;
		width : 16%;
		overflow : auto;
		border : 1px solid #d1d1d1;
		float : left;
		display : inline-block
	}
	
	#projectContent {
		width : 83%;
		overflow : auto;
		border : 1px solid #d1d1d1;
	}
	
	#contentList {
		width : 98%;
		margin-left : 1%;
		margin-top : 15px;
	}
</style>

</head>
<body>
	<div id="taskTree"></div>
	<div id="projectContent">
		<div id="contentList"></div>
	</div>
</body>
</html>