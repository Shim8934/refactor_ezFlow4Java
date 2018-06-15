<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t82' /></title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>

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
    width: 545px;
    resize: none;
    margin: 3px 1px 0px 1px;
    resize: none;
}

</style>
<script>
var projectId = parent.projectId;
var projectName = "";
var weight = null;
var managerList = null;
var overview = null;
var headManagerId = "";
var groupId = "";
var groupName = "";
var taskDetails = {};
var writerId= "";
var treeDepth = 0;

 $(function() {
// 	 taskDetails = ${taskDetails};
// 	 managerList = ${taskDetails.taskMember};
// 	 headManagerId = "${taskDetails.headManagerId}";
 });
 
function openMemberList() {
		 var win;
		 var feature = GetOpenPosition(760, 700);
		 DivPopUpShow(600, 380, "/ezPMS/goProjectMemberList.do?projectId=" + projectId, "",
				 "height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}

function openGroupTree() {
		var win;
	 	var feature = GetOpenPosition(760, 700);
	 	DivPopUpShow(338, 384, "/ezPMS/goGroupTree.do?projectId=" + projectId, "",
			 	"height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}

function openPreTaskTree() {
	alert("아직 미구현.");
}

 function popupClose() {
	parent.DivPopUpHidden();
 }
 
 function applyList() {
	 var managerNameList = "";
	 
	 for (var i = 0; i < managerList.length; i++) {
		if(headManagerId == managerList[i].userId) {
			managerNameList += "<b>"
			managerNameList += managerList[i].userName;
			managerNameList += "(" + managerList[i].userDeptname + ")</b>, ";
		} else {
			managerNameList += managerList[i].userName;
			managerNameList += "(" + managerList[i].userDeptname + "), ";
		}
		
	 }
	 
	 managerNameList = managerNameList.substr(0, managerNameList.length - 2);
	 
	 $("#managers").html(managerNameList);
 }
 
function setUpperGroup() {
	$("#upperGroup").html(groupName);
}

function addGroup() {
	 var newGroupName = document.getElementById("groupName").value.trim();
	 overview = convertString(document.getElementById("overview").value.trim());
	 var project = parent.projectDetails;
	 var planStartDate = project.planStartDate;
	 var planEndDate = project.planEndDate;
	 
	 
	 //업무 이름 길이 제한
	 if (newGroupName.length == 0) {
		 alert("<spring:message code='ezPMS.t83' />");
		 return;
	 } else if (newGroupName.length > 100) {
		 alert("<spring:message code='ezPMS.t84' />");
		 return;
	 }
	 
	// 담당자 검사
	if(managerList == null) {
		// 현재 총괄담당자 null 허용 불가
		alert("<spring:message code='ezPMS.t47' />");
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
			treeDepth : treeDepth
	}
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/addGroup.do",
		dataType : "json",
		contentType: "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(data) {
			alert("<spring:message code='ezPMS.t86' />");
			
			parent.location.reload();
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
	<h1 style="display:inline-block; width:100px;"><spring:message code='ezPMS.t82' /></h1>
	<div class="headerDiv">
		<a class="imgbtn" id="submit" onclick="addGroup()"><span><spring:message code='ezPMS.t265' /></span></a>
		<a class="imgbtn" id="cancel" onclick="popupClose()"><span><spring:message code='ezPMS.t41' /></span></a>
	</div>
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
				<td title="${userId}">${userName}</td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openGroupTree()"><span><spring:message code='ezPMS.t42' /></span></a></th>
				<td style="height:30px;" id="upperGroup"></td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openMemberList()"><span><spring:message code='ezPMS.t63' /></span></a></th>
				<td id="managers"></td>
			</tr>
			<tr>
				<th><spring:message code='ezPMS.t88' /></th>
				<td>
					<textarea id="overview"></textarea>
				</td>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>