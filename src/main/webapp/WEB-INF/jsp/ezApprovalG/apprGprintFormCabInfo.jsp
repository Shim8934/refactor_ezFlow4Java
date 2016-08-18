<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><HTML><HEAD><TITLE></TITLE>



<META content="text/html; charset=utf-8" http-equiv=Content-Type>
<META content="MSHTML 5.00.2920.0" name=GENERATOR>
<STYLE>P {MARGIN-BOTTOM: 2px; MARGIN-TOP: 2px}</STYLE>
</HEAD>
<BODY bgcolor="#FFFFFF" leftmargin="30" topmargin="10" free kaoni>
<TABLE border=0  cellPadding=0 cellSpacing=0  width=640  class="FIELD" id="table1" >
	<TR> <TD align="center" > <b><FONT SIZE=5 >${STRGet_t816}</FONT></b></TD> </TR>
</TABLE>
<table width="420" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td ><b>${STRGet_t825}</b></td>
  </tr>
</table>
<TABLE border=1 borderColorDark=ffffff borderColorLight=#B6B6B6 cellPadding=0 cellSpacing=0 width=640 style=" font-size:9pt; padding-left:5;padding-top:4; ">
  <tr  > 
    <td bgcolor="f7f7f7" width="85" height="23">${STRGet_t106}</td>
    <td  id="tdTitle" colspan=3 bgcolor="ffffff">&nbsp;${title}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23">${STRGet_t819}</td>
    <td  id="tdClassNo" colspan=3 bgcolor="ffffff">&nbsp;${cabClassID}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23">${STRGet_t826}</td>
    <td  id="tdRecType" colspan=3 bgcolor="ffffff">&nbsp;${recType}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23">${STRGet_t827}</td>
    <td  id="tdDeptName" colspan=3 bgcolor="ffffff">&nbsp;${deptName}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23">${STRGet_t828}</td>
    <td  id="tdTaskName" width=180 bgcolor="ffffff">&nbsp;${taskName}</td>
    <td bgcolor="f7f7f7" width="80">${STRGet_t829}</td>
    <td  id="tdProduceY" bgcolor="ffffff">&nbsp;${produceY}</td>
  </tr>
  <tr > 
    <td    bgcolor="f7f7f7" height="23">${STRGet_t830}</td>
    <td  id="tdRegSN" width=180 bgcolor="ffffff">&nbsp;${regSn}</td>
    <td bgcolor="f7f7f7">${STRGet_t573}</td>
    <td  id="tdVolNo" bgcolor="ffffff">&nbsp;${volNo}</td>
  </tr>
  <tr > 
    <td   bgcolor="f7f7f7" height="23">${STRGet_t831}</td>
    <td  id="tdRegDate" colspan=3 bgcolor="ffffff">&nbsp;${regDate}</td>
  </tr>
</table>
<BR>

<table width="420" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td ><b>${STRGet_t832}</b></td>
  </tr>
</table>
<TABLE border=1 borderColorDark=ffffff borderColorLight=#B6B6B6 cellPadding=0 cellSpacing=0 width=640 style=" font-size:9pt; padding-left:5;padding-top:4; ">
  <tr  > 
    <td bgcolor="f7f7f7" width="100" height="23" >${STRGet_t833}</td>
    <td  id="tdNumOfRec"  colspan=3 bgcolor="ffffff">&nbsp;${numOfRec}</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t834}</td>
    <td  id="tdNumOfPage" colspan=3 bgcolor="ffffff">&nbsp;${numOfPage}</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t835}</td>
    <td  id="tdNumOfElec" colspan=3 bgcolor="ffffff">&nbsp;${numOfFile}</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t836}</td>
    <td  id="tdModifyFlag" colspan=3 bgcolor="ffffff">&nbsp;
		  <c:if test="${modifyFlag == '0'}">
			N
		  </c:if>
		  <c:if test="${modifyFlag != '0'}">
			Y
		  </c:if>
	</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t837}</td>
    <td  id="tdOldFlag" colspan=3 bgcolor="ffffff">&nbsp;
		<c:if test="${oldFlag == '1'}">
			N
		</c:if>
		<c:if test="${oldFlag != '1'}">
			Y
        </c:if>
	</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t838}</td>
    <td  id="tdOldDept" colspan=3 bgcolor="ffffff">&nbsp;${oldCreateOrgan}</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t839}</td>
    <td  id="tdOldClassNo" colspan=3 bgcolor="ffffff">&nbsp;${oldClassNo}</td>
  </tr>
</table>
<BR>

<table width="420" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td ><b>${STRGet_t840}</b></td>
  </tr>
