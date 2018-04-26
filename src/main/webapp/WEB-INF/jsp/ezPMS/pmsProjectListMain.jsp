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
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
<script type="text/javascript">

var viewType = "${viewType}";
var projectSort = "${projectSort}";
var progressColor = "${progressColor}";
var completeColor = "${completeColor}";
var overdueColor = "${overdueColor}";
var holdColor = "${holdColor}";
var listNumber = "${listNumber}";
var listProjectStatus = "${listProjectStatus}";

function goToProjectDetails() {
	window.open("/ezPMS/getProjectDetails.do", "right");
}

function addNewProject(){ 
	addProjectPopup(845, 555, "/ezPMS/newProject.do");
}

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
		$("#memoStyleDiv").css("display", "");
		$("#memoStyle").attr("src", "/images/kr/cm/btn_onnoframe.gif");
	} else {
		$("#MailListRayer").css("display", "inline-block");
		$("#boardStyle").attr("src", "/images/kr/cm/btn_onbottomframe.gif");
	}
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
	
	$("#MailListRayer").css("display", "none");
	$("#memoStyleDiv").css("display", "");
	$("#memoStyle").attr("src", "/images/kr/cm/btn_onnoframe.gif");
	$("#boardStyle").attr("src", "/images/kr/cm/btn_bottomframe.gif");

}

