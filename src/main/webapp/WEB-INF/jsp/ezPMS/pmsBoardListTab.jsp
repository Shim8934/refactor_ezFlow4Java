<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t141' /></title>
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>

<!-- time picker-->
<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
<script type="text/javascript">

 	var projectId = Number("${projectId}");
 	var projectName = null;
	var groupId = "${groupId}";
	var taskId = "${taskId}";
	var taskName = null;
	var currentPage = 1;
	var taskDetails = {};
	var orderWhat = "";
	var orderHow = "";
	var limit = 10;
		
	$(document).ready(function() {
		setInitData();
		currentHeight = $(window).height();
		$("#projectContent").css("height", currentHeight + "px");
		$("#contentList").css("height", (currentHeight - 50) + "px");
			
		getBoardList();
	});
	
	function getBoardList() {
		var data = {
			projectId : projectId,
			groupId : groupId,
			taskId : taskId,
			currentPage : currentPage,
			limit : limit,
			//내용 header 정렬
			orderWhat : orderWhat,
			orderHow : orderHow,
			position : "tab",
			searchOrNot : "",
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			dataType : "html",
			data : JSON.stringify(data),
			url : "/ezPMS/getBoardList.do",
			success : function(contentList) {
				$("#contentList").html(contentList);
				
				setInitOrder();
			}	
		});
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page) {
		currentPage = page;
		getBoardList();
	}
	
	function setInitOrder() {
		$("table.mainlist th").each(function() {
			if (orderWhat == $(this).attr("data-order")) {
				if (orderHow == 'asc') {
					$(this).attr("data-sort", "asc");
					$(this).append(' <img src="/images/etc/view-sortdown.gif" align="absmiddle">');
				} else if (orderHow == 'desc') {
					$(this).attr("data-sort", "desc");
					$(this).append(' <img src="/images/etc/view-sortup.gif" align="absmiddle">');
				}
			}
		});

		boardListScroll();
	}
	
	function boardListScroll() {
		var thWidth = document.getElementById("tableHeader").clientWidth - document.getElementById("tableBody").clientWidth;
		
		if (thWidth > 0) {
			$("#BoardList_TH").append('<th style=width:2px;></th>');
		}
	}
	
	//헤더 리스트 셋팅
	function setListOrder(elem){
		orderWhat = $(elem).attr("data-order");
		orderHow = $(elem).attr("data-sort");
		
		if(orderHow == null){
			orderHow='asc';
		} else if(orderHow == 'asc'){
			orderHow='desc';
		} else if(orderHow == 'desc'){
			orderHow='asc';
		}
		
		getBoardList();
	}
	
	function setInitData(){
		taskDetails = JSON.parse(parent.document.querySelector("[name='frameParamTaskDetails']").value);
		projectName = taskDetails.projectName;
		taskName = taskDetails.taskName;
		
		if (!taskName) {
			taskName = taskDetails.groupName;
		}
	}
</script>
<style>
#divList {
	height: 451px !important;
}
</style>
</head>
<body>
	<div id="projectContent">
		<div id="contentList"></div>
	</div>
</body>
</html>