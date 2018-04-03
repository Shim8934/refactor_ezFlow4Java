<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
	#tblPageRayer .pagenavi span{
		margin : 0px;
	}
</style>
<script>
	setTotalCount("${totalCount}");
</script>
<div style="width: 100%; overflow: AUTO;" id="divList">
	<div id="lvBoardList">
		<table id="journalList" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="ItemPreviewRead_click" rowondblclick="ItemRead_onclick(this)" 
			width="100%" border="0" class="mainlist" style="min-width: 569px;">
		<thead id="BoardList_THEAD">
			<tr id="BoardList_TH">
				<th id="BoardList_TH_0" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" class="h4_center" bgcolor="#CCCCCC" width="3%">
					<input type="checkbox" id="HeaderAllCheckBox" onchange="selectedAllTR(this);" style="margin: 0px; padding: 0px; width: 13px; height: 13px;">
				</th>
				<c:if test="${listType eq 'recv' }">
					<th id="BoardList_TH_2" onclick="setListOrder(this)" order="14" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="5%">
						<img style="cursor:pointer" src="/images/ImgIcon/view-document.gif ">
					</th>
				</c:if>
					<th id="BoardList_TH_2" onclick="setListOrder(this)" order="10" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="5%">
						<img src="/images/newAttach.gif">
					</th>
				<c:if test="${listType eq 'mine' }">
					<th id="BoardList_TH_1" onclick="setListOrder(this)" order="4" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; padding: 0px; text-align: center;" class="h5_center" width="5%">
						<img src="/images/icon_lock.png">
