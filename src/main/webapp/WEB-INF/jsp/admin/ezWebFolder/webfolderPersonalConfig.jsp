<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminTable.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
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
			var currentType = "C";
			var tableView   = new TableView();
			var searchOptionNode = null;
			
			window.onload = function() {
				closeAllPopup();
				tableView.setTableId("tblFileList");
				tableView.setTabledHeader("tblFileListHeader-company");
				tableView.setTableType("companyConfigTable");
				tableView.setSelectedClass("bnkWebFolder2");
				tableView.setUnselectClass("bnkWebFolder");
				tableView.setCallBack(refreshView);
				
				searchOptionNode = $("#searchOption option").toArray().map(function(element) {
					return element.cloneNode(true);
				});
				
				setListType("C");
				preProcessing();
				Tab1_NewTabIni("typeTab");
			}
			
			window.onbeforeunload = function() {
				closeAllPopup();
			}
			
			function preProcessing() {
				var divList          = document.getElementById("dragDropArea");
				var reheight         = document.documentElement.clientHeight - 220;
				divList.style.height = reheight + "px";
				scroll();
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
				// 회사라면 회사명으로 선택
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
						"type"        : currentType,
						"currentPage" : pPage,
						"searchStr"   : searchStr,
						"searchOpt"   : searchOpt,
						"column"      : orderInf.col ? orderInf.col : "",
						"order"       : orderInf.ord ? orderInf.ord : "",
						"companyId"   : <c:if test="${isAdminMode}">currentType == "C" ? null : </c:if>document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						hideProgress();
						var code = data.code;
						
						switch(code) {
							case 0: 
								var result  = data.capacityList;
								totalRows   = data.totalSize;
								totalPages  = data.totalPages;
								currentPage = pPage;
								checkedArr  = [];
								
								makePageSelPage();
								renderData(result);
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300' />");
								break;
						}
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
				scroll();
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
				var list           = [];
				var usedAmountList = [];
				if (listOfSelectedRows.length == 0) {
					return null;
				}
				
				for (var i = 0; i < listOfSelectedRows.length; i++) {
					list.push(listOfSelectedRows[i].getAttribute("cn"));
					usedAmountList.push(listOfSelectedRows[i].getAttribute("usedAmount"));
				}
				
				return {list: list, usedAmountList: usedAmountList};
			}
			
			function changeStorageVal() {
				var newValue    = document.getElementById("storageVal").value;
				var checkedList = getSelectedRowInfo();
				
				if (checkedList == null) {
					switch(currentType) {
					case "C":
						alert("<spring:message code='ezWebFolder.t208_com'/>");
						break;
					case "D":
						alert("<spring:message code='ezWebFolder.t208_dep'/>");
						break;
					case "U":
						alert("<spring:message code='ezWebFolder.t208'/>");
						break;
					}
					document.getElementById("storageVal").value = "";
					document.getElementById("storageVal").focus();
					return;
				}
				
				var list = checkedList["list"];
				var amountList = checkedList["usedAmountList"];
				
				if (!isValid(newValue)) {
					alert("<spring:message code='ezWebFolder.t207'/>");
					document.getElementById("storageVal").value = "";
					document.getElementById("storageVal").focus();
					return;
				}
				
				for (var i = 0; i < amountList.length; i++) {
					if (parseFloat(amountList[i]) > parseFloat(newValue) * 1073741824) {
						alert("<spring:message code='ezWebFolder.t209'/>");
						return;
					}
				}
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/updateCapacities.do",
					data: {
						"type"      : currentType,
						"list"      : list.toString(),
						"companyId" : document.getElementById("companyList").value,
						"value"     : newValue
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								alert("<spring:message code='ezWebFolder.t252'/>");
								document.getElementById("storageVal").value = "";
								search_Set(currentPage);
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300'/>");
								break;
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
				
				var list = checkedList.list;
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/restoreCapacities.do",
					data: {
						"type" : currentType,
						"list" : list.toString(),
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								alert("<spring:message code='ezWebFolder.t253'/>")
								search_Set(currentPage);
								checkedArr = [];
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300'/>");
								break;
						}
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
			function scroll() {
				var BoardList_BODYHeight = document.getElementById("dragDropArea").clientHeight;
				var BoardListDivHeight = document.getElementById("tblFileList").clientHeight;
				var currentHeaderId = currentType == "U" ? "#tblFileListHeader-user" : currentType =="D" ? "#tblFileListHeader-department" : "#tblFileListHeader-company";
				
				 if (BoardList_BODYHeight > BoardListDivHeight) {
					if ($(currentHeaderId + " tr th.forScroll").length > 0) {
						$(currentHeaderId + " tr th.forScroll").remove();
					}
				} else {
					if ($(currentHeaderId + " tr th.forScroll").length < 1) {
						$(currentHeaderId + " tr th.forScroll").remove();
						$(currentHeaderId + " tr").append("<th></th>");
						
							var lastTh = $(currentHeaderId + " tr th").last();
							lastTh.attr("class", "forScroll");
							lastTh.css("width", "15px");
							
					}
				}
				 
				/*var lastTh = $("#BoardList_TH th").last();
				if (lastTh.attr("id") == null) {
					lastTh.css("display", "none");
				}*/
			}
			
			
			var Tab1_SelectID = "";
			function Tab1_MouserOver(obj) {
				obj.className = "tabover";
			}

			function Tab1_MouserOut(obj) {
				if (Tab1_SelectID != obj.id)
					obj.className = "";
			}

			function Tab1_MouseClick(obj) {
				obj.className = "tabon";
				if (obj.id != Tab1_SelectID) {
					if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
						document.getElementById(Tab1_SelectID).className = "";
					
					obj.className = "tabon";
					Tab1_SelectID = obj.id;
					ChangeTab(obj);
				}
			}

			function setListType(type) {
				var headerId = "";
				$("#searchOption").empty();
				
				switch (type) {
				case "C":
					headerId = "tblFileListHeader-company";
					tableView.setTableType("companyConfigTable");
					document.getElementById("searchOption").appendChild(searchOptionNode[0]);
					break;
				case "D":
					headerId = "tblFileListHeader-department";
					tableView.setTableType("departmentConfigTable");
					document.getElementById("searchOption").appendChild(searchOptionNode[1]);
					break;
				case "U":
					headerId = "tblFileListHeader-user";
					tableView.setTableType("userConfigTable");
					document.getElementById("searchOption").appendChild(searchOptionNode[1]);
					document.getElementById("searchOption").appendChild(searchOptionNode[2]);
					break;
				default:
					throw "error";
				}
				
				var tableElement = document.getElementById("tblFileList");
				currentType = type;
				
				while (tableElement.firstChild) {
					tableElement.removeChild(tableElement.firstChild);
				}
				
				document.getElementById("storageVal").value = "";
				<c:if test="${isAdminMode}">
				[].slice.call(document.querySelectorAll(".company-list-hide")).forEach(function(hideElement) {
					hideElement.style.display = type == "C" ? "none" : "";
				});
				</c:if>
				
				["tblFileListHeader-company", "tblFileListHeader-department", "tblFileListHeader-user"].filter(function(id) {
					return id != headerId;
				}).forEach(function(id) {
					document.getElementById(id).style.display = "none";
				});
				
				searchStr = "";
				searchOpt = "";
				currentPage = 1;
				
				document.getElementById(headerId).style.display = "";
				tableView.setTabledHeader(headerId);
				refreshView();
			}

			function ChangeTab(obj) {
				var pSelectTab = obj.id;
				var tableElement = document.getElementById("tblFileList");
				
				switch (pSelectTab) {
				case "companyTab":
					setListType("C");
					break;
				case "departmentTab":
					setListType("D");
					break;
				case "userTab":
					setListType("U");
					break;
				}
			}

			function Tab1_NewTabIni(pTabNodeID) {
				var nodeElement = document.getElementById(pTabNodeID);
				var childNodes = nodeElement.children;
				var length = childNodes.length;
				
				for (var i = 0; i < length; i++) {
					var currentNode = childNodes.item(i);
					if (currentNode.nodeName == "P") {
						var spanNode = currentNode.children.item(0);
						if (spanNode.nodeName == "SPAN") {
							// spanNode.onmouseover = function() {
							// 	Tab1_MouserOver(this);
							// };
							// spanNode.onmouseout = function() {
							// 	Tab1_MouserOut(this);
							// };
							spanNode.onclick = function() {
								Tab1_MouseClick(this);
							};
							
							if (i == 0) {
								spanNode.className = "tabon";
								Tab1_SelectID = spanNode.id;
							}
						}
					}
				}
			}
			
			function isEnter(e) {
				
				if (e.code == 'Enter' || e.code == 'NumpadEnter') {
					startSearch();
				}
			}
		</script>
	</head>
	<body class="mainbody" onresize="preProcessing();" onkeydown="keyPressPanel(event);">
		<h1>
			<spring:message code='ezWebFolder.t103'/>
			<span id="mailBoxInfo"></span>
			<span class="title_bar<c:if test="${isAdminMode}"> company-list-hide" style="display: none;</c:if>"><img src="/images/name_bar.gif"></span>
			<select id="companyList" class="companySelect<c:if test="${isAdminMode}"> company-list-hide" style="display: none;</c:if>" onchange="change();">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</h1>
	<div class="portlet_tabpart01_top" id="typeTab">
		<p>
			<span id="companyTab" class="tabover"><spring:message code='ezWebFolder.tab.company'/></span>
		</p>
		<p>
			<span id="departmentTab"><spring:message code='ezWebFolder.tab.department'/></span>
		</p>
		<p>
			<span id="userTab"><spring:message code='ezWebFolder.tab.user'/></span>
		</p>
	</div>
	<div style="margin-top: 10px;">
			<div style="position: relative; height: 27px; margin-bottom: 10px;">
				<div style="position: relative;">
					<div id="mainmenu">
						<ul>
							<li id="SearchOption" mode="off" onclick="openSearchPanel()"><span class="icon16 icon16_search"></span></li>
							<li><span class="icon16 icon16_refresh" onclick="refreshView()"></span></li>
						</ul>
					</div>
					<div id="searchPanel" class="wfSearchPanel" style="display: none; overflow: hidden;">
						<div class="popup" style="margin: 0; padding: 5px 10px 10px;">
						<h1><spring:message code='ezWebFolder.t23'/></h1> 
						<div class="wfClose" onclick="openSearchPanel();"><ul><li><span></span></li></ul></div>
						<div style="margin: 10px 0px 15px;">
							<table class="content wftable">
								<tr>
									<th class="wfSearchTh"><spring:message code='ezWebFolder.t141'/></th>
									<td class="wfSearchTd" style="border: 1px solid #d2d2d2; background-color: #fff;">
										<div style="width: 100%; display : flex; align-items: center;">
											<select id="searchOption" style="margin-left: 5px; height: 23px;">
												<option id="companyOption" value="displayName"><spring:message code='ezWebFolder.t146' /></option>
												<option id="departmentOption" value="deptName"><spring:message code='ezWebFolder.t142' /></option>
												<option id="userOption" value="displayName"><spring:message code='ezWebFolder.t143' /></option>
											</select>
											<input id="inputSearch" onkeypress="isEnter(event)" type="text" style="flex: 1; height: 23px; margin: 2px 5px; padding: 0px 5px; border-radius: 3px; border: 1px solid #ddd;">
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="wfdivBttn">
							<a class="webfolderBttn"><span onclick="startSearch();"    ><spring:message code='ezWebFolder.t123'/></span></a>
							<a class="webfolderBttn"><span onclick="openSearchPanel();"><spring:message code='ezWebFolder.t112'/></span></a>
						</div>
						</div>
					</div>
<!-- 				<div id="searchpopup" class="popupwrap3" style="display: none; margin-bottom: 70px"> -->
<!-- 					<div class="popupJQLayer" style="padding-top: 6px"> -->
<!-- 						<div class="title"> -->
<%-- 							<spring:message code='ezWebFolder.t10' /> --%>
<%-- 							<spring:message code='ezWebFolder.t123' /> --%>
<!-- 						</div> -->
<!-- 						<div id="close"> -->
<!-- 							<ul> -->
<!-- 								<li><a rel="modal:close"><span onclick="searchOptionHidden()"></span></a></li> -->
<!-- 							</ul> -->
<!-- 						</div> -->
<!-- 						<table class="content" style="margin-top: 10px;"> -->
<!-- 							<tr> -->
<%-- 								<th style="text-align: center"><spring:message code='ezBoard.t210' /></th> --%>
<!-- 								<td><input type="text" id="Sdatepicker" class="datepicker" style="width: 80px; text-align: center" readonly="readonly"> ~ <input type="text" id="Edatepicker" class="datepicker" -->
<!-- 									style="width: 80px; text-align: center" readonly="readonly" -->
<!-- 								></td> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<%-- 								<th style="text-align: center"><spring:message code='ezWebFolder.t152' /></th> --%>
<!-- 								확장자 -->
<!-- 								<td><input type="text" id="searchExt" style="width: 99%" value="" name="searchExt"></td> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<%-- 								<th style="text-align: center"><spring:message code='ezWebFolder.t153' /></th> --%>
<!-- 								파일명 -->
<!-- 								<td><input type="text" id="searchFileName" style="width: 99%" value="" name="searchFileName"></td> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<%-- 								<th style="text-align: center"><spring:message code='ezWebFolder.t154' /></th> --%>
<!-- 								작성자 -->
<!-- 								<td><input type="text" id="searchCreateName" style="width: 99%" value="" name="searchCreateName"></td> -->
<!-- 							</tr> -->
<!-- 						</table> -->
<!-- 						<table style="width: 100%"> -->
<!-- 							<tr> -->
<!-- 								<td style="text-align: center;"> -->
<!-- 									<div class="btnpositionLayer"> -->
<%-- 										<a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezAddress.t142' /></span></a> --%>
<!-- 									</div> -->
<!-- 								</td> -->
<!-- 							</tr> -->
<!-- 						</table> -->
<!-- 					</div> -->
<!-- 				</div> -->
			</div>
				<div style="position: absolute; top: 0px; right: 2px; height: 27px;">
					<span style="height: 20px; line-height: 20px; display: inline; font-size: 14px;"><spring:message code='ezWebFolder.t145'/></span>
					<input id="storageVal" type="text" style="width: 100px; height: 27px; border-radius: 5px; border: 1px solid #b3b3b3; padding-left: 5px;" placeholder="<spring:message code='ezWebFolder.t132' />" onKeyup="this.value=this.value.replace(/[^\.0-9]/g,'');" />
					<a id="btnChange" class="imgbtn" onClick="changeStorageVal();"><span><spring:message code='ezWebFolder.t124'/></span></a>
					<a id="btnBack" class="imgbtn" onClick="changeToDefault();"   ><span><spring:message code='ezWebFolder.t125'/></span></a>
				</div>
			</div>
			
			<div style="width:100%;"id ="tblFileList1_div">
			<div style="margin:0px 0px 0px !important;min-width: 700px;" >
				<table class="mainlist" style="width:100%;display:none;"  id="tblFileListHeader-user">
					<thead>
						<tr>
							<th class="wfFilecheck" ><div class="custom_checkbox"><input type="checkbox"></div></th>
							<th headers="cn" class="wfConfigCompany" ><spring:message code='ezWebFolder.t146'/></th>
							<th headers="dn" class="wfConfigCompany"><spring:message code='ezWebFolder.t142'/></th>
							<th headers="un" class="wfActive"><spring:message code='ezWebFolder.t143.2'/></th>
							<th headers="ut" class="wfActive" ><spring:message code='ezWebFolder.t147'/></th>
							<th              class="wfConfigCapacity" style="text-align: center;"><spring:message code='ezWebFolder.t148'/></th>
							<th headers="tc" class="wfConfigCapacity" style="text-align: center; "><spring:message code='ezWebFolder.t149'/></th>
							<th              class="wfConfigCompany" style="text-align: center;"><spring:message code='ezWebFolder.t150'/></th>
						</tr>
						</thead>
					</table>
					<table class="mainlist" style="width:100%;display:none;"  id="tblFileListHeader-department">
						<thead>
							<tr>
								<th class="wfFilecheck" ><div class="custom_checkbox"><input type="checkbox"></div></th>
								<th headers="cn" class="wfConfigCompany" ><spring:message code='ezWebFolder.t146'/></th>
								<th headers="dn" class="wfConfigCompany"><spring:message code='ezWebFolder.t142.2'/></th>
								<th              class="wfConfigCapacity" style="text-align: center;"><spring:message code='ezWebFolder.t148'/></th>
								<th headers="tc" class="wfConfigCapacity" style="text-align: center; "><spring:message code='ezWebFolder.t149'/></th>
								<th              class="wfConfigCompany" style="text-align: center;"><spring:message code='ezWebFolder.t150'/></th>
							</tr>
						</thead>
					</table>
					<table class="mainlist" style="width:100%;"  id="tblFileListHeader-company">
						<thead>
							<tr>
								<th class="wfFilecheck" ><div class="custom_checkbox"><input type="checkbox"></div></th>
								<th headers="dn" class="wfConfigCompany" ><spring:message code='ezWebFolder.t146.2'/></th>
								<th              class="wfConfigCapacity" style="text-align: center;"><spring:message code='ezWebFolder.t148'/></th>
								<th headers="tc" class="wfConfigCapacity" style="text-align: center; "><spring:message code='ezWebFolder.t149'/></th>
								<th              class="wfConfigCompany" style="text-align: center;"><spring:message code='ezWebFolder.t150'/></th>
							</tr>
						</thead>
					</table>
					<div id="dragDropArea"  style="overflow-y:auto;white-space:nowrap;" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)">
						<table class="mainlist" style="width: 100%;margin:0px 0px 0px !important; white-space:nowrap;" id="tblFileList">
					
						</table>
					</div>
				</div>
			</div>
			
			<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
				<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
			</div>
			
			<div id="tblPageRayer"></div>
			<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel" onclick="closeAllPopups();">&nbsp;</div>
			<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/pageNav.js')}"></script>
		</div>
	</body>
</html>
