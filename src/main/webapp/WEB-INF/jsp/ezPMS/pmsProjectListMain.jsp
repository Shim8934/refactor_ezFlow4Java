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
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
<!-- time picker-->
<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
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
var orderNum; 
var orderHow;
var projectIdList = [];
var CurrentHeight = document.documentElement.clientHeight - 110;
var projectTotalCount = "${projectListCount}"

function goToProjectDetails() {
	window.open("/ezPMS/getProjectDetails.do", "right");
}

function addNewProject(){ 
	addProjectPopup(845, 555, "/ezPMS/newProject.do");
}

$(document).ready(function(){
	$(window).resize(function() {
		CurrentHeight = $(window).height()-110;
		if (viewType == 0) {
			document.getElementById("memoStyleDiv").style.height = (CurrentHeight - 50) + "px";
		} else {
			document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
			document.getElementById("divList").style.height = (CurrentHeight - 50) + "px";
		}
	});
});


function addProjectPopup(popUpW, popUpH, URL) {
    try {
        var Position = DivPopUpPosition(popUpW, popUpH);
        document.getElementById("iFrameLayer").src = URL;
        document.getElementById("iFramePanel").style.top = "10%";
        document.getElementById("iFramePanel").style.left = "20%";
        document.getElementById("iFramePanel").style.height = popUpH + "px";
        document.getElementById("iFrameLayer").style.width = popUpW + "px";
        document.getElementById("iFrameLayer").style.height = popUpH + "px";
        document.getElementById("mailPanel").style.display = "";
        document.getElementById("iFramePanel").style.display = "";
    } catch (e) {}
}

$(function(){
	
	setProjectList();
	
	var projectList = new Array();
	
	<c:forEach items="${projectList}" var="project">
		var json = new Object();
		json.projectId = "${project.projectId}";
		json.progress = "${project.progress}";
		projectList.push(json);
	</c:forEach>
	
	for (var i = 0; i < projectList.length; i++) {
		$("div[name=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackGroundColor:"#9b59b6",
			height:'15px',
			radius:'15px',
			width : '80%'
		});
		
		$("div[complete=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackGroundColor:"#9b59b6",
			height:'15px',
			radius:'15px',
			width : '80%'
		});
		
		$("div[overdue=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackGroundColor:"#9b59b6",
			height:'15px',
			radius:'15px',
			width : '80%'
		});
	}
	
	if(viewType == 0) {
		$("#listcountTR").css("display", "none");
	} else {
		$("#listcountTR").css("display", "");
	}
	
	$("#listSort option[value='"+ projectSort +"']").attr("selected", true);
	$("#listcount option[value='"+ listNumber +"']").attr("selected", true);
});

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
		listNumber : listNumber,
		listProjectStatus : listProjectStatus
	}
	
	$.ajax({
		type : "POST",
		dataType: "json",
		contentType: "application/json; charset=UTF-8",
		url : "/ezPMS/updateMainSetting.do",
		data :JSON.stringify(data),
		success : function(result) {
			console.log(result);
		},
		error : function(jqXHR, textStatus, errorThrown) {
		}
	});
}

function addFavorite(projectId) {
	$("#"+projectId).find(".star").attr("src", "/images/ImgIcon/icon-flag.gif");
}

function ListCount(listCountNum) {
	listNumber = listCountNum;
	
	changeMainSetting();
	setProjectList();
}

function ChangeProjectSort(sortType) {
	projectSort = sortType;
	
	changeMainSetting();
	setProjectList();
	
}
//페이지 번호에 의한 셋팅
function goToPageByNum(page){
	currentPage = page;
	setProjectList();
}


