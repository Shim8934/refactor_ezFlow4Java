<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezPMS.t42' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script>
	var projectId = "${projectId}";
	var containerId = "test";
	var onlyGroup = true;
	var treeDepth = 0;
	var originTreeDepth = parent.treeDepth;
	var originGroupId = parent.groupId;
	var originGroupName = parent.groupName;

	$(document).ready(function() {
		$.ajax({
			type : "post",
			dataType : "json",
			url : "/ezPMS/projectTaskTree.do",
			data : {
				"projectId" : projectId, 
				"onlyGroup" : onlyGroup
			},
			success : function(data) {
				var treeData = JSON.parse(JSON.stringify(data.data));
				var treeDataCount = treeData.length;
				
				for (var i = 0; i < treeDataCount; i++) {
					var taskName = treeData[i].text;
					taskName = revertString(taskName);
					treeData[i].text = taskName;
				}
				
				$("#" + containerId).on('changed.jstree', function (e, data) {
			     	var id = data.instance.get_node(data.selected).id;
			     	var name = data.instance.get_node(data.selected).text;
			     	parent.groupId = id;
			     	parent.groupName = name;
				})
					.jstree({
						'core' : {
						'data' : treeData,
						'multiple' : false,
						'animation' : 0,
						'themes' : {
							'responsive' : true,
							//'variant' : 'small',
							//'stripes' : false
						}
					},
					'plugins' : [ 'sort', "wholerow"],
					'sort' : function(a, b) {
						var a1 = this.get_node(a);
						var b1 = this.get_node(b);
						return (a1.original.sort > b1.original.sort) ? 1 : -1;
					}
				})
				.bind("ready.jstree", function (event, data) {
			        $(this).jstree("open_all");
			    })
			},
			error : function(request, status, error) {
				alert("code : " + request.status + "\nerror : " + error);
			}
		});
		$(document).on("click", "a.jstree-anchor", function(e){
			getTreeDepth(e.target);
		})
		
		$(document).on("dblclick", "a.jstree-anchor", function(e){
			if(getTreeDepth(e.target) === false) {
				return;
			};
			
			ok_Click();
		})
	});
	
	function ok_Click() {
		parent.setUpperGroup();
		parent.DivPopUpHidden();
		// 상위그룹 선택 시, 담당자/참여자 항목 모두 초기화
		parent.managerList = [];
		parent.participantList = [];
		parent.headManagerId = null;
		$("#managers", parent.document).html("");
		$("#participants", parent.document).html("");
	}
	
	function close_Click(){
// 		parent.groupId = "";
		resetSelection();
		parent.setUpperGroup();
		parent.DivPopUpHidden();
	}
	
	function resetSelection(){
		parent.treeDepth = originTreeDepth;
		parent.groupId = originGroupId;
		parent.groupName = originGroupName;
	}
	
	function getTreeDepth(obj){
		treeDepth = obj.parentNode.getAttribute("aria-level");
		var isAddGroup = parent.document.location.href.toLowerCase().indexOf("addgroup");
		
		//그룹추가 페이지인지 확인 후 경고메시지 띄움.
		if(treeDepth > 2 && isAddGroup != -1){
			alert("<spring:message code='ezPMS.t311' />");
			$("li[aria-selected='true'] a").removeClass("jstree-clicked");
			$("li[aria-selected='true'] div").removeClass("jstree-wholerow-clicked");
			$("li[aria-selected='true']").attr("aria-selected", false);
			parent.groupName = "";
			parent.groupId = "";
			return false;
		}
		// jstree에서는 최상위가 1이나 모듈에서는 0으로 관리하고 있음
		parent.treeDepth = treeDepth - 1;
	}
	
</script>
<style>
.tree {
	overflow: auto;
	border: 1px solid silver;
	height: 215px;
	width: 315px;
	margin-top: 30px;
}
</style>

</head>
<body class="popup" style="overflow-y: auto; overflow-x: hidden"> 
	<h1 style="height: 20px;"><spring:message code='ezPMS.t42' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="popupClose()"></span>
			</li>
		</ul>
		</div>
	</h1>
	<div id="test" class="tree"></div>
	<table style="width:100%;">
		<tr>
			<td><div class="btnpositionNew"><a class="imgbtn" id="submit" onclick="ok_Click()"><span><spring:message code='ezPMS.t40' /></span></a></div></td>
		</tr>
	</table>
</body>
</html>

