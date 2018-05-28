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
<script type="text/javascript">
var projectId = "${project.projectId}";
var nowPosition = "";

$(function() {
	setMyTaskList("task");
	nowPosition = "task";
	
	$("#1tab0").addClass("tabon");
	
	$("#1tab0").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		//담당 업무
		nowPosition = "task";
		setMyTaskList("task");
	});
	
	$("#1tab1").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//담당 그룹
		nowPosition = "group";
		setMyTaskList("group");
		
	});
	
	$("#1tab2").click(function(){
		var clickTabId = $(this).attr("id");
		var nowTabAttr = $(".tabon").attr("id");
		changeTab(clickTabId, nowTabAttr);
		
		//담당 프로젝트
		nowPosition = "project";
		setMyTaskList("project")
	});
	
	$(".tab").hover(function(){
		$(this).addClass("tabover");
	},
		function(){
			$(this).removeClass("tabover");
	});
});

function changeTab(clickTabId, nowTabAttr) {
	$("#" + nowTabAttr).attr("class", "tab");
	$("#" + clickTabId).attr("class", "tabon");
}

function setMyTaskList(position) {
	$("#contentList").html(position);
}


</script>
<style type="text/css">
#iconArea div{
	float : right;
	margin-right: 10px;
	height: 23px;
	font-size : 12px;
}

#iconArea div select {
	width : 66px;
}
</style>
</head>
<body class="mainbody" style="height: 95%; overflow: hidden" marginwidth="0" marginheight="0">
	<h1 id="projectName">나의 업무</h1>
	<div class="portlet_tabpart01" style="margin-bottom: 10px">
	   <div class="portlet_tabpart01_top" id="tab1">
	   		<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab">담당 업무</span></p>
	  	 	<p id="FBoard_sub1"><span id="1tab1" divname="FBoard_div0" class="tab">담당 그룹</span></p>
	  	 	<p id="FBoard_sub2"><span id="1tab2" divname="FBoard_div0" class="tab">담당 프로젝트</span></p>
	 	</div>
	</div>
	<div id="contentArea">
	<div id="iconArea">
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
					<th>업무명 </th>
					<td style="width:50%"><input type="text" id="searchByName" style="width:50%; margin-right:5px;"></td>
					<th>담당자</th>
					<td><input type="text" id="searchByUser"></td>
				</tr>
				<tr>
					<th>시작일 </th>
					<td style="width:50%"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><a class="imgbtn" onclick="emptyDate(this)" style="margin-left:3px;"><span>날짜 초기화</span></a></td>
					<th>종료일</th>
					<td><input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"><a class="imgbtn" onclick="emptyDate(this)" style="margin-left:3px;"><span>날짜 초기화</span></a></td>
				</tr>
				<tr>
					<th>상위그룹 </th>
					<td colspan="3" style="width:50%"><input type="text" style="width:100%" id="searchByGroupName"></td>
				</tr>
				<tr>
					<th>업무개요</th>
					<td colspan="3"><input type="text" style="width:100%" id="searchByOverview"></td>
				</tr>
			</tbody>
		</table>
		<a class="imgbtn" onclick="searchTask()" style="margin-left:40%;"><span>검색</span></a>
	</div>
	<div id="contentList"></div>
	</div>
</body>
</html>