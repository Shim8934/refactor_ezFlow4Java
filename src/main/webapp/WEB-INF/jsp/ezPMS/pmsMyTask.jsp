<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height: 99%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/Tab.css" type="text/css">
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>

<!-- time picker-->
<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
<script type="text/javascript">
var projectId = "${project.projectId}";
var nowPosition = "";
var status = "";
var kanbanOrder = "MA";
var projectId = 0;
var startRow = 0;
var listNumber = 10;
var currentPage = 1;
var orderWhat = "";
var orderHow = "";
var CurrentHeight = document.documentElement.clientHeight - 110;
var searchByTaskName = "";
var searchByGroupName = "";
var searchByProjectName = "";
var searchByUser = "";
var searchByPlanStartDate = "";
var searchByPlanEndDate = "";
var searchByOverview = "";
var searchByUpperGroupName = "";

$(function() {
	setMyTaskList("task");
	nowPosition = "task";
	getDatePicker();
	
	$("#1tab0").addClass("tabon");
	
	$("#1tab0").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		//담당 업무
		nowPosition = "task";
		$("#taskName").text("업무명");
		$("#searchByGroupName").attr("id", "searchByTaskName");
		$("#mainmenu").find("div").css("display", "");
		orderWhat = "";
		setMyTaskList("task");
	});
	
	$("#1tab1").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//담당 그룹
		nowPosition = "group";
		$("#taskName").text("그룹명");
		$("#searchByTaskName").attr("id", "searchByGroupName");
		$("#mainmenu").find("div").css("display", "none");
		orderWhat = "";
		setMyTaskList("group");
		
		
	});
	
	$("#1tab2").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//담당 프로젝트
		nowPosition = "project";
		orderWhat = "";
		setMyTaskList("project")
	});
	
	$(".tab").hover(function(){
		$(this).addClass("tabover");
	},
		function(){
			$(this).removeClass("tabover");
	});
	
});

$(document).ready(function(){
	$(window).resize(function() {
		CurrentHeight = $(window).height()-100;

		$("#MailListRayer").css("display", "inline-block");
		$("#boardStyle").attr("src", "/images/kr/cm/btn_onbottomframe.gif");
	
		document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		$("#projectContent").css("height", CurrentHeight + "px");
		$("#contentList").css("height", (CurrentHeight - 65) + "px");
		document.getElementById("divList").style.height = (CurrentHeight - 100) + "px";
		document.getElementById("projectListBody").style.height = (CurrentHeight - 170) + "px";
	});
});

function getDatePicker() {
	$("#Sdatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.gif",
		buttonImageOnly: true,
		beforeShow: function (input) {
			var i_offset = $(input).offset();
			setTimeout(function () {
				//$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
			})
		}
	});

	$("#Edatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.gif",
		buttonImageOnly: true,
		beforeShow: function (input) {
			var i_offset = $(input).offset();
			setTimeout(function () {
				//$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
			})
		}
	});
	
	var SDate = new Date();
	var EDate = new Date();

	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	$("#Sdatepicker").datepicker('setDate', "");
	
	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	$("#Edatepicker").datepicker('setDate', "");
	
	$.datepicker.regional["<spring:message code='main.t0619' />"] = {
			closeText: "<spring:message code='main.t3' />",
			prevText: "<spring:message code='main.t0604' />",
			nextText: "<spring:message code='main.t0605' />",
			currentText: "<spring:message code='main.t0606' />",
			monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
			             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
			             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
			             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
			monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
			                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
			                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
			                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
			dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
			           "<spring:message code='main.t0627' />"],
			dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			                "<spring:message code='main.t0627' />"],
			dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			              "<spring:message code='main.t0627' />"],
			weekHeader: "Wk",
			dateFormat: "yy-mm-dd",
			firstDay: 0,
			isRTL: false,
			duration: 200,
			showAnim: "show",
			showMonthAfterYear: true
	  };
	  
	  $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
}

function changeTab(clickTabId, nowTabAttr) {
	$("#" + nowTabAttr).attr("class", "tab");
	$("#" + clickTabId).attr("class", "tabon");
}

