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
	var treeData = JSON.parse('${data}');
	$(document).ready(function() {
		getProjectTaskTree("taskTree", treeData, false);
		
		$("#taskTree").on("dblclick", ".jstree-anchor", function(evt) {
			evt.preventDefault();
			evt.stopPropagation();
			register();
		});
	});
	
	function register() {
		var chosenTask = $("a.jstree-clicked");	
		parent.document.getElementById("taskName").innerHTML = chosenTask.text();
		if(chosenTask.parent().attr("id").charAt(0) == 't') { 
			parent.groupId = chosenTask.parents("li").eq(1).attr("id");
			parent.taskId = chosenTask.parent().attr("id").substr(1);		
		} else {
			parent.groupId = chosenTask.parent().attr("id");
		}	
		popupClose();
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
	<h1>작업 목록</h1>
	<div id="close">
		<ul>
			<li><span onclick="register()">등록</span></li>
			<li><span onclick="popupClose()">닫기</span></li>
		</ul>
	</div>
	<div id="taskTree" class="tree"></div>
</body>
</html>