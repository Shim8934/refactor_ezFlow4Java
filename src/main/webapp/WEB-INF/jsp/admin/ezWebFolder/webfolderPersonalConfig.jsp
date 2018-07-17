<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezOrgan.e3'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezWebFolder.e1'/>"></script>
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css"          type="text/css">
		<link rel="stylesheet" href="/css/jquery.lineProgressbar.css"         type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"     ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"                  ></script>
		<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/adminTable.js"       ></script>
		<script type="text/javascript" src="/js/ezWebFolder/popup.js"                       ></script>
		<script type="text/javascript" >
			var blockSize   = 10;
			var searchStr   = "";
			var searchOpt   = "";
			var currentPage = null;
			var totalRows   = null;
			var totalPages  = null;
			var strLang39   = "<spring:message code='ezWebFolder.t135'/>";
			var strLang40   = "<spring:message code='ezWebFolder.t136'/>";
			var strLang41   = "<spring:message code='ezWebFolder.t137'/>";
			var strLang42   = "<spring:message code='ezWebFolder.t138'/>";
			var strNoData   = "<spring:message code='ezWebFolder.t144'/>";
			var tableView   = new TableView();
			
			window.onload = function() {
				closeAllPopup();
				tableView.setTableId("tblFileStorage");
				tableView.setTableType("configTable");
				tableView.setSelectedClass("bnkWebFolder2");
				tableView.setUnselectClass("bnkWebFolder");
				tableView.setCallBack(refreshView);
				search_Set("1");
				preProcessing();
			}
			
			window.onbeforeunload = function() {
				closeAllPopup();
			}
			
			function preProcessing() {
				var divList          = document.getElementById("mainSetting");
				var reheight         = document.documentElement.clientHeight - 190;
				divList.style.height = reheight + "px";
			}
			
			function keyPressPanel(e) {
				if (e.which == 27 && document.getElementById("mailPanel").style.display == "") {openSearchPanel();}
			}
			
			function openSearchPanel() {
				var searchPanel = document.getElementById("searchPanel");
				if (searchPanel.style.display == "none") {
					window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "";
					document.getElementById("mailPanel").style.display                              = "";
					var position              = getPosition(502, 128);
					searchPanel.style.top     = position[0] + "px";
					searchPanel.style.right   = position[1] + "px";
					searchPanel.style.display = "";
				}
				else {
					window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "none";
					document.getElementById("mailPanel").style.display                              = "none";
					searchPanel.style.display = "none";
				}
				
				document.getElementById("inputSearch").value                = "";
				document.getElementById("searchOption").options[0].selected = 'selected';
			}
			
			function closeAllPopups() {
				window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "none";
				document.getElementById("mailPanel").style.display                                 = "none";
				document.getElementById("searchPanel").style.display                               = "none";
			}
			
			function search_Set(pPage) {
				var orderInf = tableView.getOrderInfo();
				showProgress();
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
						hideProgress();
						var reason  = data.reason;
						if (reason) {
							alert(reason);
							return;
						}
						
						var result  = data.capacityList;
						totalRows   = data.totalUsers;
						totalPages  = data.totalPages;
						currentPage = pPage;
						checkedArr  = [];
						
						makePageSelPage();
						renderData(result);
						
					},
					error : function(error) {
						hideProgress();
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function renderData(result) {
				tableView.setDataSource(result);
				tableView.renderTable();
			}
			
			function initProgressBar(barID, color, completerate) {
				completerate = completerate > 100 ? 100 : completerate;
				
				if (completerate == '0') {
					duration = 0;
				}
				else {
					duration = 500;
				}
				
				if (color == '1') {
					$(".bar[usedrate='" + barID + "']").find("div[class=percentCount]").css("color", delayColor);
					$(".bar[usedrate='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: delayColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				} else if (color == '2') {
					$(".bar[usedrate='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: completeColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				} else {
					$(".bar[usedrate='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: '#3498db',
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				}
			}
			
			function change() {
				tableView.clearHeaders();
				searchStr = "";
				searchOpt = "";
				search_Set("1");
			}
			
			function refreshView() {
				search_Set(currentPage);
			}
			
			function startSearch() {
				var inputVal = document.getElementById("inputSearch").value;
				
				if (!inputVal.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t140'/>");
					document.getElementById("inputSearch").value = "";
					document.getElementById("inputSearch").focus;
					return;
				}
				
				searchStr = inputVal;
				searchOpt = document.getElementById("searchOption").value;
				openSearchPanel();
				search_Set("1");
			}
			
			function getSelectedRowInfo() {
				var listOfSelectedRows = document.getElementsByClassName("bnkWebFolder2");
				var userList       = [];
				var usedAmountList = [];
				if (listOfSelectedRows.length == 0) {
					return null;
				}
				
				for (var i = 0; i < listOfSelectedRows.length; i++) {
					userList.push(listOfSelectedRows[i].getAttribute("userId"));
					usedAmountList.push(listOfSelectedRows[i].getAttribute("usedAmount"));
				}
				
				return {userList: userList, usedAmountList: usedAmountList};
			}
			
			function changeStorageVal() {
				var newValue    = document.getElementById("storageVal").value;
				var checkedList = getSelectedRowInfo();
				
				if (checkedList == null) {
					alert("<spring:message code='ezWebFolder.t208'/>");
					document.getElementById("storageVal").value = "";
					document.getElementById("storageVal").focus();
					return;
				}
				
				var userIdList = checkedList["userList"];
				var amountList = checkedList["usedAmountList"];
				
				if (!isValid(newValue)) {
					alert("<spring:message code='ezWebFolder.t207'/>");
					document.getElementById("storageVal").value = "";
					document.getElementById("storageVal").focus();
					return;
				}
				
				for (var i = 0; i < amountList.length; i++) {
					if (parseFloat(amountList[i]) > parseFloat(newValue)*1073741824) {
						alert("<spring:message code='ezWebFolder.t209'/>");
						return;
					}
				}
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/updateCapacities.do",
					data: {
						"userListParam" : userIdList.toString(),
						"companyId"     : document.getElementById("companyList").value,
						"newStorage"    : newValue
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var reason = data.reason;
						
						if (reason) {
							alert(reason);
							return;
						}
						else {
							alert("<spring:message code='ezWebFolder.t252'/>");
							document.getElementById("storageVal").value = "";
							search_Set(currentPage);
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function changeToDefault() {
				var checkedList = getSelectedRowInfo();
				
				if (checkedList == null) {
					alert("<spring:message code='ezWebFolder.t208'/>");
					return;
				}
				
				var userIdList = checkedList["userList"];
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/restoreCapacities.do",
					data: {
						"userListParam" : userIdList.toString(),
						"companyId"     : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var reason = data.reason;
						if (reason) {
							alert(reason);
							return;
						}
						
						alert("<spring:message code='ezWebFolder.t253'/>")
						search_Set(currentPage);
						checkedArr = [];
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function isValid(value) {
				if (!isNaN(value) && parseFloat(value) > 0) {
					return true;
				}
				else {
					return false;
				}
			}
			
			function getPosition(popUpW, popUpH) {
				var returnValue = new Array();
				var heigth      = window.parent.document.documentElement.clientHeight;
				if (heigth == 0) {heigth = window.parent.document.body.clientHeight;}
				
				var width = window.parent.document.documentElement.clientWidth;
				if (width == 0) {width = window.parent.document.body.clientWidth;}
				
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				
				if (heigth < (popUpH + 50)) {
					returnValue[0] = (heigth / 2);
				}
				else {
					returnValue[0] = (heigth / 2) - 50;
				}
				
				returnValue[1] = pleftpos / 2;
				return returnValue;
			}
			
		</script>
	</head>
	<body class="mainbody" onresize="preProcessing();" onkeydown="keyPressPanel(event);">
		<h1>
			<spring:message code='ezWebFolder.t103'/>
			<span id="mailBoxInfo"></span>
		</h1>
		<div style="margin-left:5px">
			<div id="companySelect" style="margin: 10px 0px;">
				<span style="font-size: 12px; display: inline-block; vertical-align: middle;"><b><spring:message code='ezWebFolder.t129'/></b></span>
				<select id="companyList" style="font-size: 12px; height: 20px; display:inline-block;" onchange="change();">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<div style="position: relative; height: 27px; margin-bottom: 10px;">
				<div style="position: relative;">
					<div id="mainmenu2">
						<ul>
							<li><a id="btnSearch" onClick="openSearchPanel();"><span><spring:message code='ezWebFolder.t123'/></span></a></li>
							<li><a id="btnRefresh" onClick="refreshView();"><span><spring:message code='ezWebFolder.t139'/></span></a></li>
						</ul>
					</div>
					<div id="searchPanel" style="z-index: 2000; position: fixed; height: auto; width: 500px; border: 1px solid #666666; background-color: white; display: none; border-radius: 8px; -webkit-box-shadow: 0 0 10px #000; -moz-box-shadow: 0 0 10px #000; -o-box-shadow: 0 0 10px #000; -ms-box-shadow: 0 0 10px #000; box-shadow: 0 0 10px #000;">
						<div style="margin: 20px;">
							<table style="border-collapse: collapse; width: 458px;">
								<tr>
									<th class="layerHeader" colspan="2"><img src="/images/webfolder/left_webfolder.png" style="vertical-align: middle;padding-bottom:1px" width="16px">&nbsp;<spring:message code='ezWebFolder.t23'/></th>
								</tr>
								<tr>
									<td class="wfSearchTh2" colspan="2"></td>
								</tr>
								<tr>
									<th style="height: 30px;"><spring:message code='ezWebFolder.t141'/></th>
									<td style="border: 1px solid #d2d2d2; background-color: #fff;">
										<select id="searchOption" style="margin-left: 10px;">
											<option value="deptName"><spring:message code='ezWebFolder.t142' /></option>
											<option value="userName"><spring:message code='ezWebFolder.t143' /></option>
										</select>
										<input id="inputSearch" type="text" style="width: 275px; height: 23px; margin: 2px 5px; padding: 0px 5px; border-radius: 3px; border: 1px solid #ddd;">
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<div style="margin-top: 10px; text-align: center;">
											<a class="webfolderBttn"><span onclick="startSearch();"    ><spring:message code='ezWebFolder.t123'/></span></a>
											<a class="webfolderBttn"><span onclick="openSearchPanel();"><spring:message code='ezWebFolder.t112'/></span></a>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<span class="wfCloseBttn" onclick="openSearchPanel();"></span>
					</div>
				</div>
				<div style="position: absolute; top: 0px; right: 2px; height: 27px;">
					<span style="height: 20px; line-height: 20px; display: inline; font-size: 14px;"><spring:message code='ezWebFolder.t145'/></span>
					<input id="storageVal" type="text" style="width: 100px; height: 27px; border-radius: 5px; border: 1px solid #b3b3b3; padding-left: 5px;" placeholder="<spring:message code='ezWebFolder.t132' />"/>
					<a id="btnChange" class="webfolderBttn2" onClick="changeStorageVal();"><span><spring:message code='ezWebFolder.t124'/></span></a>
					<a id="btnBack" class="webfolderBttn2" onClick="changeToDefault();"   ><span><spring:message code='ezWebFolder.t125'/></span></a>
				</div>
			</div>
			
			<div id="mainSetting" style="margin: 10px 0px; height:500px; overflow: auto;">
				<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileStorage">
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
			
			<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
				<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
			</div>
			
			<div id="tblPageRayer"></div>
			<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel" onclick="closeAllPopups();">&nbsp;</div>
			<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
		</div>
	</body>
</html>
