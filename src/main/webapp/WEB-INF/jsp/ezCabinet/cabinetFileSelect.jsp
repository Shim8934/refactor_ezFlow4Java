<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabRelatedFile">
		<h1><spring:message code="ezCabinet.t87"/></h1>
		
		<div id="cabRlClose" class="cabClose"><ul><li><span><spring:message code='ezCabinet.t66'/></span></li></ul></div>
		
		<div class="cabRlSearch">
			<div>
				<input id="ssInput" type="text" placeholder="<spring:message code='ezCabinet.t88'/>">
				<a id="searchBttn" class="cabBttn2"><span><spring:message code='ezCabinet.t49'/></span></a>
			</div>
		</div>
		<div class="cabRlMain">
			<div class="cabRlTreeMain">
				<div class="cabRlTreeDiv">
					<div id="cabinetTree" class="cbTree"></div>
				</div>
				<div class="cabRlSelect">
					<div class="rlSelectTtl"><div id="bnkDivMain"><spring:message code='ezCabinet.t89'/></div><div id="cabinetInfo"></div></div>
					<div class="rlSelectTblDiv">
						<table class="rlSelectTbl" id="tableFiles">
							<tr>
								<th class="thType"><spring:message code='ezCabinet.t61'/></th>
								<th><spring:message code='ezCabinet.t62'/></th>
							</tr>
							<tr>
								<td colspan="2" style="text-align: center; background-color: #fff;"><spring:message code='ezCabinet.err3'/></td>
							</tr>
						</table>
					</div>
					<div id="tblPageRayer" style="display: flex;"></div>
				</div>
			</div>
			<div class="cabRlBttnDiv">
				<div>
					<img id="addBttn"    src="/images/kr/cm/arr_right.gif">
					<img id="removeBttn" src="/images/kr/cm/arr_left.gif" >
				</div>
			</div>
			<div class="cabRlSelected">
				<div class="rlSelectTtl2"><spring:message code='ezCabinet.t90'/></div>
				<div class="rlSelectTblDiv">
					<table class="rlSelectTbl" id="selectedTable">
						<tr>
							<th class="thType"><spring:message code='ezCabinet.t61'/></th>
							<th><spring:message code='ezCabinet.t62'/></th>
						</tr>
					</table>
				</div>
			</div>
		</div>
		
		<div class="cabdivBttn" id="cabRlBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetNavi.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTable.js"          ></script>
		<script type="text/javascript">
			(function() {
				var cabinetId     = null;
				var searchTtl     = "";
				var searchMode    = "normal";
				var cabinetNavi   = null;
				var cabinetTree   = new CabinetTree();
				var fileTable     = new CabinetTable({
					normal   : "bnkCabNormal",
					selected : "bnkCabSelect",
					mode     : "normal",
					render   : renderFileList
				});
				var selectedFiles = new CabinetTable({
					normal   : "bnkCabNormal",
					selected : "bnkCabSelect",
					mode     : "received",
					dblclick : removeFile
				});
				
				initEvents();
				
				function initEvents() {
					document.onselectstart = function() {return false;};
					var closeBttn          = document.getElementById("cabRlClose").firstElementChild.firstElementChild.firstElementChild;
					closeBttn.onclick      = function(e) {closeWindow();};
					
					var cabRlBttnElmt      = document.getElementById("cabRlBttn");
					var listRlBttns        = cabRlBttnElmt.children;
					listRlBttns[0].onclick = function(e) {saveRelatedFiles();};
					listRlBttns[1].onclick = function(e) {closeWindow();};
					document.getElementById("addBttn").onclick    = function(e) {addFiles();};
					document.getElementById("removeBttn").onclick = function(e) {removeFiles();};
					
					var sSearchInputElmt   = document.getElementById("ssInput");
					sSearchInputElmt.addEventListener("keypress", function(e) {onStartSimpleSearch(e);}, false);
					sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this);}, false);
					
					var searchBttnElmt = document.getElementById("searchBttn");
					searchBttnElmt.addEventListener("click", function(e) {startSimpleSearch();}, false);
					
					var naviMessages = {
						next     : CabinetMessages.strNext,
						previous : CabinetMessages.strPrev,
						item     : CabinetMessages.strItem,
						total    : CabinetMessages.strTotal
					};
					
					cabinetNavi = new CabinetNavi({
						messages : naviMessages,
						divId    : "tblPageRayer",
						divClass : "cabpagenavi",
						headerId : "cabinetInfo",
						callback : searchItem
					});
					
					cabinetNavi.setBlock(3);
					
					cabinetTree.setTreeInfo({
						treeId     : "cabinetTree",
						treeType   : "cabinet",
						type       : "list",
						initialUrl : "/ezCabinet/getAllCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : getAllItems,
						dblClick   : null
					});
					
					cabinetTree.makeTree();
					
					//Set file tables 
					fileTable.setTableType("files");
					fileTable.setTableElement("tableFiles", "id");
					
					//Set selected tables 
					selectedFiles.setTableElement("selectedTable", "id");
					
					setSelectedItem();
				}
				
				function setSelectedItem() {
					var parentWd    = window.opener;
					var selectedArr = null;
					if (parentWd && parentWd.CabinetAddFile) {selectedArr = parentWd.CabinetAddFile.get();}
					
					if (selectedArr != null && selectedArr.length != 0) {
						var tableElmt = document.getElementById("selectedTable");
						for (var i = 0, len = selectedArr.length; i < len; i++) {
							var item    = selectedArr[i];
							var trElmt  = document.createElement("tr");
							var tdElmt1 = document.createElement("td");
							var tdElmt2 = document.createElement("td");
							var imgElmt = document.createElement("img");
							imgElmt.src = getImageSource(item["itemType"]);
							tdElmt1.appendChild(imgElmt);
							tdElmt2.textContent = item["itemTitle"];
							tdElmt2.setAttribute("title", item["itemTitle"]);
							trElmt.setAttribute("role", item["itemId"]);
							trElmt.setAttribute("type", item["itemType"]);
							trElmt.className = "bnkCabNormal";
							trElmt.appendChild(tdElmt1);
							trElmt.appendChild(tdElmt2);
							
							tableElmt.appendChild(trElmt);
						}
						
						selectedFiles.resetEvents();
					}
				}
				
				function saveRelatedFiles() {
					var data      = [];
					var tableElmt = document.getElementById("selectedTable");
					var trList    = tableElmt.rows;
					
					for (var i = 1, len = trList.length; i < len; i++) {
						var itemId    = trList[i].getAttribute("role");
						var itemType  = trList[i].getAttribute("type");
						var itemTitle = trList[i].lastElementChild.getAttribute("title");
						data.push({
							itemId    : itemId,
							itemType  : itemType,
							itemTitle : itemTitle
						});
					}
					
					var parentWd = window.opener;
					if (parentWd && parentWd.CabinetAddFile) {parentWd.CabinetAddFile.save(data);}
					
					closeWindow();
				}
				
				function getAllItems(nodeElmt) {
					document.getElementById("bnkDivMain").textContent = nodeElmt.textContent;
					cabinetId = nodeElmt.getAttribute("role");
					searchMode = "normal";
					searchItem("1");
				}
				
				function searchItem(page) {
					var url  = "";
					var data = null;
					
					switch(searchMode) {
						case "normal" : url  = "/ezCabinet/getCabinetFiles.do";
										data = {cabinetId : cabinetId, currentPage : page};
										makeAjaxCall(data, "GET", url, afterGetData, null, true, null);
										break;
						case "search" : url  = "/ezCabinet/getFilesBySearching.do";
										data = {title : searchTtl, currentPage : page};
										makeAjaxCall(data, "POST", url, afterGetData, null, true, null);
										break;
					}
				}
				
				function afterGetData(data) {
					var code = data.code;
					switch(code) {
						case 0 : getDataSuccessfully(data); break;
						case 1 : alert(CabinetMessages.strParamErr); break;
						case 2 : alert(CabinetMessages.strError)   ; break;
						case 3 : alert(CabinetMessages.strPerm)    ; break;
						default: alert(CabinetMessages.strError)   ; return; 
					}
				}
				
				function getDataSuccessfully(data) {
					cabinetNavi.init(data.currentPage, data.totalRows, data.totalPages);
					fileTable.setDataSource(data.itemList);
					fileTable.renderTable();
				}
				
				function renderFileList(itemList, unselectClass, tableElmt, clickRow) {
					if (itemList == null || itemList.length == 0) {
						var trElmt = document.createElement("tr");
						var tdElmt = document.createElement("td");
						tdElmt.setAttribute("colspan", "2");
						tdElmt.setAttribute("style", "text-align: center; background-color: #fff;");
						tdElmt.innerHTML = CabinetMessages.strNoData;
						
						trElmt.appendChild(tdElmt);
						tableElmt.appendChild(trElmt);
					}
					else {
						var len = itemList.length;
						for (var i = 0; i < len; i++) {
							var trElmt  = document.createElement("tr");
							var tdElmt1 = document.createElement("td");
							var tdElmt2 = document.createElement("td");
							var imgElmt = document.createElement("img");
							imgElmt.src = getImageSource(itemList[i]["itemType"]);
							tdElmt1.appendChild(imgElmt);
							tdElmt2.textContent = itemList[i]["title"];
							tdElmt2.setAttribute("title", itemList[i]["title"]);
							trElmt.setAttribute("role", itemList[i]["itemId"]);
							trElmt.setAttribute("type", itemList[i]["itemType"]);
							trElmt.className = unselectClass;
							trElmt.appendChild(tdElmt1);
							trElmt.appendChild(tdElmt2);
							trElmt.addEventListener("click", function(e) {clickRow(e);}, false);
							trElmt.addEventListener("dblclick", function(e) {addFile(this, "one")}, false);
							
							tableElmt.appendChild(trElmt);
						}
					}
				}
				
				function addFile(trElmt, mode) {
					var selectedTable = document.getElementById("selectedTable");
					var itemId        = trElmt.getAttribute("role");
					var checkElmt     = selectedTable.querySelector("tr[role='" + itemId + "']");
					
					if (checkElmt) {if(mode) {alert(CabinetMessages.strExist);}; return;}
						
					var cloneTr       = trElmt.cloneNode(true);
					cloneTr.className = "bnkCabNormal";
					selectedTable.appendChild(cloneTr);
					selectedFiles.resetEvents();
				}
				
				function addFiles() {
					var listTableElmt  = document.getElementById("tableFiles");
					var selectedTrList = listTableElmt.querySelectorAll("tr[class='bnkCabSelect']");
					
					for (var i = 0, len = selectedTrList.length; i < len; i++) {
						addFile(selectedTrList[i]);
					}
				}
				
				function removeFile(trElmt) {
					var selectedTable = document.getElementById("selectedTable");
					selectedTable.removeChild(trElmt);
				}
				
				function removeFiles() {
					var selectedTblElmt = document.getElementById("selectedTable");
					var selectedTrList  = selectedTblElmt.querySelectorAll("tr[class='bnkCabSelect']");
					
					for (var i = 0, len = selectedTrList.length; i < len; i++) {
						removeFile(selectedTrList[i]);
					}
				}
				
				function getImageSource(moduleType) {
					var srcImg = "";
					switch(parseInt(moduleType)) {
						case 0 : srcImg = "/images/cabinet/docx.png"     ; break;
						case 1 : srcImg = "/images/cabinet/mail.png"     ; break;
						case 2 : srcImg = "/images/cabinet/approval.png" ; break;
						case 3 : srcImg = "/images/cabinet/board.png"    ; break;
						case 4 : srcImg = "/images/cabinet/schedule.png" ; break;
						case 5 : srcImg = "/images/cabinet/schedule.png" ; break;
						case 6 : srcImg = "/images/cabinet/circular.png" ; break;
						case 7 : srcImg = "/images/cabinet/community.png"; break;
						case 8 : srcImg = "/images/cabinet/mail.png"     ; break;
						case 9 : srcImg = "/images/cabinet/circular.png" ; break;
						case 10: srcImg = "/images/cabinet/rar.png"      ; break;
						case 11: srcImg = "/images/cabinet/resource.png" ; break;
					}
					
					return srcImg;
				}
				
				function onStartSimpleSearch(event) {if(event.keyCode == "13") {startSimpleSearch();}}
				
				function startSimpleSearch() {
					var searchStr = document.getElementById("ssInput").value;
					if (!searchStr.replace(/\s/g,'')) {alert(CabinetMessages.strNoInput); return;}
					document.getElementById("bnkDivMain").textContent = CabinetMessages.strResult;
					searchTtl  = searchStr;
					searchMode = "search";
					searchItem("1");
				}
				
				function clearKeyword(inputElmt) {inputElmt.value = "";}
				
				function closeWindow() {window.close();}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode, moreParam) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						success : function(data) {
							handleSuccess(data, moreParam);
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

