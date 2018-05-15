<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/ezPMS/default/style.min.css" type="text/css" />
<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
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
	var containerId = "test";
	
	$(document).ready(function() {
		getProjectTaskTree(containerId, projectId, false);
		getBoardList();
		
		$(".tree").on("click", ".jstree-anchor", function() {
			taskName = $(this).text();
			if($(this).parent().attr("id").charAt(0) == 't') { 
				groupId = $(this).parents("li").eq(1).attr("id");
				taskId = $(this).parent().attr("id").substr(1);
			} else {
				groupId = $(this).parent().attr("id");
			}
			getBoardList();
		})
	});
	
	function goAddBoard() {
		var chosenTask = $("a.jstree-clicked");
		var project = $("li[role='treeitem'][aria-level='1']");
		projectName = project.children("a").text();
		
		if(!chosenTask.length) {
			taskName = projectName;
			groupId = project.attr("id");
		}
		
		var height = window.screen.availHeight;
	    var width = window.screen.availWidth;
	    var top = (height - 820) / 2;
	    var left = (width - 790) / 2;
		
		window.open("/ezPMS/goAddBoard.do?projectName=" + projectName + "&projectId=" + projectId + "&taskName=" + taskName + "&groupId=" + groupId + "&taskId=" + taskId, 
					"", "width=790, height=820, resizable=no, scrollbars=no, status=no, top=" + top + ", left=" + left + ";");
	}
	
	function getBoardList() {
		$("#list").attr("width", "1000px");
		$("#list").attr("src", "/ezPMS/getBoardList.do?projectId=" + projectId + "&groupId=" + groupId + "&taskId=" + taskId);
	}
</script>

<style>
.tree {
	overflow: auto;
	border: 1px solid silver;
	height: auto;
	width : 250px;
}
</style>

</head>
<body style="overflow: hidden;">
	
	<div id="test" class="tree" style="float: left;"></div>
	<div style="float: left; border: 1px solid silver; margin-left: 10px;">
		<div id="mainmenu">
			<ul class="on">
				<li class="off"><span onclick="goAddBoard()">등록</span></li>
				<li class="off"><span onclick="">삭제</span></li>
				<li class="off"><span onclick="">이동</span></li>
				<li class="off"><span onclick="">새로고침</span></li>
				<li class="off"><span onclick="">검색</span></li>
			</ul>
		</div>
		<iframe id="list" frameborder="0" height="500px"></iframe>	
	</div>
</body>
</html>