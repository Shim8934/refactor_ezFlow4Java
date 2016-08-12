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
		<TABLE border="0" borderColorDark="white" borderColorLight="#b6b6b6" cellPadding="0" cellSpacing="0"
			width="635" class="FIELD" id="table1" style="MARGIN:10px">
			<TR>
				<TD align="center">
					<b><FONT SIZE="5">${STRGet_t858}</FONT></b></TD>
			</TR>
		</TABLE>
		<table width="420" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td><b>${STRGet_t825}</b></td>
			</tr>
		</table>
		<TABLE border="1" borderColorDark="#ffffff" borderColorLight="#b6b6b6" cellPadding="0"
			cellSpacing="0" width="640" style=" PADDING-LEFT:5px; FONT-SIZE:9pt; PADDING-TOP:4px">
			<tr>
				<td height="23" width="85" bgcolor="#f7f7f7">${STRGet_t106}</td>
				<td id="tdTitle" colspan="3" bgcolor="#ffffff">${title}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t859}</td>
				<td id="tdClassNo" colspan="3" bgcolor="#ffffff">${regType}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t827}</td>
				<td id="tdDeptName" colspan="3" bgcolor="#ffffff">${deptName}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t860}</td>
				<td id="tdTaskName" width="180" bgcolor="#ffffff">${regNo}</td>
				<td width="85" bgcolor="#f7f7f7">${STRGet_t861}</td>
				<td id="tdProduceY" width="180" bgcolor="#ffffff">${sepAttachNo}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t445}</td>
				<td id="tdRegSN" width="180" bgcolor="#ffffff">${drafter}</td>
				<td bgcolor="#f7f7f7">${STRGet_t862}</td>
				<td id="tdVolNo" width="180" bgcolor="#ffffff">${aprMember}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t831}</td>
				<td id="tdRegDate" colspan="3" bgcolor="#ffffff">${regDate}</td>
			</tr>
		</TABLE>
		<BR>
		<p><FONT SIZE="3"><b>${STRGet_t832}</b></FONT></p>
		<TABLE border="1" borderColorDark="#ffffff" borderColorLight="#b6b6b6" cellPadding="0"
			cellSpacing="0" width="640" style=" PADDING-LEFT:5px; FONT-SIZE:9pt; PADDING-TOP:4px">
			<tr>
				<td height="23" bgcolor="#f7f7f7" width="110">
					${STRGet_t863}</td>
				<td id="tdNumOfRec" colspan="3" bgcolor="#ffffff">&nbsp;${executeDate}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t864}</td>
				<td id="tdNumOfPage" colspan="3" bgcolor="#ffffff">&nbsp;${receiptMember}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t865}</td>
				<td id="tdDeliveryNo" width="180">&nbsp;${deliveryNo}</td>
				<td bgcolor="#f7f7f7" width="110">${STRGet_t866}</td>
				<td id="tdProduceNum" width="180">&nbsp;${produceDeptSn}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t836}</td>
				<td id="tdModifyFlag" width="180" bgcolor="#ffffff">&nbsp;
					<c:if test="${modifyFlag==0}">
					N
					</c:if>
					<c:if test="${modifyFlag!=0} }">
					Y
					</c:if>
				</td>
				<td bgcolor="#f7f7f7">${STRGet_t867}</td>
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
				<td height="23" bgcolor="#f7f7f7">${STRGet_t868}</td>
				<td id="tdElecFlag" width="180" bgcolor="#ffffff">&nbsp;
					<c:if test="${electronicFlag==1}">
					Y
					</c:if>
					<c:if test="${electronicFlag!=1} }">
					N
					</c:if>
				</td>
				<td bgcolor="#f7f7f7">${STRGet_t837}</td>
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
				<td height="23" bgcolor="#f7f7f7">${STRGet_t869}</td>
				<td id="tdOldCreateOrgan" width="180" bgcolor="#ffffff">&nbsp;
					${oldProduceDept}
				</td>
				<td bgcolor="#f7f7f7">${STRGet_t870}</td>
				<td id="tdOldDocNumber" width="180" bgcolor="#ffffff">&nbsp;
					${oldRecNo}
				</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t871}</td>
				<td id="tdOldDept" colspan="3" bgcolor="#ffffff">&nbsp;${STRGet_t871}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t872}</td>
				<td id="tdOldClassNo1" colspan="3" bgcolor="#ffffff">&nbsp;${OLDRECKP}</td>
			</tr>
			<tr>
				<td height="23" bgcolor="#f7f7f7">${STRGet_t873}</td>
				<td id="tdOldClassNo2" colspan="3" bgcolor="#ffffff">&nbsp;${AVSUMMARY}</td>
			</tr>
		</TABLE>
		<BR>
		<p><FONT SIZE="3"><b>${STRGet_t840}</b></FONT></p>
		<TABLE border="1" borderColorDark="#ffffff" borderColorLight="#b6b6b6" cellPadding="0"
			cellSpacing="0" width="640" style=" PADDING-LEFT:5px; FONT-SIZE:9pt; PADDING-TOP:4px">
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23" width="110">
					${STRGet_t819}</td>
				<td id="tdEndY" colspan="3">&nbsp;${AVTYPE}</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23">${STRGet_t874}</td>
				<td id="tdKeepPeriod" colspan="3">&nbsp;${cabTitle}</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23">${STRGet_t875}</td>
				<td id="tdKeepMethod" colspan="3">&nbsp;${specialRecCode}
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23">${STRGet_t109}</td>
				<td id="tdKeepPlace" colspan="3">&nbsp;${publicCode}</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23">${STRGet_t876}</td>
				<td id="tdDispEndD" colspan="3">&nbsp;${limitRange}</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23">${STRGet_t845}</td>
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
				<td bgcolor="#f7f7f7" height="23">${STRGet_t846}</td>
				<td id="tdCataTransFlag" width="170">&nbsp;
					<c:if test="${catatransFlag==0}">
					N
					</c:if>
					<c:if test="${catatransFlag!=0} }">
					Y
					</c:if>
				</td>
				<td bgcolor="#f7f7f7" width="80">${STRGet_t847}</td>
				<td id="tdCataTransYear" width="170">&nbsp;${catatransYear}</td>
			</tr>
			<tr bgcolor="#ffffff">
				<td bgcolor="#f7f7f7" height="23">${STRGet_t848}</td>
				<td id="tdFileTransFlag" width="170">&nbsp;
						<c:if test="${docTransFlag==0}">
					N
					</c:if>
					<c:if test="${docTransFlag!=0} }">
					Y
					</c:if>
				</td>
				<td bgcolor="#f7f7f7">${STRGet_t849}</td>
				<td id="tdFileTransYear" width="170">&nbsp;${docTransYear}</td>
			</tr>
		</TABLE>
		<br>
	</BODY>
</HTML>