function setMyTaskList(position) {
	if (status == "") {
		status = "A";
	}
	
	var url = "";
	
	if (position == "task") {
		url = "/ezPMS/getProjectTaskList.do";
	} else if (position == "group") {
		url = "/ezPMS/getGroupList.do";
	} else {
		url = "/ezPMS/getMyProjectList.do";
	}
	
	var data = {
		position : position,
		status : status,
		projectId : projectId,
		kanbanOrder : kanbanOrder,
		currentPage : currentPage,
		listNumber : listNumber,
		//헤더 정렬
		orderWhat : orderWhat,
		orderHow : orderHow,
		//검색
		searchByTaskName : searchByTaskName,
		searchByUser : searchByUser,
		searchByStartDate : searchByPlanStartDate,
		searchByEndDate : searchByPlanEndDate,
		searchByGroupName : searchByGroupName,
		searchByOverview : searchByOverview,
		searchByProjectName : searchByProjectName,
		searchByUpperGroupName : searchByUpperGroupName
	}
	
	$.ajax({
		type : "post",
		contentType : "application/json; charset=UTF-8",
		dataType : "html",
		data : JSON.stringify(data),
		url : url,
		success : function(contentList) {
			$("#contentList").html(contentList);
			//빈값으로 만들기
			searchByTaskName = "";
			searchByUser = "";
			searchByPlanStartDate = "";
			searchByPlanEndDate = "";
			searchByGroupName = "";
			searchByProjectName = "";
			searchByUpperGroupName = "";
			
			$("#searchByTaskName").val("");
			$("#searchByUser").val("");
			$("#Sdatepicker").val("");
			$("#Edatepicker").val("");
			$("#searchByGroupName").val("");
			$("#searchByProjectName").val("");
			$("#searchByOverview").val("");
			$("#searchByUpperGroupName").val("");
			
			setInitOrder();
		}
	});
}

function searchStatus(statusValue) {
	status = statusValue;
	
	setMyTaskList(nowPosition);
}

function setInitOrder() {
	$("#BoardList_TH th").each(function() {
			if (orderWhat == $(this).attr("order")) {
				if (orderHow == 'asc') {
					$(this).attr("sort", "asc");
					$(this).append(' <img src="/images/etc/view-sortdown.gif" align="absmiddle">');
				} else if (orderHow == 'desc') {
					$(this).attr("sort", "desc");
					$(this).append(' <img src="/images/etc/view-sortup.gif" align="absmiddle">');
				}
			}
	});

	projectListScroll();
}

function projectListScroll() {
	var thWidth = document.getElementById("tableHeader").clientWidth
			- document.getElementById("tableBody").clientWidth;
	if (thWidth > 0) {
		$("#BoardList_TH").append('<th style=width:2px;></th>');
	}
}

function selectedTR(elem) {
	var parentElem = $(elem).parent();
	$("#tableBody tr").removeClass("selectTR");
	$("#tableBody tr").find("input[type='checkbox']").removeProp("checked");
	$(parentElem).addClass("selectTR");
	$(parentElem).find("input[type='checkbox']").prop("checked","true");
}

//체크박스 전체선택 혹은 해제
function selectedAllTR(elem) {
	if ($(elem).is(":checked")) {
		 $('input:checkbox[name="boardCheckbox"]').each(function() {
			 $(this).prop("checked","true");
			 $(this).parent().parent().addClass("selectTR");
		 });
	} else {
		 $('input:checkbox[name="boardCheckbox"]').each(function() {
			 $(this).removeProp("checked","true");
			 $(this).parent().parent().removeClass("selectTR");
		 });
	}
}

function checkedCheckbox(elem) {
	var selectRow = '' + elem;
	
	if (selectRow.indexOf("TableCell") == -1) {
		if ($(elem).is(":checked")) {
			$(elem).prop("checked","true");
			$(elem).parent().parent().addClass("selectTR");
		} else {
			$(elem).removeProp("checked");
			$(elem).parent().parent().removeClass("selectTR");
		}
	} else {
		if (!$(elem).parent().find("input:checkbox[name='boardCheckbox']").is(":checked")) {
			$(elem).parent().find("input:checkbox[name='boardCheckbox']").prop("checked","true");
			$(elem).parent().addClass("selectTR");
		} else {
			$(elem).parent().find("input:checkbox[name='boardCheckbox']").removeProp("checked");
			$(elem).parent().removeClass("selectTR");
		}
	}
}

//페이지 번호에 의한 셋팅
function goToPageByNum(page) {
	currentPage = page;
	setMyTaskList(nowPosition);
}

