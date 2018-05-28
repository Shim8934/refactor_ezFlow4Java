<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>프로젝트 관리 목록</title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />

<!-- time picker-->
<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script type="text/javascript">

var viewType = "${viewType}";
var projectSort = "${projectSort}";
var progressColor = "${progressColor}";
var completeColor = "${completeColor}";
var overdueColor = "${overdueColor}";
var holdColor = "${holdColor}";
var listNumber = "${listNumber}";
var listProjectStatus = "${listProjectStatus}";
var currentPage = 1;
var orderWhat; 
var orderHow;
var CurrentHeight = document.documentElement.clientHeight - 110;
var projectTotalCount = 0;
var checkedVal = "";
//검색을 위한 변수
var searchByNmae = "";
var searchByUser = "";
var searchByStartDate = "";
var searchByEndDate = "";
var searchByOverview = "";

function goProjectDetails(elem) {
	var projectId = $(elem).attr("id");
	window.open("/ezPMS/getProjectDetails.do?projectId="+projectId, "right");
}

function addNewProject(){ 
	addProjectPopup(10, 20, 845, 555, "/ezPMS/newProject.do?mode=" + "new");
}

$(document).ready(function(){
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
	
	if (navigator.userAgent.toLowerCase().indexOf("m sie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { 
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
			document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		}

		if(viewType == 0) {
			$("#memoStyleDiv").css("display", "");
			$("#memoStyle").attr("src", "/images/kr/cm/btn_onnoframe.gif");
			document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
		} else {
			$("#MailListRayer").css("display", "inline-block");
			$("#boardStyle").attr("src", "/images/kr/cm/btn_onbottomframe.gif");
			
			document.getElementById("divList").style.overflow = "auto";
			document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
			document.getElementById("MailListRayer").style.width = "100%";
			document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";
			document.getElementById("projectListBody").style.height = (CurrentHeight - 50 - 35) + "px";
		}
	});
	
});

function projectListScroll(){
	if(viewType == 0) {
		$("#memoStyleDiv").css("display", "");
		$("#memoStyle").attr("src", "/images/kr/cm/btn_onnoframe.gif");
		document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
	} else {
		$("#MailListRayer").css("display", "inline-block");
		$("#boardStyle").attr("src", "/images/kr/cm/btn_onbottomframe.gif");
		
		document.getElementById("divList").style.overflow = "auto";
		document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		document.getElementById("MailListRayer").style.width = "100%";
		document.getElementById("divList").style.height = (CurrentHeight - 45) + "px";
		document.getElementById("projectListBody").style.height = (CurrentHeight - 50 - 35) + "px";
	}
	
	if (viewType == "1") {
		var thWidth = document.getElementById("tableHeader").clientWidth - document.getElementById("tableBody").clientWidth;
		if(thWidth > 0){ 
			$("#BoardList_TH").append('<th style=width:2px;></th>');
		}	
	} 
}

$(function(){
	setProjectList();
	getDatePicker();

	if(viewType == 0) {
		$("#listcountTR").css("display", "none");
	} else {
		$("#listcountTR").css("display", "");
	}
	
	if (listProjectStatus != "F") {
		$("#deleteFavorite").css("display", "none");
	} else {
		$("#deleteFavorite").css("display", "");
		$("#addFavorite").css("display", "none");
	}
	
	$("#listSort option[value='"+ projectSort +"']").attr("selected", true);
	$("#listcount option[value='"+ listNumber +"']").attr("selected", true);
	$("#listByStatus option[value='" + listProjectStatus + "']").attr("selected", true);
	$("#deleteFavorite").css("display", "none");
	
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
        if (flag=='N') {
        	document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 160 + "px";
        } else {
        	document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
        }
        document.getElementById("layer_Viewpopup").style.top = "100px";
        document.getElementById("layer_Viewpopup").style.display = "";
        obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
        obj.setAttribute("mode", "on");
    }
    else {
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
	
	changeMainSetting();
	setProjectList();
	
	$("#memoStyle").attr("src", "/images/kr/cm/btn_onnoframe.gif");
	$("#boardStyle").attr("src", "/images/kr/cm/btn_bottomframe.gif");
	$("#listcountTR").css("display", "none");
}

function changeBoardStyle() {
	viewType = 1;
	
	changeMainSetting();
	setProjectList();
	
	$("#memoStyle").attr("src", "/images/kr/cm/btn_noframe.gif");
	$("#boardStyle").attr("src", "/images/kr/cm/btn_onbottomframe.gif");
	$("#listcountTR").css("display", "");
	
}

function changeMainSetting() {
	
	data = {
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
		success : function(result) {},
		error : function(jqXHR, textStatus, errorThrown) {}
	});
}

