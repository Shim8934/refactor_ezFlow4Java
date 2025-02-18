<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t153' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/previewmail.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>

<script type="text/javascript">
var projectId = "<c:out value='${projectId}'/>";
var groupId = "<c:out value='${groupId}'/>";

if(groupId == "") {
	groupId = 0;
}

var taskId = "<c:out value='${taskId}'/>";

if(taskId == "") {
	taskId = 0;
}

var currentPage = 1;
var totalCount = 0;
var orderWhat = "";
var orderHow = "";
var searchContent = "";
var searchStatus = "";
var limit = 10;

$(function() {
	currentHeight = $(window).height();
	$("#projectContent").css("height", currentHeight + "px");
	$("#contentList").css("height", (currentHeight - 50) + "px");
	
	setContentList();
});

function setContentList() {
	
	var data = {
		//기본 setting
		projectId : projectId,
		groupId : groupId,
		taskId : taskId,
		currentPage : currentPage,
		totalCount : totalCount,
		listNumber : limit,
		//내용 header 정렬
		orderWhat : orderWhat,
		orderHow : orderHow,
		//리스트 검색
		searchByContent : searchContent,
		searchByStatus : searchStatus
	}
	
	$.ajax({
		type : "post",
		contentType: "application/json; charset=UTF-8",
		dataType : "html",
		data : JSON.stringify(data),
		url : "/ezPMS/getTaskLogList.do",
		success : function(contentList) {
			$("#contentList").html(contentList);
			searchStatus = "";
			setInitOrder();
		}	
	});
}

//페이지 번호에 의한 셋팅
function goToPageByNum(page) {
	currentPage = page;
	setContentList();
}

//헤더 리스트 셋팅
function setListOrder(elem) {
	orderWhat = $(elem).attr("order");
	orderHow = $(elem).attr("sort");
	
	if (orderHow == null) {
		orderHow='asc';
	} else if (orderHow == 'asc') {
		orderHow='desc';
	} else if (orderHow == 'desc') {
		orderHow='asc';
	}
	
	setContentList();
}

function setInitOrder() {	
	$("#BoardList_TH th").each(function () {
		if (orderWhat == $(this).attr("order")) {
			if (orderHow == 'asc') {
				$(this).attr("sort","asc");
				$(this).append(' <img src="/images/etc/view-sortdown.gif" align="absmiddle">');
			} else if (orderHow == 'desc') {
				$(this).attr("sort","desc");
				$(this).append(' <img src="/images/etc/view-sortup.gif" align="absmiddle">');
			}
		}
	});

	projectListScroll();
}

function projectListScroll() {
	var thWidth = document.getElementById("tableHeader").clientWidth - document.getElementById("tableBody").clientWidth;
	
	if (thWidth > 0) { 
		$("#BoardList_TH").append('<th style=width:2px;></th>');
	} 
}

function selectedTR(elem) {
	var parentElem = $(elem).parent();
	$("#tableBody tr").removeClass("selectTR");
	$(parentElem).addClass("selectTR");
}
</script>
<style type="text/css">

#contentList {
	width : 98%;
	margin-left : 1%;
}

#basicFormList td:not (.selectTD ):hover {
	background-color: rgb(244, 245, 245);
}

.selectTR {
	background-color: rgb(233, 241, 255);
}

.selectTD {
	background-color: rgb(233, 241, 255);
}

.listRow:hover {
	background-color: rgb(233, 241, 255);
}

#divList {
	height: 451px !important;
}

#projectListBody {
	height: 400px !important;
}

.col1 {width : 57px;}
.col3 {width : 195px;}
.col4 {width : 67px;}
.col5 {width : 115px;}
</style>
</head>
<body>
	<div id="projectContent">
		<div id="contentList"></div>
	</div>
</body>
</html>