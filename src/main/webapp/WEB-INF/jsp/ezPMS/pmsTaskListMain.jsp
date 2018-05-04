<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
	var projectId = "${projectId}";
	var containerId = "test";
	
	function goAddTask(){
		var top = ($(window).height() - $(this).outerHeight()) / 2;
	    var left = ($(window).width() - $(this).outerWidth()) / 2;
		var feature = GetOpenPosition(top, left);
	 
		DivPopUpShow(845, 555, "/ezPMS/goAddTask.do?projectId="+projectId);
	};
	
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
<body style="overflow:hidden;">
	<div id="mainmenu">
		<ul class="on">
			<li class="off"><span onclick="goAddTask()">업무 추가</span></li>
			<li class="off"><span onclick="">삭제</span></li>
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