<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/ezPMS/default/style.css"
	type="text/css" />
<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
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
	var projectId = "${projectId}";
	var CurrentHeight = document.documentElement.clientHeight - 100;
	var taskData = JSON.parse('${data}');
	var groupId = 0;
	var currentPage = 1;
	var totalCount = "${taskListCount}";
	var orderWhat = "";
	var orderHow = "";
	var checkedVal = "";
	var viewType = "1";
	
	//검색을 위한 variables
	var searchByStatus = "";
	var searchByTaskName = "";
	var searchByUser = "";
	var searchByPlanStartDate = "";
	var searchByPlanEndDate = "";
	var searchByGroupName = "";
	var searchByOverview = "";
	
	function goAddTask() {
		var top = ($(window).height() - $(this).outerHeight()) / 2;
		var left = ($(window).width() - $(this).outerWidth()) / 2;
		var feature = GetOpenPosition(top, left);

		DivPopUpShow(845, 478, "/ezPMS/goAddTask.do?projectId=" + projectId);
	};

	$(function() {
		getProjectTaskTree("taskTree", taskData, "taskList");
		getDatePicker();

		CurrentHeight = $(window).height() - 100;
		$("MailListRayer").css("height", CurrentHeight + "px");
		$("#taskTree").css("height", CurrentHeight + 10 + "px");
		$("#projectContent").css("height", CurrentHeight + "px");
		$("#contentList").css("height", (CurrentHeight - 100) + "px");
		$("#projectListBody").css("height", (CurrentHeight - 160) + "px");
		$("#divList").css("height", (CurrentHeight - 150) + "px");
	});

	$(document).ready(function() {
		$(window).resize(function() {
			CurrentHeight = $(window).height() - 100;
			$("#taskTree").css("height", CurrentHeight + 10 + "px");
			$("#projectContent").css("height", CurrentHeight + "px");
			$("#contentList").css("height", (CurrentHeight - 100) + "px");
			$("#divList").css("height", (CurrentHeight - 150) + "px");
			$("#projectListBody").css("height", (CurrentHeight - 160) + "px");
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
			searchByGroupName : searchByGroupName,
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
				//찾아 준 후 초기화
				$("#searchByName").val("");
				$("#searchByUser").val("");
				$("#Sdatepicker").val("");
				$("#Edatepicker").val("");
				$("#searchByGroupName").val("");
				$("#searchByOverview").val("");
				
				searchByName = "";
				searchByUser = "";
				searchByPlanStartDate = "";
				searchByPlanEndDate = "";
				searchByGroupName = "";
				searchByOverview = "";
				
				setInitOrder();
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

		contentTitle = "<span style='width:50%; text-overflow:ellipsis; font-size:16px;'>" + taskName + "<span id='mailBoxInfo'> - [총 <span style='color:#017BEC;' id='totalCount'>" + contentCount + " </span>개]</span>";

		$("#taskName").html(contentTitle);
	}
	 
	function searchStatus(status) {
		searchByStatus = status;
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
		searchByName = $("#searchByName").val();
		searchByUser = $("#searchByUser").val();
		searchByPlanStartDate = $("#Sdatepicker").val();
		searchByPlanEndDate = $("#Edatepicker").val();
		searchByGroupName = $("#searchByGroupName").val();
		searchByOverview = $("#searchByOverview").val();
		
		setContentList();
	}
	
	function deleteTask() {
		var result = getCheckedVal();
		
		if (result == 1) {
			var response = confirm("정말로 삭제하시겠습니까?");
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
							alert("삭제되었습니다.");
							checkedVal = "";
							setContentList();
						} else {
							alert("프로젝트 혹은 그룹 담당자만 상태를 변경할 수 있습니다.");
							return;
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
					}
				});
			}
		}
	}
</script>
<style>
#taskTree {
	margin-right: 5px;
	width: 16%;
	overflow: auto;
	border: 1px solid #d1d1d1;
	float: left;
	display: inline-block
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
	min-width : 1070px;
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

#MailListRayer tr:not (.selectTR ):hover {
	background-color: rgb(244, 245, 245);
}

#basicFormList td:not (.selectTD ):hover {
	background-color: rgb(244, 245, 245);
}

.selectTR {
	background-color: rgb(233, 241, 255);
}
#icons div{
	float : right;
	margin-right: 10px;
	height: 23px;
	font-size : 12px;
}

#icons div select {
	width : 66px;
}

.listRow:hover {
	background-color: rgb(233, 241, 255);
}

#searchDiv {
	margin-left : 11px;
}
</style>
</head>
<div id="taskTree"></div>
<div id="projectArea">
<div id="projectContent">
	<div id="iconLine">
		<div id="taskName"></div>
		<div id="icons">
			<a class="imgbtn" id="addTaskBtn" onclick="goAddTask()"
				style="margin-left: 1px; margin-top: 1px;"><span>새업무 추가</span></a> <a
				class="imgbtn" id="addTaskBtn" onclick="deleteTask()"
				style="margin-left: 1px; margin-top: 1px;"><span>삭제</span></a> <a
				class="imgbtn" id="addTaskBtn" onclick="showSearchDiv()"
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
	</div>
	<div id = "searchDiv" style="display:none; margin-bottom:10px; display:none;">
		<table class="content" style="width:80%; margin-bottom:5px;">
			<tbody>
				<tr>
					<th>업무명 </th>
					<td style="width:50%"><input type="text" id="searchByTaskName" style="width:50%; margin-right:5px;"></td>
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
	<div id="contentList" style="overflow: auto">
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
</body>
</html>