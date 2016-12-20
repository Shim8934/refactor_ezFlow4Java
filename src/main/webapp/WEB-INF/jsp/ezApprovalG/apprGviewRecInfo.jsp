<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t858' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezStatistics.e2' />" type="text/css" />
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/viewRecInfo_Cross.js"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var CompanyID = "${userInfo.companyID}";
    var strLang = "${userInfo.lang}";
    var OrderCell = "";
</script>
</head>
<body class="popup" onload = "return window_onload()">
<div id="menu">
	<ul>
		<li><span onClick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li> 
	</ul>
</div>
<div id="close"><ul><li id="btnClose" ><span onClick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li></ul></div>
<table class="content">
	<tr>
		<th><spring:message code='ezApprovalG.t106'/></th>
		<td id="tdTitle" colspan=3 >&nbsp;</td>
	</tr>
	<tr> 
		<th><spring:message code='ezApprovalG.t859'/></th>
		<td id="tdRegType" colspan=3 >&nbsp;</td>
	</tr>
	<tr> 
		<th><spring:message code='ezApprovalG.t827'/></th>
		<td id="tdDeptName" colspan=3 >&nbsp;</td>
	</tr>
	<tr> 
		<th><spring:message code='ezApprovalG.t860'/></th>
		<td id="tdRegNo" style="width:200px;padding-right:15px;white-space:nowrap">&nbsp;</td>
		<th style="width:80px"><spring:message code='ezApprovalG.t861'/></th>
		<td id="tdSepAttNo" style="width:200px;padding-right:15px;white-space:nowrap">&nbsp;</td>
	</tr>
	<tr> 
		<th><spring:message code='ezApprovalG.t445'/></th>
		<td id="tdDrafter" style="width:200px;padding-right:15px;white-space:nowrap">&nbsp;</td>
		<th style="width:80px"><spring:message code='ezApprovalG.t862'/></th>
		<td id="tdApprover" style="width:200px;padding-right:15px;white-space:nowrap">&nbsp;</td>
	</tr>
	<tr> 
		<th><spring:message code='ezApprovalG.t831'/></th>
		<td id="tdRegDate" colspan=3 >&nbsp;&nbsp;</td>
	</tr>
</table>
<br>
<div id="tabnav">
	<ul>
		<li id="tab_ViewRec0"><span onclick ="MM_swapImagesub('0'); tab_onclick('0')" ><spring:message code='ezApprovalG.t832'/></span></li>
		<li id="tab_ViewRec1"><span onclick ="MM_swapImagesub('1'); tab_onclick('1')" ><spring:message code='ezApprovalG.t840'/></span></li>
		<li id="tab_ViewRec2"><span onclick ="MM_swapImagesub('2'); tab_onclick('2')" ><spring:message code='ezApprovalG.t94'/></span></li>
	</ul>
</div>
<div ID="divTabDis1" style="DISPLAY: block; WIDTH:100%; HEIGHT: 215px;"> 
	<table class="content">
		<tr> 
			<th style="width:200px"><spring:message code='ezApprovalG.t979'/></th>
			<td id="tdNumOfPage"  style="padding-right:15px;width:100px;white-space:nowrap">&nbsp;</td>
			<th style="width:200px"><spring:message code='ezApprovalG.t865'/></th>
			<td style="width:100px;white-space:nowrap;padding-right:15px;" id="tdDeliveryNo">&nbsp;</td>
		</tr>
		<tr> 
			<th id="tdReceiptTitle"><spring:message code='ezApprovalG.t864'/></th>
			<td id="tdReceipt" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t1182'/></th>
			<td id="tdProdRegNo" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t863'/></th>
			<td id="tdExeDate"  style="padding-right:15px;white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t837'/></th>
			<td id="tdOldFlag"  style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t836'/></th>
			<td id="tdModifyFlag" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
			<th style="width:110px"><spring:message code='ezApprovalG.t870'/></th>
			<td id="tdOldSN" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t867'/></th>
			<td id="tdRejectFlag" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t869'/></th>
			<td id="tdOldProdDept" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t868'/></th>
			<td id="tdElectronic" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t871'/></th>
			<td id="tdOldKP" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t1183'/></th>
			<td colspan="3">
			    <TextArea id="tdAVSummary" style="Width:98%; height:40px" readonly ="readonly"></TextArea>
			</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t873'/></th>
			<td id="tdAVType" colspan=3 >&nbsp;</td>
		</tr>
	</table>
</div>
<div ID="divTabDis2" style="DISPLAY: none; HEIGHT: 215px; border:0;"> 
	<table class="content">
		<tr> 
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.t819'/></th>
			<td id="tdClassNo" colspan=3 style="padding-right:15px;white-space:nowrap">&nbsp;&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.t874'/></th>
			<td id="tdCabName" colspan=3 style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.t875'/></th>
			<td id="tdSpecialRec" colspan=3 style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.t109'/></th>
			<td id="tdPublic" colspan=3 style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.t876'/></th>
			<td id="tdLimit" colspan=3 style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.t845'/></th>
			<td id="tdConfirm" colspan=3 style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap" ><spring:message code='ezApprovalG.t846'/></th>
			<td id="tdCataTransFlag" style="padding-right:15px;white-space:nowrap;width:200px">&nbsp;</td>
			<th style="white-space:nowrap" ><spring:message code='ezApprovalG.t847'/></th>
			<td id="tdCataTransYear" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap" ><spring:message code='ezApprovalG.t848'/></th>
			<td id="tdFileTransFlag" style="padding-right:15px;white-space:nowrap;width:200px">&nbsp;</td>
			<th style="white-space:nowrap" ><spring:message code='ezApprovalG.t849'/></th>
			<td id="tdFileTransYear" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
	</table>
</div>
<div ID="divTabDis3" style="DISPLAY: none; HEIGHT: 215px;"> 
	<table class="content">
		<tr> 
			<td id=tdSCInfo>
			<div class="listview" style="width:605px;overflow-x : auto">
                <div id="SCList"  style="border:0;Width:950px;Height:189px; OVERFLOW-Y:AUTO;" ></div>
            </div></td>
		</tr>
	</table>
</div>
<script type="text/javascript" >
	selToggleList(document.getElementById("menu"), "ul", "li", "0");
	selToggleList(document.getElementById("close"), "ul", "li", "0");
	selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
</script>
</body>
</html>