//정렬에 의한 리스트 셋팅
function setListOrder(elem){
	
	orderNum = $(elem).attr("order");
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
	
		if(orderNum == $(this).attr("order")) {
			if(orderHow == 'asc'){
				$(this).attr("sort","asc");
				$(this).append(' <img src="/images/etc/view-sortdown.gif" align="absmiddle">');
			} else if(orderHow == 'desc'){
				$(this).attr("sort","desc");
				$(this).append(' <img src="/images/etc/view-sortup.gif" align="absmiddle">');
			}
		}
	});
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
		projectTotalCount : projectTotalCount
		//뒤에 검색부분이 들어갈 예정
	}
	
	
	$.ajax({
		type : "post",
		contentType : "application/json",
		dataType : "html",
		data : JSON.stringify(param),
		url : "/ezPMS/getProjectList.do",
		success : function(projectList) {
			$("#prjectList").html(projectList);
		}	
	});
}

//tr선택시 - 메모지용
function selectedMemoTR(elem){
//		onPreview = false;
	var parentElem = $(elem).parent().parent();
	$(".projectList").removeClass("selectTR");
	$(".projectList").find("input[type='checkbox']").removeProp("checked");
	$(parentElem).addClass("selectTR");
	$(parentElem).find("input[type='checkbox']").prop("checked","true");
}

//tr선택시 - 게시판용
function selectedTR(elem){
//		onPreview = false;
	var parentElem = $(elem).parent();
	$("#projectList tr").removeClass("selectTR");
	$("#projectList tr").find("input[type='checkbox']").removeProp("checked");
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

//게시판용
function checkedCheckbox(elem) {
	console.log(elem);
	if ($(elem).is(":checked")) {
		$(elem).prop("checked","true");
		$(elem).parent().parent().addClass("selectTR");
	} else {
		$(elem).removeProp("checked");
		$(elem).parent().parent().removeClass("selectTR");
	}
}

//메모용
function checkedCheckboxMemo(elem) {
	console.log($(elem).is(":checked"));
	console.log(elem);
	if ($(elem).is(":checked")) {
		$(elem).prop("checked","true");
		$(elem).parent().parent().parent().parent().addClass("selectTR");
	} else {
		$(elem).removeProp("checked");
		$(elem).parent().parent().parent().parent().removeClass("selectTR");
	}
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
	width : 30%;
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

</style>
</head>
<body class="mainbody">
	<h1>프로젝트 관리<span id="mailBoxInfo"> - [총 <span style="color:#017BEC;"> <c:out value="${projectListCount }"/> </span>개]</span></h1>
	<div id="mainmenu">
	<ul>
		<li>
			<select style="height:27px;">
				<option>전체 프로젝트</option>
				<option>진행 프로젝트</option>
				<option>대기 프로젝트</option>
				<option>완료 프로젝트</option>
				<option>지연 프로젝트</option>
				<option>보류 프로젝트</option>
				<option>삭제 프로젝트</option>
				<option>자주가는 프로젝트</option>
			</select>
		</li>
		<li><span onclick="goToProjectDetails()">project(임시)</span></li>
		<li><span id="newProject" onclick="addNewProject()">새 프로젝트</span></li>
		<li><span id="deleteProject" onclick="deleteProject()">삭제</span></li>
		<li><span id="changeProjectStatus" onclick="changeProjectStatus()">프로젝트 상태 변경</span></li>
		<li><span id="addFavorite" onclick="addFavorite()">즐겨찾기 추가</span></li>
		<li><span id="searchProject" onclick="showSearchDiv()">검색</span></li>
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
	<div id = "searchDiv" style="display:none">
		<table class="content" style="width:80%">
			<tbody>
				<tr>
					<th>프로젝트명 </th>
					<td><input type="text" id="searchByName" style="width:50%; margin-right:5px;"><a class="imgbtn"><span>프로젝트 선택</span></a></td>
					<th>담당자</th>
					<td style="width:40%"><input type="text" id="searchByUser"></td>
				</tr>
				<tr>
					<th>시작일 </th>
					<td><input type="text" id="searchByStartDate"><a class="imgbtn"><span>날짜 초기화</span></a></td>
					<th>종료일</th>
					<td><input type="text" id="searchByEndDate"><a class="imgbtn"><span>날짜 초기화</span></a></td>
				</tr>
				<tr>
					<th>개요</th>
					<td colspan="3"><input type="text" style="width:90%"></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div id = "prjectList"></div>
	<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>