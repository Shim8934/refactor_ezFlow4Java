<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t141' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>


<!-- time picker-->
<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
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
	var limit = 15;
	var folderId = 0;
	var userRole = "${userRole}";
	
	//검색을 위한 variables
	var searchByUser = "";
	var searchByStartDate = "";
	var searchByEndDate = "";
	var searchByTitle = "";
	var searchByOverview = "";
	var searchByContent = "";
	var searchOrNot = "";
	
	$(document).ready(function() {
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		
		viewSetting();
		
		if (userRole == 1) {
			$("#taskTreeArea").css("height", CurrentHeight - 60 + "px");
		} else {
			$("#taskTreeArea").css("height", CurrentHeight + "px");
			$("#folderSettingArea").css("display", "none");
		}
		
		treeData = ${data};
		treeData = JSON.parse(JSON.stringify(treeData));
		var treeDataCount = treeData.length;
		
		for (var i = 0; i < treeDataCount; i++) {
			var taskName = treeData[i].text;
			taskName = revertString(taskName);
			treeData[i].text = taskName;
		}
		
		getProjectTaskTree("taskTreeArea", treeData, "board", 0);
		getDatePicker();
		
		$("#taskTreeArea").on("click", ".jstree-anchor", function() {		
			folderId = $(this).parent().attr("id");
			currentPage = 1;
			
			// 트리 클릭 시, 검색 조건 초기 화
			searchByUser = "";
			searchByStartDate = ""; 
			searchByEndDate = "";
			searchByTitle = "";
			searchByOverview = "";
			searchByContent = "";
			searchOrNot = "";
			
			orderWhat = "";
			orderHow = "";
			
			getBoardList();
		});
		
		// 트리가 모두 로드된 다음 실행
	 	$("#taskTreeArea").on("ready.jstree", function() {
			var project = $("li[role='treeitem'][aria-level='1']").first();
			project.children("a").click();
			folderId = project.attr("id");
		});
	});
	
	function goAddBoard() {
		var feature = GetOpenPosition(790, 800);
		window.open("/ezPMS/goAddBoard.do?projectId=" + projectId + "&folderId=" + folderId + "&mode=new", 
					"", "width=790, height=800, resizable=no, scrollbars=no, status=no" + feature);
	}
	
	function getFolderTree() {
		$.ajax({
			type : "POST",
			dataType : "json",
			async: false,
			data : {"projectId" : projectId},
			url : "/ezPMS/getFolderList.do",
			success : function(data) {
				treeData = JSON.parse(JSON.stringify(data));
				var treeDataCount = treeData.length;
				
				for (var i = 0; i < treeDataCount; i++) {
					var taskName = treeData[i].text;
					taskName = revertString(taskName);
					treeData[i].text = taskName;
				}
				
				var clickedData = $(".jstree-clicked");
				var idx = $(".jstree-anchor").index(clickedData);
				
				getProjectTaskTree("taskTreeArea", treeData, "board", idx);
			}
		});
	}
	
	function getBoardList() {
		var data = {
			//기본 setting
			projectId : projectId,
			folderId : folderId,
			currentPage : currentPage,
			limit : limit,
			position : "boardMain",
			//내용 header 정렬
			orderWhat : orderWhat,
			orderHow : orderHow,
			//검색
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
				viewSetting();
				
				if (userRole == 1) {
					$("#taskTreeArea").css("height", CurrentHeight - 60 + "px");
				} else {
					$("#taskTreeArea").css("height", CurrentHeight + "px");
					$("#folderSettingArea").css("display", "none");
				}
				
				setInitOrder();
			}	
		});
	}
	
	function searchClear() {
		$("#searchByTaskName").val("");
		$("#searchByUser").val("");
		$("#Sdatepicker").val("");
		$("#Edatepicker").val("");
		$("#searchByTitle").val("");
		$("#searchByOverview").val("");
		$("#searchByContent").val("");
	}
	
	function searchPopup() {
		//기본값 초기화
		searchClear();
		
		//searchPopup 안에 OK넣고 온클릭에  전역변수:Tab1_SelectID로 구분해서 list가져오는거 분기
		$("<div id='blockLeft' class='blockLeft' onclick='parent.frames[\"right\"].frames[\"project\"].layerHidden()'></div>").appendTo(parent.parent.frames["left"].document.body);
		$("<div id='blockTop' class='blockTop' style='height:86px;' onclick='parent.frames[\"right\"].frames[\"project\"].layerHidden()'></div>").appendTo(parent.parent.frames["right"].document.body);
		parent.parent.frames["left"].document.body.style.overflow = "hidden";		
		
		var popupX = parent.document.body.clientWidth/2 - (500/2);
		
		$("#searchPopup").css("left", popupX);
		parent.frames["project"].$(".portlet_tabpart01").css("z-index", 0);
		$("#searchPopup").modal();
	}

	function layerHidden() {
		parent.frames["project"].$(".portlet_tabpart01").css("z-index", 100);
	    $.modal.close();
	}
	
	function setContentTitle(taskName, contentCount) {
		
		if (contentCount == null || contentCount == "") {
			totalCount = 0;
		} else {
			totalCount = contentCount;
		}
		
		$("#taskNameArea").html(taskName);
		$("#mailBoxInfo").html("<spring:message code='ezPMS.t3' /> <span class='txt_color' id='totalCount'>" + totalCount + " </span><spring:message code='ezPMS.t4' /></span>");
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page) {
		currentPage = page;
		getBoardList();
	}
	
	// 메인에서 체크박스로 선택 후 삭제할 때
	function deleteBoardsAction(itemIds) {
		var data = {
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
					
					/* for(i in itemIds) { //로그 추가하기 위한 로직
						var deletedTR = $("tr[data-itemid = " + itemIds[i] + "]");
						var title = deletedTR.children("td.boardTitle").text();
						var taskName = deletedTR.children("td.taskName").text();
						var groupId = deletedTR.attr("data-groupId");
						var taskId = deletedTR.attr("data-taskId");
					} */
					
					getFolderTree();
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
	
	function folderSetting() {
    	var OpenWin = window.open("/ezPMS/folderSetting.do", "", GetOpenWindowfeature(400, 500));
    	
        try { 
        	OpenWin.focus(); 
        } catch (e) { }
	}
</script>

<style>
	#taskTree {
		margin-right : 5px;
		width : 276px;
		overflow : hidden;
		border : 1px solid #d1d1d1;
		float : left;
		position : relative;
	}
	
	#taskTreeArea {
		overflow-x : hidden;
		overflow-y : auto;
	}
	
	.jstree-node > a {
    width: 200px;
    text-overflow: ellipsis;
    overflow: hidden;
	}
	
	#projectArea {
		overflow : auto;
		border : 1px solid #d1d1d1;
	}
	
	#projectContent {
		min-width : 1057px;
	}
	
	#iconLine {
		height: 80px;
		margin-left: 10px;
		margin-top: 5px;
		margin-right: 20px;
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
		max-width : 50%;
		white-space : nowrap;
		overflow : hidden;
		text-overflow : ellipsis;
		display : inline-block;
	}
	
	#folderSettingArea {
		position: absolute;
   		bottom: 15px;
  		border-top: 1px solid #d1d1d1;
  		width: 100%;
	}
	
	#folderSetting {
		width: 80%;
		margin-left: 20px;
		margin-top: 15px;
		text-align: center;
	}
