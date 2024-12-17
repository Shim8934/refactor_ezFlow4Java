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
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />
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
var CurrentHeight = document.documentElement.clientHeight - 100;
var groupId = 0;
var taskId = 0;
var currentPage = 1;
var totalCount = 0;
var orderWhat = "";
var orderHow = "";
var searchContent = "";
var searchStatus = "";
var logData = "";

$(function(){
	logData = ${data};
	logData = JSON.parse(JSON.stringify(logData));
	var logDataCount = logData.length;
	
	for (var i = 0; i < logDataCount; i++) {
		var taskName = logData[i].text;
		taskName = revertString(taskName);
		logData[i].text = taskName;
	}
	
	
	getProjectTaskTree("taskTree", logData, "taskLog", 0);
	
	$("#searchStatus").css("display", "none");
	
	$("#searchId").change(function() {
		if ($("#searchId option:selected").val() == "2") {
			$("#searchByContent").css("display", "none");
			$("#searchButton").css("display", "none");
			$("#searchStatus").css("display", "");
			
			searchContent = "";
		} else {
			$("#searchByContent").css("display", "");
			$("#searchButton").css("display", "");
			$("#searchStatus").css("display", "none");
			
			searchStatus = "";
		}
	});

	CurrentHeight = $(window).height() - 100;
	$("#MailListRayer").css("height", CurrentHeight - 63 + "px");
	$("#taskTree").css("height", CurrentHeight + "px");
	$("#projectContent").css("height", CurrentHeight + "px");
	$("#contentList").css("height", (CurrentHeight - 63) + "px");
	$("#projectListBody").css("height", (CurrentHeight - 208) + "px");
	$("#divList").css("height", (CurrentHeight - 125) + "px");
	$("#divList").css("overflow", "auto");
	
	$(window).resize(function() {

		CurrentHeight = $(window).height() - 100;
		$("#MailListRayer").css("height", CurrentHeight - 63 + "px");
		$("#taskTree").css("height", CurrentHeight + "px");
		$("#projectContent").css("height", CurrentHeight + "px");
		$("#contentList").css("height", (CurrentHeight - 63) + "px");
		$("#projectListBody").css("height", (CurrentHeight - 208) + "px");
		$("#divList").css("height", (CurrentHeight - 125) + "px");
		$("#divList").css("overflow", "auto");
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
		listNumber : 15,
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
			
			//viewSetting
			CurrentHeight = $(window).height() - 100;
			$("#MailListRayer").css("height", CurrentHeight - 63 + "px");
			$("#taskTree").css("height", CurrentHeight + "px");
			$("#projectContent").css("height", CurrentHeight + "px");
			$("#contentList").css("height", (CurrentHeight - 63) + "px");
			$("#projectListBody").css("height", (CurrentHeight - 188) + "px");
			$("#divList").css("height", (CurrentHeight - 125) + "px");
			$("#divList").css("overflow", "auto");
		}	
	});
}

function searchLogContent() {
	searchContent = $("#searchByContent").val();
	currentPage = 1;
	setContentList();
}

function searchLogStatus(status) {
	searchStatus = status;
	currentPage = 1;
	setContentList();
}

function searchClear() {
	searchContent = "";
	$("#searchByContent").val("");
	searchStatus = "";
	orderWhat = "";
	orderHow = "";
	currentPage = 1;
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

function setContentTitle(taskName, totalCount) {
	
	if (!totalCount) {
		totalCount = 0;
	}
	
	$("#taskNameArea").html(taskName);
	$("#mailBoxInfo").html("<spring:message code='ezPMS.t3' /> <span class='txt_color' id='totalCount'>" + totalCount + " </span><spring:message code='ezPMS.t4' /></span>");
}

function selectedTR(elem) {
	var parentElem = $(elem).parent();
	$("#tableBody tr").removeClass("selectTR");
	$(parentElem).addClass("selectTR");
}

</script>
<style type="text/css">
#taskTree {
	margin-right : 5px;
	width : 276px;
	overflow-y : auto;
	overflow-x : hidden;
	border : 1px solid #d1d1d1;
	float : left;
}

#projectArea {
	overflow : auto;
	border : 1px solid #d1d1d1;
}

#projectContent {
	min-width : 1057px;
}

.jstree-node > a {
    /* 100% - (the width of the presentation node : the line - the left padding of the <a> node - the right padding of the <a> node)*/
    width: 200px;
    text-overflow: ellipsis;
    overflow: hidden;
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
	background-color: rgb(244, 245, 245);
}

#taskNameArea {
	max-width : 50%;
	white-space : nowrap;
	overflow : hidden;
	text-overflow : ellipsis;
	display : inline-block;
}

#iconLine {
	height: 80px;
	margin-left: 10px;
	margin-top: 5px;
	margin-right: 20px;
}

#searchArea input, #searchArea select {
	height : 27px;
}

.col1 {width : 57px;}
.col3 {width : 200px;}
.col4 {width : 80px;}
.col5 {width : 163px;}

</style>
</head>
<body style="margin : 10px 10px 0px 10px">
<div id="taskTree"></div>
<div id="projectArea" class="projectAreaStyle">
<div id="projectContent">
	<div id="iconLine" class="mainbody" style="margin:0px; height:auto;">
		<h1 id="taskName" class="project_subh1">
			<div id="taskNameArea"></div>
			<span id='mailBoxInfo' style='vertical-align: text-bottom;'></span>
			<span id="searchArea" style="float:right;font-weight:normal;color:black;">
				<select id="searchId">
					<option value="1" selected><spring:message code='ezPMS.t186' /></option>
					<option value="2"><spring:message code='ezPMS.t188' /></option>
				</select>
				<input type="text" id="searchByContent" onkeypress="if(event.keyCode==13) {searchLogContent(); return false;}" style="width:150px;ime-mode: active;border-right:0px;vertical-align: baseline"/>
	                <a id="searchButton" href="#" style="float:right;"><img src="/images/bsearch_new.gif" border="0" onclick="searchLogContent()"></a>
				<select id="searchStatus" onchange="searchLogStatus(this.value)">
					<option value="0"><spring:message code='ezPMS.t14' /></option>
					<option value="1"><spring:message code='ezPMS.t40' /></option>
					<option value="2"><spring:message code='ezPMS.t110' /></option>
					<option value="3"><spring:message code='ezPMS.t11' /></option>
				</select>
			</span>
		</h1>
	</div>
	<div id="contentList" style="overflow:auto; width:100%; margin:0px; padding:0px 10px; box-sizing:border-box;">
	<span id="MailListRayer" style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
	</span>
	</div>
	</div>
</div>
</body>
</html>