<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><script type="text/javascript" src="/js/mouseeffect.js"></script>
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
<title><spring:message code='ezPMS.t142' /></title>
<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 100;

$(function() {
	CurrentHeight = $(window).height() - 100;
	$("MailListRayer").css("height", CurrentHeight + "px");
	$("#taskTree").css("height", CurrentHeight + 10 + "px");
	$("#projectContent").css("height", CurrentHeight + "px");
	$("#contentList").css("height", (CurrentHeight - 100) + "px");
	$("#projectListBody").css("height", (CurrentHeight - 190) + "px");
	$("#divList").css("height", (CurrentHeight - 150) + "px");
	$("#divList").css("overflow", "auto");

	$("#totalCount").text("${projectListCount}");
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
							<th id="BoardList_TH_1" onclick="setListOrder(this)" order="PROJECT_NAME" style="text-align: center; overflow: hidden; white-space: nowrap; 
								text-overflow: ellipsis; cursor: pointer; width: 12%;" class="h5_center"><spring:message code='ezPMS.t31' /></th>
							<th id="BoardList_TH_2" onclick="setListOrder(this)" order="HEAD_MANAGER_NAME"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 45px;"
								class="h5_center"><spring:message code='ezPMS.t32' /></th>
							<th id="BoardList_TH_3" onclick="setListOrder(this)" order="PLAN_START_DATE"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 70px"
								class="h5_center"><spring:message code='ezPMS.t61' /></th>
							<th id="BoardList_TH_4" onclick="setListOrder(this)" order="PLAN_END_DATE"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 70px"
								class="h5_center"><spring:message code='ezPMS.t62' /></th>
							<th id="BoardList_TH_5" onclick="setListOrder(this)" order="STATUS"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 30px;"
								class="h5_center"><spring:message code='ezPMS.t38' /></th>
							<th id="BoardList_TH_6" onclick="setListOrder(this)" order="PROGRESS"
								style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 50px;"
								class="h5_center"><spring:message code='ezPMS.t250' /></th>
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
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 70px">
												<c:out value="${project.planStartDate }" />
										</td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 70px">
												<c:out value="${project.planEndDate }" />
										</td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 30px">
											<c:choose>
												<c:when test="${project.status eq 'P' }"><spring:message code='ezPMS.t15' /></c:when>
												<c:when test="${project.status eq 'W' }"><spring:message code='ezPMS.t16' /></c:when>
												<c:when test="${project.status eq 'C' }"><spring:message code='ezPMS.t17' /></c:when>
												<c:when test="${project.status eq 'L' }"><spring:message code='ezPMS.t18' /></c:when>
												<c:when test="${project.status eq 'D' }"><spring:message code='ezPMS.t11' /></c:when>
												<c:when test="${project.status eq 'S' }"><spring:message code='ezPMS.t19' /></c:when>
											</c:choose></td>
										<td onclick="selectedTR(this);"
											style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 50px">
											<fmt:formatNumber value="${project.progress }" pattern="0.0" />%</td>
									</tr>
								</c:forEach>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
				</div> <c:choose>
					<c:when test="${paging.endPage>0 }">
						<div id="tblPageRayer" style="width: 470px; margin: 6px auto;">
							<div class="pagenavi">
								<c:choose>
									<c:when test="${paging.currentPage gt 1}">
										<span onclick="goToPageByNum(1)" class="btnimg"><img
											src="/images/sub/btn_p_prev.gif" width="16" height="16"></span>
									</c:when>
									<c:otherwise>
										<span class="btnimg"><img
											src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${paging.startPage gt 1}">
										<span onclick="goToPageByNum(${paging.startPage-1})"
											class="btnimg"><img src="/images/sub/btn_prev.gif"
											width="16" height="16"></span>
									</c:when>
									<c:otherwise>
										<span class="btnimg"><img
											src="/images/sub/btn_prev01.gif" width="16" height="16"></span>
									</c:otherwise>
								</c:choose>
								<span class="ptxt"
									onclick="<c:if test="${paging.currentPage gt 1 }">goToPageByNum(${paging.currentPage-1})</c:if>"><spring:message
										code='ezApproval.t931' /></span>
								<c:forEach begin="0" end="${paging.endPage-paging.startPage }"
									varStatus="status">
									<c:choose>
										<c:when
											test="${paging.startPage+status.index eq  paging.currentPage}">
											<span class="on">${paging.currentPage }</span>
										</c:when>
										<c:otherwise>
											<span
												onclick="goToPageByNum(${paging.startPage+status.index})">${paging.startPage+status.index}</span>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								<span class="ptxt"
									onclick="<c:if test="${paging.totalPage gt paging.currentPage }">goToPageByNum(${paging.currentPage+1})</c:if>"><spring:message
										code='ezApproval.t932' /></span>
								<c:choose>
									<c:when test="${paging.totalPage gt paging.endPage }">
										<span class="btnimg"
											onclick="goToPageByNum(${paging.endPage+1})"><img
											src="/images/sub/btn_next.gif" width="16" height="16"></span>
									</c:when>
									<c:otherwise>
										<span class="btnimg"><img
											src="/images/sub/btn_next01.gif" width="16" height="16"></span>
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${paging.totalPage gt paging.currentPage }">
										<span class="btnimg"
											onclick="goToPageByNum(${paging.totalPage})"><img
											src="/images/sub/btn_n_next.gif" width="16" height="16"></span>
									</c:when>
									<c:otherwise>
										<span class="btnimg"><img
											src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<div id="tblPageRayer" style="width: 470px; margin: 6px auto;">
							<div class="pagenavi">
								<span class="btnimg"><img
									src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>
								<span class="btnimg"><img
									src="/images/sub/btn_prev01.gif" width="16" height="16"></span>
								<span class="ptxt"> <spring:message code='ezApproval.t931' /></span> <span class="on">1</span> <span
									class="ptxt"><spring:message code='ezApproval.t932' /></span> <span
									class="btnimg"><img src="/images/sub/btn_next01.gif"
									width="16" height="16"></span> <span class="btnimg"><img
									src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
</body>
</html>