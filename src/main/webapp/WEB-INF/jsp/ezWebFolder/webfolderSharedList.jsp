<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>"   type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezWebFolder.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
		<link rel="stylesheet" href="/js/jquery/jquery.modal.css" type="text/css" />
		<!-- module -->
		<script type="text/javascript" src="/js/ezWebFolder/context/row-selector.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/context/favorite.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/context/search.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/selectUsers.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/popup.js"></script>
		<script type="text/javascript">
			var file 		 = new Array();
			var primary      = "<c:out value='${primary}'/>";
			var strShared1	= messages.strLang2;
			var strShared2	= messages.strLang3;
			var strErr		= messages.strLang4;
			var appType     = "user";
			var userName = "${userInfo.userName}";
			var currentPage = 1;
			var totalPages = 0 ;
			var totalRows = 0 ;
			var blockSize = 0;
			var filelist = [];
			var strSuccess  = "<spring:message code = 'ezWebFolder.t27'/>";
			var pStart = 0;
			var pEnd = 10;
			var folderId = "${folderId}";
			var folderType = "${folderType}";
			var fileCnt ;
			var fldCnt;
			var originalPath = "";
			
			// fileList 브라우저 화면 크기 변했을때 유동적화면 변화
			window.onresize = function () {
				var divList          = document.getElementById("dragDropArea");
				var reheight         = document.documentElement.clientHeight - 220;
				divList.style.height = reheight + "px";
			};
			
			document.onselectstart = function() {
				return false;
			}
			
			$(function () {
				$('#upload').css('display','none');
				pEnd= pStart + blockSize;
				getFileList(folderId);
				
				searchContext.setSearchStartEventHandler(function() {
					getFileList(folderId);
				});
				
				searchContext.setFileTypeChangeEventHandler(function() {
					getFileList(folderId);
				})
				
				window.onresize();
				
				// datepicker setup
				$(".datepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly: true
				});
		
		        $(".datepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $(".datepicker").datepicker('setDate', "");
		     });
			
			function getFileList(pPage) {
				searchRequirement = searchContext.getCurrentRequirement();
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/getSharedList.do",
					data: {
						"pageNum"           : pPage,
						"searchExt"         : searchRequirement.extension,
						"searchFileName"    : searchRequirement.name,
						"searchCreatorName" : searchRequirement.creatorName,
						"searchFileType"    : searchContext.getFileType(),
						"searchStartDate"   : searchRequirement.startDate,
						"searchEndDate"     : searchRequirement.endDate
					},
					dataType: "JSON",
					async: true,
					success : function(result) {
						if (result.status == "ok") {
							var data = result.data;
							currentPage = pPage;
							totalPages  = data.totalPage;
							fileRows    = data.fileCount;
							folderRows  = data.folderCount;
							totalRows   = data.totalCount;
							
// 							makePageSelPage();
							renderData(data.list);
							checkedArr = [];
							
							document.getElementById("mailBoxInfo").innerHTML = " - [<spring:message code='ezWebFolder.t276'/> <span style='color:#017BEC;'>" 
								+ folderRows + "</span> " + strLang42 + " / " + "<spring:message code='ezWebFolder.t277'/>" + " <span style='color:#017BEC;'>" + fileRows +" </span>" + strLang42 + "]";
						} else {
							alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function renderData(result) {
				var tableList = document.getElementById("tblFileList");
				document.getElementById("_checkAll").checked = false;
				
				while (tableList.rows.length > 1) {
					tableList.deleteRow(1);
				}
				
				if (result == null || result.length == 0) {
					var trElmt = document.createElement("tr");
					var tdElmt = document.createElement("td");
					tdElmt.setAttribute("colspan", "10");
					tdElmt.setAttribute("align", "center");
					tdElmt.setAttribute("bgcolor", "#FFFFFF");
					tdElmt.innerHTML = messages.strLang12;
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
						var tdElmt10 = document.createElement("td");
						
						setTextOverflowEllipsis(tdElmt4, tdElmt5, tdElmt6, tdElmt7, tdElmt8, tdElmt9, tdElmt10);
						setTextAlignCenter(tdElmt2, tdElmt3, tdElmt5, tdElmt10);
						
						trElmt.setAttribute("class", "bnkWebFolder");
						trElmt.setAttribute("targetId", result[i]["fileId"]);
						trElmt.setAttribute("targetType", result[i]["fileTypeName"] == 'folder' ? 'folder' : 'file');
						trElmt.addEventListener("click", function(event) { rowContext.onRowClick(this); });
						
						if (result[i]["fileTypeName"] != 'folder') {
							trElmt.addEventListener("dblclick", function(event) {downloadFileByDbClick(event);});
						}
						
						var inputElmt = document.createElement("input");
						inputElmt.setAttribute("type", "checkbox");
						inputElmt.setAttribute("value", result[i]["fileId"]);
						inputElmt.setAttribute("class", "checkBnk");
						inputElmt.addEventListener("change", function(event) { event.stopPropagation(); rowContext.onCheckboxChange(this); });
						inputElmt.addEventListener("click", function(event) { event.stopPropagation(); });
						inputElmt.addEventListener("dblclick", function(event) { event.stopPropagation(); });
						
						tdElmt1.appendChild(inputElmt);
						
						var faImgElmt = document.createElement("img");
						faImgElmt.setAttribute("class", "none-drag");
						faImgElmt.addEventListener("click", function() { favoriteContext.onImageClick(this); });
						faImgElmt.addEventListener("dblclick", function(event) { event.stopPropagation(); });
						
						if (result[i]["favouriteStatus"] == "0") {
							faImgElmt.src = "/images/ImgIcon/view-flag.gif";
						} else {
							faImgElmt.src = "/images/ImgIcon/icon-flag.gif";
							trElmt.setAttribute("favorite", "");
						}
						
						tdElmt2.appendChild(faImgElmt);
						
						var fileIconElmt = document.createElement("img");
						fileIconElmt.setAttribute("class", "webFolderImg");
						fileIconElmt.src = result[i]["fileIconUrl"];
						tdElmt3.appendChild(fileIconElmt);
						
						tdElmt4.textContent = result[i]["fileName"];
						
						tdElmt5.setAttribute("style", "text-align:center;");
						if (result[i]["folderFileType"] == 'F') {
							tdElmt5.textContent = getFileSize(result[i]["fileSize"]);
						} else {
							tdElmt5.textContent = "-";
						}
						
						tdElmt6.textContent = result[i]["createName"];
						tdElmt7.textContent = result[i]["createDate"].substring(0, 10);
						tdElmt8.textContent = result[i]["updateDate"].substring(0, 10);
						
						if (result[i]["folderFileType"] == 'F') {
							tdElmt9.textContent = result[i]["folderPath"];
						} else {
							tdElmt9.textContent = result[i]["folderPath"].slice(0, -(result[i]["fileName"].length + 1));
						}
						
						tdElmt10.textContent = result[i]["sharerName"];
						
// 						if(result[i]["typeId"] == "folder") {
// 							trElmt.ondblclick = function() {
// 								getFileList(this.getAttribute("targetId"));
// 							};
// 						}
						
						trElmt.appendChild(tdElmt1);
						trElmt.appendChild(tdElmt2);
						trElmt.appendChild(tdElmt3);
						trElmt.appendChild(tdElmt4);
						trElmt.appendChild(tdElmt5);
						trElmt.appendChild(tdElmt6);
						trElmt.appendChild(tdElmt7);
						trElmt.appendChild(tdElmt8);
						trElmt.appendChild(tdElmt9);
						trElmt.appendChild(tdElmt10);
						
						tableList.appendChild(trElmt);
					}
				} 
			}
			
			function setTextOverflowEllipsis() {
				var element;
				argumentsLength = arguments.length;
				
				for (var i = 0; i < argumentsLength; i++) {
					element = arguments[i];
					element.style.overflow = "hidden";
					element.style.textOverflow = "ellipsis";
					element.style.whiteSpace = "nowrap";
				}
			}
			
			function setTextAlignCenter() {
				var element;
				argumentsLength = arguments.length;
				
				for (var i = 0; i < argumentsLength; i++) {
					element = arguments[i];
					element.style.textAlign = "center";
				}
			}
			
			// 날짜 초기화 버튼
		   	function clearDatepicker() {
		        $(".datepicker").datepicker('setDate', "");
		    }
			
			function goToPageByNum(Value) {
		    	currentPage = Value;
		        pStart = (blockSize * (currentPage)) - blockSize;
		        pEnd = blockSize;
		        getFileList(folderId);
		    }
		    
		   	// TODO : 여기서부터 코드 정리하면서 내려가서 list 뿌리기 
			function search(type) {
				if (type == "basic") {
					requirement = {
						startDate: $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
						endDate: $('#Edatepicker').datepicker({ dateFormat: 'yy-mm-dd' }).val(),
						name: $('#searchFileName').val(),
						creatorName: $('#searchCreateName').val(),
						extension: $('#searchExt').val()
					};
		        	
					if (requirement.extension == "" && requirement.name == "" && requirement.creatorName == "" && requirement.startDate == "") {
						alert(messages.strLang20);
						return;
					}
		
					if (requirement.startDate != "" && requirement.endDate == "") {
						alert(messages.strLang18);
						return;
					}
		           
					if (requirement.startDate == "" && requirement.endDate != "") {
						alert(messages.strLang18);
						return;
					}
		
					if (new Date(requirement.startDate) > new Date(requirement.endDate)) {
						alert(messages.strLang19);
						return;
					}
	           
					searchContext.search(requirement.startDate, requirement.endDate, requirement.name, requirement.creatorName, requirement.extension);
				} else if (type == "quick") {
					if (document.getElementById("txt_keyword").value == "") {
						alert(messages.strLang20);
						return;
					}
				}
				
				searchOptionHidden();
			}
			
			function doLayerPopup(obj) {
		        var searchRequirement = searchContext.getCurrentRequirement();
		        clearDatepicker();
		        
		        $('#searchExt').val(searchRequirement.extension);               
	            $('#searchFileName').val(searchRequirement.name);
	            $('#searchCreateName').val(searchRequirement.creatorName);
	            $('#Sdatepicker').val(searchRequirement.startDate);
	            $('#Edatepicker').val(searchRequirement.endDate);
		    
		        /* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
		        var leftBody = parent.frames["left"].document.body;
		        leftBody.style.overflow = "hidden";
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].searchOptionHidden();document.body.style.overflow=\"auto\";'></div>").appendTo(leftBody);        	
	        	var popupX = parent.document.body.clientWidth / 2 - (500 / 2) - 220;
	        	
	        	$("#srarchpopup").css("left", popupX);
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	
	        	$("#srarchpopup").modal();
		    }
			
			function searchOptionHidden() {
		    	$.modal.close();
		    }
			
			function optionView(obj){
		   		 if (obj.getAttribute("mode") == "off") {
		   	        document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
//		    	        if(pAdminType == "y")
		   	            document.getElementById("layer_Viewpopup").style.top = "130px";
//		    	        else
//		    	            document.getElementById("layer_Viewpopup").style.top = "100px";
		   	        document.getElementById("layer_Viewpopup").style.display = "";
		   	        obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
		   	        obj.setAttribute("mode", "on");
		   	    } else {
		   	        optionHidden();
		   	    }
		   	}
	   	   
		 	function optionHidden() {
		 	    document.getElementById("layer_Viewpopup").style.display = "none";
		 	    document.getElementById("webfolderlistoptiondiv").setAttribute("mode", "off");
		 	    document.getElementById("webfolderlistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
		 	}
		 	
			function fileDownload() {
				var selected = getSelectedFoldersAndFiles();
				
				if (selected === undefined) {
					return;
				}
	    		
	    		var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + selected.files.toString() + "&folderList=" + selected.folders.toString();
				
				AttachDownFrame.location.href = downloadUrl;
			}
			
			function endUpdate() {

			}
			
			function fileUpload2() {
				document.getElementById("file").click();
//	     	   refreshView();
//	     	   endUpdate();
			}
	       
			function refreshView() {
				getFileList(folderId);
			}
	       
	       function fileDelete() {
				var selected = getSelectedFoldersAndFiles();
				
				if (selected === undefined) {
					return;
				}
				
				if (selected.folders.length > 0) {
					alert(messages.strLang1);
					return;
				}
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/checkPermission.do",
					data: {
						"fileList" : selected.files.toString()
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.resultValue;
						
						if (result != "ok") {
							alert(messages.strLang13);
						} else {
							openLeftPanel();
							DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + selected.files.toString());
						}
						
						refreshView();
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					}
				});
			}
			
			function fileRename() {
				var selected = getSelectedFoldersAndFiles();
				
				if (selected === undefined) {
					return;
				}
				
				if (selected.folders.length > 0) {
					alert(messages.strLang1);
					return;
				}
				
				if (selected.files.length > 1) {
					alert(messages.strLang6);
					return;
				}
				
				var fileId = selected.files[0];
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/checkPermission.do",
					data: {
						"fileId" : fileId
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.resultValue;
						
						if (result != "ok") {
							alert(messages.strLang13);
						} else {
							openLeftPanel();
							DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
						}
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					}
				});
			}
			
			function fileMove() {
				var selected = getSelectedFoldersAndFiles();
				
				if (selected === undefined) {
					return;
				}
				
				if (selected.folders.length > 0) {
					alert(messages.strLang1);
					return;
				}
				
				openLeftPanel();
				DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + selected.files.toString());
			}
			
			function getSelectedFoldersAndFiles() {
				var selectedRows = rowContext.getSelectedRows();
				var selectedLength = selectedRows.length;
				
				if (selectedLength <= 0) {
					alert(messages.strLang5);
					return undefined;
				}
				
				var files  = [];
				var folders = [];
				var rowInfo;
				
				for (var i = 0; i < selectedLength; i++) {
					rowInfo = rowContext.getRowInfo(selectedRows[i]);
					
					if (rowInfo.type === 'D') {
						folders.push(rowInfo.id);
					} else {
						files.push(rowInfo.id);
					}
				}
				
				return {
					folders : folders,
					files : files
				}
			}
			
			function changeCount(value) {
				blockSize = value;
				currentPage = 1;
				pStart = 0;
				refreshView();
			}
	       
			function onFileTypeChange(value) {
				if (value == "all") {
					value = "";
				}
				
				currentPage = 1;
				searchContext.setFileType(value);
			}
	       
			function addShare() {
				var selectedRows = rowContext.getSelectedRows();
				var selectedLength = selectedRows.length;
				
				if (selectedLength == 0) {
					alert("파일 또는 폴더를 선택하세요.");
					return;
				}
				
				if (selectedLength > 1) {
					alert("하나만 선택하세요.");
					return;
				}
				
				var folderFileInfo = rowContext.getRowInfo(selectedRows[0]);
				var folderFileId = folderFileInfo.id;
				var folderFileType = folderFileInfo.type;
	            var openWindow = window.open("/ezWebFolder/addShareView.do?folderFileId=" + folderFileId + "&folderFileType=" + folderFileType, "addShareView", GetOpenWindowfeature(610, 685));
	            try { openWindow.focus(); } catch (e) { }
			}
			
			function downloadFileByDbClick(event) {
				event.stopPropagation();
				event.preventDefault();
				var trElmt       = event.currentTarget;
				var fileFolderId = trElmt.getAttribute("targetId");
				var filesList    = [];
				filesList.push(fileFolderId);
				
				var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
				AttachDownFrame.location.href = downloadUrl;
			}
			
			function openLeftPanel() {
				var leftFrame = window.parent.frames["left"].document;
				var blockLeft = leftFrame.getElementById("bnkBlockLeft");
				var height    = Math.max(leftFrame.documentElement.clientHeight, leftFrame.documentElement.scrollHeight);
				leftFrame.body.style.overflow = "hidden";
				blockLeft.style.height        = height + "px";
				blockLeft.style.display       = "";
			}

			function closeLeftPanel() {
				var leftFrame = window.parent.frames["left"].document;
				var blockLeft = leftFrame.getElementById("bnkBlockLeft");
				leftFrame.body.style.overflow = "auto";
				blockLeft.style.height        = "100%";
				blockLeft.style.display       = "none";
			}
			
			function hideShare() {
				if (checkedArr.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				var jsonStr = JSON.stringify(checkedArr);
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/hideShare.do",
					contentType : "application/json; charset=UTF-8",
					data: jsonStr,
					dataType: "JSON",
					async: true,
					success : function(result) {
						if (result.status == "ok") {
							refreshView();
						} else {
							alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
				
			}
			
			function showHiddenSharedList(pPage) {
				location.href = "/ezWebFolder/webfolderHiddenSharedList.do";
			}
		</script>
	</head>
	<body class="mainbody">
		<h1>
			<spring:message code='ezWebFolder.t214' />
			<span id="mailBoxInfo"></span>
		</h1>
		
		<div style="height:40px;">
			<span style="font-size: 24px;font-weight: bold;font-weight: bold; display: block; float: left;" id ="originalPath" ></span>
		</div>
		
		<div id="mainmenu">
			<ul>
				<li><a onClick="fileDownload()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t186'/></span></a></li>
				<li id="upload"><a onClick="fileUpload2()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t187'/></span></a></li>
				<li><a onClick="fileDelete()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t117'/></span></a></li>
				<li><a onClick="fileRename()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t118'/></span></a></li>
				<li><a onClick="fileMove()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t120'/></span></a></li>
				<li><a onClick="hideShare()" style="margin-top: 3px;"><span>공유숨김</span></a></li>
				<li><a onClick="showHiddenSharedList(1)" style="margin-top: 3px;"><span>공유숨김목록</span></a></li>
				<li><span onClick="favoriteContext.toggleAll()"><spring:message code='ezWebFolder.t281'/></span></li>
				<li><a onClick="refreshView()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t139'/></span></a></li>
				<li id="SearchOption" mode="off" onClick="doLayerPopup(this)"><span><spring:message code='ezWebFolder.t123'/></span></li>
				<li>
					<select style="height: 27px; border-radius: 3px;" id="fileTypeSelect" onchange="refresh();">
						<option value=""><spring:message code='ezWebFolder.t191'/></option>
						<option value="document"><spring:message code='ezWebFolder.t192'/></option>
						<option value="music"><spring:message code='ezWebFolder.t193'/></option>
						<option value="video"><spring:message code='ezWebFolder.t194'/></option>
						<option value="image"><spring:message code='ezWebFolder.t195'/></option>
						<option value="zip"><spring:message code='ezWebFolder.t196'/></option>
						<option value="folder"><spring:message code='ezWebFolder.t213'/></option>
					</select>
				</li>
				<li id="right" style="float:right;">
					<label for="webfolderlistoptiondiv"><spring:message code='ezWebFolder.t215'/></label>
					<img src ="/images/kr/cm/btn_arrow_down.gif" mode="off" id="webfolderlistoptiondiv" onclick="optionView(this);">
				</li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<div id="progress-wrp" style="display: none;">
	    	<div class="progress-bar"></div ><div class="status">0%</div>
	    </div>
		
		<div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
	        <div class="popupwrap1">	
	            <div class="popupwrap2">
	                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width: 80px;">
	                        <col>
	                    </colgroup>
	                    <tr>
	                        <th><spring:message code='ezBoard.t10021' /></th>
	                        <td>
	                            <select id="listcount" style="width: 40px; height: 20px;" onchange="changeCount(this.value);">
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
	        <div class="shadow">
	        </div>
	 	</div>
		
		<div id="dragDropArea" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="margin: 10px 0px;">
			<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
				<tr>
					<th width="30px"><input type="checkbox" onchange="getCheckAll(this);" id="_checkAll"></th>
					<th width="30px"><img src='/images/ImgIcon/icon-flag.gif' /></th><!-- 즐겨찾기 -->
					<th width="30px"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
					<th width="50%"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
					<th width="70px" style="text-align:center;">크기</th><!-- 크기 -->
					<th width="100px"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
					<th width="100px"><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
					<th width="100px"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
					<th width="50%"><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
					<th width="110px">공유자</th><!-- 공유자 -->
				</tr>
			</table>
		</div>
		
		<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width:1px; height:1px; display:none;"/>
		<input type="hidden" onclick="fileupload()"/>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
		<div class="layerpopup" style="z-index:2000; position:absolute; display:none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<div id="srarchpopup" class="popupwrap3" style="display:none;padding-top:20px;padding-bottom:20px;margin-bottom:70px">
			<div class="popupwrap4">
				<table class="content" style="margin-top:10px;">  
					<tr>
						<th class="layerHeader" colspan="2"><img src="/images/kr/left/left_mail.png" style="vertical-align: middle;padding-bottom:1px"/>&nbsp;<spring:message code='ezWebFolder.t10' /></th>
					</tr>
					<tr>
			           <th style="text-align:center"><spring:message code='ezBoard.t210' /></th>
			           <td>
			               <input type="text" id="Sdatepicker" class="datepicker" style="width:80px;text-align:center" readonly="readonly">
			                ~
			               <input type="text" id="Edatepicker" class="datepicker" style="width:80px;text-align:center" readonly="readonly">
			           </td>
					</tr>
			       
			        <tr>
			            <th style="text-align:center"><spring:message code='ezWebFolder.t152' /></th><!-- 확장자 -->
			            <td><input type="text" id="searchExt" style="width:98%" value="" name="searchExt"></td>
			        </tr>
			        <tr>
			            <th style="text-align:center"><spring:message code='ezWebFolder.t153' /></th><!-- 파일명 -->
			            <td><input type="text" id="searchFileName" style="width:98%" value="" name="searchFileName"></td>
			        </tr>  
			         <tr>
			            <th style="text-align:center"><spring:message code='ezWebFolder.t154' /></th><!-- 작성자 -->
			            <td><input type="text" id="searchCreateName" style="width:98%" value="" name="searchCreateName"></td>
			        </tr>    
				</table>
				<br/>
				<table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezAddress.t142' /></span></a>
							<a class="imgbtn" rel="modal:close"><span onClick="searchOptionHidden()"><spring:message code='ezAddress.t11' /></span></a>
						</td>
					</tr>
				</table>
			</div>
		</div>	
		
		<div id="tblPageRayer"></div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
	</body>
</html>