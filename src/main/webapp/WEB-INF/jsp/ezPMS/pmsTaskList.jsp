<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t155' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/previewmail.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>

<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 100;
var contentTitle = $(".jstree-clicked").text();
var position = "${position}";

$(function() {
	groupDetail = ${groupDetail};
	
	if (position == null || position == "") {	
		setContentTitle(MakeXMLString(groupDetail.groupName), "${taskListCount}");
	} else { 
		CurrentHeight = $(window).height() - 100;
		$("MailListRayer").css("height", CurrentHeight + "px");
		$("#taskTree").css("height", CurrentHeight + 10 + "px");
		$("#projectContent").css("height", CurrentHeight + "px");
		$("#contentList").css("height", (CurrentHeight - 100) + "px");
		$("#projectListBody").css("height", (CurrentHeight - 190) + "px");
		$("#divList").css("height", (CurrentHeight - 150) + "px");
		$("#divList").css("overflow", "auto");
		
		$("#totalCount").text("${taskListCount}");
	}
});

</script>
<style>
.groupNameTd{text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 250px;}
.taskNameTd{text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;}
.projectNameTd{text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 200px;}
.memberNameTd{text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 175px;}
.planStartDateTd{text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 100px;}
.planEndDateTd{text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 100px;}
.statusTd{text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 50px;}
.realProgressTd{text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 80px;}

.upperGroupNameTh{overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 250px;}
.groupNameTh{overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;}
.taskNameTh{overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;}
.projectNameTh{overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 200px;}
.memberNameTh{overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: default; width: 175px;}
.planStartDateTh{overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 100px;}
.planStartEndTh{overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 100px;}
.statusTh{text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 50px;}
.realProgressTh{text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 80px;}

