<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><c:out value="${project.projectName }"/></title>
	<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
</head>
<script>
	var mode = 'edit';
	var projectId = '${project.projectId}';
	var projectName = '${project.projectName}';
	var weightInput = "${project.weightInput}";
	var planStartDate = "${project.planStartDate}";
	var planEndDate = "${project.planEndDate}";
	var overview = "${project.overview}";
	var endAlamStatus = "${project.alamMailStatus}"
	var headManagerId = '${project.headManagerId}';
	var headManagerName = '${project.headManagerName}';
	var headManagerDept = "${project.headManagerDeptname}";
	var groupId = '${project.groupId}';
	
	var nowStatus = '${project.status}';
	var status = '${project.status}';
	
	var memberList = JSON.parse('${project.projectMember}');
	
	var managerList = null;
	var participantList = null;
	var viewerList = null;
	//비교하여 새로 추가된 사용자에게 메일 보냄
	var beforeHeadManagerId = "${project.headManagerId}";
	var beforeManagerList = [];
	var beforeParticipantList = [];
	var beforeViewerList = [];
	var headManagerObj = {};
	
	
	$(function() {
		managerList = [];
		participantList = [];
		viewerList = [];	
		
		for(i in memberList) {
			var member = memberList[i];
			var level = member.memberRoleId;
			
			switch (level) {
			case 1:
				// managerList에 관리자를 제외하고 집어넣는다
				if(member.userId != headManagerId) {
					managerList.push(member);
					beforeManagerList.push(member);
				}
				break;
			case 2:
				participantList.push(member);
				beforeParticipantList.push(member);
				break;	
			case 3:
				viewerList.push(member);
				beforeViewerList.push(member);
				break;
			}
		}
		
		applyHeadManager();
		applyList();
		
		$("#status").val(nowStatus);
	})
	
	function applyHeadManager(){
		var headManagerStr = headManagerObj.userName + "(" + headManagerObj.userDept + ")";
		
		if(!headManagerObj.userName){
			headManagerStr = headManagerName + "(" + headManagerDept + ")";
		}
	 
		$("#headManager").html(headManagerStr);
 	}
	
	function applyList() {
		 var managerNameList = "";
		 var participantNameList = "";
		 var viewerNameList = "";
		 
		 // 조직도에서는 stringify해서 넘어옴
		 if(typeof managerList != 'object' && typeof participantList != 'object' && typeof viewerList != 'object') {
			 managerList = JSON.parse(managerList);
			 participantList = JSON.parse(participantList);
			 viewerList = JSON.parse(viewerList);
		 }
		 
		 for (var i = 0; i < managerList.length; i++) {	
			if (managerList[i].userId !== headManagerId) {
				managerNameList += managerList[i].userName;
				managerNameList += "(" + managerList[i].userDeptname + "), ";
			}
		 }
		 
		 for (var i = 0; i < participantList.length; i++) {
			participantNameList += participantList[i].userName;
			participantNameList += "(" + participantList[i].userDeptname + "), ";
		}
		 
		 for (var i = 0; i < viewerList.length; i++) {
			viewerNameList += viewerList[i].userName;
			viewerNameList += "(" + viewerList[i].userDeptname + "), ";
		}
		 
		 managerNameList = managerNameList.substr(0, managerNameList.length - 2);
		 participantNameList = participantNameList.substr(0, participantNameList.length - 2);
		 viewerNameList = viewerNameList.substr(0, viewerNameList.length - 2);
		 
		 $("#managers").html(managerNameList);
		 $("#participants").html(participantNameList);
		 $("#viewers").html(viewerNameList);
	}
	
	
	function deletePermanently() {
		
		if(confirm("<spring:message code='ezPMS.t22' />") == true) {
			
			data = {
				projectId : projectId,
				status : "D"
			}
			
			$.ajax({
				type : "POST",
				dataType: "text",
				contentType: "application/json; charset=UTF-8",
				url : "/admin/ezPMS/deleteProject.do",
				data :JSON.stringify(data),
				success : function(result) {
					if (result == "permitted") {
						window.close();
						opener.getProjectList();
					} else {
						alert("<spring:message code='ezPMS.t54' />");
						return;
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("<spring:message code='ezPMS.t54' />");
				}
			});
		}	
	}
	
	 function openOrganTree(type) {
		 var url = "/ezPMS/pmsSelectAuth.do?type=" + type.id;
		 //	url += "?companyId=" + companyId;
		 var width = type.id === "headManager" ? 700 : 980;
		 GetOpenWindow(url, "pmsSelectAuth", width, 630);
	 }
	
	function saveProject() {
		
		var data = {
			mode : mode,
			projectId : projectId,
			projectName : projectName,
			weightInput : weightInput,
			planStartDate : planStartDate,
			planEndDate : planEndDate,
			overview	 : overview,
			endAlamStatus : endAlamStatus,
			groupId : groupId,
			// 담당자
			headManagerId : headManagerId,
			managerList : managerList,
			participantList : participantList,
			viewerList : viewerList,
			// 진행 상태
			status : status,
			nowStatus : nowStatus
		}
		
		console.log(overview);
		
		var response;
		
		if (status == "C" && nowStatus != "C") {
			response = confirm("<spring:message code='ezPMS.t159' />");
		} else {
			response = true;
		}
		
		managerList.push({"userName" : headManagerName, "userId" : headManagerId, "memberRoleId" : 1, "userDeptname" : replaceString(headManagerDept), "userIdType" : "user"});
		
		if(response == true) {
			$.ajax({
				type : "POST",
				url : "/admin/ezPMS/modifyProject.do",
				dataType : "json",
				contentType: "application/json; charset=UTF-8",
				data :JSON.stringify(data),
				success : function(result) {
					if(result.memberChange == 'success' && result.statusChange == 'success') {
						sendNotiMail(projectId, projectName);
						var logContent = "<spring:message code='ezPMS.t50' arguments='" + projectName + "'/>";
						addTaskLog(projectId, 2, groupId, null, logContent);
						alert ("<spring:message code='ezPMS.t52' />");
						window.close();
						opener.getProjectList();
					} else {
						alert("<spring:message code='ezPMS.t54' />");
					}		
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("<spring:message code='ezPMS.t54' />");
				}
			});
		}	
	}
	
	function setStatus(elem) {
		status = elem;
	}
	
	function sendNotiMail(projectId, projectName) {
		 var data = {
			 projectName : projectName,
			 headManagerId : headManagerId,
			 managerList : managerList,
			 participantList : participantList,
			 viewerList : viewerList,
			 projectId : projectId,
			 beforeHeadManagerId : beforeHeadManagerId,
			 beforeManagerList : beforeManagerList,
			 beforeParticipantList : beforeParticipantList,
			 beforeViewerList : beforeViewerList,
			 mode : mode
		 }
		 
		 $.ajax({
			 type : "post",
			 ansync : false,
			 dataType : "json",
			 contentType: "application/json; charset=UTF-8",
			 data : JSON.stringify(data),
			 url : "/ezPMS/sendNotiMail.do",
			 success : function() {
				 console.log("sending mail works");
			 }
		 });
	 }
</script>
<style>
	.content th {
		text-align: center;
		font-weight: bold;
	}
	
	.content td {
		padding: 5px;
	}
</style>
<body class="popup" style="height: 95%;">
	<table class="layout" style="width: 100%">
		<tr>
			<td style="height: 20px">
				<div id="menu">
					<ul>
						<li><span onclick="saveProject()"><spring:message code='ezPMS.t265' /></span></li>
						<li><span onclick="deletePermanently()"><spring:message code='ezPMS.t12' /></span></li>
					</ul>
				</div>
				<div id="close" style="float: right;">
					<ul>
						<li><span id="cancel" onclick="window.close()"></span></li>
					</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<table class="content" style="width:100%;">
					<tr>
						<th><spring:message code='ezPMS.t31' /></th>
						<td colspan="3"><c:out value="${project.projectName}"/></td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t61' /></th>
						<td style="width: 50%;"><c:out value="${project.planStartDate}"/></td>
						<th><spring:message code='ezPMS.t62' /></th>
						<td><c:out value="${project.planEndDate}"/></td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t57' /></th>
						<td colspan="3"><c:out value="${project.creatorName}(${project.creatorDeptname})"/></td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openOrganTree(headManager)"><span><spring:message code='ezPMS.t330' /></span></a></th>
						<td colspan="3" style="height: 58px;">
							<div style="overflow-y:auto; max-height:100%; width:100%" id="headManager"></div>
						</td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openOrganTree(managers)"><span><spring:message code='ezPMS.t63' /></span></a></th>
						<td colspan="3" style="height: 58px;">
							<div style="overflow-y:auto; max-height:100%; width:100%" id="managers"></div>
						</td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openOrganTree(participants)"><span><spring:message code='ezPMS.t64' /></span></a></th>
						<td colspan="3" style="height: 58px;">
							<div style="overflow-y:auto; max-height:100%; width:100%" id="participants"></div>
						</td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openOrganTree(viewers)"><span><spring:message code='ezPMS.t65' /></span></a></th>
						<td colspan="3" style="height: 58px;">
							<div style="overflow-y:auto; max-height:100%; width:100%" id="viewers"></div>
						</td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t66' /></th>
						<td colspan="3" style="height: 58px;">
							<div style="overflow-y:auto; max-height:100%; width:100%">
								<c:out value="${project.overview}"/>
							</div>
						</td>
					</tr>
					<tr>
						<th><spring:message code='ezPMS.t38' /></th>
						<td colspan="3">
							<select id="status" onchange="setStatus(this.value)">
								<c:choose>
									<c:when test="${project.status eq 'P'}">
										<option value="P"><spring:message code='ezPMS.t15' /></option>
										<option value="C"><spring:message code='ezPMS.t17' /></option>
										<option value="S"><spring:message code='ezPMS.t19' /></option>
									</c:when>
									<c:when test="${project.status eq 'W'}">
										<option value="P"><spring:message code='ezPMS.t15' /></option>
										<option value="W"><spring:message code='ezPMS.t16' /></option>
										<option value="S"><spring:message code='ezPMS.t19' /></option>
									</c:when>
									<c:when test="${project.status eq 'C'}">
										<option value="C"><spring:message code='ezPMS.t17' /></option>
									</c:when>
									<c:when test="${project.status eq 'L'}">
										<option value="C"><spring:message code='ezPMS.t17' /></option>
										<option value="L"><spring:message code='ezPMS.t18' /></option>
										<option value="S"><spring:message code='ezPMS.t19' /></option>
									</c:when>
									<c:when test="${project.status eq 'S'}">
										<option value="P"><spring:message code='ezPMS.t15' /></option>
										<option value="C"><spring:message code='ezPMS.t17' /></option>
										<option value="S"><spring:message code='ezPMS.t19' /></option>
									</c:when>
									<c:when test="${project.status eq 'D'}">
										<option value="P"><spring:message code='ezPMS.t15' /></option>
										<option value="S"><spring:message code='ezPMS.t19' /></option>
										<option value="D"><spring:message code='ezPMS.t11' /></option>
									</c:when>
								</c:choose>
							</select>
							&nbsp;<fmt:formatNumber value="${project.progress}" pattern="0.0"/>%
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>	
</body>
</html>