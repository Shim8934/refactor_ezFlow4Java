<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>"   type="text/css">
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css"            type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css"/>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"                ></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"                          ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"                             ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"      ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"              ></script>
		<script type="text/javascript" src="/js/jquery-ui/jquery-ui.js"                     ></script>
		<script type="text/javascript" src="/js/ezWebFolder/bnk.js"                         ></script>
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
			var folderType   = "dept";
			
			document.onselectstart = function(){
				return false;
			}
			
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
				
				$('#fileTypeSelect').ddslick({
					onSelected: function(selectedElmt){
						//callback function: do something with selectedData;
						document.getElementById("fileTypeSelect").value = selectedElmt.selectedData["value"];
						refresh();
					}
				});
				
				search_Set("1");
				preProcessing();
			}
			
			function preProcessing() {
				var divList          = document.getElementById("dragDropArea");
				var reheight         = document.documentElement.clientHeight - 195;
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
						currentPage = pPage > totalPages ? totalPages : pPage;
						
						makePageSelPage();
						renderData(result);
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
						trElmt.onclick = function(event) {clickRow(event);};
						
						var inputElmt = document.createElement("input");
						inputElmt.setAttribute("type", "checkbox");
						inputElmt.setAttribute("value", result[i]["fileId"]);
						inputElmt.setAttribute("class", "checkBnk");
						inputElmt.onclick = function(e){getChecked(e);};
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
			
			function clickRow(e) {
				e.stopPropagation();
				e.preventDefault();
				var trElmt    = e.currentTarget;
				var inputElmt = trElmt.firstElementChild.firstElementChild;
				
				if (inputElmt.checked == true) {
					inputElmt.checked = false;
					trElmt.setAttribute("class", "bnkWebFolder");
				}
				else {
					inputElmt.checked = true;
					trElmt.setAttribute("class", "bnkWebFolder2");
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
				window.parent.frames["left"].getDepartmentData(document.getElementById("companyList").value, 1, "folderTree2");
			}
			
			function fileDownload() {
				var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
				
				if (listOfChecked.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				var filesList = [];
				
				for (var i = 0; i < listOfChecked.length; i++) {
					var fileFolderId = listOfChecked[i].getAttribute("_fileId");
					filesList.push(fileFolderId);
				}
				
				var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
				AttachDownFrame.location.href = downloadUrl;
			}
			
			function fileUpload() {
				document.getElementById("file").click();
			}
			
			function fileDelete() {
				var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
				
				if (listOfChecked.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				var filesList = [];
				
				for (var i = 0; i < listOfChecked.length; i++) {
					var fileFolderId = listOfChecked[i].getAttribute("_fileId");
					filesList.push(fileFolderId);
				}
				
				DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + filesList.toString());
			}
			
			function fileRename() {
				var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
				
				if (listOfChecked.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				if (listOfChecked.length > 1) {
					alert("<spring:message code='ezWebFolder.t115'/>");
					return;
				}
				
				var fileId = listOfChecked[0].getAttribute("_fileId");
				DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
			}
			
			function fileMove() {
				var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
				
				if (listOfChecked.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				var filesList = [];
				
				for (var i = 0; i < listOfChecked.length; i++) {
					var fileFolderId = listOfChecked[i].getAttribute("_fileId");
					filesList.push(fileFolderId);
				}
				
				DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + filesList.toString() + "&mode=admin");
			}
			
			function getChecked(event) {
				event.stopPropagation();
				var checkboxElmt = event.currentTarget;
				var trElmt       = checkboxElmt.parentElement.parentElement;
				trElmt.setAttribute("class", checkboxElmt.checked == true ? "bnkWebFolder2" : "bnkWebFolder");
			}
			
			function getCheckAll(obj) {
				var listInputs = document.getElementsByClassName("checkBnk");
				
				if (obj.checked == true) {
					for (var i = 0; i < listInputs.length; i++) {
						listInputs[i].checked = true;
						var trElmt            = listInputs[i].parentElement.parentElement;
						trElmt.setAttribute("class", "bnkWebFolder2");
					}
				}
				else {
					for (var i = 0; i < listInputs.length; i++) {
						var trElmt            = listInputs[i].parentElement.parentElement;
						listInputs[i].checked = false;
						trElmt.setAttribute("class", "bnkWebFolder");
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
			
			function toggleUploadBttn(levelValue) {
				document.getElementById("uploadBttn").style.display = levelValue == '0' ? 'none' : "";
				var dragDropAreaElmt                                = document.getElementById("dragDropArea");
				
				if (levelValue == '0') {
					dragDropAreaElmt.ondragenter = null;
					dragDropAreaElmt.ondragover  = null;
					dragDropAreaElmt.ondragover  = null;
				}
				else {
					dragDropAreaElmt.ondragenter = function(e) {onDragEnter(e)};
					dragDropAreaElmt.ondragover  = function(e) {onDragOver(e)};
					dragDropAreaElmt.ondrop      = function(e) {onDrop(e)};
				}
			}
		</script>
	</head>
	<body class="mainbody" onresize="preProcessing();">
		<h1>
			<spring:message code='ezWebFolder.t127' />
			<span id="mailBoxInfo"></span>
		</h1>
		<div id="companySelect" style="margin: 10px 0px;">
			<span style="font-size: 16px; display:inline-block; height: 21px; vertical-align: middle;"><b><spring:message code='ezWebFolder.t129'/></b></span>
			<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;" onchange="change();">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</div>
		
		<div id="mainmenu2" style="position: relative;">
			<ul>
				<li id=""><a onClick="fileDownload()"    style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t186'/></span></a></li>
				<li id="uploadBttn" style="display: none;"><a onClick="fileUpload()"      style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t187'/></span></a></li>
				<li id=""><a onClick="fileDelete()"      style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t117'/></span></a></li>
				<li id=""><a onClick="fileRename()"      style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t118'/></span></a></li>
				<li id=""><a onClick="fileMove()"        style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t120'/></span></a></li>
				<li id=""><a onClick="openSearchPanel()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t123'/></span></a></li>
				<li id=""><a onClick="refresh()"         style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t139'/></span></a></li>
			</ul>
			<div style="position: absolute; top: 0px; right: 10px;">
				<select style="height: 27px; border-radius: 3px; display: none;" id="fileTypeSelect" onchange="refresh();">
					<option value="1" data-imagesrc="/images/webfolder/allTypes.png" selected><spring:message code='ezWebFolder.t191'/></option>
					<option value="2" data-imagesrc="/images/webfolder/msWord.png"           ><spring:message code='ezWebFolder.t192'/></option>
					<option value="3" data-imagesrc="/images/webfolder/mp3.png"              ><spring:message code='ezWebFolder.t193'/></option>
					<option value="4" data-imagesrc="/images/webfolder/mp4.png"              ><spring:message code='ezWebFolder.t194'/></option>
					<option value="5" data-imagesrc="/images/webfolder/jpg.png"              ><spring:message code='ezWebFolder.t195'/></option>
					<option value="6" data-imagesrc="/images/webfolder/zip.png"              ><spring:message code='ezWebFolder.t196'/></option>
				</select>
			</div>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu2"), "ul", "li", "0");
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
		
		<div id="dragDropArea" style="margin: 10px 0px; overflow-y: auto;">
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
		
		<input id="file" type="file" onchange="onDrop()" onclick="this.value = null;" multiple="multiple" style="width: 1px; height: 1px; display:none" />
		<input type="hidden" onclick="fileupload()"/>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<div id="tblPageRayer"></div>
		<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	</body>
</html>