input[name='boardCheckbox']{margin: 0px; padding: 0px; width: 13px; height: 13px; cursor: pointer;}
#HeaderAllCheckBox{margin: 0px; padding: 0px; width: 13px; height: 13px; vertical-align: middle;}
</style>
</head>
<body>
	<div style="width: 100%;" id="divList">
		<div id="lvBoardList">
			<table id="tableHeader" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" width="100%" border="0"
						class="mainlist" style="overflow:hidden">
				<thead id="BoardList_THEAD">
					<tr id="BoardList_TH">
						<th class="checkboxTh" id="BoardList_TH_0" style="text-align: center; overflow: hidden; white-space: nowrap; cursor: pointer; width:20px;"
							class="h4_center" bgcolor="#CCCCCC">
							<div class='custom_checkbox'><input type="checkbox" id="HeaderAllCheckBox" name="boardCheckbox" id="HeaderAllCheckBox" onchange="selectedAllTR(this);"></div>
						</th>
						<th id="BoardList_TH_1" onclick="setListOrder(this)" order="UPPER_GROUP_NAME" class="h5_center upperGroupNameTh"><spring:message code='ezPMS.t42' /></th>
						<c:choose>
							<c:when test="${position eq 'myGroup' }">
								<th id="BoardList_TH_2" onclick="setListOrder(this)" order="GROUP_NAME" class="h5_center groupNameTh"><spring:message code='ezPMS.t87' /></th>
							</c:when>
							<c:otherwise>
								<th id="BoardList_TH_2" onclick="setListOrder(this)" order="TASK_NAME" class="h5_center taskNameTh"><spring:message code='ezPMS.t98' /></th>
							</c:otherwise>
						</c:choose>
						<c:if test="${position eq 'myTask' || position eq 'myGroup'}">
							<th id="BoardList_TH_3" onclick="setListOrder(this)" order="PROJECT_NAME" class="h5_center projectNameTh"><spring:message code='ezPMS.t31' /></th>	
						</c:if>
						<th id="BoardList_TH_4" class="h5_center memberNameTh"><spring:message code='ezPMS.t63' /></th>
						<th id="BoardList_TH_5" onclick="setListOrder(this)" order="PLAN_START_DATE" class="h5_center planStartDateTh"><spring:message code='ezPMS.t61' /></th>
						<th id="BoardList_TH_6" onclick="setListOrder(this)" order="PLAN_END_DATE" class="h5_center planStartEndTh"><spring:message code='ezPMS.t62' /></th>
						<c:choose>
							<c:when test="${position ne 'myGroup' }">
								<th id="BoardList_TH_7" onclick="setListOrder(this)" order="STATUS" class="h5_center statusTh"><spring:message code='ezPMS.t38' /></th>
							</c:when>
						</c:choose>
						<th id="BoardList_TH_8" onclick="setListOrder(this)" order="REAL_PROGRESS" class="h5_center realProgressTh"><spring:message code='ezPMS.t250' /></th>
				</thead>
			</table>
		</div>
		<div id="projectListBody" multiselectable="false" useocs="false" style="overflow:auto; min-width: 469px; height: 456px;">
			<table id="tableBody" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="ItemPreviewRead_click" width="100%" border="0" class="mainlist" style="">
				<tbody style="background-color: rgb(255, 255, 255);">
					<c:choose>
						<c:when test="${empty taskList}">
							<tr>
								<td colspan="8" style="text-align : center"> <spring:message code='ezPMS.t30' /> </td>
							</tr>
						</c:when>
						<c:when test="${position ne 'myGroup' }">
							<c:forEach items="${taskList }" var="task">
						<tr style="cursor: pointer;" id="${task.taskId }" data-groupId="${task.groupId}" class="listRow" ondblclick="goTaskDetails(this)">
							<td style="width: 20px; cursor: default; text-align: center">
								<input type="checkbox" onchange="checkedCheckbox(this);" name="boardCheckbox">
							</td>
							<td class="groupNameTd" onclick="selectedTR(this);"><c:out value="${task.groupName }" /></td>
							<td class="taskNameTd" onclick="selectedTR(this);"><c:out value="${task.taskName }" /></td>
							<c:if test="${position eq 'myTask' }">
							<td class="projectNameTd" onclick="selectedTR(this);" projectId="${task.projectId }"><c:out value="${task.projectName }" /></td>
							</c:if>
							<td class="memberNameTd" onclick="selectedTR(this);">
								<div style="margin-right: 2px;"></div>
								<c:forEach items="${task.taskMember}" var="taskMember" varStatus="status">
									<c:out value="${status.count == task.taskMember.size() ? taskMember.userName : taskMember.userName.concat(',')}" />
								</c:forEach>
							</td>
							<td class="planStartDateTd" onclick="selectedTR(this);">
								<div style="margin-right: 2px;"></div>
								<c:out value="${task.planStartDate }" />
							</td>
							<td class="planEndDateTd" onclick="selectedTR(this);">
								<div style="margin-right: 2px;"></div>
								<c:out value="${task.planEndDate }" />
							</td>
							<td class="statusTd" onclick="selectedTR(this);">
								<div style="margin-right: 2px;"></div>
								<c:choose>
									<c:when test="${task.status eq 'P' }">
										<spring:message code='ezPMS.t15' />
									</c:when>
									<c:when test="${task.status eq 'W' }">
										<spring:message code='ezPMS.t16' />
									</c:when>
									<c:when test="${task.status eq 'L' }">
										<spring:message code='ezPMS.t18' />
									</c:when>
									<c:when test="${task.status eq 'S' }">
										<spring:message code='ezPMS.t19' />
									</c:when>
									<c:otherwise>
										<spring:message code='ezPMS.t17' />
									</c:otherwise>
								</c:choose>
							</td>
							<td class="realProgressTd" onclick="selectedTR(this);">
								<div style="margin-top: 5px; display: inline-block;">
									<fmt:formatNumber value="${task.realProgress }" pattern="0.0" />%
								</div>
							</td>
						</tr>
					</c:forEach>
						</c:when>
					<c:when test="${position eq 'myGroup' }">
						<c:forEach items="${taskList }" var="task">
						<tr style="cursor: pointer;" id="${task.groupId }" class="listRow" ondblclick="goGroupDetails(this)">
							<td style="width: 20px; cursor: default; text-align: center">
								<input type="checkbox" onchange="checkedCheckbox(this);" name="boardCheckbox">
							</td>
							<td class="groupNameTd" onclick="selectedTR(this);"><c:out value="${task.upperGroupName }" /></td>
							<td class="taskNameTd" onclick="selectedTR(this);"><c:out value="${task.groupName }" /></td>
							<td class="projectNameTd" onclick="selectedTR(this);" projectId="${task.projectId }"><c:out value="${task.projectName }" /></td>
							<td class="memberNameTd" onclick="selectedTR(this);">
								<div style="margin-right: 2px;"></div>
								<c:forEach items="${task.groupMember}" var="groupMember" varStatus="status">
									<c:out value="${status.count == task.groupMember.size() ? groupMember.userName : groupMember.userName.concat(',')}" />
								</c:forEach>
							</td>
							<td class="planStartDateTd" onclick="selectedTR(this);">
								<div style="margin-right: 2px;"></div>
								<c:out value="${task.planStartDate }" />
							</td>
							<td class="planEndDateTd" onclick="selectedTR(this);">
								<div style="margin-right: 2px;"></div>
								<c:out value="${task.planEndDate }" />
							</td>
							<td class="realProgressTd" onclick="selectedTR(this);">
								<div style="margin-top: 5px; display: inline-block;">
									<fmt:formatNumber value="${task.realProgress }" pattern="0.0" />%
								</div>
							</td>
						</tr>
					</c:forEach>
					</c:when>
					</c:choose>
				</tbody>
			</table>
		</div>
	</div>

