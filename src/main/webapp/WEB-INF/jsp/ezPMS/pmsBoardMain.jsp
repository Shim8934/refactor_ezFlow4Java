<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>

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
	var treeData = JSON.parse('${data}');
	var itemIds;
	var orderWhat = "";
	var orderHow = "";
	
	//검색을 위한 variables
	var searchByTaskName = "";
	var searchByUser = "";
	var searchByStartDate = "";
	var searchByEndDate = "";
	var searchByTitle = "";
	var searchByOverview = "";
	var searchByContent = "";
	
	$(document).ready(function() {
		
		CurrentHeight = $(window).height() - 100;
		$("MailListRayer").css("height", CurrentHeight + "px");
		$("#taskTree").css("height", CurrentHeight + 10 + "px");
		$("#projectContent").css("height", CurrentHeight + "px");
		$("#contentList").css("height", (CurrentHeight - 100) + "px");
		$("#projectListBody").css("height", (CurrentHeight - 160) + "px");
		$("#divList").css("height", (CurrentHeight - 150) + "px");
		
		getProjectTaskTree("taskTree", treeData, false);
		
		$("#taskTree").on("click", ".jstree-anchor", function() {
			taskName = $(this).text();
			var contentCount = 0;
			var contentTitle = "";
			
			// 작업명 옆에 게시판 갯수가 표시되었을 때 그것을 잘라냄
			if(taskName.indexOf('(') != -1) {
				contentCount = taskName.substring(taskName.indexOf('(') + 1, taskName.indexOf(')'));
				taskName = taskName.substring(0, taskName.indexOf('('));
			}
			
			contentTitle = "<span style='width:50%; text-overflow:ellipsis; font-size:16px;'>" + taskName + "<span id='mailBoxInfo'> - [총 <span style='color:#017BEC;' id='totalCount'>" + contentCount + " </span>개]</span>";
			$("#taskName").html(contentTitle);
			
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
			
			getBoardList();
		});
		
		// 트리가 모두 로드된 다음 실행
	 	$("#taskTree").on("ready.jstree", function() {
			var project = $("li[role='treeitem'][aria-level='1']").last();
			
			groupId = project.attr("id");
			projectName = project.children("a").text();
			project.children("a").click();
			
			if(projectName.indexOf('(') != -1) {
				projectName = projectName.substr(0, projectName.indexOf('('));
			}
			
			taskName = projectName;
		});
	});
	
	function goAddBoard() {
		var feature = GetOpenPosition(790, 800);
		window.open("/ezPMS/goAddBoard.do?projectName=" + projectName + "&projectId=" + projectId + "&groupId=" + groupId 
										 + "&taskName=" + taskName  + "&taskId=" + taskId + "&mode=new", 
					"", "width=790, height=800, resizable=no, scrollbars=no, status=no" + feature);
	}
	
	function getBoardList() {
		var data = {
			//기본 setting
			projectId : projectId,
			groupId : groupId,
			taskId : taskId,
			currentPage : currentPage,
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
					alert("삭제되었습니다.");
					
					for(i in itemIds) {
						var deletedTR = $("tr[data-itemid = " + itemIds[i] + "]");
						var title = deletedTR.children("td.boardTitle").text();
						var taskName = deletedTR.children("td.taskName").text();
						var groupId = deletedTR.attr("data-groupId");
						var taskId = deletedTR.attr("data-taskId");
						
						addTaskLog(projectId, 3, groupId, taskId, "[" + taskName.trim() + "]의 " + "[" + title.trim() + "] 게시물이 삭제되었습니다.");
					}
					
					getBoardList();
				} else {
					alert('삭제는 프로젝트 담당자나 작성자만 할 수 있습니다.');
				}	
			},
			error : function() {
				alert("삭제에 실패했습니다.");
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
		width : 16%;
		overflow-y : auto;
		overflow-x : hidden;
		border : 1px solid #d1d1d1;
		float : left;
	}
	
	.jstree-node > a {
    /* 100% - (the width of the presentation node : the line - the left padding of the <a> node - the right padding of the <a> node)*/
    width: calc(100% - (68px + 1px + 4px));
    text-overflow: ellipsis;
    overflow: hidden;
	}

	#taskName {
		margin-top: 10px;
		margin-left: 10px;
	}
	
	#projectArea {
		width : 83%;
		overflow : auto;
		border : 1px solid #d1d1d1;
	}
	
	#projectContent {
		min-width : 1057px;
	}
	
	#iconLine {
		height: 72px;
		margin-left: 10px;
		margin-top: 5px;
	}
	
	#contentList {
		width : 98%;
		margin-left : 1%;
	}
	
	#icons {
		margin-top: 21px;
	}
	
	#searchDiv {
		margin-left : 11px;
	}
</style>

</head>
<body>
	<div id="taskTree"></div>
	<div id="projectArea">
		<div id="projectContent">
			<div id="iconLine">
				<div id="taskName"></div>
				<div id="icons">
					<a class="imgbtn" onclick="goAddBoard()" style="margin-left: 1px; margin-top: 1px;"><span>등록</span></a>
					<a class="imgbtn" onclick="deleteBoards()" style="margin-left: 1px; margin-top: 1px;"><span>삭제</span></a>
					<a class="imgbtn" onclick="goMoveBoards()" style="margin-left: 1px; margin-top: 1px;"><span>이동</span></a>
					<a class="imgbtn" onclick="location.reload()" style="margin-left: 1px; margin-top: 1px;"><span>새로고침</span></a>
					<a class="imgbtn" onclick="showSearchDiv()" style="margin-left: 1px; margin-top: 1px;"><span>검색 <img src="/images/etc/view-sortup.gif" class="searchViewIcon"></span></a>
				</div>
			</div>
			<div id = "searchDiv" style="display:none; margin-bottom:10px;">
				<table class="content" style="width:80%; margin-bottom:5px;">
					<tbody>
						<tr>
							<th>업무명 </th>
							<td style="width:50%">
								<input type="text" id="searchByTaskName" style="width:50%; margin-right:5px;">
							</td>
							<th>게시자</th>
							<td><input type="text" style="width:100%" id="searchByUser"></td>
						</tr>
						<tr>
							<th>제 목 </th>
							<td style="width:50%" colspan="3"><input type="text" style="width:100%" id="searchByTitle"></td>
						<!-- 	<th>내 용</th>
							<td style="width:50%"><input type="text" style="width:100%" id="searchByContent"></td> -->
						</tr>
						<tr>
							<th>게시개요</th>
							<td colspan="3"><input type="text" style="width:100%" id="searchByOverview"></td>
						</tr>
						<tr>
							<th>검색기간 </th>
							<td colspan="3">
								<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
								<a class="imgbtn" onclick="emptyDate(this)" style="margin-left:3px;"><span>날짜 초기화</span></a>
							</td>
						</tr>
					</tbody>
				</table>
				<a class="imgbtn" onclick="searchBoard()" style="margin-left:40%;"><span>검색</span></a>
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