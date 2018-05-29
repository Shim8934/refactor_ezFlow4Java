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
			<li><span onclick="moveBoard()">이동</span></li>
			<li><span onclick="popupClose()">닫기</span></li>
		</ul>
	</div>
	<div id="taskTree" class="tree"></div>
</body>
</html>