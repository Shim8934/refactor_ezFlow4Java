<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
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
	var treeData = "";
	var pretaskId;
	
	$(document).ready(function() {
		treeData = ${data};
		treeData = JSON.parse(JSON.stringify(treeData));
		
		for (var i = 0; i < treeData.length; i++) {
			var taskName = treeData[i].text;
			taskName = revertString(taskName);
			treeData[i].text = taskName;
		}
		
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
		pretaskId = $("a.jstree-clicked").parent("li[role='treeitem']").attr("id");
		
		if(checkIfExistPreTaskRel(pretaskId) == true) {
			alert("<spring:message code='ezPMS.t298' />");	
			return;
		}
		
		if(checkIfIsItself(pretaskId) == true) {
			alert("<spring:message code='ezPMS.t299' />");
			return;
		}
		
		for(var i = chosenTaskTree.length - 2; i >= 0; i--) {
			
			if(i != 0) {
				preTaskName += $(chosenTaskTree[i]).children("a").text() + " > ";
			} else {
				preTaskName += $(chosenTaskTree[i]).children("a").text();
			}
		}
		
		$("#preTaskName", parent.document).text(preTaskName);
		
		
		parent.pretaskId = pretaskId;
		popupClose();
	}
	
	function checkIfExistPreTaskRel(pretaskId) {
		
		var check;
		
		if(pretaskId.indexOf("t") != -1) {
			pretaskId = pretaskId.substring(pretaskId.indexOf("t") + 1);
			type = "task";
		} else {
			type = "group";
		}
		
		data = {
			pretaskId : pretaskId,
			type : type
		}
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/checkIfExistPreTaskRel.do",
			dataType : "json",
			async : false,
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				check = result.data;
			}
		})
		
		return check;
	}
	
	// 선택한 업무(또는 그룹)이 자기 자신인지의 여부를 판단
	function checkIfIsItself(pretaskId) {
		
		if(pretaskId.indexOf("t") != -1) {
			pretaskId = pretaskId.substring(pretaskId.indexOf("t") + 1);
			
			if(parent.taskId == pretaskId) {
				return true;
			}
			
		} else {
			
			if(parent.originGroupId == pretaskId) {
				return true;
			}
		}
		
		return false;
	}
	
	function initPreTask() {
		$("#preTaskName", parent.document).text('-');
		parent.pretaskId = "";
		parent.pretaskSetType = "initPretask";
		popupClose();
	}
</script>
<style>
.tree {
	overflow: auto;
	border: 1px solid silver;
	height: 215px;
}

.jstree-node > a {
   width: 200px;
   text-overflow: ellipsis;
   overflow: hidden;
}
</style>
</head>
<body class="popup">
	<h1><spring:message code='ezPMS.t146' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="popupClose()"></span>
			</li>
		</ul>
		</div>
	</h1>
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
	</div>
</body>
</html>