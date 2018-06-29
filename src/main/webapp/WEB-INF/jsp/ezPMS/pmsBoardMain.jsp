<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t141' /></title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/ezPMS/pms.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>

<!-- time picker-->
<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
<script>
 	var projectId = ${projectId};
 	var CurrentHeight = document.documentElement.clientHeight - 100;
 	var projectName = null;
	var groupId = null;
	var taskId = null;
	var taskName = null;
	var currentPage = 1;
	var treeData = "";
	var itemIds;
	var orderWhat = "";
	var orderHow = "";
	var limit = 10;
	
	//검색을 위한 variables
	var searchByTaskName = "";
	var searchByUser = "";
	var searchByStartDate = "";
	var searchByEndDate = "";
	var searchByTitle = "";
	var searchByOverview = "";
	var searchByContent = "";
	var searchOrNot = "";
	
	$(document).ready(function() {
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		
		CurrentHeight = $(window).height()-100;
		$("MailListRayer").css("height", CurrentHeight + "px");
		$("#taskTree").css("height", CurrentHeight + "px");
		$("#projectContent").css("height", CurrentHeight + "px");
		$("#contentList").css("height", (CurrentHeight - 100) + "px");
		$("#projectListBody").css("height", (CurrentHeight - 190) + "px");
		$("#divList").css("height", (CurrentHeight - 165) + "px");
		$("#divList").css("overflow", "auto");
		
		treeData = ${data};
		treeData = JSON.parse(JSON.stringify(treeData));
		
		getProjectTaskTree("taskTree", treeData, false);
		
		$("#taskTree").on("click", ".jstree-anchor", function() {			
			if($(this).parent().attr("id").charAt(0) == 't') { 
				groupId = $(this).parents("li").eq(1).attr("id");
				taskId = $(this).parent().attr("id").substr(1);
			} else {
				groupId = $(this).parent().attr("id");
				taskId = null;
			}
			currentPage = 1;
			
			// 트리 클릭 시, 검색 조건 초기 화
			searchByTaskName = "";
			searchByUser = "";
			searchByStartDate = ""; 
			searchByEndDate = "";
			searchByTitle = "";
			searchByOverview = "";
			searchByContent = "";
			searchOrNot = "";
			
			getBoardList();
		});
		
		// 트리가 모두 로드된 다음 실행
	 	$("#taskTree").on("ready.jstree", function() {
			var project = $("li[role='treeitem'][aria-level='1']").last();
			
			groupId = project.attr("id");
			project.children("a").click();
			
			taskName = projectName;
		});
	});
	
	function goAddBoard() {
		var feature = GetOpenPosition(790, 800);
		window.open("/ezPMS/goAddBoard.do?projectId=" + projectId + "&groupId=" + groupId + "&taskId=" + taskId + "&mode=new", 
					"", "width=790, height=800, resizable=no, scrollbars=no, status=no" + feature);
	}
	
	function getBoardList() {
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
			searchByTaskName : searchByTaskName,
			searchByUser : searchByUser,
			searchByStartDate : searchByStartDate,
			searchByEndDate : searchByEndDate,
			searchByTitle : searchByTitle,
			searchByOverview : searchByOverview,
			searchByContent : searchByContent,
			searchOrNot : searchOrNot
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
	
	function setContentTitle(taskName, contentCount) {
		var contentTitle = "";
		
		if (contentCount == null || contentCount == "") {
			totalCount = 0;
		} else {
			totalCount = contentCount;
		}
		
		console.log(taskName);
		taskName = convertString(taskName);
		
		contentTitle = "<span style='width:50%; text-overflow:ellipsis; font-size:16px;'>" + taskName + "<span id='mailBoxInfo'> <spring:message code='ezPMS.t3' /> <span style='color:#017BEC;' id='totalCount'>" + contentCount + " </span><spring:message code='ezPMS.t4' /></span>";

		$("#taskNameArea").html(contentTitle);
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page) {
		currentPage = page;
		getBoardList();
	}
	
	// 메인에서 체크박스로 선택 후 삭제할 때
	function deleteBoardsAction(itemIds) {
		data = {
			itemIds : itemIds,
			projectId : projectId
		}
		
		$.ajax({
			type : "DELETE",
			url : "/ezPMS/deleteBoard.do",
			dataType : "json",
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				if(result.data == 'success') {
					
					for(i in itemIds) {
						var deletedTR = $("tr[data-itemid = " + itemIds[i] + "]");
						var title = deletedTR.children("td.boardTitle").text();
						var taskName = deletedTR.children("td.taskName").text();
						var groupId = deletedTR.attr("data-groupId");
						var taskId = deletedTR.attr("data-taskId");
						
						addTaskLog(projectId, 3, groupId, taskId, "[" + taskName.trim() + "<spring:message code='ezPMS.t206' /> " + "[" + title.trim() + "<spring:message code='ezPMS.t207' />");
					}
					
					getBoardList();
				} else {
					alert("<spring:message code='ezPMS.t108' />");
				}	
			},
			error : function() {
				alert("<spring:message code='ezPMS.t213' />");
			}
		})
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
		
		getBoardList();
	}
