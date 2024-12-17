<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t82' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>

<style type="text/css">
.textInput {
	width : 100%;
}
.headerDiv {
    width: 150px;
    float: right;
    text-align: center;
    margin-top: 7px;
}

th a.imgbtn {
	width: 74px;
	text-align: center;
}

#overview {
    height: 175px;
    width: 553px;
    resize: none;
    margin: 3px 1px 0px 1px;
    resize: none;
}

</style>
<script>
var projectId = parent.opener.projectId;
var projectName = "";
var weight = null;
var managerList = [];
var overview = null;
var headManagerId = "";
var groupId = "";
var groupName = "";
var taskDetails = {};
var writerId= "";
var treeDepth = 0;
var participantList = [];

 $(function() {
// 	 taskDetails = ${taskDetails};
// 	 managerList = ${taskDetails.taskMember};
// 	 headManagerId = "${taskDetails.headManagerId}";
	 document.getElementById("groupName").focus();
 });
 
function openMemberList(type) {
	var win;
	
	if(groupId == "") {
		alert("<spring:message code='ezPMS.t85' />");
		return;
	}
	
	var feature = GetOpenPosition(760, 700);
	
	// 상위그룹으로 최상위 그룹인 프로젝트 자체를 선택했을 때는 groupId를 넘기지 않는다
	if(treeDepth == '0') {
		DivPopUpShow(600, 408, "/ezPMS/goProjectMemberList.do?projectId=" + projectId + "&type=" + type, "",
				"height = 408px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
	} else {
		DivPopUpShow(600, 408, "/ezPMS/goProjectMemberList.do?projectId=" + projectId + "&groupId=" + groupId + "&type=" + type, "",
				"height = 408px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
	}
	
}

function openGroupTree() {
	var win;
 	var feature = GetOpenPosition(760, 700);
 	
 	DivPopUpShow(338, 335, "/ezPMS/goGroupTree.do?projectId=" + projectId, "",
		 	"height = 335px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}

/* function open() {
	alert("아직 미구현.");
} */

 function popupClose() {
	if(window.opener){
		window.close();
	} else {
		parent.DivPopUpHidden();
	}
 }
 
 function applyList() {
	 var managerNameList = "";
	 var managerListCount = managerList.length;
	 
	 for (var i = 0; i < managerListCount; i++) {
		managerNameList += managerList[i].userName;
		managerNameList += "(" + managerList[i].userDeptname + "), ";
	 }
	 
	 managerNameList = managerNameList.substr(0, managerNameList.length - 2);
	 
	 $("#managers").html(managerNameList);
 }
 
 function applyParticipantList() {
	 var participantNameList = "";
	 var participantListCount = participantList.length;
	 
	 for (var i = 0; i < participantListCount; i++) {
			participantNameList += participantList[i].userName;
			participantNameList += "(" + participantList[i].userDeptname + "), ";
	 }
	 
	 participantNameList = participantNameList.substr(0, participantNameList.length - 2);
	 
	 $("#participants").html(participantNameList);
 }
 
function setUpperGroup() {
	$("#upperGroup").html(groupName);
}

function addGroup() {
	 var newGroupName = document.getElementById("groupName").value.trim();
	 overview = revertString(document.getElementById("overview").value.trim());
	 var project = parent.opener.projectDetails;
	 var planStartDate = project.planStartDate;
	 var planEndDate = project.planEndDate;
	 //sort Order setting
	 var sortOrder = parent.opener.$(".group").length + 1;
	 
	 //업무 이름 길이 제한
	 if (newGroupName.length == 0) {
		 alert("<spring:message code='ezPMS.t83' />");
		 return;
	 } else if (newGroupName.length > 100) {
		 alert("<spring:message code='ezPMS.t84' />");
		 return;
	 }
	 
	// 담당자 검사
	if(managerList.length < 1) {
		// 1명 이상의 담당자가 등록되어야 함
		alert("<spring:message code='ezPMS.t169' />");
		return;
	}
	
	//상위그룹 미지정
	if(groupId == "") {
		alert("<spring:message code='ezPMS.t85' />");
		return;
	}
	
	var data = {
		groupName : newGroupName,
		projectId : projectId,
		upperGroupId : groupId,
		overview	 : overview,
		headManagerId : headManagerId,
		managerList : managerList,
		planStartDate : planStartDate,
		planEndDate : planEndDate,
		// 상위그룹의 treeDepth에 +1
		treeDepth : treeDepth + 1,
		//sortOrder
		sortOrder : sortOrder,
		participantList : participantList
	}
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/addGroup.do",
		dataType : "json",
		contentType: "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(data) {
			
			var upperGroupName = $("#upperGroup").text();
			var logContent = "<spring:message code='ezPMS.t316' arguments='" + upperGroupName + "," + newGroupName + "'/>";
			addTaskLog(projectId, 1, groupId, null, logContent);

			alert("<spring:message code='ezPMS.t86' />");
			parent.opener.location.reload();
			popupClose();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("<spring:message code='ezPMS.t224' />");
		}
	});
}

</script>
</head>
<body class="popup">
	<h1 style="display:inline-block; width:100px;"><spring:message code='ezPMS.t82' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="popupClose()"></span>
			</li>
		</ul>
		</div>
	</h1>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th><spring:message code='ezPMS.t87' /></th>
				<td colspan="3">
					<input type="text" id="groupName" class="textInput" placeholder="" value="" maxlength="100">
				</td>
			</tr>
			<tr>
				<th><span><spring:message code='ezPMS.t57' /></span></th>
				<td title="${userId}"><c:out value='${userName}'/></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openGroupTree()"><span><spring:message code='ezPMS.t42' /></span></a></th>
				<td style="height:30px;" id="upperGroup"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openMemberList('managers')"><span><spring:message code='ezPMS.t63' /></span></a></th>
				<td class="nameList" colspan="3" style="height:70px"><div style="overflow-y:auto; max-height:100%; width:100%" id="managers"></div></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openMemberList('participants')"><span><spring:message code='ezPMS.t64' /></span></a></th>
				<td class="nameList" colspan="3" style="height:70px"><div style="overflow-y:auto; max-height:100%; width:100%" id="participants"></div></td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t88' /></th>
				<td>
					<textarea id="overview"></textarea>
				</td>
			</tr>
		</table>
		<table style="width:100%;">
			<tr>
				<td><div class="btnpositionNew"><a class="imgbtn" id="submit" onclick="addGroup()"><span><spring:message code='ezPMS.t265' /></span></a></div></td>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>