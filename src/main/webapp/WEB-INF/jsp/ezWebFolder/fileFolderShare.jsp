<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/organ_tree.css"                       type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>"   type="text/css">
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css"            type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css"/>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"         type="text/css"/>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"                ></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"                          ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"                             ></script>
		<script type="text/javascript" src="/js/ezOrgan/TreeView.js"                        ></script>
		<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"                   ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"        ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"      ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"              ></script>
		<script type="text/javascript" src="/js/jquery-ui/jquery-ui.js"                     ></script>
		<script type="text/javascript">
			var blockSize    = 10;
			var currentPage  = null;
			var totalRows    = null;
			var totalPages   = null;
			var primary      = "<c:out value='${primary}'/>";
			var strLang39    = "<spring:message code='ezWebFolder.t135'/>";
			var strLang40    = "<spring:message code='ezWebFolder.t136'/>";
			var strLang41    = "<spring:message code='ezWebFolder.t137'/>";
			var strLang42    = "<spring:message code='ezWebFolder.t138'/>";
			var startDateStr = "";
			var endDateStr   = "";
			var fileExtStr   = "";
			var fileNameStr  = "";
			var userNameStr  = "";
			var folderId     = "<c:out value='${folderId}'/>";
			var checkedArr   = [];
			var folderType   = "company";
			var rootFolder   = "<c:out value='${rootFolder}'/>";
			
			window.onresize = function () {
				var divList          = document.getElementById("dragDropArea");
				var reheight         = document.documentElement.clientHeight - 170;
				divList.style.height = reheight + "px";
			};
			
			window.onload = function () {
				$("#Sdatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly: true,
					dateFormat: "yy-mm-dd"
				});
				
				$("#Edatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly: true,
					dateFormat: "yy-mm-dd"
				});
				
				//search_Set("1");
				preProcessing();
			}
			
			function preProcessing() {
				var divList          = document.getElementById("dragDropArea");
				var reheight         = document.documentElement.clientHeight - 170;
				divList.style.height = reheight + "px";
			}
			
			function openSearchPanel() {
				$("#searchPanel").toggle("1000");
				
				$("#Sdatepicker").datepicker('setDate', "");
				$("#Edatepicker").datepicker('setDate', "");
				document.getElementById("fileExtVal").value     = "";
				document.getElementById("fileNameVal").value    = "";
				document.getElementById("fileCreatorVal").value = "";
			}
			
			function search_Set(pPage) {
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getFileList.do",
					data: {
						"currentPage" : pPage,
						"startDate"   : startDateStr,
						"endDate"     : endDateStr,
						"fileExt"     : fileExtStr,
						"fileName"    : fileNameStr,
						"userName"    : userNameStr,
						"fileType"    : document.getElementById("fileTypeSelect").value,
						"folderId"    : folderId
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result  = data.fileList;
						totalRows   = data.totalRows;
						totalPages  = data.totalPages;
						currentPage = pPage;
						
						makePageSelPage();
						renderData(result);
						checkedArr = [];
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function renderData(result) {
				document.getElementById("_checkAll").checked = false;
				var tableList = document.getElementById("tblFileList");
				
				while (tableList.rows.length > 1) {
					tableList.deleteRow(1);
				}
				
				if (result == null || result.length == 0) {
					var trElmt = document.createElement("tr");
					var tdElmt = document.createElement("td");
					tdElmt.setAttribute("colspan", "9");
					tdElmt.setAttribute("align", "center");
					tdElmt.setAttribute("bgcolor", "#FFFFFF");
					tdElmt.innerHTML = "<spring:message code='ezWebFolder.t144' />";
					tdElmt.setAttribute("id", "nodataRow");
					
					trElmt.appendChild(tdElmt);
					tableList.appendChild(trElmt);
				}
				else {
					var len = result.length;
					for (var i = 0; i < len; i++) {
						var trElmt  = document.createElement("tr");
						var tdElmt1 = document.createElement("td");
						var tdElmt2 = document.createElement("td");
						var tdElmt3 = document.createElement("td");
						var tdElmt4 = document.createElement("td");
						var tdElmt5 = document.createElement("td");
						var tdElmt6 = document.createElement("td");
						var tdElmt7 = document.createElement("td");	
						var tdElmt8 = document.createElement("td");	
						var tdElmt9 = document.createElement("td");
						
						trElmt.setAttribute("class", "bnkWebFolder");
						trElmt.setAttribute("_fileId", result[i]["fileId"]);
						trElmt.setAttribute("_filePath", result[i]["filePath"]);
						
						var inputElmt = document.createElement("input");
						inputElmt.setAttribute("type", "checkbox");
						inputElmt.setAttribute("value", result[i]["fileId"]);
						inputElmt.setAttribute("class", "checkBnk");			
						inputElmt.onchange = function(e){getChecked(this);};
						tdElmt1.appendChild(inputElmt);
						
						var fileIconElmt = document.createElement("img");
						fileIconElmt.setAttribute("class", "webFolderImg");
						fileIconElmt.src = result[i]["fileIconUrl"];
						tdElmt2.appendChild(fileIconElmt);
						
						tdElmt3.textContent = result[i]["fileName"];
						tdElmt4.textContent = getFileSize(result[i]["fileSize"]);
						
						if (primary == "1") {
							tdElmt5.textContent = result[i]["createName1"];
						}
						else {
							tdElmt5.textContent = result[i]["createName2"];
						}
						
						tdElmt6.textContent = result[i]["createDate"].substring(0, 10);
						tdElmt7.textContent = result[i]["updateDate"].substring(0, 10);
						tdElmt8.textContent = result[i]["filePosition"];
						tdElmt9.textContent = result[i]["downloadCnt"];
						tdElmt9.setAttribute("style","text-align: center;");
						
						trElmt.appendChild(tdElmt1);
						trElmt.appendChild(tdElmt2);
						trElmt.appendChild(tdElmt3);
						trElmt.appendChild(tdElmt4);
						trElmt.appendChild(tdElmt5);
						trElmt.appendChild(tdElmt6);
						trElmt.appendChild(tdElmt7);
						trElmt.appendChild(tdElmt8);
						trElmt.appendChild(tdElmt9);
						tableList.appendChild(trElmt);
					}
				} 
			}
			
			function startSearch() {
				var sDateVal    = document.getElementById("Sdatepicker").value;
				var eDateVal    = document.getElementById("Edatepicker").value;
				var fileExtVal  = document.getElementById("fileExtVal").value;
				var fileNameVal = document.getElementById("fileNameVal").value;
				var userNameVal = document.getElementById("fileCreatorVal").value;
				//var fileTypeVal = document.getElementById("fileTypeSelect").value;
				
				if (!sDateVal && !eDateVal && !fileExtVal && !fileNameVal && !userNameVal) {
					alert("<spring:message code='ezWebFolder.t163'/>");
					return;
				}
				
				if ((!sDateVal && eDateVal) || (sDateVal && !eDateVal)) {
					alert("<spring:message code='ezWebFolder.t184'/>");
					return;
				}
				
				if (sDateVal && eDateVal) {
					if (sDateVal > eDateVal) {
						alert("<spring:message code='ezWebFolder.t164'/>");
						return;
					}
				}
				
				startDateStr = sDateVal;
				endDateStr   = eDateVal;
				fileExtStr   = fileExtVal;
				fileNameStr  = fileNameVal;
				userNameStr  = userNameVal;
				
				openSearchPanel();
				search_Set("1");
			}
			
			function change() {
				refresh();
				window.parent.frames["left"].getData(document.getElementById("companyList").value, 1);
			}
			
			function fileDownload() {
				if (checkedArr.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				var checkedList = checkedArr[0];
				
				for (var i = 1; i < checkedArr.length; i++) {
					checkedList = checkedList + "," + checkedArr[i];
				}
				
				var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + checkedList;
				
				AttachDownFrame.location.href = downloadUrl;
				
			}
			
			function fileUpload() {
				document.getElementById("file").click();
			}
			
			function fileDelete() {
				if (checkedArr.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				var checkedList = checkedArr[0];
				
				for (var i = 1; i < checkedArr.length; i++) {
					checkedList = checkedList + "," + checkedArr[i];
				}
				
				DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + checkedList);
			}
			
			function fileRename() {
				if (checkedArr.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				if (checkedArr.length > 1) {
					alert("<spring:message code='ezWebFolder.t115'/>");
					return;
				}
				
				var fileId = checkedArr[0];
				
				DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
			}
			
			function fileMove() {
				if (checkedArr.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				if (checkedArr.length > 1) {
					alert("<spring:message code='ezWebFolder.t115'/>");
					return;
				}
				
				var fileId = checkedArr[0];
				
				DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileId=" + fileId + "&rootFolder=" + rootFolder);
			}
			
			function getChecked(obj) {
				var id = obj.getAttribute("value");
				if (obj.checked == true) {
					checkedArr.push(id);
				}
				else {
					var pos = checkedArr.indexOf(id);
					
					if (pos != -1) {
						checkedArr.splice(pos, 1);
					}
				}
			}
			
			function getCheckAll(obj) {
				var listInputs = document.getElementsByClassName("checkBnk");
				
				checkedArr = [];
				if (obj.checked == true) {
					for (var i = 0; i < listInputs.length; i++) {
						listInputs[i].checked = true;
						checkedArr.push(listInputs[i].value);
					}
				}
				else {
					for (var i = 0; i < listInputs.length; i++) {
						listInputs[i].checked = false;
					}
				}
			}
			
			function refresh() {
				startDateStr = "";
				endDateStr   = "";
				fileExtStr   = "";
				fileNameStr  = "";
				userNameStr  = "";
				search_Set("1");
			}
			
			function refreshView() {
				search_Set(currentPage);
			}
			
			function optionView(obj){
				if (obj.getAttribute("mode") == "off") {
					document.getElementById("layer_Viewpopup").style.left    = document.documentElement.clientWidth - 260 + "px";
					document.getElementById("layer_Viewpopup").style.top     = "96px";
					document.getElementById("layer_Viewpopup").style.display = "";
					obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
					obj.setAttribute("mode", "on");
				}
				else {
					optionHidden();
				}
			}
			
			function optionHidden() {
				document.getElementById("layer_Viewpopup").style.display = "none";
				document.getElementById("webfolderlistoptiondiv").setAttribute("mode", "off");
				document.getElementById("webfolderlistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
			}
		</script>
	</head>
	<body class="mainbody">
		<h1>
			<spring:message code='ezWebFolder.t214' />
			<span id="mailBoxInfo"></span>
		</h1>
		
		<div id="mainmenu" style="position: relative;">
			<ul>
				<li id=""><a onClick="fileDownload()"    style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t186'/></span></a></li>
				<li id=""><a onClick="fileUpload()"      style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t187'/></span></a></li>
				<li id=""><a onClick="fileDelete()"      style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t117'/></span></a></li>
				<li id=""><a onClick="fileRename()"      style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t118'/></span></a></li>
				<li id=""><a onClick="fileMove()"        style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t120'/></span></a></li>
				<li id=""><a onClick="openSearchPanel()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t123'/></span></a></li>
				<li id=""><a onClick="refresh()"         style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t139'/></span></a></li>
				<li id="right" style="float:right;">
					<spring:message code='ezWebFolder.t215'/>
					<img src ="/images/kr/cm/btn_arrow_down.gif" mode="off" id="webfolderlistoptiondiv" onclick="optionView(this);">
				</li>
			</ul>
			<div style="position: absolute; top: 0px; right: 85px;">
				<select style="height: 27px; border-radius: 3px;" id="fileTypeSelect" onchange="refresh();">
					<option value="1"><spring:message code='ezWebFolder.t191'/></option>
					<option value="2"><spring:message code='ezWebFolder.t192'/></option>
					<option value="3"><spring:message code='ezWebFolder.t193'/></option>
					<option value="4"><spring:message code='ezWebFolder.t194'/></option>
					<option value="5"><spring:message code='ezWebFolder.t195'/></option>
					<option value="6"><spring:message code='ezWebFolder.t196'/></option>
					<option value="7"><spring:message code='ezWebFolder.t213'/></option>
				</select>
			</div>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<div id="searchPanel" style="position: fixed; top: 132px; left: 200px; height: 180px; width: 514px; border: 1px solid #666666; z-index: 10; background-color: #f2f2f2; display: none;">
			<div style="margin: 10px;">
				<table class="content" style="border-collapse: collapse; width: 100%;">
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t151'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
							~
							<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
						</td>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t152'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input id="fileExtVal" type="text" style="height: 23px; width: 200px;">
						</td>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t153'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input id="fileNameVal" type="text" style="height: 23px; width: 200px;">
						</td>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t197'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input id="fileCreatorVal" type="text" style="height: 23px; width: 200px;">
						</td>
					</tr>
				</table>
					<div style="margin: 12px 50px 12px 180px;">
						<a class="webfolderBttn"><span onclick="startSearch();"    ><spring:message code='ezWebFolder.t123'/></span></a>
						<a class="webfolderBttn"><span onclick="openSearchPanel();"><spring:message code='ezWebFolder.t112'/></span></a>
					</div>
			</div>
		</div>
		
		<div id="progress-wrp" style="display: none;">
			<div class="progress-bar"></div ><div class="status">0%</div>
		</div>
		
		<div id="dragDropArea" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="margin: 10px 0px;">
			<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
				<tr>
					<th width="10px" ><input type="checkbox" onchange="getCheckAll(this);" id="_checkAll"></th>
					<th width="40px" ><spring:message code='ezWebFolder.t188'/></th>
					<th width="160px"><spring:message code='ezWebFolder.t156'/></th>
					<th width="60px" ><spring:message code='ezWebFolder.t157'/></th>
					<th width="120px"><spring:message code='ezWebFolder.t189'/></th>
					<th width="80px" ><spring:message code='ezWebFolder.t190'/></th>
					<th width="80px" ><spring:message code='ezWebFolder.t198'/></th>
					<th width="160px"><spring:message code='ezWebFolder.t199'/></th>
					<th width="60px" ><spring:message code='ezWebFolder.t200'/></th>
				</tr>
			</table>
		</div>
		
		<div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
			<div class="popupwrap1">	
				<div class="popupwrap2">
					<table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
						<tr>
							<th><spring:message code='ezBoard.t10021'/></th>
							<td>
								<select id="listcount" style="width: 40px; height: 20px;" onchange="ListCount(this.value);">
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="30">30</option>
									<option value="40">40</option>
									<option value="50">50</option>
								</select>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="shadow"></div>
		</div>
		
		<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width:1px; height:1px; display:none;"/>
		<input type="hidden" onclick="fileupload()"/>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
		<div class="layerpopup" style="z-index:2000; position:absolute; display:none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<div id="tblPageRayer"></div>
		<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	</body>
</html>