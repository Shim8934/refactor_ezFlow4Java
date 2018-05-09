<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/ezPMS/default/style.min.css"
	type="text/css" />
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
		
		if(!chosenTask.length) {
			alert("트리에서 업무를 선택해주세요");
			return;
		}
		var taskName = chosenTask.text();
		var project = $("li[role='treeitem'][aria-level='1']");
		var projectName = project.children("a").text();
		var groupId = project.attr("id");
		var taskId = -1;
		
		if(chosenTask.parent().attr("aria-level") != '1') {
			taskId = chosenTask.parent().attr("id").substr(1);
		} 
		
		console.log(projectName);
		DivPopUpShow(845, 555, "/ezPMS/goAddBoard.do?projectId=" + projectId + "&projectName=" + projectName + "&taskName=" 
																 + taskName + "&groupId=" + groupId + "&taskId=" + taskId);
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
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>