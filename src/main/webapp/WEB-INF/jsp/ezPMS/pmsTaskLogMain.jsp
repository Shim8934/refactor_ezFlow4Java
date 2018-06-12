<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/Tab.css" type="text/css">
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
var projectId = "${projectId}";
var CurrentHeight = document.documentElement.clientHeight - 100;
var groupId = 0;
var taskId = 0;
var currentPage = 1;
var totalCount = 0;
var orderWhat = "";
var orderHow = "";
var searchContent = "";
var searchStatus = "";
var logData = JSON.parse('${data}');

$(document).ready(function(){
	CurrentHeight = $(window).height()-100;
	$("MailListRayer").css("height", CurrentHeight + "px");
	$("#taskTree").css("height", CurrentHeight + 10 + "px");
	$("#projectContent").css("height", CurrentHeight + "px");
	$("#contentList").css("height", (CurrentHeight - 100) + "px");
	$("#projectListBody").css("height", (CurrentHeight - 190) + "px");
	$("#divList").css("height", (CurrentHeight - 150) + "px");
	
	$(window).resize(function() {
		CurrentHeight = $(window).height()-100;
		$("MailListRayer").css("height", CurrentHeight + "px");
		$("#taskTree").css("height", CurrentHeight + 10 + "px");
		$("#projectContent").css("height", CurrentHeight + "px");
		$("#contentList").css("height", (CurrentHeight - 100) + "px");
		$("#projectListBody").css("height", (CurrentHeight - 190) + "px");
		$("#divList").css("height", (CurrentHeight - 150) + "px");
	});

});

$(function(){
	getProjectTaskTree("taskTree", logData, "taskLog");
	
	$("#searchStatus").css("display", "none");
	
	$("#searchId").change(function(){
		if($("#searchId option:selected").val() == "2") {
			$("#searchByContent").css("display", "none");
			$("#searchButton").css("display", "none");
			$("#searchStatus").css("display", "");
		} else {
			$("#searchByContent").css("display", "");
			$("#searchButton").css("display", "");
			$("#searchStatus").css("display", "none");
		}
	});
});

function setContentList() {
	var data = {
		//기본 setting
		projectId : projectId,
		groupId : groupId,
		taskId : taskId,
		currentPage : currentPage,
		totalCount : totalCount,
		listNumber : 10,
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
			viewSetting();
			searchStatus = "";
			setInitOrder();
		}	
	});
}

function searchLogContent() {
	searchContent = $("#searchByContent").val();
	setContentList();
}

function searchLogStatus(status) {
	searchStatus = status;
	setContentList();
}

//페이지 번호에 의한 셋팅
function goToPageByNum(page){
	currentPage = page;
	setContentList();
}

//헤더 리스트 셋팅
function setListOrder(elem){
	
	orderWhat = $(elem).attr("order");
	orderHow = $(elem).attr("sort");
	
	if(orderHow == null){
		orderHow='asc';
	} else if(orderHow == 'asc'){
		orderHow='desc';
	} else if(orderHow == 'desc'){
		orderHow='asc';
	}
	
	setContentList();
}

function setInitOrder(){	
	$("#BoardList_TH th").each(function () {
		if(orderWhat == $(this).attr("order")) {
			if(orderHow == 'asc'){
				$(this).attr("sort","asc");
				$(this).append(' <img src="/images/etc/view-sortdown.gif" align="absmiddle">');
			} else if(orderHow == 'desc'){
				$(this).attr("sort","desc");
				$(this).append(' <img src="/images/etc/view-sortup.gif" align="absmiddle">');
			}
		}
	});

	projectListScroll();
}

function projectListScroll(){
	var thWidth = document.getElementById("tableHeader").clientWidth - document.getElementById("tableBody").clientWidth;
	if(thWidth > 0){ 
		$("#BoardList_TH").append('<th style=width:2px;></th>');
	} 
}

function setContentTitle(taskName, totalCount) {
	var contentTitle = "";
	
	if (!totalCount) {
		totalCount = 0;
	}
	
	contentTitle = "<span style='width:50%; text-overflow:ellipsis; font-size:16px;'>" + taskName + "<span id='mailBoxInfo'> - [총 <span style='color:#017BEC;' id='totalCount'>" + totalCount + " </span>개]</span>";
	
	$("#taskName").html(contentTitle);
}

function selectedTR(elem){
	var parentElem = $(elem).parent();
	$("#tableBody tr").removeClass("selectTR");
	$(parentElem).addClass("selectTR");
}

</script>
<style type="text/css">
#taskTree {
	margin-right : 5px;
	width : 16%;
	overflow-y : auto;
	overflow-x : hidden;
	border : 1px solid #d1d1d1;
	float : left;
}

#projectArea {
	width : 83%;
	overflow : auto;
	border : 1px solid #d1d1d1;
}

#projectContent {
	min-width : 1057px;
}

.jstree-node > a {
    /* 100% - (the width of the presentation node : the line - the left padding of the <a> node - the right padding of the <a> node)*/
    width: calc(100% - (55px + 1px + 4px));
    text-overflow: ellipsis;
    overflow: hidden;
}

#searchArea {
	float : right;
	margin-top : 10px;
	margin-right : 10px;
}

#searchId, #searchStatus {
	height : 25px;
	width : 87px;
}

#taskName {
	margin-top : 10px;
	margin-left : 10px;
	overflow : hidden;
}

#iconLine {
	margin-left: 10px;
	margin-top: 5px;
	height: 80px;
}

#contentList {
	width : 98%;
	margin-left : 1%;
}

#MailListRayer tr:not (.selectTR ):hover {
	background-color: rgb(244, 245, 245);
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
</style>
</head>
<body>
<div id="taskTree"></div>
<div id="projectArea">
<div id="projectContent">
	<div id="iconLine">
		<div id="taskName"></div>
		<div id="searchArea">
			<select id="searchId">
				<option value="1" selected>이력 내용</option>
				<option value="2">이력 상태</option>
			</select>
			<input type="text" id="searchByContent" onkeypress="if(event.keyCode==13) {searchLogContent(); return false;}">
			<a class="imgbtn" id="searchButton" onclick="searchLogContent()" style="margin-left:1px; margin-top:1px;"><span>검색</span></a>
			<select id="searchStatus" onchange="searchLogStatus(this.value)">
				<option value="0">전체</option>
				<option value="1">등록</option>
				<option value="2">수정</option>
				<option value="3">삭제</option>
			</select>
		</div>
	</div>
	<div id="contentList" style="overflow:auto">
	<span id="MailListRayer" style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
	</span>
	</div>
	</div>
</div>
</body>
</html>