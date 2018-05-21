<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>
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
		
		currentHeight = $(window).height()-100;
		$("#taskTree").css("height", currentHeight + "px");
		$("#projectContent").css("height", currentHeight + "px");
		$("#contentList").css("height", (currentHeight - 50) + "px");
		
		getProjectTaskTree("taskTree", treeData, false);
		getBoardList();
		
		$("#taskTree").on("click", ".jstree-anchor", function() {
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
			var project = $("li[role='treeitem'][aria-level='1']");
			groupId = project.attr("id");
			projectName = project.children("a").text();
			taskName = projectName;
		}, 100);
	});
	
	function goAddBoard() {
	
		// 중앙에 뜨게 하고 싶은데 잘 안됨
		var height = window.screen.availHeight;
	    var width = window.screen.availWidth;
	    var top = (height - 820) / 2;
	    var left = (width - 790) / 2;
		
		window.open("/ezPMS/goAddBoard.do?projectName=" + projectName + "&projectId=" + projectId + "&groupId=" + groupId 
										 + "&taskName=" + taskName  + "&taskId=" + taskId + "&mode=new", 
					"", "width=790, height=820, resizable=no, scrollbars=no, status=no, top=" + top + ", left=" + left + ";");
	}
	
	function getBoardList() {
		$("#contentList").load("/ezPMS/getBoardList.do?projectId=" + projectId + "&groupId=" + groupId + "&taskId=" + taskId
												 + "&currentPage=" + currentPage);
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page){
		currentPage = page;
		getBoardList();
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