<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t153' /></title>
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
	var projectId = "<c:out value='${projectId}'/>";
	var CurrentHeight = document.documentElement.clientHeight - 100;
	var taskData = "";
	var groupId = 0;
	var currentPage = 1;
	var totalCount = "<c:out value='${taskListCount}'/>";
	var orderWhat = "";
	var orderHow = "";
	var checkedVal = "";
	var viewType = "1";
	var userRole = "${userRole}";
	
	//검색을 위한 variables
	var searchByStatus = "";
	var searchByTaskName = "";
	var searchByUser = "";
	var searchByPlanStartDate = "";
	var searchByPlanEndDate = "";
	var searchByUpperGroupName = "";
	var searchByOverview = "";
	
	function goAddTask() {
		var feature = GetOpenPosition(845,502);
		window.open("/ezPMS/goAddTask.do?projectId=" + projectId, "", "width=845, height=502, resizable=no, scrollbars=no, status=no" + feature);
		
// 		DivPopUpShow(845, 482, "/ezPMS/goAddTask.do?projectId=" + projectId);
	};

	$(function() {
		taskData = ${data};
		taskData = JSON.parse(JSON.stringify(taskData));
		var taskDataCount = taskData.length;
		
		for (var i = 0; i < taskDataCount; i++) {
			var taskName = taskData[i].text;
			taskName = revertString(taskName);
			taskData[i].text = taskName;
		}
		
		getProjectTaskTree("taskTree", taskData, "taskList", 0);
		getDatePicker();
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	});

	$(document).ready(function() {
		viewSetting();
		
		$(window).resize(function() {
			viewSetting();
		});

	});

	function setContentList() {
		if (searchByStatus == "") {
			searchByStatus = "A";
		}
		
		var data = {
			//기본 setting
			projectId : projectId,
			groupId : groupId,
			currentPage : currentPage,
			totalCount : totalCount,
			listNumber : 15,
			//내용 header 정렬
			orderWhat : orderWhat,
			orderHow : orderHow,
			//검색
			status : searchByStatus,
			searchByTaskName : searchByTaskName,
			searchByUser : searchByUser,
			searchByStartDate : searchByPlanStartDate,
			searchByEndDate : searchByPlanEndDate,
			searchByUpperGroupName : searchByUpperGroupName,
			searchByOverview : searchByOverview
		}

		$.ajax({
			type : "post",
			contentType : "application/json; charset=UTF-8",
			dataType : "html",
			data : JSON.stringify(data),
			url : "/ezPMS/getProjectTaskList.do",
			success : function(contentList) {
				$("#contentList").html(contentList);
				viewSetting();
				setInitOrder();
				
				if (userRole == 1) {
					$("#addTaskBtn").parent().css("display", "");
					$("#deleteTaskBtn").parent().css("display", "");
				} else {
					$("#addTaskBtn").parent().css("display", "none");
					$("#deleteTaskBtn").parent().css("display", "none");
				}
			}
		});
	}
	
	function getTaskTree() {
		$.ajax({
			type : "POST",
			dataType : "json",
			async: false,
			data : {"projectId" : projectId, "onlyGroup" : true, "location" : "taskList"},
			url : "/ezPMS/projectTaskTree.do",
			success : function(data) {
				taskData = JSON.parse(JSON.stringify(data.data));
				var taskDataCount = taskData.length;
				
				for (var i = 0; i < taskDataCount; i++) {
					var taskName = taskData[i].text;
					taskName = revertString(taskName);
					taskData[i].text = taskName;
				}
			
				var clickedData = $(".jstree-clicked");
				var idx = $(".jstree-anchor").index(clickedData);
				
				getProjectTaskTree("taskTree", taskData, "taskList", idx);
			}
		});
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
		setContentList();
	}
	
	function searchClear() {
		$("#searchByTaskName").val("");
		$("#searchByUser").val("");
		$("#Sdatepicker").val("");
		$("#Edatepicker").val("");
		$("#searchByUpperGroupName").val("");
		$("#searchByOverview").val("");

		searchByTaskName = "";
		searchByUser = "";
		searchByPlanStartDate = "";
		searchByPlanEndDate = "";
		searchByUpperGroupName = "";
		searchByOverview = "";
		searchByStatus = "";
		
		orderWhat = "";
		orderHow = "";
		currentPage = 1;
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

		setContentList();
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
	 
	function searchStatus(status) {
		searchByStatus = status;
		currentPage = 1;
		setContentList();
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
	
	function searchTask() {
		searchByTaskName = $("#searchByTaskName").val();
		searchByUser = $("#searchByUser").val();
		searchByPlanStartDate = $("#Sdatepicker").val();
		searchByPlanEndDate = $("#Edatepicker").val();
		searchByUpperGroupName = $("#searchByUpperGroupName").val();
		searchByOverview = $("#searchByOverview").val();
		
		var startDate = new Date(searchByPlanStartDate);
		var endDate   = new Date(searchByPlanEndDate);
		
		if(startDate > endDate) {
			alert("<spring:message code='ezPMS.t49' />");
			return;
		}
		
		layerHidden();
		setContentList();
	}
	
	// 소속 그룹과 소속 그룹의 상위까지 실제 시작일 및 종료일을 업데이트 한다.
	function updateGroupRealStartEndDate(groupId) {
		var data = {groupId : groupId};
		
		$.ajax({
			type : "PUT",
			url : "/ezPMS/updateGroupRealStartEndDate.do",
			dataType : "json",
			contentType: "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function() {}
		});
	}
	
	function deleteTask() {
		var result = getCheckedVal();
		
		if (result == 1) {
			var response = confirm("<spring:message code='ezPMS.t107' />");
			if (response == true) {
				$.ajax({
					type : "POST",
					dataType: "json",
					url : "/ezPMS/deleteTask.do",
					data : {
						taskId : checkedVal,
						projectId : projectId
					},
					success : function(result) {
						if (result.checkPermission == "permitted") {
							alert("<spring:message code='ezPMS.t242' />");
							
							var checkedTaskInfo = getCheckedTaskInfo();
							var checkedTaskInfoCount = checkedTaskInfo.length;
							
							for(var i = 0; i < checkedTaskInfoCount; i++) {
								var taskInfo = checkedTaskInfo[i];
								
								var logContent = "<spring:message code='ezPMS.t313' arguments='" + taskInfo.groupName + "," + taskInfo.taskName + "'/>";
								addTaskLog(projectId, 3, taskInfo.groupId, null, logContent);
								updateGroupRealStartEndDate(taskInfo.groupId);
							}
							
							checkedVal = "";
							$("#projectProgress", parent.document).text(result.projectProgress.toFixed(1) + '%');
							getTaskTree();
						} else {
							alert("<spring:message code='ezPMS.t184' />");
							return;
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
					}
				});
			}
		} else {
			alert("<spring:message code='ezPMS.t247' />");
   			return;
		}
	}
	
	function goTaskDetails(elem) {
		var taskId = elem.id;
		var feature = GetOpenPosition(835, 810);
		
		window.open("/ezPMS/getTaskDetails.do?projectId=" + projectId + "&taskId=" + taskId + "&userIdType=user",
				"", "width=835, height=810, resizable=no, scrollbars=no, status=no" + feature);
	}
	
	function getCheckedTaskInfo() {
		
		var result = [];
		
		function TaskInfo(groupName, taskName, groupId, taskId) {
			this.groupName = groupName;
			this.taskName  = taskName;
			this.groupId   = groupId;
			this.taskId    = taskId;
		}
		
		$("input[type='checkbox']:checked:not('#HeaderAllCheckBox')").each(function() {
			var groupName = $(this).parent().siblings(".groupNameTd").text();
			var taskName  = $(this).parent().siblings(".taskNameTd").text();
			var groupId   = $(this).parents("tr:eq(0)").attr("data-groupid");
			var taskId    = $(this).parents("tr:eq(0)").attr("id");
			
			result.push(new TaskInfo(groupName, taskName, groupId, taskId));
		});
		
		return result;
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
	margin-left : 10px;
}

.jstree-node > a {
    /* 100% - (the width of the presentation node : the line - the left padding of the <a> node - the right padding of the <a> node)*/
    width : 200px;
    text-overflow : ellipsis;
    overflow : hidden;
    min-width : 198px;
}

#projectArea {
	overflow : auto;
	border : 1px solid #d1d1d1;
	margin-right : 10px;
	margin-top : 10px;
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

#MailListRayer tr:not (.selectTR ):hover {
	background-color: rgb(244, 245, 245);
}

#basicFormList td:not (.selectTD ):hover {
	background-color: rgb(244, 245, 245);
}

.selectTR {
	background-color: rgb(233, 241, 255);
}

#mainmenu div{
	float : right;
	margin-right: 10px;
	height: 23px;
	font-size : 12px;
}

