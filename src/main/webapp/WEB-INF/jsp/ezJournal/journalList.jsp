<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>"
	type="text/css">
<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
<script type="text/javascript"
	src="<spring:message code='ezBoard.e1' />"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/Common.js"></script>
<style>
 tr.noView td{
 	font-weight: bold;
 }
</style>
<script type="text/javascript">
	
</script>
</head>
<div style="width: 100%; overflow: AUTO;" id="divList">
	<div id="lvBoardList">
		<table id="BoardList" cellspacing="0" cellpadding="0"
		multiselectable="false" useocs="false"
		rowonclick="ItemPreviewRead_click"
		rowondblclick="ItemRead_onclick(this)" width="100%" border="0"
		class="mainlist" style="min-width: 569px;">
		<thead id="BoardList_THEAD">
			<tr id="BoardList_TH">
				<th id="BoardList_TH_0"
					style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;"
					class="h4_center" bgcolor="#CCCCCC" width="20px"><input
					type="checkbox" id="HeaderAllCheckBox"
					style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
				<c:if test="${listType eq 'mine' }">
				<th id="BoardList_TH_1"
					style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; padding: 0px; text-align: center;"
					class="h5_center" width="50px"><spring:message code='ezJournal.t109'/></th>
				</c:if>
				<c:if test="${listType eq 'recv' or listType eq 'temp' }">
				<th id="BoardList_TH_1"
					style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; padding: 0px; text-align: center;"
					class="h5_center" width="100px"><spring:message code='ezJournal.t12'/></th>
				</c:if>
				<th id="BoardList_TH_3"
					style="text-align:center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width: 50%;"
					class="h5_center" width="400px"><spring:message code='ezJournal.t56'/></th>
				<c:if test="${listType eq 'recv' }">
				<th id="BoardList_TH_4"
					style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;"
					class="h5_center" width="100px"><spring:message code='ezJournal.t40'/></th>
				</c:if>
				<c:if test="${listType eq 'department' or listType eq 'recv' }">
				<th id="BoardList_TH_5"
					style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;"
					class="h5_center" width="100px" writerindex="5"><spring:message code='ezJournal.t34'/></th>
				</c:if>
				<th id="BoardList_TH_6"
					style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;"
					class="h5_center" width="120px"><spring:message code='ezJournal.t35'/></th>
				<c:if test="${listType eq 'department' or listType eq 'recv' or listType eq 'mine' }">
				<th id="BoardList_TH_8"
					style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;"
					class="h5_center" width="100px" writerindex="5"><spring:message code='ezJournal.t22'/></th>
				</c:if>
				<c:if test="${listType eq 'mine' }">
				<th id="BoardList_TH_9"
					style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;"
					class="h5_center" width="50px" writerindex="5"><spring:message code='ezJournal.t110'/></th>
				</c:if>
				<th id="BoardList_TH_2"
					style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;"
					class="h5_center" width="20px"><img
					src="/images/newAttach.gif"></th>
				<c:if test="${listType eq 'department' or listType eq 'mine' }">
				<th id="BoardList_TH_7"
					style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;"
					class="h5_center" width="50px"><spring:message code='ezJournal.t65'/></th>
				</c:if>
			</tr>
		</thead>
		<tbody style="background-color: rgb(255, 255, 255);">
		<c:choose>
		<c:when test="${fn:length(journalList) ne 0}">
			<c:forEach items="${journalList}" var="journal" varStatus="status">
			<tr id="${journal.journalId }" class="${journal.isView }" onclick="selectedTR(this);" style="cursor: pointer;">
				<td
					style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><input
					type="checkbox" id="" style="width: 13px; height: 13px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-center: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-center: 0px; vertical-align: middle"></td>
				<c:if test="${listType eq 'mine' }">
				<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				${journal.deptShare}
				</td>
				</c:if>
				<c:if test="${listType eq 'recv' or listType eq 'temp' }">
				<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				<spring:message code='${journal.typeId}'/>
				</td>
				</c:if>
				<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				${journal.journalTitle}
				<c:if test="${journal.replyCount gt 0}">
					<a onclick=""><span style="color: #2222ff">[${journal.replyCount }]</span></a>
				</c:if>
				</td>
				<c:if test="${listType eq 'recv' }">
				<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				${journal.deptName}
				</td>
				</c:if>
				<c:if test="${listType eq 'department' or listType eq 'recv' }">
				<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				${journal.writerName}
				</td>
				</c:if>
				<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				${journal.journalDate}
				</td>
				<c:if test="${listType eq 'department' or listType eq 'recv' or listType eq 'mine' }">
				<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				${journal.formName}
				</td>
				</c:if>
				<c:if test="${listType eq 'mine' }">
				<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				${journal.checkRecv} / ${journal.totalRecv}
				</td>
				</c:if>
				<c:choose>
				<c:when test="${journal.fileCount ne 0}">
				<td
					style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; padding: 0px;"><img
					src="/images/i_notice.gif"></td>
				</c:when>
				<c:otherwise>
				<td
					style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; padding: 0px;"></td>
				</c:otherwise>
				</c:choose>
				<c:if test="${listType eq 'department' or listType eq 'mine' }">
				<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
				${journal.viewCount}
				</td>
				</c:if>
			</tr>
			</c:forEach>
		</c:when>
		<c:otherwise>
				<tr selected="false" class="" style="cursor: pointer; background-color: rgb(255, 255, 255);">
					<td	style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;" colspan="<c:choose><c:when test="${listType eq 'mine' or listType eq 'recv' }">8</c:when><c:when test="${listType eq 'department' }">7</c:when><c:otherwise>4</c:otherwise></c:choose>">
						<spring:message code='ezJournal.t125'/>
					</td>
				</tr>
		</c:otherwise>
		</c:choose>
		</tbody>
	</table>
	</div>
</div>
<div id='runtime' style="color: #666; padding-top: 5px"></div>
<c:if test="${paging.endPage>0 }">
<div id="tblPageRayer" style="text-align: center">
	<div class="pagenavi">               
		<c:choose>
			<c:when test="${paging.startPage gt 1}">
				<span onclick="goToPageByNum(1)" class="btnimg"><img src="/images/sub/btn_p_prev.gif" width="16" height="16"></span>            
				<span onclick="goToPageByNum(${paging.startPage-1})" class="btnimg"><img src="/images/sub/btn_prev.gif" width="16" height="16"></span>              
			</c:when>
			<c:otherwise>
				<span class="btnimg"><img src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>            
				<span class="btnimg"><img src="/images/sub/btn_prev01.gif" width="16" height="16"></span>              
			</c:otherwise>                                                                    
		</c:choose>
		<span class="ptxt" onclick="<c:if test="${paging.currentPage gt 1 }">goToPageByNum(${paging.currentPage-1})</c:if>"><spring:message code='ezApproval.t931'/></span>                                   
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
		<span class="ptxt" onclick="<c:if test="${paging.totalPage gt paging.currentPage }">goToPageByNum(${paging.currentPage+1})</c:if>"><spring:message code='ezApproval.t932'/></span>
		<c:choose>
			<c:when test="${paging.totalPage gt paging.endPage }">
				<span class="btnimg" onclick="goToPageByNum(${paging.endpage+1})"><img src="/images/sub/btn_next.gif" width="16" height="16"></span>
				<span class="btnimg" onclick="goToPageByNum(${paging.totalPage})"><img src="/images/sub/btn_n_next.gif" width="16" height="16"></span>
			</c:when>
			<c:otherwise>
				<span class="btnimg"><img src="/images/sub/btn_next01.gif" width="16" height="16"></span>
				<span class="btnimg"><img src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</c:if>
</html>