function ListCount(listCountNum) {
	listNumber = listCountNum;
	
	changeMainSetting();
	setProjectList();
}

function ChangeProjectSort(sortType) {
	projectSort = sortType;
	orderHow = "";
	orderWhat = "";
	changeMainSetting();
	setProjectList();
	
}

//페이지 번호에 의한 셋팅
function goToPageByNum(page){
	currentPage = page;
	setProjectList();
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
	
	setProjectList();
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

	//검색 초기화
	$("#searchByName").val("");
	$("#searchByUser").val("");
	$("#Sdatepicker").val("");
	$("#Edatepicker").val("");
	$("#searchByOverview").val("");
	
	projectListScroll();
}

function setProjectList() {	
	var param = {
		projectSort : projectSort,
		viewType : viewType,
		progressColor : progressColor,
		completeColor : completeColor,
		overdueColor  : overdueColor,
		holdColor     : holdColor,
		listNumber : listNumber,
		listProjectStatus : listProjectStatus,
		currentPage : currentPage,
		projectTotalCount : projectTotalCount,
		//프로젝트 header 정렬
		orderWhat : orderWhat,
		orderHow : orderHow,
		//프로젝트 검색
		searchByName : searchByName,
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
			$("#prjectList").html(projectList);
			setInitOrder();
		}	
	});
}

//tr선택시 - 메모지용
function selectedMemoTR(elem){
	if (PressCtrlKey == true) {
		checkedCheckboxMemo(elem);
	} else {
		var parentElem = $(elem).parent().parent();
		$(".projectList").removeClass("selectTR");
		$(".projectList").find("input[type='checkbox']").removeProp("checked");
		$(parentElem).addClass("selectTR");
		$(parentElem).find("input[type='checkbox']").prop("checked","true");
	}
}

//tr선택시 - 게시판용
function selectedTR(elem){
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
	
	if (selectRow.indexOf("TableRow") == -1) {
		if ($(elem).is(":checked")) {
			$(elem).prop("checked","true");
			$(elem).parent().parent().parent().parent().addClass("selectTR");
		} else {
			$(elem).removeProp("checked");
			$(elem).parent().parent().parent().parent().removeClass("selectTR");
		}
	} else {
		if (!$(elem).parent().parent().find("input:checkbox[name='memoCheckbox']").is(":checked")) {
			$(elem).parent().parent().find("input:checkbox[name='memoCheckbox']").prop("checked", "true");
			$(elem).parent().parent().addClass("selectTR");
		} else {
			$(elem).parent().parent().find("input:checkbox[name='memoCheckbox']").removeProp("checked");
			$(elem).parent().parent().removeClass("selectTR");
		}
	}
}

function changeProjectStatus() {
	var result = getCheckedVal();
	
	if (result == 1) {
		addProjectPopup(36, 38, 400, 162, "/ezPMS/changeProjectStatus.do");
	} else {
		return;	
	}
}

function viewListByStatus(status) {
	listProjectStatus = status;
	currentPage = 1;
	
	if (listProjectStatus != "F") {
		$("#deleteFavorite").css("display", "none");
		$("#addFavorite").css("display", "");
		$("#changeProjectStatus").css("display", "");
	} else {
		$("#deleteFavorite").css("display", "");
		$("#addFavorite").css("display", "none");
		$("#changeProjectStatus").css("display", "none");
	}
	
	if (listProjectStatus == "D") {
		$("#deleteProject").text("영구삭제");
	} else {
		$("#deleteProject").text("삭제");
	}
	
	setProjectList();
}