#mainmenu div select {
	width : 66px;
}

.listRow:hover {
	background-color: rgb(244, 245, 245);
}

#searchDiv {
	margin-left : 11px;
}

#searchStatus {
	height : 29px;
	border-radius : 2px;
	border-color : #d2d2d2;
}

#taskNameArea {
	max-width : 50%;
	white-space : nowrap;
	overflow : hidden;
	text-overflow : ellipsis;
	display : inline-block;
}
</style>
</head>
<body>
<div id="taskTree"></div>
<div id="projectArea" class="projectAreaStyle">
<div id="projectContent">
	<div id="iconLine" class="mainbody" style="margin:0px; height:auto;">
		<h1 id="taskName" class="project_subh1">
			<div id="taskNameArea"></div>
			<span id='mailBoxInfo' style='vertical-align: text-bottom;'></span>
			<span id="searchArea" style="float:right;font-weight:normal;color:black;">
			<div>
			<select id="searchStatus" onchange="searchStatus(this.value)">
				<option value="A"><spring:message code='ezPMS.t14' /> <spring:message code='ezPMS.t137' /></option>
				<option value="P"><spring:message code='ezPMS.t15' /> <spring:message code='ezPMS.t137' /></option>
				<option value="W"><spring:message code='ezPMS.t16' /> <spring:message code='ezPMS.t137' /></option>
				<option value="C"><spring:message code='ezPMS.t17' /> <spring:message code='ezPMS.t137' /></option>
				<option value="L"><spring:message code='ezPMS.t18' /> <spring:message code='ezPMS.t137' /></option>
				<option value="S"><spring:message code='ezPMS.t19' /> <spring:message code='ezPMS.t137' /></option>
			</select>
			</div>
			</span>
		</h1>
		<div id="mainmenu">
		<ul>
			<li style="display:none;"><span id="addTaskBtn" onclick="goAddTask()"><spring:message code='ezPMS.t89' /></span></li> 
			<li style="display:none;"><span id="deleteTaskBtn" onclick="deleteTask()"><spring:message code='ezPMS.t287' /></span></li>
			<li><span id="addTaskBtn" onclick="searchPopup()"><spring:message code='ezPMS.t1' /></span></li>
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
<div
	style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.4); display: none;"
	id="mailPanel">&nbsp;</div>
