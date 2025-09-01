<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t155' /></title>

<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>

<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/previewmail.css')}" type="text/css" />


<!-- time picker-->
<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>

<script type="text/javascript">

var viewType = "${listSetting.viewType}";
var projectSort = "${listSetting.projectSort}";
var progressColor = "${listSetting.progressColor}";
var completeColor = "${listSetting.completeColor}";
var overdueColor = "${listSetting.overdueColor}";
var holdColor = "${listSetting.holdColor}";
var deleteColor = "${listSetting.deleteColor}";
var waitColor = "${listSetting.waitColor}";
var listNumber = "${listSetting.listNumber}";
var initListNumber = "${listSetting.listNumber}";
var listProjectStatus = "${listSetting.listProjectStatus}";
var currentPage = 1;
var orderWhat; 
var orderHow;
var CurrentHeight = document.documentElement.clientHeight - 110;
var projectTotalCount = 0;
var checkedVal = "";
var startRow = 0;
var userId = "${userId}";

//검색을 위한 변수
var searchByProjectName = "";
var searchByUser = "";
var searchByStartDate = "";
var searchByEndDate = "";
var searchByOverview = "";

function goProjectDetails(elem) {
	var projectId = $(elem).attr("id");
    parent.document.querySelector("iframe[name=right]").src = "/ezPMS/getProjectDetails.do?projectId=" + projectId;
}

function addNewProject() { 
	var feature = GetOpenPosition(845, 645);
	
	window.open("/ezPMS/newProject.do?mode=" + "new", "", "width=845, height=645, resizable=no, scrollbars=no, status=no" + feature);
// 	addProjectPopup(10, 20, 845, 555, "/ezPMS/newProject.do?mode=" + "new");
}

$(document).ready(function() {
	var clickOutside;
	var leftDocument;
	
	try {
		leftDocument = $(window.parent.frames['left'].document);
	} catch (e) {
		try {
			leftDocument = $(window.parent.parent.frames['left'].document);
		} catch (e) {
			leftDocument = $(window.parent.parent.frames['board_menu'].document);
		}
	}
	if (navigator.userAgent.toLowerCase().indexOf("msie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { 
		clickOutside = $(window.parent.parent.parent.frames['topFrame'].document);
	} else {
		clickOutside = $(window.parent.parent.parent.frames['topFrame'].contentWindow.document);
	}	  
	
	clickOutside.mouseup(function (e) {
		MailOptionHiddenOutside(e);
	});
	
	leftDocument.mouseup(function (e) {
		MailOptionHiddenOutside(e);
	});
	
	$(parent.document).mouseup(function (e) {
		MailOptionHiddenOutside(e);
	});
	
	$(document).mouseup(function (e) {
		MailOptionHiddenOutside(e);
	});
	
	$(window).resize(function() {
		CurrentHeight = $(window).height()-110;
		
		if (viewType == 0) {
			document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
		} else {
			document.getElementById("MailListRayer").style.height = CurrentHeight - 3 + "px";
		}

		if (viewType == 0) {
			$("#memoStyleDiv").css("display", "");
			$("#memoStyle").attr("src", "/images/kr/cm/btn_cardframe_on.png");
			document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
		} else {
			$("#MailListRayer").css("display", "inline-block");
			$("#boardStyle").attr("src", "/images/kr/cm/btn_listframe_on.png");
			
			document.getElementById("divList").style.overflow = "auto";
			document.getElementById("MailListRayer").style.height = CurrentHeight - 3 + "px";
			document.getElementById("MailListRayer").style.width = "100%";
			document.getElementById("divList").style.height = (CurrentHeight - 51) + "px";
			document.getElementById("projectListBody").style.height = (CurrentHeight - 50 - 35) + "px";
		}
	});
});

function searchPopup() {
	//기본값 초기화
	$("#searchByProjectName").val("");
	$("#searchByUser").val("");
	$("#Sdatepicker").val("");
	$("#Edatepicker").val("");
	$("#searchByOverview").val("");
	
	//searchPopup 안에 OK넣고 온클릭에  전역변수:Tab1_SelectID로 구분해서 list가져오는거 분기
	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].layerHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	
	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	
	$("#searchPopup").css("left", popupX);
	
	$("#searchPopup").modal();
}

function layerHidden() {
    $.modal.close();
}

