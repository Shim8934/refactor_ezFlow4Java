<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>업무 이력 조회 페이지</title>
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
// 	var logList;
	
// 	$(function(){
// 		logList = ${logList};
// 	});
	
	
var projectId = parent.parent.projectId;
var CurrentHeight = document.documentElement.clientHeight - 100;
var groupId = 0;
var taskId = 0;
var currentPage = 1;
var totalCount = 0;
var orderWhat = "";
var orderHow = "";
var searchContent = "";
var searchStatus = "";
var logData = '${logList}';
var taskData = {};

$(document).ready(function(){
	$(window).resize(function() {
		CurrentHeight = $(window).height()-100;
		$("#projectContent").css("height", CurrentHeight + "px");
		$("#contentList").css("height", (CurrentHeight - 100) + "px");
		$("#divList").css("height", (CurrentHeight - 160) + "px");
		$("#projectListBody").css("height", (CurrentHeight - 150) + "px");
	});

});

$(function(){
	if(logData !== ""){
		logData = JSON.parse(logData);
	}
	taskData = JSON.parse(parent.document.querySelector("[name='frameParamTaskDetails']").value);
	taskName = taskData.taskName;
	contentTitle = taskName;
	setInitOrder();
	setContentTitle(taskName, logData.length);
	
	CurrentHeight = $(window).height()-100;
// 	$("#projectContent").css("height", CurrentHeight + "px");
	$("#contentList").css("height", (CurrentHeight - 100) + "px");
	$("#projectListBody").css("height", (CurrentHeight - 160) + "px");
	$("#divList").css("height", (CurrentHeight - 150) + "px");
	
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
	var taskId = "${taskId}";
	var groupId = "${groupId}";
	
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
		url : "/ezPMS/getLogListTab.do",
		success : function(contentList) {
			$("#contentList").html(contentList);
			//찾아 준 후 초기화
			searchContent = "";
			$("#searchByContent").val("");
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
	
	contentTitle = "<span style='width:50%; text-overflow:ellipsis; font-size:18px; font-weight:bold;'>" + taskName + "<span id='totalCount'> - [총 " + totalCount + " 개]</span></span>";
	
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
	overflow : auto;
	border : 1px solid #d1d1d1;
	float : left;
	display : inline-block
}

#projectArea {
	width : 806px;
	overflow : auto;
	border : 1px solid #d1d1d1;
}

#projectContent {
	height: 280px;
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
	height: 72px;
}

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
</style>
</head>
<body>
<div id="taskTree" style="display:none;"></div>
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
		<div style="width: 100%;" id="divList">
		<div id="lvBoardList">
			<table id="tableHeader" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowondblclick="ItemRead_onclick(this)" width="100%" border="0"
						class="mainlist" style="overflow:hidden">
				<thead id="BoardList_THEAD">
					<tr id="BoardList_TH">
						<th id="BoardList_TH_0" onclick="setListOrder(this)" order="LOG_STATUS" style="text-align: left; overflow: hidden; white-space: nowrap; 
							text-overflow: ellipsis; cursor: pointer; width: 20px; text-align: center" class="h5_center">상태</th>
						<th id="BoardList_TH_1" onclick="setListOrder(this)" order="LOG_CONTENT"
							style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 20%;"
							class="h5_center">이력 내용</th>
						<th id="BoardList_TH_2"
							style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 40px"
							class="h5_center">작업 이름</th>
						<th id="BoardList_TH_3" onclick="setListOrder(this)" order="USER_NAME"
							style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 30px"
							class="h5_center">담당자</th>
						<th id="BoardList_TH_4" onclick="setListOrder(this)" order="LOG_DATE"
							style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 70px"
							class="h5_center">등록일</th>
						</tr>
						</thead>
					</table>
				</div>
				<div id="projectListBody" multiselectable="false" useocs="false" style="overflow:auto; min-width: 469px;">
				<table id="tableBody" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="ItemPreviewRead_click" rowondblclick="ItemRead_onclick(this)"  width="100%" border="0" class="mainlist" style="">
						<tbody style="background-color: rgb(255, 255, 255);">
							<c:choose>
								<c:when test="${empty logList}">
									<tr>
										<td colspan="5" style="text-align : center"> 작업이력이 없습니다. </td>
									</tr>
								</c:when>
							<c:otherwise>
								<c:forEach items="${logList }" var="log">
								<tr style="cursor: pointer;" id="${log.logId }" class="listRow" ondblclick="goProjectDetails(this)">
									<td style="width: 20px; cursor: default; text-align: center">
										<c:choose>
											<c:when test="${log.logStatus eq 1 }">
												<span style="background-color:#8DFF1B;">&nbsp;<c:out value="등록"/>&nbsp;</span>
											</c:when>
											<c:when test="${log.logStatus eq 2 }">
												<span style="background-color:#ffff66;">&nbsp;<c:out value="수정"/>&nbsp;</span>
											</c:when>
											<c:otherwise>
												<span style="background-color:#FF7A1B;">&nbsp;<c:out value="삭제"/>&nbsp;</span>
											</c:otherwise>
										</c:choose>
									</td>
									<td onclick="selectedTR(this);"
										style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 20%"><c:out
											value="${log.logContent }" /></td>
									<td onclick="selectedTR(this);"
										style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 40px; text-align:center;">
										<c:choose>
											<c:when test="${empty log.taskName }">
												<c:out value="${log.groupName }" />
											</c:when>
											<c:otherwise>
													<c:out value="${log.taskName }" />
											</c:otherwise>
										</c:choose>
									</td>
									<td onclick="selectedTR(this);"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 30px"><c:out
											value="${log.userName }" /></td>
									<td onclick="selectedTR(this);"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 70px"><div
											name="${log.logId }" style="margin-right: 2px;"></div>&nbsp;
										<div style="margin-top: 5px; display: inline-block;">
											<c:out value="${log.logDate }" />
										</div>
									</td>
								</tr>
								</c:forEach>
							</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>
			<c:choose>
				<c:when test="${paging.endPage>0 }">
					<div id="tblPageRayer" style="width: 470px; margin: 6px auto;">
					<div class="pagenavi">
							<c:choose>
								<c:when test="${paging.currentPage gt 1}">
									<span onclick="goToPageByNum(1)" class="btnimg"><img
										src="/images/sub/btn_p_prev.gif" width="16" height="16"></span>
								</c:when>
								<c:otherwise>
									<span class="btnimg"><img
										src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${paging.startPage gt 1}">
									<span onclick="goToPageByNum(${paging.startPage-1})"
										class="btnimg"><img src="/images/sub/btn_prev.gif"
										width="16" height="16"></span>
								</c:when>
								<c:otherwise>
									<span class="btnimg"><img
										src="/images/sub/btn_prev01.gif" width="16" height="16"></span>
								</c:otherwise>
							</c:choose>
							<span class="ptxt"
								onclick="<c:if test="${paging.currentPage gt 1 }">goToPageByNum(${paging.currentPage-1})</c:if>"><spring:message
									code='ezApproval.t931' /></span>
							<c:forEach begin="0" end="${paging.endPage-paging.startPage }"
								varStatus="status">
								<c:choose>
									<c:when
										test="${paging.startPage+status.index eq  paging.currentPage}">
										<span class="on">${paging.currentPage }</span>
									</c:when>
									<c:otherwise>
										<span
											onclick="goToPageByNum(${paging.startPage+status.index})">${paging.startPage+status.index}</span>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<span class="ptxt"
								onclick="<c:if test="${paging.totalPage gt paging.currentPage }">goToPageByNum(${paging.currentPage+1})</c:if>"><spring:message
									code='ezApproval.t932' /></span>
							<c:choose>
								<c:when test="${paging.totalPage gt paging.endPage }">
									<span class="btnimg"
										onclick="goToPageByNum(${paging.endPage+1})"><img
										src="/images/sub/btn_next.gif" width="16" height="16"></span>
								</c:when>
								<c:otherwise>
									<span class="btnimg"><img
										src="/images/sub/btn_next01.gif" width="16" height="16"></span>
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${paging.totalPage gt paging.currentPage }">
									<span class="btnimg"
										onclick="goToPageByNum(${paging.totalPage})"><img
										src="/images/sub/btn_n_next.gif" width="16" height="16"></span>
								</c:when>
								<c:otherwise>
									<span class="btnimg"><img
										src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:when>
			<c:otherwise>
		<div id="tblPageRayer" style="width: 470px; margin: 6px auto;">
					<div class="pagenavi">
						<span class="btnimg"><img
							src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>
						<span class="btnimg"><img
							src="/images/sub/btn_prev01.gif" width="16" height="16"></span>
						<span class="ptxt"> <spring:message code='ezApproval.t931' /></span> <span class="on">1</span> <span
							class="ptxt"><spring:message code='ezApproval.t932' /></span> <span
							class="btnimg"><img src="/images/sub/btn_next01.gif"
								width="16" height="16"></span> <span class="btnimg"><img
							src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
					</div>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
	</div>
</div>
</body>
</html>