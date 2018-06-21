<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t146' /></title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
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
		var chosenTaskTree = $("a.jstree-clicked").parents("li[role='treeitem']").toArray();
		var preTaskName = "";
		
		for(var i = chosenTaskTree.length - 2; i >= 0; i--) {
			
			if(i != 0) {
				preTaskName += $(chosenTaskTree[i]).children("a").text() + " > ";
			} else {
				preTaskName += $(chosenTaskTree[i]).children("a").text();
			}
		}
		
		$("#preTaskName", parent.document).text(preTaskName);
		
		parent.pretaskId = $("a.jstree-clicked").parent("li[role='treeitem']").attr("id");
		popupClose();
	}
	
	function initPreTask() {
		$("#preTaskName", parent.document).text('-');
		parent.pretaskId = "";
		parent.pretaskSetType = "initPreTask";
		popupClose();
	}
</script>
<style>
.tree {
	overflow: auto;
	border: 1px solid silver;
	height: 215px;
}
</style>
</head>
<body class="popup">
	<h1><spring:message code='ezPMS.t146' /></h1>
	<div id="close">
		<ul>
			<li><span onclick="initPreTask()"><spring:message code='ezPMS.t295' /></span></li>
		</ul>
	</div>
	<div id="taskTree" class="tree"></div>
	<div style="margin-top: 8px; text-align: center;">
		<a class="imgbtn" onclick="register()">
			<span><spring:message code='ezPMS.t40' /></span>
		</a>
		<a class="imgbtn" onclick="popupClose()">
			<span><spring:message code='ezPMS.t76' /></span>
		</a>
	</div>
</body>
</html>