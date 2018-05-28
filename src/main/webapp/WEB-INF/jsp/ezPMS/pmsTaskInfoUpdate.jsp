<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>업무정보수정</title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<!-- date picker -->
<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>

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
    height: 100px;
    width: 97.8%;
    resize: none;
    margin: 3px 1px 0px 1px;
    resize: none;
}

</style>
<script>
var projectId = "${taskDetails.projectId}";
var projectName = "";
var weight = null;
var managerList = null;
var overview = null;
var headManagerId = "";
var groupId = "";
var groupName = "";
var taskDetails = {};
var writerId= "";

 $(function() {
	 taskDetails = ${taskDetails};
 });
 
function openMemberList() {
		 var win;
		 var feature = GetOpenPosition(760, 700);
		 DivPopUpShow(684, 384, "/ezPMS/goProjectMemberList.do?projectId=" + projectId, "",
				 "height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}

function openGroupTree() {
		var win;
	 	var feature = GetOpenPosition(760, 700);
	 	DivPopUpShow(338, 338, "/ezPMS/goGroupTree.do?projectId=" + projectId, "",
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

function updateTaskInfo() {
	 taskName = document.getElementById("taskName").value.trim();
	 weight = document.getElementById("weight").value.trim();
	 overview = convertString(document.getElementById("overview").value.trim());
	 var weightInput = 1; // 수정해야함.
	 var remainingWeight = ${weightData.remainingWeight};
	 
	 //업무 이름 길이 제한
	 if (taskName.length == 0) {
		 alert("업무명을 입력해주세요.");
		 return;
	 } else if (taskName.length > 100) {
		 alert("업무명은 100자를 초과할 수 없습니다.");
		 return;
	 }
	 
	// 담당자 검사
	if(managerList == null) {
		// 현재 총괄담당자 null 허용 불가
		alert("최소 1명 이상의 담당자를 지정해주세요.");
		return;
	}
	
	//상위그룹 미지정
	if(groupId == "") {
		alert("상위그룹을 지정해주세요.");
		return;
	}
	
	// 가중치 검사
	if(weightInput == 1) {
		if(weight == ""){
			alert("가중치를 입력해 주십시오.");
			return;
		}
		if(isNaN(weight)) {
			alert("가중치는 숫자만 입력 가능합니다.");
			return;
		}
		if(Number(weight) > remainingWeight) {
			alert("가중치는 프로젝트의 잔여가중치를 초과할 수 없습니다.");
			return;
		}
	} else {
		weight = -1;
	}

	
	data = {
			taskName : taskName,
			projectId : projectId,
			groupId : groupId,
			overview	 : overview,
			headManagerId : headManagerId,
			managerList : managerList,
			weight : weight,
			writerId : writerId
	}
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/updateTaskInfo.do",
		dataType : "json",
		contentType: "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(data) {
			alert("<spring:message code='ezTask.t150' />");
			
			parent.location.reload();
			popupClose();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert("error2");
		}
	});
}

</script>
</head>
<body class="popup">
	<h1 style="display:inline-block; width:100px;">업무정보수정</h1>
	<div class="headerDiv">
		<a class="imgbtn" id="submit" onclick="updateTaskInfo()"><span>저장</span></a>
		<a class="imgbtn" id="cancel" onclick="popupClose()"><span>취소</span></a>
	</div>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<tr>
				<th>업무명</th>
				<td colspan="3">
					<input type="text" id="taskName" class="textInput" placeholder="${taskDetails.taskName}" value="${taskDetails.taskName}" maxlength="100">
				</td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openMemberList()"><span>담당자</span></a></th>
				<td id="managers">${taskDetails.headManagerName}(${taskDetails.headManagerDeptname})</td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openGroupTree()"><span>상위그룹</span></a></th>
				<td style="height:30px;" id="upperGroup">${taskDetails.ancesterGroup == null ? "-" : taskDetails.ancesterGroup}</td>
			</tr>
			<tr>
				<th><a class="imgbtn" onclick="openPreTaskTree()"><span>선행작업</span></a></th>
				<td>${taskDetails.preTask == null ? "-" : taskDetails.preTask}</td>
			</tr>
			<tr>
				<th>가중치</th>
				<td><input type="text" id="weight" class="textInput" placeholder="${taskDetails.weight}" value="${taskDetails.weight}"></td>
<%-- 				<td style="height:30px" id="weight">${taskDetails.weight == null ? "-" : taskDetails.weight}</td> --%>
			</tr>
			<tr>
				<th>업무개요</th>
				<td>
					<textarea id="overview">${taskDetails.overview == null ? "-" : taskDetails.overview}</textarea>
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