function projectListScroll() {
	if (viewType == 0) {
		$("#memoStyleDiv").css("display", "");
		$("#memoStyle").attr("src", "/images/kr/cm/btn_cardframe_on.png");
		document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
	} else {
		$("#MailListRayer").css("display", "inline-block");
		$("#boardStyle").attr("src", "/images/kr/cm/btn_listframe_on.png");
		
		document.getElementById("divList").style.overflow = "auto";
		document.getElementById("MailListRayer").style.height = CurrentHeight - 3 + "px";
		document.getElementById("MailListRayer").style.width = "100%";
		document.getElementById("divList").style.height = (CurrentHeight - 51) + "px";
		document.getElementById("projectListBody").style.height = (CurrentHeight - 50 - 35) + "px";
	}
	
	if (viewType == "1") {
		var thWidth = document.getElementById("tableHeader").clientWidth - document.getElementById("tableBody").clientWidth;
		
		if(thWidth > 0){ 
			$("#BoardList_TH").append('<th style=width:2px;></th>');
		}	
	} 
}

$(function() {
	if (viewType == 0) {
		listNumber = 20;
	}
	
	$("#listcount").val(initListNumber).prop("selected", true);
	
	setProjectList("new");
	getDatePicker();

	if (viewType == 0) {
		$("#listcountTR").css("display", "none");
	} else {
		$("#listcountTR").css("display", "");
	}
	
	if (listProjectStatus != "F") {
		$("#deleteFavorite").parent().css("display", "none");
		$("#addFavorite").css("display", "");
	} else {
		$("#deleteFavorite").parent().css("display", "");
		$("#addFavorite").css("display", "none");
	}
	
	if (listProjectStatus == "D") {
		$("#deleteProject").text("<spring:message code='ezPMS.t13'/> <spring:message code='ezPMS.t12' />");
	}
	
	$("#listSort option[value='"+ projectSort +"']").attr("selected", true);
	$("#listcount option[value='"+ listNumber +"']").attr("selected", true);
	$("#listByStatus option[value='" + listProjectStatus + "']").attr("selected", true);
	selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
});

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

function setTotalCount(totalCount) {
	if (!totalCount) {
		totalCount = 0;
	}
	
	$("#totalCount").text(totalCount);
}

function MailOptionView(obj, flag) {
    if (obj.getAttribute("mode") == "off") {
        if (flag == 'N') {
        	document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 160 + "px";
        } else {
        	document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
        }
        
        document.getElementById("layer_Viewpopup").style.top = "100px";
        document.getElementById("layer_Viewpopup").style.display = "";
        obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
        obj.setAttribute("mode", "on");
    } else {
        MailOptionHidden();
    }
}

function MailOptionHidden() {
    document.getElementById("layer_Viewpopup").style.display = "none";
    document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
    document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");    
}

//레이어팝업 바깥쪽 클릭시 레이어팝업 꺼지게 2018-02-22 강민수92
function MailOptionHiddenOutside(e) {
	var container = $('#layer_Viewpopup');
	var maillistoptionmode = $('#maillistoptiondiv').attr('mode');
	
	if (maillistoptionmode == "on") {
		if (container.has(e.target).length === 0 && $(e.target).attr('id') != 'maillistoptiondiv') {
			MailOptionHidden();
		}
	}
}

function changeMemoStyle() {
	viewType = 0;
	listNumber = 20;
	startRow = 0;
	currentPage = 1;
	orderWhat = "";
	orderHow = "";

	setProjectList("new");
	changeMainSetting();
	
	$("#memoStyle").attr("src", "/images/kr/cm/btn_cardframe_on.png");
	$("#boardStyle").attr("src", "/images/kr/cm/btn_listframe.png");
	$("#listcountTR").css("display", "none");
}

function changeBoardStyle() {
	viewType = 1;
	listNumber = initListNumber;
	currentPage = 1;
	
	changeMainSetting();
	setProjectList("new");
	
	$("#memoStyle").attr("src", "/images/kr/cm/btn_cardframe.png");
	$("#boardStyle").attr("src", "/images/kr/cm/btn_listframe_on.png");
	$("#listcountTR").css("display", "");
	$("#listcount option[value='"+ listNumber +"']").attr("selected", true);
}

