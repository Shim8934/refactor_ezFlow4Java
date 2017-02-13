<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t816'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ViewCabInfo_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var CompanyID = "${userInfo.companyID}";
		    var UserLang = "${userInfo.lang}";
		    var OrderCell="";
		</script>
	</head>
	<body class="popup" onload="return window_onload()">
		<!-- <OBJECT classid=clsid:F8E93A35-2D04-4E2C-A04D-87947594C674 height=0 id=behave1 width=0 style="display:none"></OBJECT>  -->
		<div id="menu">
			<ul>
				<li><span onClick="btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li> 
			</ul>
		</div>
		<div id="close"><ul><li><span onClick="btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li></ul></div>
		<table class="content">
			<tr> 
				<th><spring:message code='ezApprovalG.t106'/></th>
				<td id="tdTitle" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t819'/></th>
				<td id="tdClassNo" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t826'/></th>
				<td id="tdRecType" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t827'/></th>
				<td id="tdDeptName" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t828'/></th>
				<td id="tdTaskName" width="200" nowrap style="padding-right:15px">&nbsp;</td>
				<th><spring:message code='ezApprovalG.t829'/></th>
				<td id="tdProduceY" nowrap style="padding-right:15px">&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t830'/></th>
				<td id="tdRegSN" nowrap style="padding-right:15px">&nbsp;</td>
				<th><spring:message code='ezApprovalG.t573'/></th>
				<td id="tdVolNo" nowrap style="padding-right:15px">&nbsp;</td>
			</tr>
			<tr>
				<th><spring:message code='ezApprovalG.t831'/></th>
				<td id="tdRegDate" colspan=3>&nbsp;&nbsp;</td>
			</tr>
		</table>
		<br>
		<div id="tabnav">
			<ul>
				<li id="tab_ViewCab0"><span onclick ="MM_swapImagesub('0'); tab_onclick('0')" ><spring:message code='ezApprovalG.t832'/></span></li>
				<li id="tab_ViewCab1"><span onclick ="MM_swapImagesub('1'); tab_onclick('1')" ><spring:message code='ezApprovalG.t840'/></span></li>
				<li id="tab_ViewCab2"><span onclick ="MM_swapImagesub('2'); tab_onclick('2')" ><spring:message code='ezApprovalG.t850'/></span></li>
				<li id="tab_ViewCab3"><span onclick ="MM_swapImagesub('3'); tab_onclick('3')" ><spring:message code='ezApprovalG.t94'/></span></li>
			</ul>
		</div>
		<span ID="divTabDis1" style="DISPLAY: OVERFLOW: auto;">
		<table class="content">
			<tr> 
				<th><spring:message code='ezApprovalG.t1180'/></th>
				<td id="tdNumOfRec">&nbsp;&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t834'/></th>
				<td id="tdNumOfPage">&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t835'/></th>
				<td id="tdNumOfElec">&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t836'/></th>
				<td id="tdModifyFlag">&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t837'/></th>
				<td id="tdOldFlag" >&nbsp;</td>
			</tr>
			<tr>       
				<th><spring:message code='ezApprovalG.t838'/></th>
				<td id="tdOldDept">&nbsp;</td>
			</tr>    
			<tr>       
				<th><spring:message code='ezApprovalG.t839'/></th>
				<td id="tdOldClassNo">&nbsp;</td>
			</tr>
		</table>
		</span>
		<span ID="divTabDis2" style="DISPLAY: none;"> 
		<table class="content">
			<tr> 
				<th><spring:message code='ezApprovalG.t841'/></th>
				<td id="tdEndY"  colspan=3>&nbsp;&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t117'/></th>
				<td id="tdKeepPeriod" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t599'/></th>
				<td id="tdKeepMethod" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t600'/></th>
				<td id="tdKeepPlace" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t842'/></th>
				<td id="tdDispEndD" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t843'/></th>
				<td id="tdDispReason" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t844'/></th>
				<td id="tdCharger" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t845'/></th>
				<td id="tdConfirm" colspan=3>&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t846'/></th>
				<td id="tdCataTransFlag" width="200" nowrap style="padding-right:15px">&nbsp;</td>
				<th><spring:message code='ezApprovalG.t847'/></th>
				<td id="tdCataTransYear" nowrap style="padding-right:15px">&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t848'/></th>
				<td id="tdFileTransFlag" width="200" nowrap style="padding-right:15px">&nbsp;</td>
				<th><spring:message code='ezApprovalG.t849'/></th>
				<td id="tdFileTransYear" nowrap style="padding-right:15px">&nbsp;</td>
			</tr>
		</table>
		</span>
		<span ID="divTabDis3" style="DISPLAY: none;">
		<table class="content">
			<tr> 
				<th><spring:message code='ezApprovalG.t851'/></th>
				<td id="tdTransfer" colspan="3">&nbsp;&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t854'/></th>
				<td id="tdTransDate" colspan="3">&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t855'/></th>
				<td id="tdTDeptName" width="200" nowrap style="padding-right:15px">&nbsp;</td>
				<th><spring:message code='ezApprovalG.t856'/></th>
				<td id="tdTDeptCode" nowrap style="padding-right:15px">&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t577'/></th>
				<td id="tdTTaskName" width="200" nowrap style="padding-right:15px">&nbsp;</td>
				<th><spring:message code='ezApprovalG.t576'/></th>
				<td id="tdTTaskCode" nowrap style="padding-right:15px">&nbsp;</td>
			</tr>
				<tr> 
				<th><spring:message code='ezApprovalG.t829'/></th>
				<td id="tdTProduceY" colspan="3">&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t830'/></th>
				<td id="tdTRegSN" colspan="3">&nbsp;</td>
			</tr>
			<tr> 
				<th><spring:message code='ezApprovalG.t573'/></th>
				<td id="tdTVolNo" colspan="3">&nbsp;</td>
			</tr>
		</table>
		</span>
		<span ID="divTabDis4" style="DISPLAY: none;width:100%;"> 
			<table class="content" style="width:100%;">
				<tr>      
					<td id="tdSCInfo">
					<div class="listview" style="width:605px;overflow-x : auto">
					<div ID="SCList" style="BEHAVIOR:url('#behave1#ListView');border:0; width:950px; height:230px;" onclick ="" OnSelChanged="" onRowDblClick=""></div></div></td>
				</tr>
			</table>
		</span>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
			selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
		</script>
	</body>
</html>
