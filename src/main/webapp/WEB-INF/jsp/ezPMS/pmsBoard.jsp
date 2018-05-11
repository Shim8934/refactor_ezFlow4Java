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
	var containerId = "test";
	
	
	function goAddBoard() {
		var chosenTask = $("a.jstree-clicked");	
		var project = $("li[role='treeitem'][aria-level='1']");
		var projectName = project.children("a").text();
		var groupId = project.attr("id"); // 수정 필요
		var taskId = -1;		
		var taskName = null;
		
		if(!chosenTask.length) {
			taskName = projectName;
		} else {
			taskName = chosenTask.text();
			if(chosenTask.parent().attr("id").charAt(0) == 't') { // 여기도 수정이 필요할 수도 있다. 그룹 안에 그룹이 생겼을 때 어떻게 될지 아직 모르겠음. 아마 전체적인 수정이 필요할 수도
				groupId = chosenTask.parents("li").eq(1).attr("id");
				taskId = chosenTask.parent().attr("id").substr(1);
			} else {
				groupId = chosenTask.parent().attr("id");
			}
		}
		
		var height = window.screen.availHeight;
        var width = window.screen.availWidth;
        var top = (height - 820) / 2;
        var left = (width - 790) / 2;
		
		window.open("/ezPMS/goAddBoard.do?projectName=" + projectName + "&projectId=" + projectId + "&taskName=" + taskName + "&groupId=" + groupId + "&taskId=" + taskId, 
					"", "width=790, height=820, resizable=no, scrollbars=no, status=no, top=" + top + ", left=" + left + ";");
	}
	
	$(document).ready(function() {
		getProjectTaskTree(containerId, projectId, false);
	});
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
	<div id="mainmenu">
		<ul class="on">
			<li class="off"><span onclick="goAddBoard()">등록</span></li>
			<li class="off"><span onclick="">삭제</span></li>
			<li class="off"><span onclick="">이동</span></li>
			<li class="off"><span onclick="">새로고침</span></li>
			<li class="off"><span onclick="">검색</span></li>
		</ul>
	</div>	
	<div id="test" class="tree"></div>
</body>
</html>