function deleteProject() {
	var result = getCheckedVal();
	var response;
	
	if (listProjectStatus != "D") {
		if (result == 1) {
			 response = confirm("프로젝트를 삭제하시겠습니까? \n 프로젝트는 삭제프로젝트로 상태가 변경됩니다.");
		} else {
			return;
		}
		
		if (response == true) {
			data = {
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
						alert("상태가 변경되었습니다.");
						checkedVal = "";
						setProjectList();
					} else {
						alert("프로젝트 담당자만 상태를 변경할 수 있습니다.");
						return;
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
				}
			});
		}
		
	} else {
		if (result == 1) {
			response = confirm("프로젝트를 영구 삭제하시겠습니까?");
		} else {
			return;
		}
		
		if (response == true) {
			data = {
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
						alert("프로젝트가 영구삭제 되었습니다.");
						checkedVal = "";
						setProjectList();
					} else {
						alert("프로젝트 담당자만 상태를 변경할 수 있습니다.");
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
	var response = confirm("프로젝트를 즐겨찾기 하시겠습니까?");
	if (response == true) {
		data = {
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
					alert("프로젝트가 즐겨찾기 되었습니다.");
					$("#"+projectId).find("img").attr("src", "/images/ImgIcon/icon-flag.gif");
					$("#"+projectId).find("img").attr("onclick", "deleteFavoriteMemo(this)");
				
				} else {
					alert("이미 추가된 프로젝트 입니다.");
					return;
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
		
	}
}

function deleteFavoriteMemo(projectId) {
	var response = confirm("프로젝트 즐겨찾기를 해제하시겠습니까?");
	if (response == true) {
		
		data = {
				status : "F",
				projectList : projectId
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			url : "/ezPMS/deleteFavoriteProject.do",
			data :JSON.stringify(data),
			success : function(result) {
				alert("즐겨찾기가 해제되었습니다.");
				$("#"+projectId).find("img").attr("src", "/images/ImgIcon/view-flag.gif");
				$("#"+projectId).find("img").attr("onclick", "addFavoriteMemo(this)");
				
				if (listProjectStatus == "F") {
					setProjectList();
				}
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
		response = confirm("프로젝트를 즐겨찾기 하시겠습니까?");
	} else {
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
			url : "/ezPMS/addFavoriteProject.do",
			data :JSON.stringify(data),
			success : function() {
				if (result == "0") {
					checkedVal = "";
					setProjectList(); 
					alert("프로젝트가 즐겨찾기 되었습니다.");
				} else {
					alert("이미 추가된 프로젝트 입니다.");
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
		response = confirm("프로젝트를 해제 하시겠습니까?");
	} else {
		return;
	}
	
	if (response == true) {
		getCheckedVal();
		
		data = {
				status : "F",
				projectList : checkedVal
		}
		
		$.ajax({
			type : "POST",
			contentType: "application/json; charset=UTF-8",
			url : "/ezPMS/deleteFavoriteProject.do",
			data :JSON.stringify(data),
			success : function() {
				alert("프로젝트가 즐겨찾기가 해제되었습니다.");
				checkedVal = "";
				setProjectList(); 
			},
			error : function(jqXHR, textStatus, errorThrown) {
			}
		});
	}
}

function getCheckedVal() {

	checkedVal = "";
	
	if (viewType == "1") {
		$("input[type='checkbox']:checked").parent().parent().each(function(){
			checkedVal += "_" + $(this).attr("id");
		});
		
		if (checkedVal != "") {
			if ($("input:checkbox[id='HeaderAllCheckBox']").is(":checked") == true) {
				checkedVal = checkedVal.substring(14);
			} else {
				checkedVal = checkedVal.substring(1);
			}
		}
		
	} else {
		$("input[type='checkbox']:checked").parent().parent().parent().parent().each(function(){
			checkedVal += "_" + $(this).attr("id");
		});
		
		if(checkedVal != "") {
			checkedVal = checkedVal.substring(1);
		}
	}
	
	if (checkedVal == "") {
		alert("하나 이상의 프로젝트를 선택해 주세요.");
		return 0;
	}
	
	return 1;
}

function getSearchProject() {
	addProjectPopup(20, 30, 400, 300, "/ezPMS/getProjectNameList.do");
}

function searchProject() {
	currentPage = 1;
	listProjectStatus = "A";
	searchByName = $("#searchByName").val();
	searchByUser = $("#searchByUser").val();
	searchByStartDate = $("#Sdatepicker").val();
	searchByEndDate = $("#Edatepicker").val();
	searchByOverview = $("#searchByOverview").val();
	
	setProjectList();
}

function emptyDate(elem){
	$(elem).siblings('input').val("");
}


</script>
<style type="text/css">
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
	background-color: rgb(233, 241, 255);
}
</style>
</head>
<body class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);">
	<h1>프로젝트 관리<span id="mailBoxInfo"> - [총 <span style="color:#017BEC;" id="totalCount"> </span>개]</span></h1>
	<div id="mainmenu">
	<ul>
		<li>
			<select style="height:27px;" id="listByStatus" onchange="viewListByStatus(this.value)">
				<option value="A">전체 프로젝트</option>
				<option value="P">진행 프로젝트</option>
				<option value="W">대기 프로젝트</option>
				<option value="C">완료 프로젝트</option>
				<option value="L">지연 프로젝트</option>
				<option value="S">보류 프로젝트</option>
				<option value="D">삭제 프로젝트</option>
				<option value="F">자주가는 프로젝트</option>
			</select>
		</li>
		<li><span id="1" onclick="goProjectDetails(this)">project(임시)</span></li>
		<li><span id="newProject" onclick="addNewProject()">새 프로젝트</span></li>
		<li><span id="deleteProject" onclick="deleteProject()">삭제</span></li>
		<li><span id="changeProjectStatus" onclick="changeProjectStatus()">프로젝트 상태 변경</span></li>
		<li><span id="deleteFavorite" onclick="deleteFavorite()">즐겨찾기 해제</span></li>
		<li><span id="addFavorite" onclick="addFavorite()">즐겨찾기 추가</span></li>
		<li><span id="searchProject" onclick="showSearchDiv()">검색 <img src="/images/etc/view-sortup.gif" align="absmiddle" class="searchViewIcon"></span></li>
		<li id="right">
	        <img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="memoStyle" onclick="changeMemoStyle()">
	        <img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="boardStyle" onclick="changeBoardStyle()">
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
		                        <th>리스트 설정</th>
		                        <td>
		                            <select id="listSort" style="WIDTH: 82px; height: 20px;" onchange="ChangeProjectSort(this.value);">
		                                <option value="0">완료일 순</option>
		                                <option value="1">시작일 순</option>
		                            </select>    
		                        </td>
		                    </tr>
		                    <tr id="listcountTR">
		                        <th><spring:message code='ezBoard.t10021' /></th>
		                        <td>
		                            <select id="listcount" style="WIDTH: 40px; height: 20px;" onchange="ListCount(this.value);">
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
	<div id = "searchDiv" style="display:none; margin-bottom:10px; display:none;">
		<table class="content" style="width:80%; margin-bottom:5px;">
			<tbody>
				<tr>
					<th>프로젝트명 </th>
					<td style="width:50%"><input type="text" id="searchByName" style="width:50%; margin-right:5px;"><a class="imgbtn" onclick="getSearchProject()"><span>프로젝트 선택</span></a></td>
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
					<th>개요</th>
					<td colspan="3"><input type="text" style="width:100%" id="searchByOverview"></td>
				</tr>
			</tbody>
		</table>
		<a class="imgbtn" onclick="searchProject()" style="margin-left:40%;"><span>검색</span></a>
	</div>
	<div id = "prjectList"></div>
	<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>