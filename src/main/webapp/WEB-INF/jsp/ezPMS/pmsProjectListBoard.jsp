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
<%--<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />--%>
<link rel="stylesheet" href="${util.addVer('/css/previewmail.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>

<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 110;
setTotalCount("${projectListCount}");

$(function(){
	$("#listcount").val(initListNumber).prop("selected", true);
	
	var projectList = new Array();
		
	<c:forEach items="${projectList}" var="project">
		var json = new Object();
		json.projectId = "${project.projectId}";
		json.progress = "${project.progress}";
		json.totalTaskCount = "${project.totalTaskCount}";
		json.completeTaskCount = "${project.completeTaskCount}";
		json.lateTaskCount = "${project.lateTaskCount}";
		json.status = "${project.status}";
		projectList.push(json);
	</c:forEach>
	
	/* for (var i = 0; i < projectList.length; i++) {
		var completeTaskPercent = (projectList[i].completeTaskCount / projectList[i].totalTaskCount) * 100;
		var lateTaskPercent = (projectList[i].lateTaskCount / projectList[i].totalTaskCount) * 100;
		
		if (isNaN(completeTaskPercent)) {
			completeTaskPercent = 0;
		}
		
		if (isNaN(lateTaskPercent)) {
			lateTaskPercent = 0;
		}
		
		$("div[name=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : projectList[i].progress,
			fillBackgroundColor : progressColor,
			height : '15px',
			radius : '15px',
			width : '68%'
		});
		
		$("div[complete=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : completeTaskPercent,
			fillBackgroundColor : completeColor,
			height : '15px',
			radius : '15px',
			width : '68%'
		});
		
		$("div[overdue=" + projectList[i].projectId+"]").LineProgressbar({
			percentage : lateTaskPercent,
			fillBackgroundColor : overdueColor,
			height : '15px',
			radius : '15px',
			width : '68%'
		});
	} */
	
	// by mslim start
	var i = 0;
	setProgressBar();
	
	i = i++;
	
	var progressBar = setInterval(setProgressBar, 0);
	
	function setProgressBar() {
		var projectCount = projectList.length;
		
		for(var j = 0; j < 10 && i < projectCount; j++, i++) {
			var htmlStr = "";
			
			if (projectList[i].status == "P") {
				htmlStr = "<span class='situation_progress' style='background-color:" + progressColor + ";'><spring:message code='ezPMS.t15' /></span>";
			} else if (projectList[i].status == "C") {
//				if (projectList[i].restDueday >= 0) {
					htmlStr = "<span class='situation_complete' style='background-color:" + completeColor + ";'><spring:message code='ezPMS.t17' /></span>";
	/* 			} else if (projectList[i].restDueday < 0) {
					htmlStr = "<span class='situation_complete' style='background-color:" + completeColor + ";'><spring:message code='ezPMS.t17' /></span><span class='situation_delay' style='background-color:" + overdueColor + ";'><spring:message code='ezPMS.t18' /></span>";
				} */
			} else if (projectList[i].status == "S") {
				htmlStr = "<span class='situation_hold' style='background-color:" + holdColor + ";'><spring:message code='ezPMS.t19' /></span>";
			} else if (projectList[i].status == "L") {
				htmlStr = "<span class='situation_progress' style='background-color:" + progressColor + ";'><spring:message code='ezPMS.t15' /></span><span class='situation_delay' style='background-color:" + overdueColor + ";'><spring:message code='ezPMS.t18' /></span>";
			} else if (projectList[i].status == "W") {
				htmlStr = "<span class='situation_standby' style='background-color:" + waitColor + ";'><spring:message code='ezPMS.t16' /></span>";
			} else if (projectList[i].status == "D") {
				htmlStr = "<span class='situation_delet' style='background-color:" + deleteColor + ";'><spring:message code='ezPMS.t11' /></span>";
			}
			
			$("tr[id='" + projectList[i].projectId + "']").find(".projectStatus").html(htmlStr);
			
			var completeTaskPercent = (projectList[i].completeTaskCount / projectList[i].totalTaskCount) * 100;
			var lateTaskPercent = (projectList[i].lateTaskCount / projectList[i].totalTaskCount) * 100;
			
			if (isNaN(completeTaskPercent)) {
				completeTaskPercent = 0;
			}
			
			if (isNaN(lateTaskPercent)) {
				lateTaskPercent = 0;
			}
			
			$("div[name=" + projectList[i].projectId+"]").LineProgressbar({
				percentage : projectList[i].progress,
				fillBackgroundColor : progressColor,
				duration : 0,
				height : '15px',
				radius : '15px',
				width : '68%'
			});
			
			$("div[complete=" + projectList[i].projectId+"]").LineProgressbar({
				percentage : completeTaskPercent,
				fillBackgroundColor : completeColor,
				duration : 0,
				height : '15px',
				radius : '15px',
				width : '68%'
			});
			
			$("div[overdue=" + projectList[i].projectId+"]").LineProgressbar({
				percentage : lateTaskPercent,
				fillBackgroundColor : overdueColor,
				duration : 0,
				height : '15px',
				radius : '15px',
				width : '68%'
			});
		}
		
		if(i >= projectCount) {
			clearInterval(progressBar);
		}
	}
	// by mslim end
});
</script>
</head>
<body>
	
		<div style="width: 100%;" id="divList">
			<div id="lvBoardList">
				<table id="tableHeader" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" width="100%" border="0"
							class="mainlist" style="overflow:hidden">
					<thead id="BoardList_THEAD">
						<tr id="BoardList_TH">
							<th id="BoardList_TH_0" style="text-align: center; overflow: hidden; white-space: nowrap; cursor: pointer; width:20px;"
								class="h4_center" bgcolor="#CCCCCC">
								<div class='custom_checkbox'><input type="checkbox" id="HeaderAllCheckBox" name="boardCheckbox" id="HeaderAllCheckBox" onchange="selectedAllTR(this);"
                                    style="margin: 0px; padding: 0px; width: 13px; height: 13px; vertical-align: middle;"></div>
							</th>
							<th id="BoardList_TH_1" onclick="setListOrder(this)" order="PROJECT_NAME" style="text-align: left; overflow: hidden; white-space: nowrap; 
								text-overflow: ellipsis; cursor: pointer;;" class="h5_center"><spring:message code='ezPMS.t31' /></th>
							<th id="BoardList_TH_2" onclick="setListOrder(this)" order="HEAD_MANAGER_NAME"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 70px;"
								class="h5_center"><spring:message code='ezPMS.t330' /></th>
							<th id="BoardList_TH_3" onclick="setListOrder(this)" order="PROGRESS"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 250px"
								class="h5_center"><spring:message code='ezPMS.t33' /></th>
							<th id="BoardList_TH_4"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;  width: 250px"
								class="h5_center"><spring:message code='ezPMS.t34' /></th>
							<th id="BoardList_TH_5"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 250px"
								class="h5_center"><spring:message code='ezPMS.t35' /></th>
							<th id="BoardList_TH_6" onclick="setListOrder(this)" order="REST_DUEDAY"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 70px;"
								class="h5_center"><spring:message code='ezPMS.t36' /></th>
							<th id="BoardList_TH_7" onclick="setListOrder(this)" order="PLAN_END_DATE"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 210px;"
								class="h5_center"><spring:message code='ezPMS.t37' /></th>
							<th id="BoardList_TH_8" onclick="setListOrder(this)" order="STATUS"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 100px;"
								class="h5_center"><spring:message code='ezPMS.t38' /></th>
							</tr>
							</thead>
						</table>
					</div>
					<div id="projectListBody" multiselectable="false" useocs="false" style="overflow:auto; min-width: 469px; height: 456px;">
					<table id="tableBody" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="ItemPreviewRead_click" width="100%" border="0" class="mainlist" style="">
							<tbody style="background-color: rgb(255, 255, 255);">
								<c:choose>
									<c:when test="${empty projectList}">
										<tr>
											<td colspan="9" style="text-align : center"> <spring:message code='ezPMS.t30' /> </td>
										</tr>
									</c:when>
									<c:otherwise>
										<c:forEach items="${projectList }" var="project">
									<tr style="cursor: pointer;" id="${project.projectId }" data-groupId="${project.groupId}" data-headmanagerid="${project.headManagerId}" class="listRow" ondblclick="goProjectDetails(this)">
										<td style="width: 20px; cursor: default; text-align: center"><input
											type="checkbox" onchange="checkedCheckbox(this);"
											name="boardCheckbox"
											style="margin: 0px; padding: 0px; width: 13px; height: 13px; cursor: pointer;"></td>
										<td class="projectName" onclick="selectedTR(this);"
											style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><c:out
												value="${project.projectName }" /></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 70px"><c:out
												value="${project.headManagerName }" /></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 250px"><div
												name="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
											<div style="margin-top: 5px; display: inline-block;">
												&nbsp;<fmt:formatNumber value="${project.progress }" pattern="0.0" /></div>
											</div></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 250px"><div
												complete="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
											<div style="margin-top: 5px; display: inline-block;">
												<c:out value="${project.completeTaskCount }" /> / <c:out value="${project.totalTaskCount }"/>
											</div></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 250px"><div
												overdue="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
											<div style="margin-top: 5px; display: inline-block;">
												<c:out value="${project.lateTaskCount }" /> / <c:out value="${project.totalTaskCount }"/>
											</div></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 70px">D<c:out value="${project.restDueday - 1 < 0 ? '+ '.concat(-(project.restDueday - 1)) : '- '.concat(project.restDueday - 1) }"/>
										</td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 210px"><c:out
												value="${project.planStartDate }" /> ~ <c:out
												value="${project.planEndDate }" /></td>
										<td class="projectStatus" onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 100px">
										</td>
									</tr>
								</c:forEach>
									</c:otherwise>
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