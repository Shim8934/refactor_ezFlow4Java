<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t154' /></title>
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>


<!-- time picker-->
<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
<script>
 	var projectId = "${projectId}";
 	var CurrentHeight = document.documentElement.clientHeight - 100;
	var groupId = "";
	var taskId = "";
	var taskName = "";
	var currentPage = 1;
	var treeData = "";
	var orderWhat = "";
	var orderHow = "";
	var limit = 15;
	
	//검색을 위한 variables
	var searchByUser = "";
	var searchByStartDate = "";
	var searchByEndDate = "";
	var searchByContent = "";
	
	$(document).ready(function() {

		CurrentHeight = $(window).height() - 100;
		$("MailListRayer").css("height", CurrentHeight + "px");
		$("#taskTree").css("height", CurrentHeight + "px");
		$("#projectContent").css("height", CurrentHeight + "px");
		$("#contentList").css("height", (CurrentHeight - 70) + "px");
		$("#projectListBody").css("height", (CurrentHeight - 261) + "px");
		$("#divList").css("height", (CurrentHeight - 220) + "px");
		
		$(window).resize(function() {
			CurrentHeight = $(window).height() - 100;
			$("MailListRayer").css("height", CurrentHeight + "px");
			$("#taskTree").css("height", CurrentHeight + "px");
			$("#projectContent").css("height", CurrentHeight + "px");
			$("#contentList").css("height", (CurrentHeight - 70) + "px");
			$("#projectListBody").css("height", (CurrentHeight - 261) + "px");
			$("#divList").css("height", (CurrentHeight - 220) + "px");
		});
		
		treeData = ${data};
		treeData = JSON.parse(JSON.stringify(treeData));
		var treeDataCount = treeData.length;
		
		for (var i = 0; i < treeDataCount; i++) {
			var taskName = treeData[i].text;
			taskName = revertString(taskName);
			treeData[i].text = taskName;
		}
		
		getProjectTaskTree("taskTree", treeData, "comment", 0);
		
		$("#taskTree").on("click", ".jstree-anchor", function() {
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
			
			orderWhat = "";
			orderHow = "";
			
			getCommentList();
		});
		
		// 트리가 모두 로드된 다음 실행
	 	$("#taskTree").on("ready.jstree", function() {
			var project = $("li[role='treeitem'][aria-level='1']").last();
			
			groupId = project.attr("id");
			project.children("a").click();
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
			limit : limit,
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
				
				//순서 재조정
				CurrentHeight = $(window).height() - 100;
				$("MailListRayer").css("height", CurrentHeight + "px");
				$("#taskTree").css("height", CurrentHeight + "px");
				$("#projectContent").css("height", CurrentHeight + "px");
				$("#contentList").css("height", (CurrentHeight - 70) + "px");
				$("#projectListBody").css("height", (CurrentHeight - 261) + "px");
				$("#divList").css("height", (CurrentHeight - 220) + "px");
				
				setInitOrder();
			}	
		});
	}
	
	function projectListScroll() {
		var thWidth = document.getElementById("tableHeader").clientWidth - document.getElementById("tableBody").clientWidth;
		
		if (thWidth > 0) { 
			$("#BoardList_TH").append('<th style=width:10px;></th>');
		} 
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

		projectListScroll();
	}
	
	function getTaskTree() {
		$.ajax({
			type : "POST",
			dataType : "json",
			async: false,
			data : {"projectId" : projectId, "onlyGroup" : false, "location" : "comment"},
			url : "/ezPMS/projectTaskTree.do",
			success : function(data) {
				var data = JSON.parse(JSON.stringify(data));
				
				var treeData = data.data;
				var treeDataCount = treeData.length;
				
				for (var i = 0; i < treeDataCount; i++) {
					var taskName = treeData[i].text;
					taskName = revertString(taskName);
					treeData[i].text = taskName;
				}
				
				var clickedData = $(".jstree-clicked");
				var idx = $(".jstree-anchor").index(clickedData);
				
				getProjectTaskTree("taskTree", treeData, "comment", idx);
				getCommentList();
			}
		});
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
	
	function searchComment() {
		
		// 이전 검색을 통해 남아있을 수 있는 값들을 초기화
		searchByUser = "";
		searchByStartDate = "";
		searchByEndDate = "";
		searchByContent = "";
		
		var searchCondition = $("#searchArea option:selected").val();
		var searchKeyword = $("#searchKeyword").val();
		
		if (searchCondition == 'searchByUser') {
			searchByUser = searchKeyword;
		} else if (searchCondition == 'searchByContent') {
			searchByContent = searchKeyword;
		} else if (searchCondition == 'searchByWriteDate') {
			searchByStartDate = $("#Sdatepicker").val();
			searchByEndDate   = $("#Edatepicker").val();
		}
		
		getCommentList();
	}
	
	function setSearchInput(elem) {
		if (elem == 'searchByWriteDate') {
			$("#searchKeyword").css("display", "none");
			$("#searchDate").css("display", "");
		} else {
			$("#searchKeyword").css("display", "");
			$("#searchDate").css("display", "none");
		}
	}
	
	function searchKeyEvent() {
		if (event.keyCode == 13) {
			searchComment();
		}
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
</script>

<style>

	.jstree-node > a {
    /* 100% - (the width of the presentation node : the line - the left padding of the <a> node - the right padding of the <a> node)*/
  	width: 200px;
    text-overflow: ellipsis;
    overflow: hidden;
	}
	
	#taskTree {
		margin-right : 5px;
		width : 276px;
		overflow-y: auto;
    	overflow-x: hidden;
		border : 1px solid #d1d1d1;
		float : left;
		display : inline-block
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
	
	table.mainlist th {
		cursor: pointer;
	}
	
	#taskNameArea {
		max-width : 50%;
		white-space : nowrap;
		overflow : hidden;
		text-overflow : ellipsis;
		display : inline-block;
	}
	
	.col1 {width: 6%;}
	.col2 {width: 18%;}
	.col4 {width: 12%;}
	.col5 {width: 7%}
	.commentContent {width: 80%;}
	
	#searchArea input, #searchArea select {
		height : 27px;
	}
