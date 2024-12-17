<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t179' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>

<style type="text/css">
	.textInput {
		width : 100%;
	}
	.textInput[readonly] {
		cursor : default;
	}
	
	.headerDiv {
	    width: 150px;
	    float: right;
	    text-align: center;
	    margin-top: 7px;
	}
	
	th a.imgbtn {
		width: 63px;
		text-align: center;
	}
	
	#overview {
	    height: 156px;
	    width: 97.8%;
	    resize: none;
	    margin: 3px 1px 0px 1px;
	    resize: none;
	}
	
	.tooltip {
	    position: relative;
	    display: inline-block;
	}
	
	.tooltip .tooltiptext {
	    visibility: hidden;
	    width: 120px;
	    background-color: #555;
	    color: #fff;
	    text-align: center;
	    border-radius: 6px;
	    padding: 5px 0;
	    position: absolute;
	    z-index: 1;
	    bottom: 125%;
	    left: 50%;
	    margin-left: -60px;
	    opacity: 0;
	    transition: opacity 0.3s;
	}
	
	.tooltip .tooltiptext::after {
	    content: "";
	    position: absolute;
	    top: 100%;
	    left: 50%;
	    margin-left: -5px;
	    border-width: 5px;
	    border-style: solid;
	    border-color: #555 transparent transparent transparent;
	}
	
	.tooltip:hover .tooltiptext {
	    visibility: visible;
	    opacity: 1;
	}
	
	#managers, #participants{overflow-y: auto; height:70px;}
</style>
<script>
var projectId = "<c:out value='${taskDetails.projectId}'/>";
var projectName = "";
var weight = null;
var managerList = [];
var overview = null;
var headManagerId = "";
var originGroupId = 0;
var groupName = "<c:out value='${taskDetails.groupName}'/>";
var taskDetails = "";
var writerId= "";
var weightData = '${weightData}';
var target = "<c:out value='${target}'/>";
var headManagerName = "<c:out value='${taskDetails.headManagerName}'/>";
var groupId = 0;
var pretaskId = "";
var realProgress = "<c:out value='${taskDetails.realProgress}'/>";
var workingday = "<c:out value='${taskDetails.realWorkingday ne null ? taskDetails.realWorkingday : taskDetails.workingday}'/>";
var pretaskSetType = "";
var participantList = [];
var groupTaskMember = null;
var taskId = "${taskDetails.taskId}";
var initMemberList = [];
var treeDepth = "<c:out value='${taskDetails.upperTreeDepth}'/>"
var prevWeight = 0;
var userRoleId = parent.userRoleId;

 $(function() {
	 taskDetails = ${taskDetails};
	 $("#taskName").val(replaceString(revertString(taskDetails.taskName || taskDetails.groupName)));
	 $("#overview").val(replaceTextAreaString(taskDetails.overview));
	 
	 if (target == "task") {
		 initMemberList = '${taskDetails.taskMember}';
		 groupId = "<c:out value='${taskDetails.groupId}'/>";
		 originGroupId = "<c:out value='${taskDetails.groupId}'/>";
		 prevWeight = taskDetails.weight;
	 } else {
		 initMemberList = '${taskDetails.groupMember}';
		 groupId = "<c:out value='${taskDetails.upperGroupId}'/>";
		 originGroupId = "<c:out value='${taskDetails.groupId}'/>";
		 groupTaskMember = '${groupTaskMember}';
	 }
	 
	 headManagerId = "<c:out value='${taskDetails.headManagerId}'/>";
	 
	 initMemberList = JSON.parse(initMemberList);
	 var initMemberListCount = initMemberList.length;
	 
	 for (var i = 0; i < initMemberListCount; i++) {
		 var initMember = initMemberList[i];
		 
		 if (initMember.memberRoleId == 2) {
			 participantList.push(initMember);
		 } else {
			 managerList.push(initMember);
		 }
	 }
	 
	 if(groupTaskMember){
		 groupTaskMember = JSON.parse(groupTaskMember);
	 }
	 
	 applyList();
	 applyParticipantList();
	 initpretaskNames();
	 
	 if(weightData){
		 if(JSON.parse(weightData).weightInput === 0){
			 document.getElementById("weight").readOnly = true;
		 }
	 }
	 
	 document.getElementById("taskName").focus();
 });
 
