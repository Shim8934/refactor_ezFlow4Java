<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t154' /></title>
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>

<!-- time picker-->
<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
<script>
 	var projectId = "${projectId}";
 	var CurrentHeight = document.documentElement.clientHeight - 100;
	var groupId = "${groupId}";
	var taskId = "${taskId}";
	var currentPage = 1;
	var orderWhat = "";
	var orderHow = "";
	var limit = 10;
	
	var projectName = null;
	var taskName = null;
	var taskDetails = {};
	
	//검색을 위한 variables
	var searchByUser = "";
	var searchByStartDate = "";
	var searchByEndDate = "";
	var searchByContent = "";
	
	$(document).ready(function() {
		setInitData();
		currentHeight = $(window).height();
		$("#projectContent").css("height", currentHeight + "px");
		$("#contentList").css("height", (currentHeight - 50) + "px");
	
		getCommentList();
	});
	
	function getCommentList() {
		var data = {
			//기본 setting
			projectId : projectId,
			groupId : groupId,
			taskId : taskId,
			currentPage : currentPage,
			limit : limit,
			//내용 header 정렬
			orderWhat : orderWhat,
			orderHow : orderHow,
			//검색
			searchByUser : searchByUser,
			searchByStartDate : searchByStartDate,
			searchByEndDate : searchByEndDate,
			searchByContent : searchByContent,
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			dataType : "html",
			data : JSON.stringify(data),
			url : "/ezPMS/getCommentList.do",
			success : function(contentList) {
				$("#contentList").html(contentList);
				
				setInitOrder();
			}	
		});
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page) {
		currentPage = page;
		getCommentList();
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
		var thWidth = document.getElementById("tableHeader").clientWidth
				- document.getElementById("tableBody").clientWidth;
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
		
		getCommentList();
	}
	
	function setInitData(){
		taskDetails = JSON.parse(parent.document.querySelector("[name='frameParamTaskDetails']").value);
		projectName = taskDetails.projectName;
		taskName = taskDetails.taskName;
		
		if(!taskName) {
			taskName = taskDetails.groupName;
		}
	}
</script>

<style>	
	table.mainlist th, table.mainlist td {
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		text-align: center;
	}
	
	table.mainlist th {
		cursor: pointer;
	}
	
	#divList {
		height: 360px !important;
	}

	.col1 {width: 10%;}
	.col2 {width: 15%;}
	.col3 {width: 50%;}
	.col4 {width: 15%;}
	.commentContent {width: 70%;}
</style>

</head>
<body>
	<div id="projectContent">
		<div id="contentList"></div>
	</div>
</body>
</html>