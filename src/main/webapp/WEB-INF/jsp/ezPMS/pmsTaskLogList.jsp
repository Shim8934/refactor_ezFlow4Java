<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t153' /></title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/css/ezPMS/pms.css" type="text/css">
<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
<script type="text/javascript">
var CurrentHeight = document.documentElement.clientHeight - 100;
var contentTitle = $(".jstree-clicked").text();

$(function() {
	var groupDetails = ${groupDetails};
	var taskDetails = ${taskDetails};
	
	if (groupDetails.groupName == undefined) {
		contentTitle = taskDetails.taskName;
	} else {
		contentTitle = groupDetails.groupName;
	}
	
	if(typeof setContentTitle != 'undefined') {
		setContentTitle(contentTitle, "${taskLogListCount}");
	}
	
	/* if (contentTitle == "") {
		var treeItemId = $("li[role=treeitem]").attr("id");
		contentTitle = $("#" + treeItemId + "_anchor").text();
		
		 if (contentTitle.indexOf("(") != -1) {
			contentTitle = contentTitle.substring(0, contentTitle.indexOf("("));
		} 
		
		setContentTitle(contentTitle, "${taskLogListCount}");
	} else {
		
		 if (contentTitle.indexOf("(") != -1) {
			contentTitle = contentTitle.substring(0, contentTitle.indexOf("("));
		} 
		
		setContentTitle(contentTitle, "${taskLogListCount}");
	} */
});

</script>
</head>
<body>
	<div style="width: 100%;" id="divList">
		<div id="lvBoardList">
			<table id="tableHeader" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowondblclick="ItemRead_onclick(this)" width="100%" border="0"
						class="mainlist" style="overflow:hidden">
				<thead id="BoardList_THEAD">
					<tr id="BoardList_TH">
						<th id="BoardList_TH_0" onclick="setListOrder(this)" order="LOG_STATUS" style="text-align: left; overflow: hidden; white-space: nowrap; 
							text-overflow: ellipsis; cursor: pointer; width: 57px; text-align: center" class="h5_center"><spring:message code='ezPMS.t38' /></th>
						<th id="BoardList_TH_1" onclick="setListOrder(this)" order="LOG_CONTENT"
							style="text-align: center;cursor: pointer;"
							class="h5_center"><spring:message code='ezPMS.t186' /></th>
						<th id="BoardList_TH_2"
							style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 200px"
							class="h5_center"><spring:message code='ezPMS.t98' /></th>
						<th id="BoardList_TH_3" onclick="setListOrder(this)" order="USER_NAME"
							style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 80px"
							class="h5_center"><spring:message code='ezPMS.t63' /></th>
						<th id="BoardList_TH_4" onclick="setListOrder(this)" order="LOG_DATE"
							style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 163px"
							class="h5_center"><spring:message code='ezPMS.t187' /></th>
						</tr>
						</thead>
					</table>
				</div>
				<div id="projectListBody" multiselectable="false" useocs="false" style="overflow:auto; min-width: 469px;">
				<table id="tableBody" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="ItemPreviewRead_click" rowondblclick="ItemRead_onclick(this)"  width="100%" border="0" class="mainlist" style="">
						<tbody style="background-color: rgb(255, 255, 255);">
							<c:choose>
								<c:when test="${empty logList}">
									<tr>
										<td colspan="5" style="text-align : center"> <spring:message code='ezPMS.t30' /> </td>
									</tr>
								</c:when>
							<c:otherwise>
								<c:forEach items="${logList }" var="log">
								<tr id="${log.logId }" class="listRow" ondblclick="goProjectDetails(this)">
									<td style="width: 57px; cursor: default; text-align: center">
										<c:choose>
											<c:when test="${log.logStatus eq 1 }">
												<span class="situation_registration">&nbsp;<spring:message code='ezPMS.t40' />&nbsp;</span>
											</c:when>
											<c:when test="${log.logStatus eq 2 }">
												<span class="situation_modify">&nbsp;<spring:message code='ezPMS.t110' />&nbsp;</span>
											</c:when>
											<c:otherwise>
												<span class="situation_delet">&nbsp;<spring:message code='ezPMS.t11' />&nbsp;</span>
											</c:otherwise>
										</c:choose>
									</td>
									<td onclick="selectedTR(this);"
										style="text-align: left;"><c:out
											value="${log.logContent }" /></td>
									<td onclick="selectedTR(this);"
										style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 200px; text-align:center;">
										<c:choose>
											<c:when test="${empty log.taskName }">
												<c:out value="${log.groupName }" />
											</c:when>
											<c:otherwise>
													<c:out value="${log.taskName }" />
											</c:otherwise>
										</c:choose>
									</td>
									<td onclick="selectedTR(this);"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 80px"><c:out
											value="${log.userName }" /></td>
									<td onclick="selectedTR(this);"
										style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width: 163px"><div
											name="${log.logId }" style="margin-right: 2px;"></div>&nbsp;
										<div style="margin-top: 5px; display: inline-block;">
											<c:out value="${fn:substring(log.logDate, 0, 16)}" />
										</div>
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