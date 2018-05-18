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
	var currentPage = 1;
	var treeData = JSON.parse('${data}');
	
	$(document).ready(function() {
		
		getProjectTaskTree("taskTree", treeData, false);
		getBoardList();
		
		$(".tree").on("click", ".jstree-anchor", function() {
			taskName = $(this).text();
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
		
		// 여기 다른 방법으로 할 순 없을지 고민해봐야함. 근데 아무리 해도 모르겠음
		setTimeout(function() {
			projectName = $("li[role='treeitem'][aria-level='1']").children("a").text();
			taskName = projectName;
		}, 100);
	});
	
	function goAddBoard() {
	
		var height = window.screen.availHeight;
	    var width = window.screen.availWidth;
	    var top = (height - 820) / 2;
	    var left = (width - 790) / 2;
		
		window.open("/ezPMS/goAddBoard.do?projectName=" + projectName + "&projectId=" + projectId 
										  + "&groupId=" + groupId + "&taskName=" + taskName  + "&taskId=" + taskId, 
					"", "width=790, height=820, resizable=no, scrollbars=no, status=no, top=" + top + ", left=" + left + ";");
	}
	
	function getBoardList() {
		$("#list").attr("width", "1000px");
		$("#list").load("/ezPMS/getBoardList.do?projectId=" + projectId + "&groupId=" + groupId + "&taskId=" + taskId
												 + "&currentPage=" + currentPage);
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page){
		currentPage = page;
		getBoardList();
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
	
	<div id="taskTree" class="tree" style="float: left;"></div>
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
		<span id="list"></span>
	</div>
</body>
</html>