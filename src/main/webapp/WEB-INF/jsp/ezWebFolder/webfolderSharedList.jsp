<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css" />
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
		<script type="text/javascript" src="/js/ezWebFolder/context/share.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/context/favorite.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/context/search.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/selectUsers.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/popup.js"></script>
		<script type="text/javascript">
			var file 		 = new Array();
			var filelist = [];
			var folderId = "${folderId}";
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
				// dom elements setup
				initDomElement();
				
				$('#upload').css('display','none');
				getFileList();
				
				searchContext.setSearchStartEventHandler(function() {
					getFileList();
				});
				
				searchContext.setFileTypeChangeEventHandler(function() {
					getFileList();
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
		        
		     	// listoption 다른 곳 클릭시 숨김 처리
				var listOptionHidden = function(event) {
					if (dom.listoptiondiv.getAttribute('mode') == "on" && !dom.layerViewpopup.contains(event.target)) {
						optionHidden();
					}
				};
				
				document.addEventListener("click", listOptionHidden);
				parent.frames["left"].document.addEventListener("click", listOptionHidden);
				parent.parent.document.getElementById("topFrame").contentWindow.document.addEventListener("click", listOptionHidden);
				
				// listoption 클릭 이벤트
				dom.listoptiondiv.addEventListener("click", function(event) {
					event.stopPropagation();
					optionView(event.target);
				});
				
				dom.listSizeSelect.addEventListener("change", function(event) {
					optionHidden();
					pagination.setListSize(this.value);
					getFileList(folderId);
				});
		    });
			
			function initDomElement() {
				dom = {
					mailBoxInfo: document.getElementById("mailBoxInfo"),
					mainmenu: document.getElementById("mainmenu"),
					upload: document.getElementById("upload"),
					originalPath: document.getElementById("originalPath"),
					originalPathWrapper: document.getElementById("originalPathWrapper"),
					dragDropArea: document.getElementById("dragDropArea"),
					pageArea: document.getElementById("pageArea"),
					layerViewpopup: document.getElementById("layer_Viewpopup"),
					allCheckBox: document.getElementById("checkAll"),
					listTable: document.getElementById("tblFileList"),
					layerViewpopup: document.getElementById("layer_Viewpopup"),
					listoptiondiv: document.getElementById("webfolderlistoptiondiv"),
					listSizeSelect: document.getElementById("listcount")
				};
			}
			
			function getFileList(folderId) {
				if (typeof(folderId) == "undefined") {
					folderId = "";
				}
				
				searchRequirement = searchContext.getCurrentRequirement();
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/getSharedList.do",
					data: {
						"folderId"          : folderId,
						"pageNum"           : pagination.currentPage(),
						"pageSize"          : pagination.listSize(),
						"searchExt"         : searchRequirement.extension,
						"searchFileName"    : searchRequirement.name,
						"searchCreatorName" : searchRequirement.creatorName,
						"searchFileType"    : searchContext.getFileType(),
						"searchStartDate"   : searchRequirement.startDate,
						"searchEndDate"     : searchRequirement.endDate,
						"subSearchFlag"     : $('#checkSubSearch').is(':checked') ? "Y" : "N"
					},
					dataType: "JSON",
					async: true,
					success : function(result) {
						if (result.status == "ok") {
							var data = result.data;
							
							pagination.setListSize(data.pageSize);
							pagination.setAmount(data.totalCount);
							pagination.build();
							
							renderList(data.list);
							checkedArr = [];
							
							setNamePath(data.folderPath, data.folderPath2);
							setMailBoxInfo(data.folderCount, data.fileCount);
							
						} else {
							alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			// originalPath 는 한글 path
			// folderPath 는 숫자 
			function setNamePath(folderPath, originalPath) {
				var nameTag = document.createElement("span");
				var detailName = [];
				
				$('#originalPath').empty();
				dom.originalPath.appendChild(nameTag);
				
				if (folderPath == null) {
					detailName = document.createElement("span");
					detailName.className = "aName";
					detailName.textContent = "공유받은 목록";
					detailName.setAttribute("style", "font-size:18px; ");
					detailName.onclick = function() {
						getFileList();
					};
					
					nameTag.appendChild(detailName);
					return;
				}
				
				var path = [];
				var imgElmt;
				
				folderPath = folderPath.substring(1, folderPath.length - 1);
				originPath = folderPath.split("|");
				path = originalPath.split("/");
				originPath = folderPath.split("|");
				
				for (var i = 1; i < path.length - 1; i++) {
					detailName = document.createElement("span");
					
					detailName.className = "aName";
					detailName.id = originPath[i];
					detailName.onclick = function() {
						getFileList(this.id);
					};
					detailName.textContent = path[i];
					detailName.setAttribute("style", "font-size:18px; ");
					
					nameTag.appendChild(detailName);
					
					imgElmt = document.createElement("img");
					imgElmt.setAttribute("style", "height: 18px; width: 18px; display: inline-block;");
					imgElmt.src = "/images/webfolder/arrow.png";
					
					if (i != path.length - 2) {
						nameTag.appendChild(imgElmt);
					}
				}
			}
			
			function setMailBoxInfo(folderCount, fileCount) {
				dom.mailBoxInfo.innerHTML = " - [" + messages.strLang15 + " <span style='color:#017BEC;'>" + folderCount + " </span>" + messages.strLang11 + " / " + messages.strLang16 + " <span style='color:#017BEC;'> " + fileCount + " </span>" + messages.strLang11 + "]";
				$("#listcount").val(pagination.listSize()).prop("selected", true);
			}
			
			function renderList(result) {
				checkedArr = [];
				$('#tblFileList tr').not(":first").remove();
				
				dom.allCheckBox.checked = false;
				
				if (result == null || result.length == 0) {
					var row = document.createElement("tr");
					var column = document.createElement("td");
					
					column.setAttribute("colspan", "9");
					column.setAttribute("align", "center");
					column.setAttribute("bgcolor", "#FFFFFF");
					column.innerHTML = messages.strLang12;
					column.setAttribute("id", "nodataRow");
					
					row.appendChild(column);
					dom.listTable.appendChild(row);
					
					return;
				}
				
				var len = result.length;
				var resultJson;
				var isFolder;
				
				var row;
				var checkboxColumn, favoriteIconColumn, fileIconColumn, nameColumn, sizeColumn, creatorColumn, createDateColumn, absolutePathColumn, shareStatusColumn;
				
				var inputElement;
				var fileIconElement;
				
				
				for (var i = 0; i < len; i++) {
					resultJson = result[i];
					
					if (resultJson["folderFileType"] === 'D') {
						isFolder = true;
					} else {
						isFolder = false;
					}
					
					row = document.createElement("tr");
					
					checkboxColumn = document.createElement("td");
					favoriteIconColumn = document.createElement("td");
					fileIconColumn = document.createElement("td");
					nameColumn = document.createElement("td");
					sizeColumn = document.createElement("td");
					creatorColumn = document.createElement("td");
					createDateColumn = document.createElement("td");
					absolutePathColumn = document.createElement("td");
					shareStatusColumn = document.createElement("td");
					
					setStyles([ nameColumn, sizeColumn, creatorColumn, createDateColumn, absolutePathColumn ], function(style) {
						style.overflow = "hidden";
						style.textOverflow = "ellipsis";
						style.whiteSpace = "nowrap";
					});
					
					setStyles([ checkboxColumn, favoriteIconColumn, fileIconColumn, sizeColumn, shareStatusColumn ], function(style) {
						style.textAlign = "center";
					})
					
					row.setAttribute("class", "bnkWebFolder");
					row.setAttribute("targetId", resultJson["fileId"]);
					row.setAttribute("targetType", resultJson["folderFileType"]);
					row.addEventListener("click", function(event) {
						rowContext.onRowClick(this);
					});
					
					inputElement = document.createElement("input");
					inputElement.setAttribute("type", "checkbox");
					inputElement.setAttribute("value", resultJson["fileId"]);
					inputElement.setAttribute("class", "checkBnk");
					inputElement.addEventListener("change", function(event) {
						event.stopPropagation();
						rowContext.onCheckboxChange(this);
					});
					inputElement.addEventListener("click", function(event) {
						event.stopPropagation();
					});
					inputElement.addEventListener("dblclick", function(event) {
						event.stopPropagation();
					});
					
					checkboxColumn.appendChild(inputElement);
					
					fileIconElement = document.createElement("img");
					fileIconElement.setAttribute("class", "none-drag");
					fileIconElement.addEventListener("click", function() {
						favoriteContext.onImageClick(this);
					});
					fileIconElement.addEventListener("dblclick", function(event) {
						event.stopPropagation();
					});
					
					if (resultJson["favouriteStatus"] == "0") {
						fileIconElement.src = "/images/ImgIcon/view-flag.gif";
					} else {
						fileIconElement.src = "/images/ImgIcon/icon-flag.gif";
						row.setAttribute("favorite", "");
					}
					
					favoriteIconColumn.appendChild(fileIconElement);
					
					fileIconElement = document.createElement("img");
					fileIconElement.setAttribute("class", "webFolderImg");
					fileIconElement.src = resultJson["fileIconUrl"];
					
					fileIconColumn.appendChild(fileIconElement);
					
					nameColumn.textContent = resultJson["fileName"];
					creatorColumn.textContent = resultJson["createName"];
					createDateColumn.textContent = resultJson["createDate"].substring(0, 10);
// 					shareDateColumn.textContent = resultJson["shareDate"].substring(0, 10);
					absolutePathColumn.textContent = resultJson["folderPath"];
					
					if (resultJson["shareStatus"] == "Y") {
						var spanElmt = document.createElement("span");
						spanElmt.innerHTML = "<img src='/images/webfolder/sharing2.png' class='webFolderImg' />";
						spanElmt.addEventListener("click", function () {
							shareContext.showShareInfo(this);
						});
						shareStatusColumn.appendChild(spanElmt);
					} else if (resultJson["shareStatus"] == "S") {
						var spanElmt = document.createElement("span");
						spanElmt.innerHTML = "<img src='/images/webfolder/sharing.png' class='webFolderImg' />";
						shareStatusColumn.appendChild(spanElmt);
					} else {
						shareStatusColumn.textContent = "";
					}
					
					if (isFolder) {
						row.ondblclick = function() {
							onFolderDoubleClick(this);
						};
						
						sizeColumn.textContent = "-";
					} else {
						row.addEventListener("dblclick", function(event) {
							downloadFileByDbClick(event);
							rowContext.setSelectState(this, true);
						});
						
						sizeColumn.textContent = getFileSize(resultJson["fileSize"]);
					}
					
					row.appendChild(checkboxColumn);
					row.appendChild(favoriteIconColumn);
					row.appendChild(fileIconColumn);
					row.appendChild(nameColumn);
					row.appendChild(sizeColumn);
					row.appendChild(creatorColumn);
					row.appendChild(createDateColumn);
					row.appendChild(absolutePathColumn);
					row.appendChild(shareStatusColumn);
					
					dom.listTable.appendChild(row);
				}
			}
			
			function setStyles(elements, excutor) {
				var length = elements.length;
				
				for (var i = 0; i < length; i++) {
					excutor(elements[i].style);
				}
			}
			
			function onFolderDoubleClick(obj) {
				var folderId = obj.getAttribute("targetId");
				getFileList(folderId);
			}
			
			// 날짜 초기화 버튼
		   	function clearDatepicker() {
		        $(".datepicker").datepicker('setDate', "");
		    }
			
			function goToPageByNum(Value) {
		    	currentPage = Value;
		        pStart = (blockSize * (currentPage)) - blockSize;
		        pEnd = blockSize;
		        getFileList();
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
		   	        document.getElementById("layer_Viewpopup").style.top = "130px";
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
				getFileList();
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
		</script>
	</head>
	<body class="mainbody">
		<h1>
			공유폴더
			<span id="mailBoxInfo"></span>
		</h1>
		<div id="pageArea">
			<!-- pagenation이 namePath로 움직이지 않도록 설정 -->
			<div id="originalPathWrapper" style="height: 40px;">
				<span style="font-size: 24px; font-weight: bold; font-weight: bold; display: block; float: left;" id="originalPath">
					<span class="aName" style="font-size:18px;" onClick="getFileList();">공유받은 목록</span>
				</span>
			</div>
			
			<div id="mainmenu">
				<ul>
					<li><a onClick="fileDownload()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t186'/></span></a></li>
					<li id="upload"><a onClick="fileUpload2()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t187'/></span></a></li>
					<li><a onClick="fileDelete()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t117'/></span></a></li>
					<li><a onClick="fileRename()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t118'/></span></a></li>
					<li><a onClick="fileMove()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t120'/></span></a></li>
					<li><a onClick="shareContext.hideShare()" style="margin-top: 3px;"><span>공유숨김</span></a></li>
					<li><a onClick="shareContext.showHiddenSharedList(1)" style="margin-top: 3px;"><span>공유숨김목록</span></a></li>
					<li><span onClick="favoriteContext.toggleAll()"><spring:message code='ezWebFolder.t281'/></span></li>
					<li><a onClick="refreshView()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t139'/></span></a></li>
					<li id="SearchOption" mode="off" onClick="doLayerPopup(this)"><span><spring:message code='ezWebFolder.t123'/></span></li>
					<li>
						<select id="fileTypeSelect" class="select" onchange="onFileTypeChange(this.value);">
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
						<img src ="/images/kr/cm/btn_arrow_down.gif" mode="off" id="webfolderlistoptiondiv">
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
		        <div class="shadow"></div>
		 	</div>
			
			<div id="dragDropArea" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="margin: 10px 0px;">
				<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
					<tr>
						<th style="width: 20px; text-align: center;"><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="checkAll"></th>
						<th style="width: 18px; text-align: center;"><img class="none-drag" src='/images/ImgIcon/icon-flag.gif'/></th><!-- 즐겨찾기 -->
						<th style="width: 30px; text-align: center;"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
						<th style="width: 29%;"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
						<th style="width: 6%; text-align: center;"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
						<th style="width: 7%;"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
						<th id="dateInfoHeader" style="width: 9%;">등록일</th><!-- 등록일 -->
						<th style="width: 25%;"><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
						<th id="shareInfoHeader" style="width: 35px; text-align: center;"><spring:message code='ezWebFolder.t278'/></th><!-- 공유상태 -->
					</tr>
				</table>
			</div>
			
			<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width:1px; height:1px; display:none;"/>
			<input type="hidden" onclick="fileupload()"/>
			<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
			<div class="layerpopup" style="z-index:2000; position:absolute; display:none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
			</div>
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
			               <input type="checkbox" style="margin-left:30px;" id="checkSubSearch" /><label for="checkSubSearch">하위폴더 검색</label>
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