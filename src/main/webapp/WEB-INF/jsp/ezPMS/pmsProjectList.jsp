<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
<script type="text/javascript">
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
		$("#" + projectList[i].projectId).LineProgressbar({
			percentage : projectList[i].progress,
			fillBackGroundColor:"#9b59b6",
			height:'15px',
			radius:'15px',
			width : '80%'
		});
	}
});

</script>
<style type="text/css">
.viewType {
	float : right;
}

.percentCount {
	display : none;
}

</style>
</head>
<body class="mainbody">
	<h1>프로젝트 관리</h1>
	<div id="mainmenu">
		<a class="imgbtn" id="projectDetail" onclick="goToProjectDetails()"><span>project</span></a>
		<a class="imgbtn" id="newProject" onclick="addNewProject()"><span>new project</span></a>
		<a class="imgbtn viewType" id="cancel" onclick="changeToMemo()"><span>메모형식</span></a>
		<a class="imgbtn viewType" id="cancel" onclick="changeToBoard()"><span>게시판형식</span></a>
	</div>
	
	<span id="MailListRayer" style="border: 0px solid blue; width: 100%; height: 484px; vertical-align: top; overflow: hidden; display: inline-block;"> 
	<div style="width: 100%; height: 434px;" id="divList">
	<div id="lvBoardList">
	<table class="mainlist" style="min-width:579px;" width="100%" border="0" multiselectable="false" useocs="false" cellspacing="0" cellpadding="0">
		<tr>
			<th style="width: 50px; text-align:center"><input type="checkbox" id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
			<th style="width: 20%">프로젝트명</th>
			<th>총괄 담당자</th>
			<th style="width: 10%; text-align:center">전체 진행률</th>
			<th>완료된 업무</th>
			<th>기한 지난 업무</th>
			<th>남은 기간</th>
			<th style="width:20%; text-align : center;">프로젝트 기간</th>
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
					<td style="width: 10%"><div id="${project.projectId }" style="margin-right:2px;"></div>&nbsp;<div style="margin-top:5px; display:inline-block;"><c:out value="${project.progress }"/></div></td>
					<td></td>
					<td></td>
					<td>D <c:choose><c:when test="${project.restDueday ge 0 }">- <c:out value="${project.restDueday }"/></c:when>
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