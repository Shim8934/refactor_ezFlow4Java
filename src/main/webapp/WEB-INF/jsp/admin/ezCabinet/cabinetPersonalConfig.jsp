<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezCabinet.t10'/><span id="cabinetTtlInf"></span></h1>
		<div class="cabiMain">
			<div class="compSelect" id="companySelect">
				<span><b><spring:message code='ezCabinet.t13'/></b></span>
				<select id="companyList">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<div id="mainmenu">
				<ul>
					<li><a><span><spring:message code='ezCabinet.t48' /></span></a></li>
					<li><a><span><spring:message code='ezCabinet.t49' /></span></a></li>
					<li><a><span><spring:message code='ezCabinet.t108'/></span></a></li>
					<li id="right"><img src="/images/kr/cm/btn_arrow_down.gif" role="off" id="sltView"></li>
				</ul>
			</div>
			
			<div id="layerPopup" class="cabViewPopup" style="left: 0px; top: 0px; display: none;">
				<div class="popupwrap1">
					<div class="popupwrap2">
						<table class="list_element cabinet">
							<colgroup><col class="cabcol"><col></colgroup>
							<tr>
								<th class="cabTitle"><spring:message code='ezCabinet.t92'/></th>
								<td> 
									<select id="listcount">
										<option value="10" ${cabinetGeneral.listCount == '10' ? 'selected' : ''}>10</option>
										<option value="20" ${cabinetGeneral.listCount == '20' ? 'selected' : ''}>20</option>
										<option value="30" ${cabinetGeneral.listCount == '30' ? 'selected' : ''}>30</option>
										<option value="40" ${cabinetGeneral.listCount == '40' ? 'selected' : ''}>40</option>
										<option value="50" ${cabinetGeneral.listCount == '50' ? 'selected' : ''}>50</option>
									</select>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div class="shadow"></div>
			</div>
			
			<div id="mainSetting" style="margin: 10px 0px; height: 500px; overflow: auto;">
				<table class="mainlist cabTbl" id="userCapacityTbl">
					<tr>
						<th width="20px"><input type="checkbox"></th>
						<th headers="cn" style="width: 20%;"><spring:message code='ezWebFolder.t146'/></th>
						<th headers="dn" style="width: 20%;"><spring:message code='ezWebFolder.t142'/></th>
						<th headers="un" style="width: 20%;"><spring:message code='ezWebFolder.t143'/></th>
						<th headers="ut" style="width: 5%;" ><spring:message code='ezWebFolder.t147'/></th>
						<th              style="text-align: center; width: 8%;"><spring:message code='ezWebFolder.t148'/></th>
						<th headers="tc" style="text-align: center; width: 8%;"><spring:message code='ezWebFolder.t149'/></th>
						<th              style="text-align: center; width: 15%;"><spring:message code='ezWebFolder.t150'/></th>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="tblPageRayer"></div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"                     ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetNavi.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTable.js"          ></script>
		<script type="text/javascript">
			(function() {
				var cabinetTable = null;
				var cabinetNavi  = null;
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
				initEvents();
				
				function initEvents() {
					document.onselectstart = function() {return false;};
					window.addEventListener("resize", function(e) {windowResize();}, false);
					
					var libttns = document.getElementById("mainmenu").firstElementChild.children;
					libttns[0].firstElementChild.onclick  = function() {refreshView();};
					libttns[1].firstElementChild.onclick  = function() {toggleSearchPanel();};
					libttns[2].firstElementChild.onclick  = function() {toggleChangePanel();};
					
					var optionViewElmt     = document.getElementById("sltView");
					optionViewElmt.addEventListener("click", function(e) {toggleOptionView(this);}, false);
					
					var selectCompBox      = document.getElementById("companyList");
					selectCompBox.onchange = function(e) {};
					
					//Set table view
					cabinetTable = new CabinetTable({
						normal   : "bnkCabNormal",
						selected : "bnkCabSelect"
					});
					
					cabinetTable.setTableElement("userCapacityTbl", "id");
					cabinetTable.setTableType("capacity");
					cabinetTable.setCallBack(searchCallBack);
					cabinetTable.setRenderFunct(renderTable);
					
					//Initial page navigation
					var naviMessages = {
						next     : CabinetMessages.strNext,
						previous : CabinetMessages.strPrev,
						item     : CabinetMessages.strItem,
						total    : CabinetMessages.strTotal
					};
					
					cabinetNavi = new CabinetNavi({
						messages : naviMessages,
						divId    : "tblPageRayer",
						divClass : "pagenavi",
						headerId : "cabinetTtlInf",
						callback : startSearchCabinet
					});
				}
				
				function startSearch(pPage) {
					var orderInf = cabinetTable.getOrderInfo();
					var url      = "/admin/ezWebFolder/getCapacities.do";
					
					makeAjaxCall ();
					
					
					$.ajax({
						type: "POST",
						url: "/admin/ezWebFolder/getCapacities.do",
						data: {
							"currentPage" : pPage,
							"searchStr"   : searchStr,
							"searchOpt"   : searchOpt,
							"column"      : orderInf.col ? orderInf.col : "",
							"order"       : orderInf.ord ? orderInf.ord : "",
							"companyId"   : document.getElementById("companyList").value
						},
						dataType: "JSON",
						async: true,
						success : function(data) {
						},
						error : function(error) {
							hideProgress();
							alert("<spring:message code='ezWebFolder.t134'/>" + error);
						}
					});
				}
				
				function searchCallBack() {
					//*Note here
				}
				
				function getUserCapacities() {
					var url  = "/admin/ezCabinet/getCompanyCapacity.do";
					var data = {companyId : document.getElementById("companyList").value};
					makeAjaxCall(data, "GET", url, processData, null, true, null);
				}
				
				function toggleOptionView(optElmt) {if (optElmt.getAttribute("role") == "off") {showViewPopUp();} else {closeViewPopUp();}}
				
				function showViewPopUp() {
					var optElmt             = document.getElementById("sltView");
					var viewPopup           = document.getElementById("layerPopup");
					viewPopup.style.left    = document.documentElement.clientWidth - 160 + "px";
					viewPopup.style.top     = "128px";
					viewPopup.style.display = "";
					optElmt.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
					optElmt.setAttribute("role", "on");
				}
				
				function closeViewPopUp() {
					var optElmt = document.getElementById("sltView");
					document.getElementById("layerPopup").style.display = "none";
					optElmt.setAttribute("role", "off");
					optElmt.setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
				}
				
				function windowResize() {closeViewPopUp();}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						success : function(data) {
							handleSuccess(data);
						},
						error : function(error) {
							if (handleError != null) {handleError();}
							
							alert(CabinetMessages.strError);
						}
					});
				}
			})();
		</script>
	</body>
</html>