</style>

</head>
<body style="margin:10px 10px 0px 10px;">
	<div id="taskTree">
		<div id="taskTreeArea"></div>
		<div id="folderSettingArea"><a id="folderSetting" onclick="folderSetting()" class="imgbtn imgbck"><span><spring:message code='ezPMS.t334' /></span></a></div>
	</div>
	<div id="projectArea" class="projectAreaStyle">
		<div id="projectContent">
			<div id="iconLine" class="mainbody" style="margin:0px; height:auto;">
				<h1 id="taskName" class="project_subh1">
					<div id="taskNameArea"></div>
					<span id='mailBoxInfo' style='vertical-align: text-bottom;'></span>
				</h1>
				<div id="mainmenu">
				<ul>
					<c:if test="${userRole ne 3}">
						<li><span onclick="goAddBoard()"><spring:message code='ezPMS.t40' /></span></li>
						<li><span onclick="deleteBoards()"><spring:message code='ezPMS.t11' /></span></li>
						<li><span onclick="goMoveBoards()"><spring:message code='ezPMS.t111' /></span></li>
					</c:if>
					<li><span onclick="location.reload()"><spring:message code='ezPMS.t123' /></span></li>
					<li><span onclick="searchPopup()"><spring:message code='ezPMS.t1' /></span></li>
				</ul>
				</div>
			</div>
			<div id="contentList" style="overflow: auto; width:100%; margin:0px; padding:0px 10px; box-sizing:border-box;">
				<span id="MailListRayer"
					style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
				</span>
			</div>
		</div>
	</div>
	<div id="searchPopup" class="popupwrap1 modal" style="display:none;margin-bottom:50px;">
	<div class = "popupJQLayer">
			<div class="title"><spring:message code='ezPMS.t141'/> <spring:message code='ezPMS.t1'/></div>
			<div id="close">
				<ul>
					<li><a rel="modal:close"><span onclick="layerHidden()"></span></a></li>
				</ul>
			</div>
	<table class="content" style="width:100%;">
		<tbody>
			<tr>
				<th><spring:message code='ezPMS.t114' /></th>
	 			<td><input type="text" style="width:100%" id="searchByUser"></td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t215' /></th>
				<td><input type="text" style="width:100%" id="searchByTitle"></td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t81' /></th>
				<td><input type="text" style="width:100%" id="searchByOverview"></td>
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
		<table style="width:100%">
				<tr>
				<td style="text-align:center;">
					<div class="btnpositionLayer">
					<a class="imgbtn" onclick="searchBoard()"><span><spring:message code='ezPMS.t1' /></span></a>
					<a class="imgbtn" rel="modal:close"><span onclick="layerHidden();"><spring:message code='ezAttitude.t34'/></span></a>
					</div>
			    </td>
			    </tr>
		</table>
	</div>
	</div>
</body>
</html>