function initpretaskNames() {
	var pretaskNames = $("#pretaskNames", parent.document.getElementById("FBoard_ifrm").contentDocument).html();
		
	$("#pretaskNames").html(pretaskNames);
}

function openMemberList(type) {
	var win;
	
	var feature = GetOpenPosition(760, 700);
	
	// 상위그룹으로 최상위 그룹인 프로젝트 자체를 선택했을 때는 groupId를 넘기지 않는다
	if(treeDepth == '0') {
		DivPopUpShow(608, 420, "/ezPMS/goProjectMemberList.do?projectId=" + projectId + "&type=" + type, "",
				"height = 420px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
	} else {
		DivPopUpShow(608, 420, "/ezPMS/goProjectMemberList.do?projectId=" + projectId + "&groupId=" + groupId + "&type=" + type, "",
				"height = 420px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
	}
}

function openGroupTree() {
	var win;
	var feature = GetOpenPosition(760, 700);
	DivPopUpShow(338, 338, "/ezPMS/goGroupTree.do?projectId=" + projectId, "",
			 	"height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}

function openPreTaskTree() {
	var feature = GetOpenPosition(760, 700);
	DivPopUpShow(338, 338, "/ezPMS/goPreTaskSelectionTree.do?projectId=" + projectId + "&onlyGroup=false", "",
		 	"height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
}

 function popupClose() {
	parent.DivPopUpHidden();
 }
 
 function applyList() {
	 var managerNameList = "";
	 var managerListCount = managerList.length;
	 
	 for (var i = 0; i < managerListCount; i++) {
		var manager = managerList[i];
		
		managerNameList += manager.userName;
		managerNameList += "(" + manager.userDeptname + "), ";
	 }
	 
	 managerNameList = managerNameList.substr(0, managerNameList.length - 2);
	 
	 $("#managers").html(managerNameList);
 }
 
 //참여자를 추가하기
 function applyParticipantList() {
	 var participantNameList = "";
	 var participantListCount = participantList.length;
	 
	 for (var i = 0; i < participantListCount; i++) {
		var participant = participantList[i];
		
		participantNameList += participant.userName;
		participantNameList += "(" + participant.userDeptname + "), ";
	 }
	 
	 participantNameList = participantNameList.substr(0, participantNameList.length - 2);
	 
	 $("#participants").html(participantNameList);
 }
 
function setUpperGroup() {
	$("#upperGroup").html(groupName);
}

function updateTaskInfo() {
	 taskName = document.getElementById("taskName").value.trim();
	 //담당자가 아닌경우 변경 불가능
	 if (userRoleId != 1) {
		alert("<spring:message code='ezPMS.t322'/>");
		return;
	 }
	 
	// 담당자 검사
	if (managerList.length < 1) {
		// 1명 이상의 담당자가 등록되어야 함
		alert("<spring:message code='ezPMS.t169' />");
		return;
	}
	
	//상위그룹 미지정
	if (groupId == "") {
		alert("<spring:message code='ezPMS.t85' />");
		return;
	}
	
	if (target == "task") {		
		 weight = document.getElementById("weight").value.trim();
		 overview = revertString(document.getElementById("overview").value.trim());
		 
		 var weightInput = 1; // 수정해야함.
		 var remainingWeight = '${weightData.remainingWeight}';
		 var projectStartDate = "${taskDetails.planStartDate}";
		 var projectEndDate = "${projectEndDate}";
		 var planStartDate = "${taskDetails.planStartDate}";
		 var planEndDate = "${taskDetails.planEndDate}";
		 var writeDate = "${taskDetails.writeDate}";
		 
		 remainingWeight = (Number(remainingWeight) + prevWeight).toFixed(1);

		//업무 이름 길이 제한
		 if (taskName.length == 0) {
			 alert("<spring:message code='ezPMS.t90' />");
			 return;
		 } else if (taskName.length > 100) {
			 alert("<spring:message code='ezPMS.t91' />");
			 return;
		 }
		
		// 가중치 검사
		if (weightInput == 1) {
			if(weight == ""){
				alert("<spring:message code='ezPMS.t96' />");
				return;
			}
			
			if(isNaN(weight)) {
				alert("<spring:message code='ezPMS.t248' />");
				return;
			}
			
			if(Number(weight) > remainingWeight) {
				alert("<spring:message code='ezPMS.t97' />");
				return;
			}
			
			if(weight < 0){
				alert("<spring:message code='ezPMS.t310' />");
				return;
			}
		} else {
			weight = -1;
		}
		
		// 선행작업 지정 타입을 판단
		if(pretaskId != "") {
			
			if(pretaskId.indexOf("t") != -1) {
				pretaskId = pretaskId.substring(pretaskId.indexOf("t") + 1);
				pretaskSetType = "task2task";
			} else {
				pretaskSetType = "group2task";
			}
		}
		
		
		var data = {
				taskName : taskName,
				taskId : taskId,
				projectId : projectId,
				groupId : groupId,
				originGroupId : originGroupId,
				overview	 : overview,
				headManagerId : headManagerId,
				managerList : managerList,
				planStartDate : planStartDate,
				planEndDate : planEndDate,
				realProgress : realProgress,
				workingday : workingday,
				writeDate : writeDate,
				weight : weight,
				pretaskId : pretaskId,
				type : pretaskSetType,
				// 상위그룹의 treeDepth + 1
				treeDepth : treeDepth + 1
		}
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/updateTaskInfo.do",
			dataType : "text",
			contentType: "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(data) {
				if (data == "permitted") {
					alert("<spring:message code='ezPMS.t170' />");
					
					var logContent = "<spring:message code='ezPMS.t318' arguments='" + taskName + "'/>";
					addTaskLog(projectId, 2, groupId, taskId, logContent);
					updateGroupRealStartEndDate(groupId);
					updateGroupRealStartEndDate(originGroupId);	
					parent.location.reload();
					parent.opener.location.reload();
				} else {
					alert("<spring:message code='ezPMS.t322'/>");
				}
				
				popupClose();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("<spring:message code='ezPMS.t208' />");
			}
		});
	} else if (target == "group") {
		 overview = revertString(document.getElementById("overview").value.trim());
		 
		//업무 이름 길이 제한
		 if (taskName.length == 0) {
			 alert("<spring:message code='ezPMS.t83' />");
			 return;
		 } else if (taskName.length > 100) {
			 alert("<spring:message code='ezPMS.t84' />");
			 return;
		 }
		
		//삭제 및 추가할 리스트를 받아옴.
		var canDel = checkDelGroupMember(managerList, participantList);
		
		if (!canDel) {
			alert("<spring:message code='ezPMS.t301' />");
			return;
		}
		
		// 선행작업 지정 타입을 판단
		if (pretaskId != "") {
			if (pretaskId.indexOf("t") != -1) {
				pretaskId = pretaskId.substring(pretaskId.indexOf("t") + 1);
				pretaskSetType = "task2group";
			} else {
				pretaskSetType = "group2group";
			}
		}
		
		var data = {
			groupName : taskName,
			projectId : projectId,
			groupId : parent.groupId,
			overview	 : overview,
			headManagerId : headManagerId,
			managerList : managerList,
			planStartDate : planStartDate,
			planEndDate : planEndDate,
			upperGroupId : groupId,
			participantList : participantList,
			pretaskId : pretaskId,
			type : pretaskSetType
		}
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/updateGroupInfo.do",
			dataType : "text",
			contentType: "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(data) {
				if (data == "permitted") {
					alert("<spring:message code='ezPMS.t170' />");
					
					var logContent = "<spring:message code='ezPMS.t319' arguments='" + taskName + "'/>";
					addTaskLog(projectId, 2, parent.groupId, null, logContent);
					
					parent.location.reload();
					parent.opener.location.reload();
				} else {
					alert("<spring:message code='ezPMS.t184'/>");
				}
				
				popupClose();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("<spring:message code='ezPMS.t208' />");
			}
		}); 
	}
	
	//소속 그룹과 소속 그룹의 상위까지 실제 시작일 및 종료일을 업데이트 한다.
	function updateGroupRealStartEndDate(groupId) {
		var data = {groupId : groupId};
		
		$.ajax({
			type : "PUT",
			url : "/ezPMS/updateGroupRealStartEndDate.do",
			dataType : "json",
			contentType: "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function() {}
		});
	}
	
	function checkDelGroupMember(managers, participants){
		//하위 업무들의 담당자가 있는지 확인
		var delMemberList = [];
		var newList = managers;
		var list = {};
		var flags = true;
		var canDel = true;
		
		if (participants != undefined) {
			newList = newList.concat(participants);
		}
		
		//삭제, 유지, 추가를 분류
		var groupTaskMemberCount = groupTaskMember.length;
		
		for(var i = 0; i < groupTaskMemberCount; i++){
			newList.forEach(function(member, idx){
				if(groupTaskMember[i].userId === member.userId){
					flags = false;
				}
			})
			if(flags){
				delMemberList.push(groupTaskMember[i]);
			}
		}
		
		if (delMemberList.length > 0) {
			canDel = false;
		}
		
		return canDel;
	}
}