function changeMainSetting() {
	if (viewType == 0) {
		listNumber = initListNumber;
	}
	
	var data = {
		projectSort : projectSort,
		viewType : viewType,
		progressColor : progressColor,
		completeColor : completeColor,
		overdueColor  : overdueColor,
		holdColor     : holdColor,
		listNumber : listNumber
	}
	
	$.ajax({
		type : "POST",
		dataType: "text",
		contentType: "application/json; charset=UTF-8",
		url : "/ezPMS/updateMainSetting.do",
		data :JSON.stringify(data),
		success : function() {},
		error : function(jqXHR, textStatus, errorThrown) {}
	});
}

function changelistCount(listCountNum) {
	listNumber = listCountNum;
	initListNumber = listCountNum;
	
	changeMainSetting();
	setProjectList("new");
	MailOptionHidden();
}

function changeProjectSort(sortType) {
	projectSort = sortType;
	orderHow = "";
	orderWhat = "";
	startRow = 0;
	listNumber = initListNumber;

	setProjectList("new");
	changeMainSetting();
	MailOptionHidden();
}

//페이지 번호에 의한 셋팅
function goToPageByNum(page) {
	currentPage = page;
	setProjectList("new");
}


//헤더 리스트 셋팅
function setListOrder(elem){
	orderWhat = $(elem).attr("order");
	orderHow = $(elem).attr("sort");
	
	if (orderHow == null) {
		orderHow='asc';
	} else if (orderHow == 'asc') {
		orderHow='desc';
	} else if (orderHow == 'desc') {
		orderHow='asc';
	}
	
	setProjectList("new");
}

function setInitOrder() {
	$("#BoardList_TH th").each(function () {
		if (orderWhat == $(this).attr("order")) {
			if (orderHow == 'asc') {
				$(this).attr("sort","asc");
				$(this).append(' <img src="/images/etc/view-sortdown.gif" align="absmiddle">');
			} else if(orderHow == 'desc') {
				$(this).attr("sort","desc");
				$(this).append(' <img src="/images/etc/view-sortup.gif" align="absmiddle">');
			}
		}
	});
	
	projectListScroll();
}

function setProjectList(mode) {
	var param = {
		projectSort : projectSort,
		viewType : viewType,
		listNumber : listNumber,
		startRow : startRow,
		listProjectStatus : listProjectStatus,
		currentPage : currentPage,
		projectTotalCount : projectTotalCount,
		//프로젝트 header 정렬
		orderWhat : orderWhat,
		orderHow : orderHow,
		//프로젝트 검색
		searchByProjectName : searchByProjectName,
		searchByUser :	searchByUser,
		searchByStartDate : searchByStartDate,
		searchByEndDate : searchByEndDate,
		searchByOverview : searchByOverview
	}
	
	$.ajax({
		type : "post",
		contentType : "application/json",
		dataType : "html",
		data : JSON.stringify(param),
		url : "/ezPMS/getProjectList.do",
		success : function(projectList) {
			if (listProjectStatus == "A" || listProjectStatus == "C" || listProjectStatus == "F") {
				$("#changeProjectStatus").parent().css("display", "none");
			} else {
				$("#changeProjectStatus").parent().css("display", "");
			}
			
			if (viewType == 1) {
				$("#MailListRayer").html(projectList);
				$("#MailListRayer").css("display", "");
				$("#memoStyleDiv").css("display", "none");
			} else {
				if (mode == "moreBtn") {
					$("#memoStyleDiv").append(projectList);
				} else {
					$("#memoStyleDiv").html(projectList);
				}
				
				$("#MailListRayer").css("display", "none");
				$("#memoStyleDiv").css("display", "");
				$("#memoStyleDiv").scrollTop(0);
			}
			
			setInitOrder();
		}	
	});
}

function moreProjectList() {
	listNumber = 20;
	startRow = $("#memoStyleDiv").find(".project_list").length;
	$(".project_mainlist").find(".moreBtn").remove();
	
	setProjectList("moreBtn");
}

//tr선택시 - 메모지용
function selectedMemoTR(elem) {
	if (PressCtrlKey == true) {
		checkedCheckboxMemo(elem);
	} else {
		var parentElem = $(elem).parent().parent();
		$(".project_mainlistUL li").removeClass("selectTR");
		$(".project_mainlistUL li").find("input[type='checkbox']").removeProp("checked");
		$(parentElem).addClass("selectTR");
		$(parentElem).find("input[type='checkbox']").prop("checked","true");
	}
}

