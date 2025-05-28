<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style>
	table.mainlist th, table.mainlist td {
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		cursor: pointer;
	}
</style>
<script>
setTotalCount("${projectListCount}");
</script>
<div id="divList" style="width: 100%;">
	<table cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" width="100%" border="0" class="mainlist" style="overflow:hidden">
		<thead id="tableHeader">
			<tr style="height: 37px;" id="BoardList_TH">
				<!-- <th onclick="setListOrder(this)" data-order='PROJECT_ID' style="width:60px; text-align: center;">NO</th> -->
				<th onclick="setListOrder(this)" data-order='PROJECT_NAME' style="width:30%; padding-left:20px;"><spring:message code="ezPMS.t31"/></th>
				<th onclick="setListOrder(this)" data-order='OVERVIEW'><spring:message code="ezPMS.t236"/></th>
				<th onclick="setListOrder(this)" data-order='CREATOR_NAME' style="width:100px;"><spring:message code="ezPMS.t57"/></th>
				<th onclick="setListOrder(this)" data-order='PLAN_START_DATE' style="width:140px;"><spring:message code="ezPMS.t61"/></th>
				<th onclick="setListOrder(this)" data-order='PLAN_END_DATE' style="width:140px;"><spring:message code="ezPMS.t62"/></th>
				<th onclick="setListOrder(this)" data-order='STATUS' style="width:150px;"><spring:message code="ezPMS.t38"/></th>
			</tr>
		</thead>
		<tbody id="tableBody" style="background-color: rgb(255, 255, 255);">
			<c:choose>
				<c:when test="${empty projectList}">
					<tr>
						<td colspan="7" style="text-align : center"> <spring:message code="ezPMS.t30"/> </td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${projectList}" var="projectVO" varStatus="status">
						<tr ondblclick="getProjectGeneralInfo(${projectVO.projectId})">
							<%-- <td style="text-align: center;"><c:out value="${paging.currentPage * 20 - (20 - (status.index + 1))}"/></td> --%>
							<td style="padding-left : 20px;"><c:out value="${projectVO.projectName}"/></td>
							<td><c:out value="${projectVO.overview}"/></td>
							<td><c:out value="${projectVO.creatorName}"/></td>
							<td><c:out value="${fn:substring(projectVO.planStartDate, 0, 19)}"/></td>
							<td><c:out value="${fn:substring(projectVO.planEndDate, 0, 19)}"/></td>
							<td>
								<c:choose>
									<c:when test="${projectVO.status eq 'P'}"><spring:message code="ezPMS.t15"/>(<fmt:formatNumber value="${projectVO.progress}" pattern="0.0"/>%)</c:when>
									<c:when test="${projectVO.status eq 'W'}"><spring:message code="ezPMS.t16"/></c:when>
									<c:when test="${projectVO.status eq 'C'}"><spring:message code="ezPMS.t17"/></c:when>
									<c:when test="${projectVO.status eq 'L'}"><spring:message code="ezPMS.t15"/>/<spring:message code="ezPMS.t18"/>(<fmt:formatNumber value="${projectVO.progress}" pattern="0.0"/>%)</c:when>
									<c:when test="${projectVO.status eq 'S'}"><spring:message code="ezPMS.t19"/>(<fmt:formatNumber value="${projectVO.progress}" pattern="0.0"/>%)</c:when>
									<c:when test="${projectVO.status eq 'D'}"><spring:message code="ezPMS.t11"/></c:when>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>                                                            	
		</tbody>
	</table>	
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