</script>

<style>
	#taskTree {
		margin-right : 5px;
		width : 276px;
		overflow-y : auto;
		overflow-x : hidden;
		border : 1px solid #d1d1d1;
		float : left;
	}
	
	.jstree-node > a {
    width: 200px;
    text-overflow: ellipsis;
    overflow: hidden;
	}

	#taskName {
		margin-top: 14px;
		margin-bottom : 19px;
	}
	
	#projectArea {
		overflow : auto;
		border : 1px solid #d1d1d1;
	}
	
	#projectContent {
		min-width : 1057px;
	}
	
	#iconLine {
		height: 95px;
		margin-left: 10px;
		margin-top: 5px;
	}
	
	#contentList {
		width : 98%;
		margin-left : 1%;
	}
	
	#searchDiv {
		margin-left : 11px;
	}
	
	.mainlist tr:hover {
		background-color: rgb(244, 245, 245);
	}
	
	#taskNameArea {
		display : inline-block;
	}
</style>

</head>
<body>
	<div id="taskTree"></div>
	<div id="projectArea">
		<div id="projectContent">
			<div id="iconLine" class="mainbody" style="margin:0px;">
				<h1 id="taskName"><div id="taskNameArea"></div></h1>
				<div id="mainmenu">
				<ul>
					<c:if test="${userRole ne 3}">
						<li><span onclick="goAddBoard()"><spring:message code='ezPMS.t40' /></span></li>
						<li><span onclick="deleteBoards()"><spring:message code='ezPMS.t11' /></span></li>
						<li><span onclick="goMoveBoards()"><spring:message code='ezPMS.t111' /></span></li>
					</c:if>
					<li><span onclick="location.reload()"><spring:message code='ezPMS.t123' /></span></li>
					<li><span onclick="showSearchDiv()"><spring:message code='ezPMS.t1' /> <img src="/images/etc/view-sortup.gif" class="searchViewIcon"></span></li>
				</ul>
				</div>
			</div>
			<div id = "searchDiv" style="display:none; margin-bottom:40px;">
				<table class="content" style="width:100%;">
					<tbody>
						<tr>
							<th><spring:message code='ezPMS.t98' /> </th>
							<td style="width:50%">
								<input type="text" id="searchByTaskName" style="width:50%; margin-right:5px;">
							</td>
							<th><spring:message code='ezPMS.t114' /></th>
							<td><input type="text" style="width:100%" id="searchByUser"></td>
						</tr>
						<tr>
							<th><spring:message code='ezPMS.t215' /></th>
							<td style="width:50%" colspan="3"><input type="text" style="width:100%" id="searchByTitle"></td>
						<!-- 	<th>내 용</th>
							<td style="width:50%"><input type="text" style="width:100%" id="searchByContent"></td> -->
						</tr>
						<tr>
							<th><spring:message code='ezPMS.t81' /></th>
							<td colspan="3"><input type="text" style="width:100%" id="searchByOverview"></td>
						</tr>
						<tr>
							<th><spring:message code='ezPMS.t125' /> </th>
							<td colspan="3">
								<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
								<a class="imgbtn" onclick="emptyDate(this)" style="margin-left:3px;"><span><spring:message code='ezPMS.t124' /></span></a>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="newbtn_position">
        			<a class="imgbtn" onclick="searchBoard()"><span><spring:message code='ezPMS.t1' /></span></a>
    			</div>
			</div>
			<div id="contentList" style="overflow: auto">
				<span id="MailListRayer"
					style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
				</span>
			</div>
		</div>
	</div>
</body>
</html>