//헤더 리스트 셋팅
function setListOrder(elem) {

	orderWhat = $(elem).attr("order");
	orderHow = $(elem).attr("sort");

	if (orderHow == null) {
		orderHow = 'asc';
	} else if (orderHow == 'asc') {
		orderHow = 'desc';
	} else if (orderHow == 'desc') {
		orderHow = 'asc';
	}

	setMyTaskList(nowPosition);
}

function searchContent() {
	currentPage = 1;
	searchByTaskName = $("#searchByTaskName").val();
	searchByUser = $("#searchByUser").val();
	searchByPlanStartDate = $("#Sdatepicker").val();
	searchByPlanEndDate = $("#Edatepicker").val();
	searchByGroupName = $("#searchByGroupName").val();
	searchByProjectName = $("#searchByProjectName").val();
	searchByOverview = $("#searchByOverview").val();
	
	setMyTaskList(nowPosition);
}
</script>
<style type="text/css">
#mainmenu div{
	float : right;
	margin-right: 10px;
	height: 23px;
	font-size : 12px;
}

#mainmenu div select {
	width : 66px;
}

.selectTR {
	background-color: rgb(233, 241, 255);
}

.listRow:hover {
	background-color: rgb(233, 241, 255);
}

#contentList {
	width : 99%;
}

#contentArea {
	width : 100%;
	height : 88%;
}
</style>
</head>
<body class="mainbody" style="height: 95%; overflow: hidden" marginwidth="0" marginheight="0">
	<h1>나의 업무<span id="mailBoxInfo"> - [총 <span style="color:#017BEC;" id="totalCount"> </span>개]</span></h1>
	<div class="portlet_tabpart01" style="margin-bottom: 10px">
	   <div class="portlet_tabpart01_top" id="tab1">
	   		<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab">담당 업무</span></p>
	  	 	<p id="FBoard_sub1"><span id="1tab1" divname="FBoard_div0" class="tab">담당 그룹</span></p>
	  	 	<p id="FBoard_sub2"><span id="1tab2" divname="FBoard_div0" class="tab">담당 프로젝트</span></p>
	 	</div>
	</div>
	<div id="contentArea" style="overflow:auto;">
	<div id="mainmenu">
		<a class="imgbtn" id="addTaskBtn" onclick="showSearchDiv()"
		style="margin-left: 1px; margin-top: 1px;"><span>검색 <img src="/images/etc/view-sortup.gif" align="absmiddle" class="searchViewIcon"></span></a>
		<div>
				업무 상태별 보기 <select id="searchStatus" onchange="searchStatus(this.value)">
					<option value="A">전체</option>
					<option value="P">진행</option>
					<option value="W">대기</option>
					<option value="C">완료</option>
					<option value="L">지연</option>
					<option value="S">보류</option>
				</select>
		</div>
	</div>
	<div id = "searchDiv" style="display:none; margin-bottom:10px; display:none;">
		<table class="content" style="width:80%; margin-bottom:5px;">
			<tbody>
				<tr>
					<th id="taskName">업무명 </th>
					<td style="width:50%"><input type="text" id="searchByTaskName" style="width:100%; margin-right:5px;"></td>
					<th>담당자</th>
					<td><input type="text" style="width:100%" id="searchByUser"></td>
				</tr>
				<tr>
					<th>시작일 </th>
					<td style="width:50%"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><a class="imgbtn" onclick="emptyDate(this)" style="margin-left:3px;"><span>날짜 초기화</span></a></td>
					<th>종료일</th>
					<td><input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"><a class="imgbtn" onclick="emptyDate(this)" style="margin-left:3px;"><span>날짜 초기화</span></a></td>
				</tr>
				<tr>
					<th>상위그룹 </th>
					<td style="width:50%"><input type="text" style="width:100%" id="seachByUpperGroupName"></td>
					<th>프로젝트 이름</th>
					<td><input type="text" style="width:100%" id="searchByProjectName"></td>
				</tr>
				<tr>
					<th>업무개요</th>
					<td colspan="3"><input type="text" style="width:100%" id="searchByOverview"></td>
				</tr>
			</tbody>
		</table>
		<a class="imgbtn" onclick="searchContent()" style="margin-left:40%;"><span>검색</span></a>
	</div>
	<div id="contentList"></div>
	<span id="MailListRayer" style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
	</span>
	</div>
</body>
</html>