<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t858' /></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/viewRecInfo_Cross.js')}"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var CompanyID = "<c:out value='${userInfo.companyID}'/>";
    var strLang = "<c:out value='${userInfo.lang}'/>";
    var OrderCell = "";
</script>
</head>
<body class="popup" onload = "return window_onload()" style="overflow-x:hidden; overflow-y:auto; margin-bottom:7px;">
<div id="menu">
	<ul>
		<li style="margin:2px 0px 19px 0px;"><span class="icon16 popup_icon16_print" onClick="return btnPrint_onclick()"></span></li> 
	</ul>
</div>
<div id="close"><ul><li id="btnClose" ><span onClick="return btnClose_onclick()"></span></li></ul></div>
<table class="content">
	<tr>
		<th style="padding-right: 82px;"><spring:message code='ezApprovalG.t106'/></th>
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
		<td id="tdRegNo" style="width:200px;white-space:nowrap">&nbsp;</td>
		<th style="width:105px"><spring:message code='ezApprovalG.t861'/></th>
		<td id="tdSepAttNo" style="width:200px;white-space:nowrap">&nbsp;</td>
	</tr>
	<tr> 
		<th><spring:message code='ezApprovalG.t445'/></th>
		<td id="tdDrafter" style="width:200px;white-space:pre-wrap;">&nbsp;</td>
		<th><spring:message code='ezApprovalG.t862'/></th>
		<td id="tdApprover" style="width:200px;white-space:pre-wrap;">&nbsp;</td>
	</tr>
	<tr> 
		<th><spring:message code='ezApprovalG.t831'/></th>
		<td id="tdRegDate" colspan=3 >&nbsp;&nbsp;</td>
	</tr>
</table>
<br>
<div class="portlet_tabpart01" style="margin:0px;">
	<div class="portlet_tabpart01_top" style="border-bottom:0px;">
		<p id="tab_ViewRec0"><span onclick="MM_swapImagesub('0'); tab_onclick('0')" class="tabon"><spring:message code='ezApprovalG.t832'/></span>
		</p>
		<p id="tab_ViewRec1"><span onclick="MM_swapImagesub('1'); tab_onclick('1')"><spring:message code='ezApprovalG.t840'/></span>
		</p>
		<p id="tab_ViewRec2"><span onclick="MM_swapImagesub('2'); tab_onclick('2')"><spring:message code='ezApprovalG.t94'/></span>
		</p>
	</div>
</div>
<div ID="divTabDis1" style="DISPLAY: block; WIDTH:100%; HEIGHT: 265px;"> 
	<table class="content" style="width:100%; height: 100%;">
		<tr> 
			<th><spring:message code='ezApprovalG.t979'/></th>
			<td id="tdNumOfPage" style="width:200px; white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t865'/></th>
			<td id="tdDeliveryNo" style="width:200px; white-space:nowrap;">&nbsp;</td>
		</tr>
		<tr> 
			<th id="tdReceiptTitle"><spring:message code='ezApprovalG.t864'/></th>
			<td id="tdReceipt" style="width:200px;white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t1182'/></th>
			<td id="tdProdRegNo" style="width:200px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t863'/></th>
			<td id="tdExeDate"  style="width:200px;white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t837'/></th>
			<td id="tdOldFlag"  style="width:200px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t836'/></th>
			<td id="tdModifyFlag" style="width:200px;white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t870'/></th>
			<td id="tdOldSN" style="width:200px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t867'/></th>
			<td id="tdRejectFlag" style="width:200px;white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t869'/></th>
			<td id="tdOldProdDept" style="width:200px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t868'/></th>
			<td id="tdElectronic" style="width:200px;white-space:nowrap">&nbsp;</td>
			<th><spring:message code='ezApprovalG.t871'/></th>
			<td id="tdOldKP" style="width:200px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t1183'/></th>
			<td colspan="3">
			    <TextArea id="tdAVSummary" style="Width:98%; height:15px; border:0; resize:none;" readonly ="readonly"></TextArea>
			</td>
		</tr>
		<tr> 
			<th><spring:message code='ezApprovalG.t873'/></th>
			<td id="tdAVType" colspan=3 >&nbsp;</td>
		</tr>
	</table>
</div>
<div ID="divTabDis2" style="DISPLAY: none; WIDTH:100%; HEIGHT: 265px;"> 
	<table class="content" style="width:100%; height: 100%;">
		<tr> 
			<th style="white-space:nowrap; padding-right: 58px;"><spring:message code='ezApprovalG.t819'/></th>
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
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.kes06'/></th>
			<td id="tdPublic" colspan=3 style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.t109'/></th>
			<td id="tdPublicYn" style="padding-right:15px;white-space:nowrap;width:200px">&nbsp;</td>
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.t876'/></th>
			<td id="tdLimit" style="padding-right:15px;white-space:nowrap;width:200px">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap"><spring:message code='ezApprovalG.t845'/></th>
			<td id="tdConfirm" colspan=3 style="padding-right:15px;white-space:nowrap">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap" ><spring:message code='ezApprovalG.t846'/></th>
			<td id="tdCataTransFlag" style="padding-right:15px;white-space:nowrap;width:200px">&nbsp;</td>
			<th style="white-space:nowrap; padding-right: 35px;" ><spring:message code='ezApprovalG.t847'/></th>
			<td id="tdCataTransYear" style="padding-right:15px;white-space:nowrap;width:200px">&nbsp;</td>
		</tr>
		<tr> 
			<th style="white-space:nowrap" ><spring:message code='ezApprovalG.t848'/></th>
			<td id="tdFileTransFlag" style="padding-right:15px;white-space:nowrap;width:200px">&nbsp;</td>
			<th style="white-space:nowrap" ><spring:message code='ezApprovalG.t849'/></th>
			<td id="tdFileTransYear" style="padding-right:15px;white-space:nowrap;width:200px">&nbsp;</td>
		</tr>
	</table>
</div>
<div id="divTabDis3" style="DISPLAY: none; WIDTH:100%; HEIGHT: 265px;"> 
	<table class="content" style="width:100%; height: 100%;">
		<tr> 
			<td id="tdSCInfo">
			<div class="listview" style="width:610px;overflow-x : auto">
            <div id="SCList" style="BEHAVIOR:url('#behave1#ListView');border:0; /* width:950px; */ width:100%; height:230px;" onclick ="" OnSelChanged="" onRowDblClick=""></div></div></td>

		</tr>
	</table>
</div>
<script type="text/javascript" >
	selToggleList(document.getElementById("menu"), "ul", "li", "0");
</script>
</body>
</html>
