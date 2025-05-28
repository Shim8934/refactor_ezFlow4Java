<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
	setTotalCount("${totalCount}");
</script>
<div style="width: 100%;" id="divList">
	<div id="journalListHeader">
		<table id="journalListHead" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" width="100%" class="mainlist">
		<thead id="BoardList_THEAD">
			<tr id="BoardList_TH">
				<th id="BoardList_TH_0" style="text-align: center; overflow: hidden; white-space: nowrap; cursor: pointer; width:20px;" class="h4_center" bgcolor="#CCCCCC">
					<input type="checkbox" id="HeaderAllCheckBox" onchange="selectedAllTR(this);" style="margin: 0px; padding: 0px; width: 13px; height: 13px; vertical-align: middle;">
				</th>
				<th id="BoardList_TH_2" onclick="setListOrder(this)" order="14" style="overflow: hidden; white-space: nowrap; cursor: pointer; width:25px; text-align: center;" class="h5_center">
					<img style="cursor:pointer; vertical-align: middle;" src="/images/ImgIcon/view-document.gif ">
				</th>
				<!-- 취합여부아이콘 -->
				<th id="BoardList_TH_10" onclick="setListOrder(this)" order="16" style="overflow: hidden; white-space: nowrap; cursor: pointer; width:35px; text-align: center; padding: 0px 3px;" class="h5_center">
					<img src="/images/ImgIcon/addon.png" style="vertical-align: middle;">
				</th>
				<th id="BoardList_TH_2" onclick="setListOrder(this)" order="10" style="padding-left: 0; overflow: hidden; white-space: nowrap; cursor: pointer; width:20px; text-align: center;" class="h5_center">
					<img src="/images/newAttach.gif" style="vertical-align: middle;">
				</th>
				<th id="BoardList_TH_1" onclick="setListOrder(this)" order="8" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: left; width:12%" class="h5_center" width="150">
					<spring:message code='ezJournal.t176'/>
				</th>
				<th id="BoardList_TH_3" onclick="setListOrder(this)" order="2" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width:35%;" class="h5_center">
					<spring:message code='ezJournal.t56'/>
				</th>
				<th style="width:20px;"></th>
				<th id="BoardList_TH_4" onclick="setListOrder(this)" order="6" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width:10%;" class="h5_center">
					<spring:message code='ezJournal.t40'/>
				</th>
				<th id="BoardList_TH_5" onclick="setListOrder(this)" order="5" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width:12%;" class="h5_center">
					<spring:message code='ezJournal.t34'/>
				</th>
				<th id="BoardList_TH_6" onclick="setListOrder(this)" order="3" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width:12%;" class="h5_center">
					<spring:message code='ezJournal.t35'/>
				</th>
				<th id="BoardList_TH_8" onclick="setListOrder(this)" order="7" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; width:12%;" class="h5_center">
					<spring:message code='ezJournal.t22'/>
				</th>
			</tr>
		</thead>
		</table>
		</div>
		<div id="journalListBody" multiselectable="false" useocs="false" style="overflow:auto; min-width: 469px; height: 456px;">
		<table id="journalList" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="ItemPreviewRead_click" rowondblclick="ItemRead_onclick(this)" 
			width="100%" border="0" class="mainlist" style="">
		<tbody style="background-color: rgb(255, 255, 255);">
		<c:choose>
			<c:when test="${fn:length(journalList) ne 0}">
				<c:forEach items="${journalList}" var="journal" varStatus="status">
				<tr class="${journal.isView }" id="${journal.journalId }" mine="${journal.mine }" formStatus="${journal.formStatus }" typeId="${journal.typeId}" formId="${journal.formId}" ondblclick="goJournalDetail(this);" style="cursor: pointer;">
					<td class="cbTD" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width:20px;"><input onchange="checkedCheckbox(this);" type="checkbox" name="journalCheckbox" style="width: 13px; height: 13px; padding : 0px; margin : 0px; vertical-align: middle"></td>
					<c:choose>
						<c:when test="${journal.isView == 'noView'}">
							<td onclick="selectedTR(this);" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width:25px;">
								<img style="cursor:pointer; vertical-align: middle;" src="/images/ImgIcon/view-document.gif">
							</td>
						</c:when>
						<c:otherwise>
							<td onclick="selectedTR(this);" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width:25px;">
								<img style="cursor:pointer; vertical-align: middle;" draggable="false" src="/images/ImgIcon/icon-msg-read.gif">
							</td>
						</c:otherwise>
					</c:choose>
					<!-- 취합여부아이콘 -->
					<c:choose>
						<c:when test="${journal.isSum eq 'Y'}">
							<td onclick="selectedTR(this);" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;  padding: 0px 3px; width:35px;">
								<img src="/images/ImgIcon/addon.png" style="vertical-align: middle;">
							</td>
						</c:when>
						<c:otherwise>
							<td onclick="selectedTR(this);" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;  padding: 0px 3px; width:35px;">
								<img src="/images/ImgIcon/addoff.png" style="vertical-align: middle;">
							</td>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${journal.fileCount ne 0}">
							<td onclick="selectedTR(this);" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; padding-left: 0px; width:20px;">
								<img src="/images/newAttach.gif" style="vertical-align: middle;">
							</td>
						</c:when>
						<c:otherwise>
							<td onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; padding-left: 0px; width:20px;"></td>
						</c:otherwise>
					</c:choose>
					<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width:12%" width="150">
						<spring:message code='${journal.typeId}'/>
					</td>
					<td	onclick="selectedTR(this); goJournalDetailOneClick(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width:35%;">
						<div style="display:flex; align-items:center;">
						<div style='float:left; overflow: hidden; text-overflow: ellipsis; display: block; max-width: 95;'>
							<jsp:useBean id="toDay" class="java.util.Date" />
							<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="nowDay"/>
							<fmt:parseDate value="${journal.journalDate}" pattern="yyyy-MM-dd"  var="jDay"/>
							<fmt:formatDate value="${jDay}" pattern="yyyy-MM-dd" var="jDay"/>
							<c:if test="${nowDay <= jDay }">
								<img src="/images/i_new.gif">
							</c:if>
							<c:out value='${journal.journalTitle}'/>
						</div>
						<c:if test="${journal.replyCount gt 0}">
<!-- 							<a style="position: absolute;" onclick=""> -->
							<span style="color: #c64200">[<c:out value='${journal.replyCount }'/>]</span>
<!-- 							</a> -->
						</c:if>
						</div>
					</td>
					<td style="width:20px; "></td>
					<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width:10%;">
						<c:out value='${journal.deptName}'/>
					</td>
					<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width:12%;">
						<c:out value='${journal.writerName}'/>
					</td>
					<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width:12%;">
						<c:out value='${fn:substring(journal.journalDate, 0, 16) }'/>
					</td>
					<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; width:12%;">
						<c:out value='${journal.formName}'/>
					</td>
				</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr selected="false" class="" style="background-color: rgb(255, 255, 255);">
					<td	style="text-align: center; font-weight: normal; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;" colspan="10">
						<spring:message code='ezJournal.t125'/>
					</td>
				</tr>
			</c:otherwise>
		</c:choose>
		</tbody>
	</table>
	</div>
</div>
<!-- <div id='runtime' style="color: #666; padding-top: 5px"></div> -->
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
