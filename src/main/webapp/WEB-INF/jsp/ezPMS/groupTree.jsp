<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezPMS.t42' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
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
				$("#"+containerId).on('changed.jstree', function (e, data) {
			     	var id = data.instance.get_node(data.selected).id;
			     	var name = data.instance.get_node(data.selected).text;
			     	parent.groupId = id;
			     	parent.groupName = name;
				})
					.jstree({
						'core' : {
						'data' : data.data,
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
				.bind("loaded.jstree", function (event, data) {
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
	});
	
	function ok_Click() {
		parent.setUpperGroup();
		parent.DivPopUpHidden();
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
			alert("해당 그룹은 상위그룹으로 지정할 수 없습니다.");
			$("li[aria-selected='true'] a").removeClass("jstree-clicked");
			$("li[aria-selected='true']").attr("aria-selected", false);
			return false;
		}
		parent.treeDepth = treeDepth;
	}
	
</script>
<style>
.tree {
	overflow: auto;
	border: 1px solid silver;
	height: auto;
	width: 315px;
	margin-top: 30px;
}
</style>

</head>
<body class="popup" style="overflow-y: auto; overflow-x: hidden"> 
	<h1 style="height: 20px;"><spring:message code='ezPMS.t42' /></h1>
    <div id="close">
        <ul>
            <li><span onclick="ok_Click()"><spring:message code='ezPMS.t43' /></span></li>
            <li><span onclick="close_Click()"><spring:message code='ezPMS.t41' /></span></li>
        </ul>
    </div>
	<div id="test" class="tree"></div>
</body>
</html>

