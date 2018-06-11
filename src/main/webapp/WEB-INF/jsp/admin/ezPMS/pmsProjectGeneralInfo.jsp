<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>프로젝트 개요</title>
	<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
	<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
	<script type="text/javascript" src="/js/ezPMS/common.js"></script>
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
	var groupId = '${project.groupId}';
	
	var nowStatus = '${project.status}';
	var status = '${project.status}';
	
	var memberList = JSON.parse('${project.projectMember}');
	
	var managerList = null;
	var participantList = null;
	var viewerList = null;
	//비교하여 새로 추가된 사용자에게 메일 보냄
	var beforeManagerList = [];
	var beforeParticipantList = [];
	var beforeViewerList = [];
	
	$(function() {
		
		managerList = [];
		participantList = [];
		viewerList = [];	
		
		for(i in memberList) {
			var member = memberList[i];
			var level = member.memberRoleId;
			
			switch (level) {
			case 1:
				managerList.push(member);
				beforeManagerList.push(member);
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
		
		applyList();
		
		$("#status").val(nowStatus);
	})
	
	function applyList() {
		 var managerNameList = "";
		 var participantNameList = "";
		 var viewerNameList = "";
		 
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
		
		if(confirm("삭제하시겠습니까?") == true) {
			
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
						alert("error");
						return;
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("error");
				}
			});
		}	
	}
	
	function openOrganTree(type) {
		var url = "/ezPMS/pmsSelectAuth.do?type=" + type.id;
		//	url += "?companyId=" + companyId;
		GetOpenWindow(url, "pmsSelectAuth", 980, 610);
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
			headManagerId : headManagerId,
			managerList : managerList,
			participantList : participantList,
			viewerList : viewerList,
			groupId : groupId,
			
			status : status,
			nowStatus : nowStatus
		}
		
		$.ajax({
			type : "POST",
			url : "/admin/ezPMS/modifyProject.do",
			dataType : "json",
			contentType: "application/json; charset=UTF-8",
			data :JSON.stringify(data),
			success : function(result) {
				if(result.memberChange == 'success' && result.statusChange == 'success') {
					sendNotiMail(projectId, projectName);
					var logContent = "[" + projectName + "]의 정보가 수정되었습니다."
					addTaskLog(projectId, 2, groupId, null, logContent);
					alert ("프로젝트가 수정되었습니다.");
					window.close();
					opener.getProjectList();
				} else {
					alert("error");
				}		
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("error");
			}
		});
	}
	
	function setStatus(elem) {
		status = elem;
	}
	
	function sendNotiMail(projectId, projectName) {
		 var data = {
			 projectName : projectName,
			 managerList : managerList,
			 participantList : participantList,
			 viewerList : viewerList,
			 projectId : projectId,
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
<body class="popup" style="height: 99%;">
	<table class="layout" style="width: 100%">
		<tr>
			<td style="height: 20px">
				<div id="menu">
					<ul>
						<li><span onclick="saveProject()">저장</span></li>
						<li><span onclick="deletePermanently()">영구 삭제</span></li>
						<li style="float: right;"><span onclick="window.close()">닫기</span></li>
					</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<table class="content" style="width:100%;">
					<tr>
						<th>프로젝트명</th>
						<td colspan="3"><c:out value="${project.projectName}"/></td>
					</tr>
					<tr>
						<th>시작일</th>
						<td style="width: 50%;"><c:out value="${project.planStartDate}"/></td>
						<th>종료일</th>
						<td><c:out value="${project.planEndDate}"/></td>
					</tr>
					<tr>
						<th>작성자</th>
						<td colspan="3"><c:out value="${project.creatorName}(${project.creatorDeptname})"/></td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openOrganTree(managers)"><span>담당자</span></a></th>
						<td colspan="3">
							<div style="overflow-y:auto; height:100%; width:100%" id="managers"></div>
						</td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openOrganTree(participants)"><span>참여자</span></a></th>
						<td colspan="3">
							<div style="overflow-y:auto; height:100%; width:100%" id="participants"></div>
						</td>
					</tr>
					<tr>
						<th><a class="imgbtn" onclick="openOrganTree(viewers)"><span>조회자</span></a></th>
						<td colspan="3">
							<div style="overflow-y:auto; height:100%; width:100%" id="viewers"></div>
						</td>
					</tr>
					<tr>
						<th>프로젝트 개요</th>
						<td colspan="3"><c:out value="${project.overview}"/></td>
					</tr>
					<tr>
						<th>진행상태</th>
						<td colspan="3">
							<select id="status" onchange="setStatus(this.value)">
								<c:choose>
									<c:when test="${project.status eq 'P'}">
										<option value="P">진행</option>
										<option value="C">완료</option>
										<option value="S">보류</option>
									</c:when>
									<c:when test="${project.status eq 'W'}">
										<option value="P">진행</option>
										<option value="W">대기</option>
										<option value="S">보류</option>
									</c:when>
									<c:when test="${project.status eq 'C'}">
										<option value="C">완료</option>
									</c:when>
									<c:when test="${project.status eq 'L'}">
										<option value="C">완료</option>
										<option value="L">지연</option>
										<option value="S">보류</option>
									</c:when>
									<c:when test="${project.status eq 'S'}">
										<option value="P">진행</option>
										<option value="C">완료</option>
										<option value="S">보류</option>
									</c:when>
									<c:when test="${project.status eq 'D'}">
										<option value="P">진행</option>
										<option value="S">보류</option>
										<option value="D">삭제</option>
									</c:when>
								</c:choose>
							</select>
							&nbsp;<c:out value="${project.progress}%"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
</body>
</html>