function initPreTask() {
	$("#pretaskNames").text('-');
	pretaskId = "";
	pretaskSetType = "initPretask";
}

</script>
</head>
<body class="popup">
	<c:choose>
	<c:when test="${target eq 'task' }">
	<h1 style="display:inline-block; width:100px;"><spring:message code='ezPMS.t179' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="popupClose()"></span>
			</li>
		</ul>
		</div>
	</h1>
	</c:when>
	<c:otherwise>
	<h1 style="display:inline-block; width:100px;"><spring:message code='ezPMS.t279' />
		<div id="close" style="float:right">
		<ul>
			<li>
				<span id="cancel" onclick="popupClose()"></span>
			</li>
		</ul>
		</div>
	</h1>
	</c:otherwise>
	</c:choose>
	<div id="main_body">
		<table class="content" style="width:100%;">
			<c:choose>
				<c:when test="${target eq 'task' }">
					<tr>
						<th><spring:message code='ezPMS.t98' /></th>
						<td colspan="3">
							<input type="text" id="taskName" class="textInput" maxlength="100">
						</td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openGroupTree()"><span><spring:message code='ezPMS.t42' /></span></a></th>
						<td style="height:30px;" id="upperGroup"> 
						<c:out value="${taskDetails.groupName == null ? '-' : taskDetails.groupName}"/> 
						</td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openMemberList('managers')"><span><spring:message code='ezPMS.t63' /></span></a></th>
						<td><div id="managers"></div></td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t181' /></th>
						<td>
							<span id="pretaskNames" style="line-height: 30px;"></span>
							<a class="imgbtn" onclick="initPreTask()" style="float: right; margin-top: 4px;">
								<span><spring:message code='ezPMS.t295' /></span>
							</a>
						</td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t267' /></th>
						<td><input type="text" id="weight" class="textInput" placeholder="<fmt:formatNumber value="${taskDetails.weight}" pattern="0.0"/>" value="<fmt:formatNumber value="${taskDetails.weight}" pattern="0.0"/>"></td>
		<%-- 				<td style="height:30px" id="weight">${taskDetails.weight == null ? "-" : taskDetails.weight}</td> --%>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t104' /></th>
						<td>
							<textarea id="overview"></textarea>
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<th><spring:message code='ezPMS.t87' /></th>
						<td colspan="3">
							<input type="text" id="taskName" class="textInput" placeholder="${taskDetails.groupName}" value="${taskDetails.groupName}" maxlength="100">
						</td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openGroupTree()"><span><spring:message code='ezPMS.t42' /></span></a></th>
						<td style="height:30px;" id="upperGroup">
							<c:out value="${taskDetails.upperGroupName == null ? '-' : taskDetails.upperGroupName}"/>
						</td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openMemberList('managers')"><span><spring:message code='ezPMS.t63' /></span></a></th>
						<td class="memberTd" style="height:58px;"><div id="managers"></div></td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openMemberList('participants')"><span><spring:message code='ezPMS.t64' /></span></a></th>
						<td class="memberTd" style="height:58px;"><div id="participants"></div></td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t88' /></th>
						<td>
							<textarea id="overview"><c:out value="${taskDetails.overview == null ? '-' : taskDetails.overview}"/></textarea>
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</table>
		<table style="width:100%;">
			<tr>
				<td><div class="btnpositionNew"><a class="imgbtn" id="submit" onclick="updateTaskInfo()"><span><spring:message code='ezPMS.t265' /></span></a></div></td>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>