<c:choose>
<c:when test="${paging.endPage>0 }">
<div id="tblPageRayer" style="width:470px; margin:6px auto; font-size:0">
	<div class="pagenavi">   
		<c:choose>
				<c:when test="${paging.currentPage gt 1}">   
					<span onclick="goToPageByNum(1)" class="btnimg first"></span>            
				</c:when>
				<c:otherwise>
					<span class="btnimg first disabled"></span>            
				</c:otherwise>         
		</c:choose>
		<c:choose>
			<c:when test="${paging.startPage gt 1}">
				<span onclick="goToPageByNum(${paging.startPage-1})" class="btnimg prev"></span>              
			</c:when>
			<c:otherwise>
				<span class="btnimg prev disabled"></span>
			</c:otherwise>                                    
		</c:choose>
		<%-- <span class="ptxt" onclick="<c:if test="${paging.currentPage gt 1 }">goToPageByNum(${paging.currentPage-1})</c:if>"><spring:message code='ezApproval.t931'/></span> --%>                                   
		<c:forEach begin="0" end="${paging.endPage-paging.startPage }" varStatus="status">
			<c:choose>
				<c:when test="${paging.startPage+status.index eq  paging.currentPage}">
					<span class="on">${paging.currentPage }</span>
				</c:when>
				<c:otherwise>
					<span onclick="goToPageByNum(${paging.startPage+status.index})">${paging.startPage+status.index}</span>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<%-- <span class="ptxt" onclick="<c:if test="${paging.totalPage gt paging.currentPage }">goToPageByNum(${paging.currentPage+1})</c:if>"><spring:message code='ezApproval.t932'/></span> --%>
		<c:choose>
			<c:when test="${paging.totalPage gt paging.endPage }">
				<span class="btnimg next" onclick="goToPageByNum(${paging.endPage+1})"></span>
			</c:when>
			<c:otherwise>
				<span class="btnimg next disabled"></span>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${paging.totalPage gt paging.currentPage }">
				<span class="btnimg last" onclick="goToPageByNum(${paging.totalPage})"></span>
			</c:when>
			<c:otherwise>
				<span class="btnimg last disabled"></span>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</c:when>
<c:otherwise>
<div id="tblPageRayer" style="width:470px; margin:6px auto; font-size:0">
	<div class="pagenavi">  
		<span class="btnimg first disabled"></span>
		<span class="btnimg prev disabled"></span>
		<%-- <span class="ptxt"> <spring:message code='ezApproval.t931'/></span> --%>  
		<span class="on">1</span> 
		<%-- <span class="ptxt"><spring:message code='ezApproval.t932'/></span> --%>
		<span class="btnimg next disabled"></span>
		<span class="btnimg last disabled"></span>
	</div>
</div>
</c:otherwise>
</c:choose>

</body>
</html>