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
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript"
	src="/js/ezTask/jquery.lineProgressbar.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />"
	type="text/css">
<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/css/jquery.lineProgressbar.css"
	type="text/css">
<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 110;
setTotalCount("${projectListCount}");

$(function(){
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
	
	var progressBar = setInterval(setProgressBar, 300);
	
	function setProgressBar() {
		for(var j = 0; j < 10 && i < projectList.length; j++, i++) {
			if (projectList[i].status == "P") {
			 	$("#" + projectList[i].projectId).find(".statusSpan").css("background-color", progressColor);
			} else if (projectList[i].status == "C") {
				$("#" + projectList[i].projectId).find(".statusSpan").css("background-color", completeColor);
			} else if (projectList[i].status == "S") {
				$("#" + projectList[i].projectId).find(".statusSpan").css("background-color", holdColor);
			} else if (projectList[i].status == "L") {
				$("#" + projectList[i].projectId).find(".statusSpan").css("background-color", overdueColor);
			} else if (projectList[i].status == "W") {
				$("#" + projectList[i].projectId).find(".statusSpan").css("background-color", waitColor);
			} else if (projectList[i].status == "D") {
				$("#" + projectList[i].projectId).find(".statusSpan").css("background-color", deleteColor);
			}
			
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
		}
		
		if(i >= projectList.length) {
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
								<input type="checkbox" id="HeaderAllCheckBox" name="boardCheckbox" id="HeaderAllCheckBox" onchange="selectedAllTR(this);"
									style="margin: 0px; padding: 0px; width: 13px; height: 13px; vertical-align: middle;">
							</th>
							<th id="BoardList_TH_1" onclick="setListOrder(this)" order="PROJECT_NAME" style="text-align: left; overflow: hidden; white-space: nowrap; 
								text-overflow: ellipsis; cursor: pointer; width: 12%;" class="h5_center"><spring:message code='ezPMS.t31' /></th>
							<th id="BoardList_TH_2" onclick="setListOrder(this)" order="HEAD_MANAGER_NAME"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 45px;"
								class="h5_center"><spring:message code='ezPMS.t32' /></th>
							<th id="BoardList_TH_3" onclick="setListOrder(this)" order="PROGRESS"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 110px"
								class="h5_center"><spring:message code='ezPMS.t33' /></th>
							<th id="BoardList_TH_4" onclick="setListOrder(this)" order="COMPLETE_TASK"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 110px"
								class="h5_center"><spring:message code='ezPMS.t34' /></th>
							<th id="BoardList_TH_5" onclick="setListOrder(this)" order="LATE_TASK"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 110px"
								class="h5_center"><spring:message code='ezPMS.t35' /></th>
							<th id="BoardList_TH_6" onclick="setListOrder(this)" order="REST_DUEDAY"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 45px;"
								class="h5_center"><spring:message code='ezPMS.t36' /></th>
							<th id="BoardList_TH_7" onclick="setListOrder(this)" order="PLAN_END_DATE"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 10%;"
								class="h5_center"><spring:message code='ezPMS.t37' /></th>
							<th id="BoardList_TH_8" onclick="setListOrder(this)" order="STATUS"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 30px;"
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
									<tr style="cursor: pointer;" id="${project.projectId }" class="listRow" ondblclick="goProjectDetails(this)">
										<td style="width: 20px; cursor: default; text-align: center"><input
											type="checkbox" onchange="checkedCheckbox(this);"
											name="boardCheckbox"
											style="margin: 0px; padding: 0px; width: 13px; height: 13px; cursor: pointer;"></td>
										<td onclick="selectedTR(this);"
											style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 12%"><c:out
												value="${project.projectName }" /></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 45px"><c:out
												value="${project.headManagerName }" /></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 110px"><div
												name="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
											<div style="margin-top: 5px; display: inline-block;">
												&nbsp;<fmt:formatNumber value="${project.progress }" pattern="0.0" /></div>
											</div></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 110px"><div
												complete="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
											<div style="margin-top: 5px; display: inline-block;">
												<c:out value="${project.completeTaskCount }" /> / <c:out value="${project.totalTaskCount }"/>
											</div></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 110px"><div
												overdue="${project.projectId }" style="margin-right: 2px;"></div>&nbsp;
											<div style="margin-top: 5px; display: inline-block;">
												<c:out value="${project.lateTaskCount }" /> / <c:out value="${project.totalTaskCount }"/>
											</div></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 45px">D
											<c:choose>
												<c:when test="${project.restDueday ge 0 }">- <c:out
														value="${project.restDueday }" />
												</c:when>
												<c:otherwise>+ <c:out
														value="${-project.restDueday }" />
												</c:otherwise>
											</c:choose>
										</td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 10%"><c:out
												value="${project.planStartDate }" /> ~ <c:out
												value="${project.planEndDate }" /></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 30px">
											<c:choose>
												<c:when test="${project.status eq 'P' }"><span class="statusSpan situation_progress"><spring:message code='ezPMS.t15' /></span></c:when>
												<c:when test="${project.status eq 'W' }"><span calss="statusSpan situation_stanby"><spring:message code='ezPMS.t16' /></span></c:when>
												<c:when test="${project.status eq 'C' }"><span calss="statusSpan situation_complete"><spring:message code='ezPMS.t17' /></span></c:when>
												<c:when test="${project.status eq 'L' }"><span calss="statusSpan situation_delay"><spring:message code='ezPMS.t18' /></span></c:when>
												<c:when test="${project.status eq 'D' }"><span calss="statusSpan situation_delet"><spring:message code='ezPMS.t11' /></span></c:when>
												<c:when test="${project.status eq 'S' }"><span calss="statusSpan situation_hold"><spring:message code='ezPMS.t19' /></span></c:when>
											</c:choose>
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
					<span onclick="goToPageByNum(1)" class="btnimg"><img src="/images/sub/btn_p_prev.gif" ></span>            
				</c:when>
				<c:otherwise>
					<span class="btnimg"><img src="/images/sub/btn_p_prev01.gif" ></span>            
				</c:otherwise>         
		</c:choose>
		<c:choose>
			<c:when test="${paging.startPage gt 1}">
				<span onclick="goToPageByNum(${paging.startPage-1})" class="btnimg"><img src="/images/sub/btn_prev.gif" ></span>              
			</c:when>
			<c:otherwise>
				<span class="btnimg"><img src="/images/sub/btn_prev01.gif" ></span>              
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
				<span class="btnimg" onclick="goToPageByNum(${paging.endPage+1})"><img src="/images/sub/btn_next.gif" ></span>
			</c:when>
			<c:otherwise>
				<span class="btnimg"><img src="/images/sub/btn_next01.gif" ></span>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${paging.totalPage gt paging.currentPage }">
				<span class="btnimg" onclick="goToPageByNum(${paging.totalPage})"><img src="/images/sub/btn_n_next.gif" ></span>
			</c:when>
			<c:otherwise>
				<span class="btnimg"><img src="/images/sub/btn_n_next01.gif" ></span>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</c:when>
<c:otherwise>
<div id="tblPageRayer" style="width:470px; margin:6px auto; font-size:0">
	<div class="pagenavi">  
		<span class="btnimg"><img src="/images/sub/btn_p_prev01.gif" ></span>
		<span class="btnimg"><img src="/images/sub/btn_prev01.gif" ></span>
		<%-- <span class="ptxt"> <spring:message code='ezApproval.t931'/></span> --%>  
		<span class="on">1</span> 
		<%-- <span class="ptxt"><spring:message code='ezApproval.t932'/></span> --%>
		<span class="btnimg"><img src="/images/sub/btn_next01.gif" ></span>
		<span class="btnimg"><img src="/images/sub/btn_n_next01.gif" ></span>
	</div>
</div>
</c:otherwise>
</c:choose>
</body>
</html>