<div class="layerpopup"
	style="z-index: 2000; position: absolute; display: none;"
	id="iFramePanel">
	<iframe src="/blank_kr.htm" style="border: none;" id="iFrameLayer"></iframe>
</div>
<div id="searchPopup" class="popupwrap1 modal" style="display:none;margin-bottom:50px;">
	<div class = "popupJQLayer">
	<div class="title"><spring:message code='ezPMS.t137'/> <spring:message code='ezPMS.t1'/></div>
			<div id="close">
				<ul>
					<li><a rel="modal:close"><span onclick="layerHidden()"></span></a></li>
				</ul>
			</div>
	<table class="content" style="width:100%;">
			<tbody>
				<tr>
					<th><spring:message code='ezPMS.t98' /> </th>
					<td ><input type="text" id="searchByTaskName" style="width:100%; margin-right:5px;"></td>
				</tr>
				<tr>
					<th><spring:message code='ezPMS.t63' /></th>
					<td><input type="text" id="searchByUser" style="width:100%;"></td>
				</tr>
				<tr>
					<th><spring:message code='ezPMS.t61' /> </th>
					<td><input type="text" id="Sdatepicker" style="width:100px;text-align:center" readonly="readonly"><a class="imgbtn" onclick="emptyDate(this)" style="margin-left:3px;"><span><spring:message code='ezPMS.t124' /></span></a></td>
				</tr>
				<tr>
					<th><spring:message code='ezPMS.t62' /></th>
					<td><input type="text" id="Edatepicker" style="width:100px;text-align:center" readonly="readonly"><a class="imgbtn" onclick="emptyDate(this)" style="margin-left:3px;"><span><spring:message code='ezPMS.t124' /></span></a></td>
				</tr>
				<tr>
					<th><spring:message code='ezPMS.t42' /> </th>
					<td><input type="text" style="width:100%" id="searchByUpperGroupName"></td>
				</tr>
				<tr>
					<th><spring:message code='ezPMS.t104' /></th>
					<td><input type="text" style="width:100%" id="searchByOverview"></td>
				</tr>
			</tbody>
		</table>
		<table style="width:100%">
				<tr>
				<td style="text-align:center;">
					<div class="btnpositionLayer">
					<a class="imgbtn" onclick="searchTask()"><span><spring:message code='ezPMS.t1' /></span></a>
					<a class="imgbtn" rel="modal:close"><span onclick="layerHidden();"><spring:message code='ezAttitude.t34'/></span></a>
					</div>
			    </td>
			    </tr>
		</table>
	</div>
	</div>
</body>
</html>