</style>

</head>
<body style="margin:10px 10px 0px 10px;">
	<div id="taskTree"></div>
	<div id="projectArea" class="projectAreaStyle">
		<div id="projectContent">
			<div id="iconLine" class="mainbody" style="margin:0px; height:auto;">
				<h1 id="taskName" class="project_subh1">
					<div id="taskNameArea"></div>
					<span id='mailBoxInfo' style='vertical-align: text-bottom;'></span>
					<span id="searchArea" style="float:right;font-weight:normal;color:black;">
						<select id="searchCondition" onchange="setSearchInput(this.value)">
							<option value="searchByUser"><spring:message code='ezPMS.t114' /></option>
							<option value="searchByContent"><spring:message code='ezPMS.t130' /></option>
							<option value="searchByWriteDate"><spring:message code='ezPMS.t119' /></option>
						</select>
						<input type="text" id="searchKeyword" onkeypress="if(event.keyCode==13) {searchComment(); return false;}" style="width:150px;ime-mode: active;border-right:0px;vertical-align: baseline">
						<span id="searchDate" style="display: none; margin-right : 10px;">
							<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~ 
							<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
						</span>
						<a id="searchButton" href="#" style="float:right"><img src="/images/bsearch_new.gif" border="0" onclick="searchComment()"></a>
					</span>
				</h1>
			</div>
			<div id="contentList" style="overflow: auto; width:100%; margin:0px; padding:0px 10px; box-sizing:border-box;">
				<span id="MailListRayer"
					style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
				</span>
			</div>
		</div>
	</div>
</body>
</html>