//tr선택시 - 게시판용
function selectedTR(elem) {
	if (PressCtrlKey == true) {
		checkedCheckbox(elem);
	} else {
		var parentElem = $(elem).parent();
		$("#tableBody tr").removeClass("selectTR");
		$("#tableBody tr").find("input[type='checkbox']").removeProp("checked");
		$(parentElem).addClass("selectTR");
		$(parentElem).find("input[type='checkbox']").prop("checked","true");

	}	
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

//게시판용
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

//메모용
function checkedCheckboxMemo(elem) {
	var selectRow = '' + elem;

	if (selectRow.indexOf("Div") == -1) {
		if ($(elem).is(":checked")) {
			$(elem).prop("checked","true");
			$(elem).parent().parent().parent().parent().parent().parent().addClass("selectTR");
		} else {
			$(elem).removeProp("checked");
			$(elem).parent().parent().parent().parent().parent().parent().removeClass("selectTR");
		}
	} else {
		if (!$(elem).parent().find("input:checkbox[name='memoCheckbox']").is(":checked")) {
			$(elem).parent().find("input:checkbox[name='memoCheckbox']").prop("checked", "true");
			$(elem).parent().parent().addClass("selectTR");
		} else {
			$(elem).parent().find("input:checkbox[name='memoCheckbox']").removeProp("checked");
			$(elem).parent().parent().removeClass("selectTR");
		}
	}
}

function changeProjectStatus() {
	var result = getCheckedVal();
	
	if (result == 1) {
		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%;background:none rgba(0, 0, 0, 0.4)'></div>").appendTo(parent.frames["left"].document.body);
		addProjectPopup(36, 38, 400, 220, "/ezPMS/changeProjectStatus.do");
	} else {
		alert("<spring:message code='ezPMS.t29' />");
		return;	
	}
}

function searchClear() {
	searchByProjectName = "";
	searchByUser = "";
	searchByPlanStartDate = "";
	searchByPlanEndDate = "";
	searchByOverview = "";
}

function viewListByStatus(status) {
	listProjectStatus = status;
	searchClear();
	currentPage = 1;
	
	if (viewType == 0) {
		listNumber = 20;
	} else {
		listNumber = initListNumber;
	}
	
	startRow = 0;
	
	if (listProjectStatus != "F") {
		$("#deleteFavorite").parent().css("display", "none");
		$("#addFavorite").parent().css("display", "");
		$("#changeProjectStatus").parent().css("display", "");
	} else {
		$("#deleteFavorite").parent().css("display", "");
		$("#addFavorite").parent().css("display", "none");
		$("#changeProjectStatus").parent().css("display", "none");
	}
	
	if (listProjectStatus == "D") {
		$("#deleteProject").text("<spring:message code='ezPMS.t13'/> <spring:message code='ezPMS.t12' />");
	} else {
		$("#deleteProject").text("<spring:message code='ezPMS.t13'/> <spring:message code='ezPMS.t11' />");
	}
	
	setProjectList("new");
}

function deleteProject() {
	var result = getCheckedVal();
	var response;
	var isHeadManager = true;
	
	var checkedPrjInfo = getCheckedProjectInfo();
	
	checkedPrjInfo.forEach(function(elem, idx) {
	    if (elem.headManagerId !== userId) {
	    	isHeadManager = false;
	    }
	});
	
	if(!isHeadManager){
		alert("<spring:message code='ezPMS.t9' />");
		popupClose();
		return;
	}
	
	if (listProjectStatus != "D") {
		if (result == 1) {
			 response = confirm("<spring:message code='ezPMS.t21' />");
		} else {
			alert("<spring:message code='ezPMS.t29' />");
			return;
		}
		
		if (response == true) {
			var data = {
				status : "D",
				projectList : checkedVal,
				nowStatus : listProjectStatus
			}
			
			$.ajax({
				type : "POST",
				dataType: "text",
				contentType: "application/json; charset=UTF-8",
				url : "/ezPMS/updateProjectStatus.do",
				data :JSON.stringify(data),
				success : function(result) {
					if (result == "permitted") {
						alert("<spring:message code='ezPMS.t10' />");
						
						checkedVal = "";
						
						if (viewType == 0) {
							startRow = 0;
							listNumber = $(".project_list").length;
						}
						
						var checkedPrjInfoCount = checkedPrjInfo.length;
						
						for (var i = 0; i < checkedPrjInfoCount; i++) {
							var projectName = checkedPrjInfo[i].projectName;
							var projectId 	= checkedPrjInfo[i].projectId;
							var groupId 	= checkedPrjInfo[i].groupId;
							
							var logContent = "<spring:message code='ezPMS.t312' arguments='" + projectName + "'/>";
							addTaskLog(projectId, 3, groupId, null, logContent);
						}
						
						setProjectList("new");
					} else {
						alert("<spring:message code='ezPMS.t9' />");
						return;
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
				}
			});
		}
		
	} else {
		if (result == 1) {
			response = confirm("<spring:message code='ezPMS.t22' />");
		} else {
			return;
		}
		
		if (response == true) {
			var data = {
					status : "D",
					projectList : checkedVal,
					nowStatus : listProjectStatus
				}
			
			$.ajax({
				type : "POST",
				dataType: "text",
				contentType: "application/json; charset=UTF-8",
				url : "/ezPMS/deleteProject.do",
				data :JSON.stringify(data),
				success : function(result) {
					if (result == "permitted") {
						alert("<spring:message code='ezPMS.t23' />");
						checkedVal = "";
						
						if (viewType == 0) {
							startRow = 0;
							listNumber = $(".project_list").length;
						}
						
						setProjectList("new");
					} else {
						alert("<spring:message code='ezPMS.t9' />");
						return;
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
				}
			});
		}
	}
}

function addFavoriteMemo(projectId) {
	var response = confirm("<spring:message code='ezPMS.t24' />");
	
	
	if (response == true) {		
		var data = {
				status : "F",
				projectList : projectId
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			url : "/ezPMS/addFavoriteProject.do",
			data :JSON.stringify(data),
			success : function(result) {
				if (result == "0") {
					$("#" + projectId).find("img").attr("src", "/images/ImgIcon/icon-flag.gif");
					$("#" + projectId).find("img").attr("onclick", "deleteFavoriteMemo(this)");
					
					if (viewType == 0) {
						startRow = 0;
						listNumber = $(".project_list").length;
					}
					
					setProjectList("new");
				} else {
					alert("<spring:message code='ezPMS.t26' />");
					return;
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
		
	}
}

function deleteFavoriteMemo(projectId) {
	var response = confirm("<spring:message code='ezPMS.t27' />");
	
	if (response == true) {		
		var data = {
			status : "F",
			projectList : projectId
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			url : "/ezPMS/deleteFavoriteProject.do",
			data :JSON.stringify(data),
			success : function(result) {
				$("#" + projectId).find("img").attr("src", "/images/ImgIcon/view-flag.gif");
				$("#" + projectId).find("img").attr("onclick", "addFavoriteMemo(this)");

				if (viewType == 0) {
					startRow = 0;
					listNumber = $(".project_list").length;
				}

				setProjectList("new");
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
		
	}
}

function addFavorite() {
	var result = getCheckedVal();
	var response;
	
	if (result == 1) {
		response = confirm("<spring:message code='ezPMS.t24' />");
	} else {
		alert("<spring:message code='ezPMS.t29' />");
		return;
	}
	
	if (response == true) {
		data = {
				status : "F",
				projectList : checkedVal
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			dataType : "text",
			url : "/ezPMS/addFavoriteProject.do",
			data :JSON.stringify(data),
			success : function(result) {
				
				if (result == "0") {
					checkedVal = "";

					if (viewType == 0) {
						startRow = 0;
						listNumber = $(".project_list").length;
					}
					
					setProjectList("new");
				} else {
					alert("<spring:message code='ezPMS.t26' />");
					return;
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
	}
}

var PressCtrlKey = false;

function event_listOnkeyUp(event) {
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (!event) event = window.event;
    }
    
    if (event.keyCode == 17) {
    	PressCtrlKey = false;
    }

}
function event_listOnkeyDown(event) {
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (!event) event = window.event;  
    }
    
    if (event.keyCode == 17) {
    	PressCtrlKey = true;
    }
}

function deleteFavorite() {
	var result = getCheckedVal();
	var response;
	
	if (result == 1) {
		response = confirm("<spring:message code='ezPMS.t27' />");
	} else {
		alert("<spring:message code='ezPMS.t29' />");
		return;
	}
	
	if (response == true) {
		getCheckedVal();
		
		var data = {
				status : "F",
				projectList : checkedVal
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			url : "/ezPMS/deleteFavoriteProject.do",
			data :JSON.stringify(data),
			success : function() {
				checkedVal = "";
				
				if (viewType == 0) {
					startRow = 0;
					listNumber = $(".project_list").length;
				}
				
				setProjectList("new"); 
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
	}
}

function getSearchProject() {
	addProjectPopup(20, 30, 400, 300, "/ezPMS/getProjectNameList.do");
}

function searchProject() {
	currentPage = 1;	
	searchByProjectName = $("#searchByProjectName").val();
	searchByUser = $("#searchByUser").val();
	searchByStartDate = $("#Sdatepicker").val();
	searchByEndDate = $("#Edatepicker").val();
	searchByOverview = $("#searchByOverview").val();
	
	var startDate = new Date(searchByStartDate);
	var endDate = new Date(searchByEndDate);
	//시작일 > 종료일은 불가능
	if (startDate.getTime() > endDate.getTime()) {
		 alert("<spring:message code='ezPMS.t49' />");
		 return;
	}
	
	if (viewType == 0) {
		listNumber = 20;
		startRow = 0;
	}
	
	setProjectList("new");
	layerHidden();
}

</script>
<style type="text/css">
.popupwrapAtt {
	display: inline-block;
	vertical-align: middle;
	position: relative;
	z-index: 2;
	max-width: 565px;
	box-sizing: border-box;
	width: 90%;
	background: #fff;
	padding: 15px 30px;
	-webkit-border-radius: 8px;
	-moz-border-radius: 8px;
	-o-border-radius: 8px;
	-ms-border-radius: 8px;
	border-radius: 8px;
	-webkit-box-shadow: 0 0 10px #000;
	-moz-box-shadow: 0 0 10px #000;
	-o-box-shadow: 0 0 10px #000;
	-ms-box-shadow: 0 0 10px #000;
	box-shadow: 0 0 10px #000;
	text-align: left;
}
.viewType {
	float : right;
}

.percentCount {
	display : none;
}

#layer_Viewpopup { 
	z-index:1000; 
	margin:0px; 
	padding:0px;
}

#layer_Viewpopup .popupwrap1 {
	border:1px solid #555a64;
	padding:0px;
	margin:0px;
}

#layer_Viewpopup .shadow {
	height:2px;
	background:#d7d7d7;
}

#layer_Viewpopup .popupwrap2 {
	border:2px solid #e5e5e5;
	padding:10px;
}

#layer_Viewpopup .btn_area { 
	border-top:1px solid #e5e5e5; 
	margin:10px 0px 0px 0px; 
	padding:10px 0px 0px;
}
			
/* 20130809 추가 */
#layer_Viewpopup .popupwrap3 {
	position:relative;
	padding:10px;
	background:url("../images/kr/cm/popup_layerbg.gif") repeat-x;
}

#layer_Viewpopup .popupwrap3 h1 {
	font-size:13px;
	margin:0px 0px 10px 0px;
	height:24px; 
	line-height:15px; 
	padding:0px;
	color:#fff; 
	white-space:nowrap; 
	text-overflow:ellipsis; 
	overflow:hidden;
}

.memoTd {
	width : 92px;
}

.restDueday {
	font-family : Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif;
	font-weight : bold;
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

.selectTD {
	background-color: rgb(233, 241, 255);
}

.listRow:hover {
	background-color: rgb(244, 245, 245);
}

.statusSpan {
	color :  #ffffff;
}

.project_mainlistUL li {
	cursor : pointer;
}
</style>
</head>
<body class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);">
	<h1><spring:message code='ezPMS.t8' /><span id="mailBoxInfo"> <spring:message code='ezPMS.t3' /> <span class='txt_color' id="totalCount"> </span><spring:message code='ezPMS.t4' /></span></h1>
	<div id="mainmenu">
	<ul>
		<li>
			<select id="listByStatus" onchange="viewListByStatus(this.value)">
				<option value="A"><spring:message code='ezPMS.t271' /></option>
				<option value="P"><spring:message code='ezPMS.t258' /></option>
				<option value="W"><spring:message code='ezPMS.t260' /></option>
				<option value="C"><spring:message code='ezPMS.t261' /></option>
				<option value="L"><spring:message code='ezPMS.t262' /></option>
				<option value="S"><spring:message code='ezPMS.t259' /></option>
				<option value="D"><spring:message code='ezPMS.t263' /></option>
				<option value="F"><spring:message code='ezPMS.t20' /></option>
			</select>
		</li>
		<li><span id="newProject" onclick="addNewProject()"><spring:message code='ezPMS.t55' /></span></li>
		<li><span id="deleteProject" onclick="deleteProject()"><spring:message code='ezPMS.t13'/> <spring:message code='ezPMS.t11' /></span></li>
		<li><span id="changeProjectStatus" onclick="changeProjectStatus()"><spring:message code='ezPMS.t92' /></span></li>
		<li><span id="deleteFavorite" onclick="deleteFavorite()"><spring:message code='ezPMS.t6' /></span></li>
		<li><span id="addFavorite" onclick="addFavorite()"><spring:message code='ezPMS.t7' /></span></li>
		<li><span id="searchProject" onclick="searchPopup();"><spring:message code='ezPMS.t1' /></span></li>
		<li id="right">
	        <img src="/images/kr/cm/btn_cardframe.png" width="22" height="20" class="btnimg" id="memoStyle" onclick="changeMemoStyle()">
	        <img src="/images/kr/cm/btn_listframe.png" width="22" height="20" class="btnimg" id="boardStyle" onclick="changeBoardStyle()">
			<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" />
		</li>
	</ul>
	</div>
	<div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
		        <div class="popupwrap1">
		            <div class="popupwrap2">
		                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
		                    <caption></caption>
		                    <colgroup>
		                        <col style="width: 80px;">
		                        <col>
		                    </colgroup>
		                    <tr>
		                        <th><spring:message code='ezPMS.t272' /></th>
		                        <td>
		                            <select id="listSort" style="WIDTH: 82px; height: 20px;" onchange="changeProjectSort(this.value);">
		                                <option value="0"><spring:message code='ezPMS.t273' /></option>
		                                <option value="1"><spring:message code='ezPMS.t274' /></option>
		                            </select>    
		                        </td>
		                    </tr>
		                    <tr id="listcountTR">
		                        <th><spring:message code='ezPMS.t275' /></th>
		                        <td>
		                            <select id="listcount" style="WIDTH: 40px; height: 20px;" onchange="changelistCount(this.value);">
		                                <option value="10">10</option>
		                                <option value="20">20</option>
		                                <option value="30">30</option>
		                                <option value="40">40</option>
		                                <option value="50">50</option>
		                            </select>    
		                        </td>
		                    </tr>
		                </table>
		            </div>
		        </div>
		        <div class="shadow">
		        </div>
		    </div>
	<div id = "prjectList">
		<span id="MailListRayer" style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: none;"></span>
		<div id="memoStyleDiv" style="height: 80%; width: 100%; overflow: auto; display: none;"></div>
	</div>
	<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	<div id="searchPopup" class="popupwrap1 modal" style="display:none;margin-bottom:50px;">
		<div class="popupJQLayer">
			<div class="title"><spring:message code='ezPMS.t13'/> <spring:message code='ezPMS.t1'/></div>
			<div id="close">
				<ul>
					<li><a rel="modal:close"><span onclick="layerHidden()"></span></a></li>
				</ul>
			</div>
			<!-- 내용 -->
			<table class="content" style="width:100%;">
			<tbody>
				<tr>
					<th><spring:message code='ezPMS.t31' /> </th>
					<td><input type="text" id="searchByProjectName" style="width:100%; margin-right:5px;"><%-- <a class="imgbtn" onclick="getSearchProject()"><span><spring:message code='ezPMS.t150' /></span></a> --%></td>
				</tr>
				<tr>
					<th><spring:message code='ezPMS.t63' /></th>
					<td><input type="text" id="searchByUser" style="width:100%"></td>
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
					<th><spring:message code='ezPMS.t66' /></th>
					<td colspan="3"><input type="text" style="width:100%" id="searchByOverview"></td>
				</tr>
			</tbody>
		</table>
				<!-- /내용 -->
				<table style="width:100%">
				<tr>
				<td style="text-align:center;">
					<div class="btnpositionLayer">
					<a class="imgbtn" onclick="searchProject()"><span><spring:message code='ezPMS.t1' /></span></a>
					<a class="imgbtn" rel="modal:close"><span onclick="layerHidden();"><spring:message code='ezAttitude.t34'/></span></a>
					</div>
			    </td>
			    </tr>
			    </table>
			</div>
		</div>
</body>
</html>