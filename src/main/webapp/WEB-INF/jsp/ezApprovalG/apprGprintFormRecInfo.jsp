<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<HTML>
	<HEAD>
		<TITLE></TITLE>
		
		
		<META content="text/html; charset=utf-8" http-equiv="Content-Type">
		<META content="MSHTML 5.00.2920.0" name="GENERATOR">
		<STYLE>P { MARGIN-BOTTOM: 2px; MARGIN-TOP: 2px }</STYLE>
	</HEAD>
	<BODY topMargin="10" free kaoni bgcolor="#ffffff">
		<TABLE border="0" borderColorDark="white" borderColorLight="#ddd" cellPadding="0" cellSpacing="0"
			width="635" class="FIELD" id="table1" style="MARGIN:10px">
			<TR>
				<TD align="center">
					<b><FONT SIZE="5"><spring:message code='ezApprovalG.t858'/></FONT></b></TD>
			</TR>
		</TABLE>
		<table width="420" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td><b><spring:message code='ezApprovalG.t825'/></b></td>
			</tr>
		</table>
		<TABLE border="1" borderColorDark="#ffffff" borderColorLight="#ddd" cellPadding="0"
			cellSpacing="0" width="640" style=" PADDING-LEFT:5px; FONT-SIZE:9pt; PADDING-TOP:4px">
			<tr>
				<td height="23" width="85" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t106'/></td>
				<td id="tdTitle" colspan="3" bgcolor="#ffffff">${title}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t859'/></td>
				<td id="tdClassNo" colspan="3" bgcolor="#ffffff">${regType}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t827'/></td>
				<td id="tdDeptName" colspan="3" bgcolor="#ffffff">${deptName}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t860'/></td>
				<td id="tdTaskName" width="180" bgcolor="#ffffff">${regNo}</td>
				<td width="85" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t861'/></td>
				<td id="tdProduceY" width="180" bgcolor="#ffffff">${sepAttachNo}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t445'/></td>
				<td id="tdRegSN" width="180" bgcolor="#ffffff">${drafter}</td>
				<td bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t862'/></td>
				<td id="tdVolNo" width="180" bgcolor="#ffffff">${aprMember}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t831'/></td>
				<td id="tdRegDate" colspan="3" bgcolor="#ffffff">${regDate}</td>
			</tr>
		</TABLE>
		<BR>
		<p><FONT SIZE="3"><b><spring:message code='ezApprovalG.t832'/></b></FONT></p>
		<TABLE border="1" borderColorDark="#ffffff" borderColorLight="#ddd" cellPadding="0"
			cellSpacing="0" width="640" style=" PADDING-LEFT:5px; FONT-SIZE:9pt; PADDING-TOP:4px">
			<tr>
				<td height="23" bgcolor="#f7f7f7" width="110">
					<spring:message code='ezApprovalG.t863'/></td>
				<td id="tdNumOfRec" colspan="3" bgcolor="#ffffff">&nbsp;${executeDate}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t864'/></td>
				<td id="tdNumOfPage" colspan="3" bgcolor="#ffffff">&nbsp;${receiptMember}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t865'/></td>
				<td id="tdDeliveryNo" width="180">&nbsp;${deliveryNo}</td>
				<td bgcolor="#f7f7f7" width="110"><spring:message code='ezApprovalG.t866'/></td>
				<td id="tdProduceNum" width="180">&nbsp;${produceDeptSn}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t836'/></td>
				<td id="tdModifyFlag" width="180" bgcolor="#ffffff">&nbsp;
					<c:if test="${modifyFlag==0}">
					N
					</c:if>
					<c:if test="${modifyFlag!=0}">
					Y
					</c:if>
				</td>
				<td bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t867'/></td>
				<td id="tdRejectFlag" width="180" bgcolor="#ffffff">&nbsp;
					<c:if test="${rejectFalge==0}">
					N
					</c:if>
					<c:if test="${rejectFalge!=0} }">
					Y
					</c:if>
				</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t868'/></td>
				<td id="tdElecFlag" width="180" bgcolor="#ffffff">&nbsp;
					<c:if test="${electronicFlag==1}">
					Y
					</c:if>
					<c:if test="${electronicFlag!=1} }">
					N
					</c:if>
				</td>
				<td bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t837'/></td>
				<td id="tdOldFlag" width="180" bgcolor="#ffffff">&nbsp;
					<c:if test="${oldFlag==1}">
					N
					</c:if>
					<c:if test="${oldFlag!=1} }">
					Y
					</c:if>
				</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t869'/></td>
				<td id="tdOldCreateOrgan" width="180" bgcolor="#ffffff">&nbsp;
					${oldProduceDept}
				</td>
				<td bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t870'/></td>
				<td id="tdOldDocNumber" width="180" bgcolor="#ffffff">&nbsp;
					${oldRecNo}
				</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t871'/></td>
				<td id="tdOldDept" colspan="3" bgcolor="#ffffff">&nbsp;${oldRecKp}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t872'/></td>
				<td id="tdOldClassNo1" colspan="3" bgcolor="#ffffff">&nbsp;${avSummary}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t873'/></td>
				<td id="tdOldClassNo2" colspan="3" bgcolor="#ffffff">&nbsp;${avType}</td>
			</tr>
		</TABLE>
		<BR>
		<p><FONT SIZE="3"><b><spring:message code='ezApprovalG.t840'/></b></FONT></p>
		<TABLE border="1" borderColorDark="#ffffff" borderColorLight="#ddd" cellPadding="0"
			cellSpacing="0" width="640" style=" PADDING-LEFT:5px; FONT-SIZE:9pt; PADDING-TOP:4px">
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23" width="110">
					<spring:message code='ezApprovalG.t819'/></td>
				<td id="tdEndY" colspan="3">&nbsp;${cabClassID}</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23"><spring:message code='ezApprovalG.t874'/></td>
				<td id="tdKeepPeriod" colspan="3">&nbsp;${cabTitle}</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23"><spring:message code='ezApprovalG.t875'/></td>
				<td id="tdKeepMethod" colspan="3">&nbsp;${specialRecCode}
			</tr>
			<%-- 2021-10-14 홍승비 - 기록물 등록정보 출력 시 대민공개(공개/비공개/부분공개)와 공개여부(공개/비공개) 분리, 기록물 등록정보창과 출력창의 표출방식 통일 --%>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23"><spring:message code='ezApprovalG.kes06'/></td>
				<td id="tdPublic" colspan="3">
				<c:choose>
					<c:when test="${publicCode == 'ALL'}">
						&nbsp;<spring:message code='ezApprovalG.t47'/>
					</c:when>
					<c:when test="${publicCode == 'LINE'}">
						&nbsp;<spring:message code='ezApprovalG.t46'/>
					</c:when>
					<c:otherwise>
						&nbsp;<spring:message code='ezApprovalG.t150'/>
					</c:otherwise>
				</c:choose>
				</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23"><spring:message code='ezApprovalG.t109'/></td>
				<td id="tdPublicYn" colspan="3">
				<c:choose>
					<c:when test="${publicCode2 == 'N'}">
						&nbsp;<spring:message code='ezApprovalG.kmh05'/>
					</c:when>
					<c:when test="${publicCode2 == 'B'}">
						&nbsp;<spring:message code='ezApprovalG.kmh04'/>
					</c:when>
					<c:otherwise>
						&nbsp;<spring:message code='ezApprovalG.kmh03'/>
					</c:otherwise>
				</c:choose>
				</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23"><spring:message code='ezApprovalG.t876'/></td>
				<td id="tdDispEndD" colspan="3">&nbsp;${limitRange}</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23"><spring:message code='ezApprovalG.t845'/></td>
				<td id="tdDispReason" colspan="3">&nbsp;
					<c:if test="${confirmFlag==0}">
					N
					</c:if>
					<c:if test="${confirmFlag!=0} }">
					Y
					</c:if>
				</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23"><spring:message code='ezApprovalG.t846'/></td>
				<td id="tdCataTransFlag" width="170">&nbsp;
					<c:if test="${catatransFlag==0}">
					N
					</c:if>
					<c:if test="${catatransFlag!=0} }">
					Y
					</c:if>
				</td>
				<td bgcolor="#f7f7f7" width="80"><spring:message code='ezApprovalG.t847'/></td>
				<td id="tdCataTransYear" width="170">&nbsp;${catatransYear}</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23"><spring:message code='ezApprovalG.t848'/></td>
				<td id="tdFileTransFlag" width="170">&nbsp;
						<c:if test="${docTransFlag==0}">
					N
					</c:if>
					<c:if test="${docTransFlag!=0} }">
					Y
					</c:if>
				</td>
				<td bgcolor="#f7f7f7"><spring:message code='ezApprovalG.t849'/></td>
				<td id="tdFileTransYear" width="170">&nbsp;${docTransYear}</td>
			</tr>
		</TABLE>
		<br>
	</BODY>
</HTML>