function changeBoardStyle() {
	viewType = 1;
	
	changeMainSetting();
	
	$("#memoStyleDiv").css("display", "none");
	$("#MailListRayer").css("display", "");
	$("#memoStyle").attr("src", "/images/kr/cm/btn_noframe.gif");
	$("#boardStyle").attr("src", "/images/kr/cm/btn_onbottomframe.gif");
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
		<li><span onclick="goProjectDetails">project(임시)</span></li>
		<li><span id="newProject" onclick="addNewProject()">새 프로젝트</span></li>
		<li><span id="deleteProject" onclick="deleteProject()">삭제</span></li>
		<li><span id="changeProjectStatus" onclick="changeProjectStatus()">프로젝트 상태 변경</span></li>
		<li><span id="addFavorite" onclick="addFavorite()">즐겨찾기 추가</span></li>
		<li><span id="searchProject" onclick="searchProject()">검색</span></li>
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
		                            <select id="listSort" style="WIDTH: 82px; height: 20px;">
		                                <option value="sortEndDate">완료일 순</option>
		                                <option value="sortStartDate">시작일 순</option>
		                            </select>    
		                        </td>
		                    </tr>
		                    <tr>
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
	<div id = "memoStyleDiv" style="max-height:484px; width:100%; overflow:auto; display:none;">
		<c:forEach items="${projectList }" var="project" >
			<table id="${project.projectId }" style="margin:10px 20px; float:left; position:relative; border:solid 1px gray; clear:none; width:360px; left:2%;">
				<tr>
					<th colspan="2" style="height:30px; font-size:15px;"><input type="checkbox" style="margin: 0px; padding: 0px; width: 13px; height: 13px; cursor: pointer; float:left"><c:out value="${project.projectName }"/><img class="star" style="cursor:pointer; float:right;" draggable="false" src="/images/ImgIcon/view-flag.gif" onclick="addFavorite(${project.projectId })"></th>
				</tr>
				<tr>
					<td colspan="2">&nbsp;&nbsp;<c:out value="${project.status }"/></td>
				</tr>
				<tr><td colspan="2" >&nbsp;</td></tr>
				<tr>
				
					<td colspan="2" style="text-align:center; font-size:20px;" class="restDueday">D <c:choose><c:when test="${project.restDueday ge 0 }">- <c:out value="${project.restDueday }"/></c:when>
								<c:otherwise>+ <c:out value="${-project.restDueday }"/></c:otherwise></c:choose>  </td>
				</tr>
				<tr>
					<td colspan="2" style="text-align:center">(<c:out value="${project.planStartDate }"/> ~ <c:out value="${project.planEndDate }"/>)</td>
				</tr>
				<tr><td colspan="2" >&nbsp;</td></tr>
				<tr><td colspan="2" >&nbsp;</td></tr>
				<tr>
					<td class="memoTd">&nbsp;&nbsp;총괄 담당자</td>
					<td><c:out value="${project.headManagerName }"/></td>
				</tr>
				<tr>
					<td class="memoTd">&nbsp;&nbsp;전체 진행률</td>
					<td><div name="${project.projectId }" style="margin-right:2px;"></div>&nbsp;<div style="margin-top:5px; display:inline-block;"><c:out value="${project.progress }"/></div></td>
					
				</tr>
				<tr>
					<td class="memoTd">&nbsp;&nbsp;완료된 업무</td>
					<td><div complete="${project.projectId }" style="margin-right:2px;"></div>&nbsp;<div style="margin-top:5px; display:inline-block;"><c:out value="${project.progress }"/></div></td>
				</tr>
				<tr>
					<td class="memoTd">&nbsp;&nbsp;지연된 업무</td>
					<td><div overdue="${project.projectId }" style="margin-right:2px;"></div>&nbsp;<div style="margin-top:5px; display:inline-block;"><c:out value="${project.progress }"/></div></td>
				</tr>
			</table>
		</c:forEach>
	</div>
	<span id="MailListRayer" style="border: 0px solid blue; width: 100%; height: 484px; vertical-align: top; overflow: hidden; display: none;"> 
	<div style="width: 100%; height: 434px;" id="divList">
	<div id="lvBoardList">
	<table class="mainlist" style="min-width:579px;" width="100%" border="0" multiselectable="false" useocs="false" cellspacing="0" cellpadding="0">
		<tr>
			<th style="width: 50px; text-align:center"><input type="checkbox" id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
			<th style="width: 20%">프로젝트명</th>
			<th>총괄 담당자</th>
			<th style="width: 10%; text-align:center">전체 진행률</th>
			<th style="width: 10%; text-align:center">완료된 업무</th>
			<th style="width: 10%; text-align:center">기한 지난 업무</th>
			<th>남은 기간</th>
			<th style="width:20%;">프로젝트 기간</th>
			<th>상태</th>
		</tr>
		</table>
		<div style="overflow: auto; min-width: 579px; height: 396px;">
		<table class="mainlist" style="width:100%">
			<c:forEach items="${projectList }" var="project" >
				<tr>
					<td style="width: 50px; cursor: default; text-align:center"><input type="checkbox" style="margin: 0px; padding: 0px; width: 13px; height: 13px; cursor: pointer;"></td>
					<td style="width: 20%; text-align:left;"><c:out value="${project.projectName }"/></td>
					<td><c:out value="${project.headManagerName }"/></td>
					<td style="width: 10%"><div name="${project.projectId }" style="margin-right:2px;"></div>&nbsp;<div style="margin-top:5px; display:inline-block;"><c:out value="${project.progress }"/></div></td>
					<td style="width: 10%"><div complete="${project.projectId }" style="margin-right:2px;"></div>&nbsp;<div style="margin-top:5px; display:inline-block;"><c:out value="${project.progress }"/></div></td>
					<td style="width: 10%"><div overdue="${project.projectId }" style="margin-right:2px;"></div>&nbsp;<div style="margin-top:5px; display:inline-block;"><c:out value="${project.progress }"/></div></td>
					<td style="text-align:center;">D <c:choose><c:when test="${project.restDueday ge 0 }">- <c:out value="${project.restDueday }"/></c:when>
								<c:otherwise>+ <c:out value="${-project.restDueday }"/></c:otherwise></c:choose>  </td>
					<td style="width:20%"><c:out value="${project.planStartDate }"/> ~ <c:out value="${project.planEndDate }"/></td>
					<td><div style="width:40px; background-color:rgb(224, 224, 224); margin-left:10px;"><c:out value="${project.status }"/></div></td>
				</tr>
			</c:forEach>
			</table>
		</div>
		
	</div>
		
	</div>
		</span>
	
	
	<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>