<%-- 						<spring:message code='ezJournal.t109'/> --%>
					</th>
				</c:if>
				<c:if test="${listType eq 'recv' or listType eq 'temp' }">
					<th id="BoardList_TH_1" onclick="setListOrder(this)" order="8" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; padding: 0px; text-align: left;" class="h5_center" width="15%">
						<spring:message code='ezJournal.t12'/>
					</th>
				</c:if>
				<th id="BoardList_TH_3" onclick="setListOrder(this)" order="2" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" class="h5_center" width="40%">
					<spring:message code='ezJournal.t56'/>
				</th>
				<c:if test="${listType eq 'recv' }">
					<th id="BoardList_TH_4" onclick="setListOrder(this)" order="6" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" class="h5_center" width="15%">
						<spring:message code='ezJournal.t40'/>
					</th>
				</c:if>
				<c:if test="${listType eq 'department' or listType eq 'recv' }">
					<th id="BoardList_TH_5" onclick="setListOrder(this)" order="5" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" class="h5_center" width="15%">
						<spring:message code='ezJournal.t34'/>
					</th>
				</c:if>
				<th id="BoardList_TH_6" onclick="setListOrder(this)" order="3" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" class="h5_center" width="20%">
					<spring:message code='ezJournal.t35'/>
				</th>
				<c:if test="${listType eq 'department' or listType eq 'recv' or listType eq 'mine' }">
					<th id="BoardList_TH_8" onclick="setListOrder(this)" order="7" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" class="h5_center" width="15%">
						<spring:message code='ezJournal.t22'/>
					</th>
				</c:if>
				<c:if test="${listType eq 'mine' }">
					<th id="BoardList_TH_9" onclick="setListOrder(this)" order="12" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" class="h5_center" width="5%">
						<spring:message code='ezJournal.t110'/>
					</th>
				</c:if>
				<c:if test="${listType eq 'department' or listType eq 'mine' }">
					<th id="BoardList_TH_7" onclick="setListOrder(this)" order="11" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer; text-align: center;" class="h5_center" width="5%">
						<spring:message code='ezJournal.t65'/>
					</th>
				</c:if>
			</tr>
		</thead>
		<tbody style="background-color: rgb(255, 255, 255);">
		<c:choose>
			<c:when test="${fn:length(journalList) ne 0}">
				<c:forEach items="${journalList}" var="journal" varStatus="status">
				<tr class="${journal.isView }" id="${journal.journalId }" formStatus="${journal.formStatus }" typeId="${journal.typeId}" formId="${journal.formId}" ondblclick="goJournalDetail(this);" style="cursor: pointer;">
					<td class="cbTD" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"><input onchange="checkedCheckbox(this);" type="checkbox" name="journalCheckbox" style="width: 13px; height: 13px; padding : 0px; margin : 0px; vertical-align: middle"></td>
					<c:if test="${listType eq 'recv' }">
						<c:choose>
							<c:when test="${journal.isView == 'noView'}">
								<td onclick="selectedTR(this);" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; padding: 0px;">
									<img style="cursor:pointer" src="/images/ImgIcon/view-document.gif ">
								</td>
							</c:when>
							<c:otherwise>
								<td onclick="selectedTR(this);" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; padding: 0px;">
									<img style="cursor:pointer" draggable="false" src="/images/ImgIcon/icon-msg-read.gif">
								</td>
							</c:otherwise>
						</c:choose>
					</c:if>
					<c:choose>
						<c:when test="${journal.fileCount ne 0}">
							<td onclick="selectedTR(this);" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; padding: 0px;">
								<img src="/images/newAttach.gif">
							</td>
						</c:when>
						<c:otherwise>
							<td onclick="selectedTR(this);" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; padding: 0px;"></td>
						</c:otherwise>
					</c:choose>
					<c:if test="${listType eq 'mine' }">
						<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
							<c:if test="${journal.deptShare eq 'N' }">
								<img src="/images/icon_lock.png">
	<%-- 							${journal.deptShare} --%>
							</c:if>
						</td>
					</c:if>
					<c:if test="${listType eq 'recv' or listType eq 'temp' }">
						<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
							<spring:message code='${journal.typeId}'/>
						</td>
					</c:if>
					<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
						${journal.journalTitle}
						<c:if test="${journal.replyCount gt 0}">
							<!-- <a onclick=""><span onclick="quickReply('${journal.journalId }','${journal.journalTitle }');" style="color: #c64200">[${journal.replyCount }]</span></a> -->
							<a onclick=""><span style="color: #c64200">[${journal.replyCount }]</span></a>
						</c:if>
					</td>
					<c:if test="${listType eq 'recv' }">
						<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
							${journal.deptName}
						</td>
					</c:if>
					<c:if test="${listType eq 'department' or listType eq 'recv' }">
						<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
							${journal.writerName}
						</td>
					</c:if>
					<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
						${journal.journalDate}
					</td>
					<c:if test="${listType eq 'department' or listType eq 'recv' or listType eq 'mine' }">
						<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
							${journal.formName}
						</td>
					</c:if>
					<c:if test="${listType eq 'mine' }">
						<td	onclick="selectedTR(this);" style="text-align: left; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
							<c:choose>
								<c:when test="${journal.totalRecv ne 0}">
									${journal.checkRecv} / ${journal.totalRecv}
								</c:when>
								<c:otherwise>
									<span style="word-spacing: -0.6px;">&nbsp;&nbsp;-</span>
								</c:otherwise>
							</c:choose>
						</td>
					</c:if>
					<c:if test="${listType eq 'department' or listType eq 'mine' }">
						<td	onclick="selectedTR(this);" class="viewCount" style="text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">
							${journal.viewCount}
						</td>
					</c:if>
				</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr selected="false" class="" style="background-color: rgb(255, 255, 255);">
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
<div id="tblPageRayer" style="width:470px; margin:6px auto;">
	<div class="pagenavi">   
		<c:choose>
				<c:when test="${paging.currentPage gt 1}">   
					<span onclick="goToPageByNum(1)" class="btnimg"><img src="/images/sub/btn_p_prev.gif" width="16" height="16"></span>            
				</c:when>
				<c:otherwise>
					<span class="btnimg"><img src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>            
				</c:otherwise>         
		</c:choose>
		<c:choose>
			<c:when test="${paging.startPage gt 1}">
				<span onclick="goToPageByNum(${paging.startPage-1})" class="btnimg"><img src="/images/sub/btn_prev.gif" width="16" height="16"></span>              
			</c:when>
			<c:otherwise>
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
			</c:when>
			<c:otherwise>
				<span class="btnimg"><img src="/images/sub/btn_next01.gif" width="16" height="16"></span>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${paging.totalPage gt paging.currentPage }">
				<span class="btnimg" onclick="goToPageByNum(${paging.totalPage})"><img src="/images/sub/btn_n_next.gif" width="16" height="16"></span>
			</c:when>
			<c:otherwise>
				<span class="btnimg"><img src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</c:if>
