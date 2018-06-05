<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
 	var projectId = "${projectId}";
 	var CurrentHeight = document.documentElement.clientHeight - 100;
	var groupId = "";
	var taskId = "";
	var taskName = "";
	var currentPage = 1;
	var treeData = JSON.parse('${data}');
	var orderWhat = "";
	var orderHow = "";
	
	//검색을 위한 variables
	var searchByUser = "";
	var searchByStartDate = "";
	var searchByEndDate = "";
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
				taskId = "";
			}
			currentPage = 1;
			
			// 트리 클릭 시, 검색 조건 초기 화
			searchByUser = "";
			searchByStartDate = ""; 
			searchByEndDate = "";
			searchByContent = "";
			
			getCommentList();
		});
		
		// 트리가 모두 로드된 다음 실행
	 	$("#taskTree").on("ready.jstree", function() {
			var project = $("li[role='treeitem'][aria-level='1']").last();
			
			groupId = project.attr("id");
			taskName = project.children("a").text();
			project.children("a").click();
			
			if(taskName.indexOf('(') != -1) {
				taskName = taskName.substring(0, projectName.indexOf('('));
			}
		});
		
		getDatePicker();
	});
	
	function getCommentList() {
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
			searchByUser : searchByUser,
			searchByStartDate : searchByStartDate,
			searchByEndDate : searchByEndDate,
			searchByContent : searchByContent,
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			dataType : "html",
			data : JSON.stringify(data),
			url : "/ezPMS/getCommentList.do",
			success : function(contentList) {
				$("#contentList").html(contentList);
				
				setInitOrder();
			}	
		});
	}
	
	//페이지 번호에 의한 셋팅
	function goToPageByNum(page) {
		currentPage = page;
		getCommentList();
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
		
		getCommentList();
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
</script>

<style>
	#taskTree {
		margin-right : 5px;
		width : 16%;
		overflow : auto;
		border : 1px solid #d1d1d1;
		float : left;
		display : inline-block
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
	
	table.mainlist th, table.mainlist td {
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		text-align: center;
	}
	
	table.mainlist th {
		cursor: pointer;
	}
</style>

</head>
<body>
	<div id="taskTree"></div>
	<div id="projectArea">
		<div id="projectContent">
			<div id="iconLine">
				<div id="taskName"></div>
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