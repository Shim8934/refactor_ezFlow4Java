<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/pageNav.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" />
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
		<!-- module -->
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/row-selector.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/share.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/favorite.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/search.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/buttons.js')}"></script>
		<script type="text/javascript">
			var folderType = "";
			var _selectedCell = null;
			var _cellInfo        = {};
			var sortColumn = null;
			var sortType = null;
			var uploadIng = false;
			var uploadIngStatusMessage = "<spring:message code='uploadIngStatusMessage'/>";
			
			// fileList 브라우저 화면 크기 변했을때 유동적화면 변화
			window.onresize = function () {
				var reheight = document.documentElement.clientHeight - 240;
				document.getElementById("dragDropArea").style.height = reheight + "px";
				
				reheight = document.documentElement.clientHeight - 90;
				document.getElementById("pageArea").style.height = reheight + "px";
				
				scroll();
			};
			
			document.onselectstart = function() {
				return false;
			}
			
			$(function () {
				// dom elements setup
				initDomElement();
				
				pagination.setPageChangeEventHandler(function() {
					getFileList();
				});
				
				getFileList();
				window.onresize();
				
		     	// listoption 다른 곳 클릭시 숨김 처리
				var listOptionHidden = function(event) {
					if (dom.listoptiondiv.getAttribute('mode') == "on"
							&& !dom.layerViewpopup.contains(event.target)
							&& event.target.id !== "webfolderlistoptiondiv") {
						optionHidden();
					}
				};
				
				document.addEventListener("mouseup", listOptionHidden, true);
				parent.frames["left"].document.addEventListener("mouseup", listOptionHidden, true);
				parent.parent.document.getElementById("topFrame").contentWindow.document.addEventListener("mouseup", listOptionHidden, true);
				
				var listHeader = document.getElementsByClassName("headListClick");
				for(var i = 0 ; i <listHeader.length; i++) {
					listHeader[i].addEventListener("click", function(event) {
						sortByHeader(this);
					});
				}
				
				// listoption 클릭 이벤트
				dom.listoptiondiv.addEventListener("click", function(event) {
					event.stopPropagation();
					optionView(event.target);
				});
				
				dom.listSizeSelect.addEventListener("change", function(event) {
					optionHidden();
					pagination.setPage(1, true);
					pagination.setListSize(this.value);
					refreshView();
				});
		    });
			
			function initDomElement() {
				dom = {
					mailBoxInfo: document.getElementById("mailBoxInfo"),
					mainmenu: document.getElementById("mainmenu"),
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
			
			function getFileList() {
				searchRequirement = searchContext.getCurrentRequirement();
				showProgress();
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/getHiddenSharedList.do",
					data: {
						"pageNum"    : pagination.currentPage(),
						"pageSize"   : pagination.listSize(),
						"sortType"   : sortType,
						"sortColumn" : sortColumn
					},
					dataType: "JSON",
					async: true,
					success : function(result) {
						hideProgress();
						if (result.status == "ok") {
							var data = result.data;
							
							pagination.setListSize(data.pageSize);
							pagination.setAmount(data.totalCount);
							pagination.build();
							
							renderList(data.list);
							checkedArr = [];
							
							setMailBoxInfo(data.folderCount, data.fileCount);
							
						} else {
							alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
						}
					},
					error : function(error) {
						hideProgress();
// 						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function sortByHeader(cell) {
				var column = cell.getAttribute("headers");
				
				if (!column) {return;}
				
				if (_selectedCell != null) {
					var orderOption = cell.getAttribute("orderoption") == "DESC" ? "ASC" : "DESC";
					cell.setAttribute("orderoption", orderOption);
					
					if (cell.cellIndex != _selectedCell) {
						var lastSelectedCell = document.getElementById("BoardList_THEAD").rows[0].cells[_selectedCell];
						lastSelectedCell.removeChild(lastSelectedCell.lastElementChild);
						var spanElmt = document.createElement("span");
						cell.appendChild(spanElmt);
					}
					
					var spanImg       = cell.lastElementChild;
					spanImg.className = orderOption == "DESC" ? "spanDown" : "spanUp";
				} else {
					cell.setAttribute("orderoption", "DESC");
					var spanElmt       = document.createElement("span");
					spanElmt.className = "spanDown";
					cell.appendChild(spanElmt);
				}
				
				_selectedCell = cell.cellIndex;
				
				var order     = cell.getAttribute("orderoption");
				this.sortType = order;
				this.sortColumn = column;
				getFileList();
			}
			
			function setMailBoxInfo(folderCount, fileCount) {
				dom.mailBoxInfo.innerHTML = "&nbsp;&nbsp; " + messages.strLang15 + " <span class='txt_color'>" + folderCount + " </span> / " + messages.strLang16 + " <span class='txt_color'> " + fileCount + " </span>";
				$("#listcount").val(pagination.listSize()).prop("selected", true);
			}
			
			function renderList(result) {
				checkedArr = [];
				$('#tblFileList tr').remove();
				
				dom.allCheckBox.checked = false;
				
				if (result == null || result.length == 0) {
					var row = document.createElement("tr");
					var column = document.createElement("td");
					
					column.setAttribute("colspan", "11");
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
				var checkboxColumn, favoriteIconColumn, fileIconColumn, nameColumn, sizeColumn, 
				creatorColumn, createDateColumn, updateDateColumn, sharerColumn, shareDateColumn, 
				absolutePathColumn, shareStatusColumn;
				
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
					updateDateColumn = document.createElement("td");
					sharerColumn = document.createElement("td");
					shareDateColumn = document.createElement("td");
					absolutePathColumn = document.createElement("td");
					shareStatusColumn = document.createElement("td");
					
					checkboxColumn.setAttribute("class", "wfFilecheck");
					favoriteIconColumn.setAttribute("class", "wfFileFavorite");
					fileIconColumn.setAttribute("class", "wfFileType");
					nameColumn.setAttribute("class", "wfFileName");
					sizeColumn.setAttribute("class", "wfFileSize");
					creatorColumn.setAttribute("class", "wfFileShareMember");
					createDateColumn.setAttribute("class", "wfFileShareDate");
					updateDateColumn.setAttribute("class", "wfFileShareDate");
					sharerColumn.setAttribute("class", "wfFileShareMember");
					shareDateColumn.setAttribute("class", "wfFileShareDate");
					absolutePathColumn.setAttribute("class", "wfFilePath");
					shareStatusColumn.setAttribute("class", "wfFileShare");

					setStyles([nameColumn, sizeColumn, creatorColumn, createDateColumn, updateDateColumn, sharerColumn, shareDateColumn, absolutePathColumn], function(style) {
						style.overflow = "hidden";
						style.textOverflow = "ellipsis";
						style.whiteSpace = "nowrap";
						style.wordWrap = "normal";
					});
					
					setStyles([checkboxColumn, favoriteIconColumn, fileIconColumn, sizeColumn, shareStatusColumn], function(style) {
						style.textAlign = "center";
					})
					
					row.setAttribute("class", "bnkWebFolder");
					row.setAttribute("targetId", resultJson["fileId"]);
					row.setAttribute("targetType", resultJson["folderFileType"]);
					row.setAttribute("targetPath", result[i]["folderPath"]);
					
					var functionType = ""
					if (result[i]["folderType"]) {
						row.setAttribute("targetFunction", result[i]["folderType"]);
					}
					
					var creator = ""
					if (!result[i]["creatorId"]) {
						row.setAttribute("targetCreater", result[i]["createId"]);
					} else {
						row.setAttribute("targetCreater", result[i]["creatorId"]);
					}
					row.addEventListener("click", function(event) {rowContext.onRowClick(event, this);});
					
					inputElement = document.createElement("input");
					inputElement.setAttribute("type", "checkbox");
					inputElement.setAttribute("value", resultJson["fileId"]);
					inputElement.setAttribute("class", "checkBnk");
					inputElement.addEventListener("change", rowContext.onCheckboxChange);
					inputElement.addEventListener("click", function(event) {
						event.stopPropagation();
					});
					inputElement.addEventListener("dblclick", function(event) {
						event.stopPropagation();
					});
					
					checkboxColumn.appendChild(inputElement);
					
					fileIconElement = document.createElement("img");
					fileIconElement.setAttribute("class", "none-drag");
					fileIconElement.addEventListener("click", favoriteContext.onImageClick);
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
					nameColumn.setAttribute("title", resultJson["fileName"]);
					creatorColumn.textContent = resultJson["createName"];
					createDateColumn.textContent = resultJson["createDate"].substring(0, 10);
					updateDateColumn.textContent = resultJson["updateDate"].substring(0, 10);
					sharerColumn.textContent = resultJson["sharerName"];
					shareDateColumn.textContent = resultJson["shareDate"].substring(0, 10);
					absolutePathColumn.textContent = resultJson["folderPath"];
					absolutePathColumn.setAttribute("title", resultJson["folderPath"]);
					
					if (resultJson["shareStatus"] == "Y") {
						var spanElmt = document.createElement("span");
						spanElmt.innerHTML = "<img src='/images/webfolder/sharing2.png' class='webFolderImg' />";
						spanElmt.addEventListener("click", function () {
							shareContext.showShareInfo(this);
						});
						shareStatusColumn.appendChild(spanElmt);
					} else {
						shareStatusColumn.textContent = "";
					}
					
					if (isFolder) {
						sizeColumn.textContent = "-";
					} else {
						row.addEventListener("dblclick", function(event) {
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
					row.appendChild(sharerColumn);
					row.appendChild(shareDateColumn);
					row.appendChild(absolutePathColumn);
					row.appendChild(shareStatusColumn);
					
					dom.listTable.appendChild(row);
				}
				scroll();
			}
			
			function setStyles(elements, excutor) {
				var length = elements.length;
				
				for (var i = 0; i < length; i++) {
					excutor(elements[i].style);
				}
			}
			
			function goToPageByNum(Value) {
		    	currentPage = Value;
		        pStart = (blockSize * (currentPage)) - blockSize;
		        pEnd = blockSize;
		        getFileList();
		    }
			
			function refreshView() {
				getFileList();
			}
			
			function getSelectedFoldersAndFiles() {
				var selectedRows = rowContext.getSelectedRows();
				var selectedLength = selectedRows.length;
				
				if (selectedLength <= 0) {
					alert(messages.strLang38);
					return undefined;
				}
				
				var files = [];
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
			
			function showSharedList() {
				location.href = "/ezWebFolder/webfolderSharedList.do";
			}
		</script>
	</head>
	<body class="mainbody">
		<h1>
			<spring:message code='ezWebFolder.t266'/>
			<span id="mailBoxInfo"></span>
		</h1>
		
		<div id="pageArea">
			<!-- pagenation이 namePath로 움직이지 않도록 설정 -->
			<div id="originalPathWrapper" style="height: 40px;">
				<span style="font-size: 24px; font-weight: bold; font-weight: bold; display: block; float: left;" id="originalPath">
					<span class="aName" style="font-size:15px;" onClick="getFileList();"><spring:message code='ezWebFolder.t318'/></span><!-- 공유숨김목록 -->
				</span>
			</div>
			
			<div id="mainmenu">
				<ul>
					<li><a onClick="showSharedList()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t518'/></span></a></li><!-- 돌아가기 -->
					<li><a onClick="shareContext.showShare()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t519'/></span></a></li><!-- 숨김취소 -->
					<!-- <li id="right" style="float:right;">
						<img src ="/images/kr/cm/btn_arrow_down.gif" mode="off" id="webfolderlistoptiondiv">
					</li> -->
					<div class="sub_frameIcon" style="float:right">
						<div class="sub_frameIconUL02">
						  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="webfolderlistoptiondiv"></span></p>  
						</div>
					</div>
				</ul>
			</div>
			
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			
			<div id="progress-wrp" style="display: none;">
		    	<div class="progress-bar"></div>
		    	<div class="status">0%</div>
		    </div>
			
			<div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
		        <div class="popupwrap1">	
		            <div class="popupwrap2">
		                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
		                    <caption></caption>
		                    <colgroup>
		                        <col style="width: 90px;">
		                        <col>
		                    </colgroup>
		                    <tr>
		                        <th><spring:message code='ezBoard.t10021' /></th>
		                        <td>
		                            <select id="listcount" style="width: 40px; height: 20px;">
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
		 	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id=""></div>
	    	<div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	    	<div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
			
			<div style="width:100%;"id ="tblFileList1_div">
				<div style="margin:0px 0px 0px !important;min-width: 700px;" >
					<table class="mainlist" style="width:100%"  id="tblFileList1">
						<thead id ="BoardList_THEAD">
							<tr>
								<th class="wfFilecheck			headListClick" style="text-align: center;"><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="checkAll"></th>
								<th class="wfFileFavorite		headListClick" headers="FAVORITE_STATUS" style=" text-align: center;"><img class="none-drag" src='/images/ImgIcon/icon-flag.gif'/></th><!-- 즐겨찾기 -->
								<th class="wfFileType			headListClick" headers="TYPE_ICON" style="text-align: center;"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
								<th class="wfFileName			headListClick" headers="FILE_NAME" style=""><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
								<th class="wfFileSize			headListClick" headers="FILE_SIZE" style=" text-align: center;"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
								<th class="wfFileShareMember 	headListClick" headers="CREATE_NAME" style=""><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
								<th class="wfFileShareDate		headListClick" headers="CREATE_DATE" style=""><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
								<th class="wfFileShareDate		headListClick" headers="UPDATE_DATE" id="updateDateHeader" style="display:none;"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
								<th class="wfFileShareMember	headListClick" headers="SHARER_NAME" id="sharerHeader" style=""><spring:message code='ezWebFolder.t319'/></th><!-- 공유자 -->
								<th class="wfFileShareDate		headListClick" headers="SHARE_DATE" id="shareDateHeader" style=""><spring:message code='ezWebFolder.t321'/></th><!-- 공유받은날짜 -->
								<th class="wfFilePath			" headers="FOLDER_PATH" style=""><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
								<th class="wfFileShare			headListClick" headers="SHARE_STATUS" style="margin:0px 0px 0px !important; text-align: center;"><spring:message code='ezWebFolder.t254'/></th><!-- 공유 -->
							</tr>
						</thead>
					</table>
					<div id="dragDropArea"  ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="margin: 10px 0px;overflow-y:auto;white-space:nowrap;">
						<table class="mainlist" style="width: 100%;margin:0px 0px 0px !important; white-space:nowrap;" id="tblFileList">
					
						</table>
					</div>
				</div>
			</div>
			<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width:1px; height:1px; display:none;"/>
			<input type="hidden" onclick="fileupload()"/>
			<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
			<div class="layerpopup" style="z-index:2000; position:absolute; display:none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
			</div>
			<div id="tblPageRayer"></div>
		</div>
		
		<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
			<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
		</div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>