</table>
<TABLE border=1 borderColorDark=ffffff borderColorLight=#B6B6B6 cellPadding=0 cellSpacing=0 width=640 style=" font-size:9pt; padding-left:5;padding-top:4; ">
  <tr  > 
    <td bgcolor="f7f7f7" width="100" height="23" >${STRGet_t841}</td>
    <td  id="tdEndY"  colspan=3 bgcolor="ffffff">&nbsp;${endY}</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t117}</td>
    <td  id="tdKeepPeriod" colspan=3 bgcolor="ffffff">&nbsp;${keepPeriod}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t599}</td>
    <td  id="tdKeepMethod" colspan=3 bgcolor="ffffff">&nbsp;${keepMethod}</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t600}</td>
    <td  id="tdKeepPlace" colspan=3 bgcolor="ffffff">&nbsp;${keepPlace}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t842}</td>
    <td  id="tdDispEndD" colspan=3 bgcolor="ffffff">&nbsp;${dispEndDate}</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t843}</td>
    <td  id="tdDispReason" colspan=3 bgcolor="ffffff">&nbsp;${dispReason}</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t844}</td>
    <td  id="tdCharger" colspan=3 bgcolor="ffffff">&nbsp;${cabCharger}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t845}</td>
    <td  id="tdConfirm" colspan=3 bgcolor="ffffff">&nbsp;
		<c:if test="${confirmFlag == '0'}">
			N
		</c:if>
		<c:if test="${confirmFlag != '0'}">
			Y
		</c:if>
	</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t846}</td>
    <td  id="tdCataTransFlag" width=170 bgcolor="ffffff">&nbsp;
		 <c:if test="${cataTransFlag == '0'}">
			N
		</c:if>
		<c:if test="${cataTransFlag != '0'}">
			Y
		 </c:if>
	</td>
    <td bgcolor="f7f7f7" width="85" >${STRGet_t847}</td>
    <td  id="tdCataTransYear" bgcolor="ffffff">&nbsp;${cataTransYear}</td>
  </tr>
  <tr  > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t848}</td>
    <td  id="tdFileTransFlag" width=170 bgcolor="ffffff">&nbsp;
		 <c:if test="${docTransFlag == '0'}">
			N
		  </c:if>
		  <c:if test="${docTransFlag != '0'}">
			Y
		  </c:if>
	</td>
    <td bgcolor="f7f7f7" >${STRGet_t849}</td>
    <td  id="tdFileTransYear" bgcolor="ffffff">&nbsp;${docTransYear}</td>
  </tr>
</table>
<br>

<table width="420" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td ><b>${STRGet_t850}</b></td>
  </tr>
</table>
<TABLE border=1 borderColorDark=ffffff borderColorLight=#B6B6B6 cellPadding=0 cellSpacing=0 width=640 style=" font-size:9pt; padding-left:5;padding-top:4; ">
  <tr  > 
    <td bgcolor="f7f7f7" width="100" height="23" >${STRGet_t851}</td>
    <td  id="tdTransfer"  colspan="3" bgcolor="ffffff">&nbsp;
		    <c:if test="${cabTransFlag == '0'}">
			${STRGet_t852}
			</c:if>
			<c:if test="${cabTransFlag == '1'}">
			${STRGet_t853}
			</c:if>
			<c:if test="${cabTransFlag == '2'}">
			${STRGet_t574}
			</c:if>
			<c:if test="${cabTransFlag !='0' && cabTransFlag !='1' &&cabTransFlag !='2'}">
			${STRGet_t852}
			</c:if>
</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t854}</td>
    <td  id="tdTransDate" colspan="3" bgcolor="ffffff">&nbsp;${transDate}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t855}</td>
    <td  id="tdTDeptName" width=170 bgcolor="ffffff">&nbsp;${tDeptName}</td>
    <td bgcolor="f7f7f7" width="85" >${STRGet_t856}</td>
    <td  id="tdTDeptCode" bgcolor="ffffff">&nbsp;${tDeptCode}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t577}</td>
    <td  id="tdTTaskName" width=170 bgcolor="ffffff">&nbsp;${tTaskName}</td>
    <td bgcolor="f7f7f7" >${STRGet_t576}</td>
    <td  id="tdTTaskCode" bgcolor="ffffff">&nbsp;${tTaskCode}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t829}</td>
    <td  id="tdTProduceY" colspan="3" bgcolor="ffffff">&nbsp;${tProduceY}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t830}</td>
    <td  id="tdTRegSN" colspan="3" bgcolor="ffffff">&nbsp;${tRegSn}</td>
  </tr>
  <tr > 
    <td bgcolor="f7f7f7" height="23" >${STRGet_t573}</td>
    <td  id="tdTVolNo" colspan="3" bgcolor="ffffff">&nbsp;${tVolNo}</td>
  </tr>
</table>
<br>
</BODY>
</HTML>
