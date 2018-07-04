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
<link rel="stylesheet" href="/css/ezPMS/default/style.css"
	type="text/css" />
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/ezPMS/pms.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />

<!-- time picker-->
<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
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
	var userRole = 0;
	
	//검색을 위한 variables
	var searchByStatus = "";
	var searchByTaskName = "";
	var searchByUser = "";
	var searchByPlanStartDate = "";
	var searchByPlanEndDate = "";
	var searchByUpperGroupName = "";
	var searchByOverview = "";
	
	function goAddTask() {
		var top = ($(window).height() - $(this).outerHeight()) / 2;
		var left = ($(window).width() - $(this).outerWidth()) / 2;
		var feature = GetOpenPosition(top, left);

		DivPopUpShow(845, 482, "/ezPMS/goAddTask.do?projectId=" + projectId);
	};

	$(function() {
		taskData = ${data};
		taskData = JSON.parse(JSON.stringify(taskData));
		
		getProjectTaskTree("taskTree", taskData, "taskList");
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
			listNumber : 10,
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
	
	function searchPopup() {
		//기본값 초기화
		//searchClear();
		
		//searchPopup 안에 OK넣고 온클릭에  전역변수:Tab1_SelectID로 구분해서 list가져오는거 분기
		$("<div id='blockLeft' class='blockLeft' onclick='parent.frames[\"right\"].frames[\"project\"].layerHidden()'></div>").appendTo(parent.parent.frames["left"].document.body);
		$("<div id='blockTop' class='blockTop' onclick='parent.frames[\"right\"].frames[\"project\"].layerHidden()'></div>").appendTo(parent.parent.frames["right"].document.body);
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
		var contentTitle = "";
		
		if (contentCount == null || contentCount == "") {
			totalCount = 0;
		} else {
			totalCount = contentCount;
		}
		
		taskName = convertString(taskName);
		
		contentTitle = taskName + "<span id='mailBoxInfo'> <spring:message code='ezPMS.t3' /> <span style='color:#017BEC;' id='totalCount'>" + contentCount + " </span><spring:message code='ezPMS.t4' />";

		$("#taskNameArea").html(contentTitle);
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
		
		setContentList();
	}
	
	function deleteTask() {
		var result = getCheckedVal();
		
		if (result == 1) {
			var response = confirm("<spring:message code='ezPMS.t107' />");
			console.log(result);
			if (response == true) {
				$.ajax({
					type : "POST",
					dataType: "text",
					url : "/ezPMS/deleteTask.do",
					data : {
						taskId : checkedVal,
						projectId : projectId
					},
					success : function(result) {
						if (result == "permitted") {
							alert("<spring:message code='ezPMS.t242' />");
							checkedVal = "";
							setContentList();
						} else {
							alert("<spring:message code='ezPMS.t184' />");
							return;
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
					}
				});
			}
		}
	}
	
	function goTaskDetails(elem) {
		var taskId = elem.id;
		var feature = GetOpenPosition(835, 810);
		
		window.open("/ezPMS/getTaskDetails.do?projectId=" + projectId + "&taskId=" + taskId + "&userIdType=user",
				"", "width=835, height=810, resizable=no, scrollbars=no, status=no" + feature);
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
</style>
</head>
<body>
<div id="taskTree"></div>
<div id="projectArea" class="projectAreaStyle">
<div id="projectContent">
	<div id="iconLine" class="mainbody" style="margin:0px; height:auto;">
		<h1 id="taskName" class="project_subh1"><div id="taskNameArea" style="display:inline-block"></div>
				<span id="searchArea" style="float:right;font-weight:normal;color:black;">
				<div>
				<spring:message code='ezPMS.t270' /> <select id="searchStatus" onchange="searchStatus(this.value)">
					<option value="A"><spring:message code='ezPMS.t14' /></option>
					<option value="P"><spring:message code='ezPMS.t15' /></option>
					<option value="W"><spring:message code='ezPMS.t16' /></option>
					<option value="C"><spring:message code='ezPMS.t17' /></option>
					<option value="L"><spring:message code='ezPMS.t18' /></option>
					<option value="S"><spring:message code='ezPMS.t19' /></option>
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
<div id="searchPopup" class="popupwrapAtt" style="display:none;padding-top:20px;padding-bottom:20px;margin-bottom:50px;">
	<div id = "popupwrap3">
	<table class="content" style="width:100%;">
			<tbody>
				<tr>
					<th class="layerHeader" colspan="2"><img src="/images/kr/left/left_mail.png" style="vertical-align: middle;padding-bottom:1px"/>&nbsp;
					<spring:message code='ezPMS.t137'/> <spring:message code='ezPMS.t1'/></th>
				</tr>
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
		<br />
		<div style="text-align:center;">
			<a class="imgbtn" onclick="searchTask()"><span><spring:message code='ezPMS.t1' /></span></a>
			<a class="imgbtn" rel="modal:close"><span onclick="layerHidden();"><spring:message code='ezAttitude.t34'/></span></a>
	    </div>
	</div>
	</div>
</body>
</html>