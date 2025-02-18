
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
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" />
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
		<!-- datepicker -->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<!-- module -->
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/duplicate-file.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/buttons.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/capacity.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/favorite.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/search.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/share.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/row-selector.js')}"></script>
		<script type="text/javascript">
			var folderTypeCheck = "Y";
			var folderId = "";
			var folderIdReturnTemp = "";
			var isShareMode = true;
			var isSubSearching = "N";
			var strSuccess  = "<spring:message code='ezWebFolder.t27'/>";
			var folderType = "S";
			var inputNameDlg_cross_dialogArguments = new Array();
			var parentId = folderId;
			var userId = "${userId}";
			var resultErr1 = "<spring:message code='ezWebFolder.t306'/>";
			var resultErr2 = "<spring:message code='ezWebFolder.t305'/>";
			var resultErr3 = "<spring:message code='ezWebFolder.t300'/>";
			var resultErr4 = "<spring:message code='ezWebFolder.t249'/>";
			var resultErr5 = "<spring:message code='ezWebFolder.t250'/>";
			var resultErr6 = "<spring:message code='ezWebFolder.kes014'/>";
			var progressSubject = {
				C: "<spring:message code='ezWebFolder.t11'/>",
				D: "<spring:message code='ezWebFolder.t12'/>",
				U: "<spring:message code='ezWebFolder.t13'/>"
			};
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
				
				searchContext.setSearchStartEventHandler(function() {
					pagination.setPage(1, true);
					$("#fileTypeSelect").val("");
					searchContext.setFileType("");
					refreshView();
				});
				
				pagination.setPageChangeEventHandler(function() {
					getFileList();
				});
				
				capacity.setFolderIdProvider(function() {
					return folderId;
				});
				
				capacity.setOnLoadEventListener(function(data) {
					$("#capacity-folder-type").text(progressSubject[data.type]);
				})
				
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
				
				// listoption 클릭 이벤트
				dom.listoptiondiv.addEventListener("click", function(event) {
					event.stopPropagation();
					optionView(event.target);
				});
				
				var listHeader = document.getElementsByClassName("headListClick");
				for(var i = 0 ; i <listHeader.length; i++) {
					listHeader[i].addEventListener("click", function(event) {
						sortByHeader(this);
					});
				}
				
				dom.listSizeSelect.addEventListener("change", function(event) {
					optionHidden();
					pagination.setPage(1, true);
					pagination.setListSize(this.value);
					refreshView();
				});
				
				// datepicker setup
				$(".datepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true
				});
		
		        $(".datepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $(".datepicker").datepicker('setDate', "");
				
			    var monthMsg = "<spring:message code='ezSchedule.t110' />";
			    var monthStr = monthMsg.split(";");		    
			    var dayMsg = "<spring:message code='ezSchedule.t108' />";
			    var dayStr = dayMsg.split(";");
			    
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		        	closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
		            monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
			
			function initDomElement() {
				dom = {
					mailBoxInfo: document.getElementById("mailBoxInfo"),
					mainmenu: document.getElementById("mainmenu"),
					upload: document.getElementById("uploadBtn"),
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
				if (isShareMode) {
					getSharingList();
				} else {
					getFileList2();
				}
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
			
			function getSharingList() {
				searchRequirement = searchContext.getCurrentRequirement();
				showProgress();
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/getSharingList.do",
					data: {
						"pageNum" : pagination.currentPage(),
						"pageSize" : pagination.listSize(),
						"searchExt" : searchRequirement.extension,
						"searchFileName" : searchRequirement.name,
						"searchCreatorName" : searchRequirement.creatorName,
						"searchFileType" : searchContext.getFileType(),
						"searchStartDate" : searchRequirement.startDate,
						"searchEndDate" : searchRequirement.endDate,
						"subSearchFlag" : isSubSearching,
						"sortColumn" : sortColumn,
						"sortType" : sortType
					},
					dataType: "JSON",
					async: true,
					success : function(result) {
						hideProgress();
						if (result.status != "ok") {
							if (result.code == 1) {
								alert("<spring:message code='ezWebFolder.t306'/>");
							} else if (result.code == 2) {
								alert("<spring:message code='ezWebFolder.t305'/>");
							} else if (result.code == 3) {
								alert("<spring:message code='ezWebFolder.t300'/>");
							} else {
								alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
							}
							
							return;
						}
						
						var data = result.data;
						
						setButtons();
						
						pagination.setListSize(data.pageSize);
						pagination.setAmount(data.totalCount);
						pagination.build();
						
						var dragDropArea = dom.dragDropArea;
						dragDropArea.ondragenter = null;
						dragDropArea.ondragover = null;
						dragDropArea.ondragover = null;
						
						renderList(data.list);
						setNamePath(data.folderPath, data.folderPath2);
						setMailBoxInfo(data.folderCount, data.fileCount);
						disableCapacity();
						
						folderId = "";
					},
					error : function(error) {
						hideProgress();
// 						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function getFileList2() {
				searchRequirement = searchContext.getCurrentRequirement();
				showProgress();
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/fileList.do",
					data: {
						"folderId": folderId,
						"currPage": pagination.currentPage(),
						"listCount": pagination.listSize(),
						"pStart": pagination.startPosition(),
						"searchExt" : searchRequirement.extension,
						"searchFileName" : searchRequirement.name,
						"searchCreateName" : searchRequirement.creatorName,
						"searchFileType" : searchContext.getFileType(),
						"searchStartDate" : searchRequirement.startDate,
						"searchEndDate" : searchRequirement.endDate,
						"sortColumn" : sortColumn,
						"sortType" : sortType
					},
					dataType: "JSON",
					async: true,
					success : function(result) {
						hideProgress();
						if (result.status != "ok") {
							if (result.code == 1) {
								alert("<spring:message code='ezWebFolder.t306'/>");
							} else if (result.code == 2) {
								alert("<spring:message code='ezWebFolder.t305'/>");
							} else if (result.code == 3) {
								alert("<spring:message code='ezWebFolder.t300'/>");
							} else {
								alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
							}
							folderId = folderIdReturnTemp;
							return;
						}
						
						setButtons();
						
						result = result.data;
						
						pagination.setListSize(result.listCount);
						pagination.setAmount(result.totalRows);
						pagination.build();
						
						var dragDropArea = dom.dragDropArea;
						
						if (result.folderUpp == "root") {
							dom.upload.setAttribute("hidden", "");
							dragDropArea.ondragenter = null;
							dragDropArea.ondragover = null;
							dragDropArea.ondragover = null;
						} else {
							dom.upload.removeAttribute("hidden");
							dragDropArea.ondragenter = function(e) {
								onDragEnter(e)
							};
							dragDropArea.ondragover = function(e) {
								onDragOver(e)
							};
							dragDropArea.ondrop = function(e) {
								onDrop(e)
							};
						}
						
						renderList2(result.fileList);
						setNamePath(result.folderPath, result.originalPath);
						setMailBoxInfo(result.fldCnt, result.fileCnt);
						capacity.load();
					},
					error : function(error) {
						hideProgress();
// 						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function setButtons() {
				if (isShareMode) {
					if (isSubSearching === "Y") {
						$('#uploadBtn').css('display','none');
						$('#modifyShareBtn').css('display','none');
						$('#deleteShareBtn').css('display','none');
						$('#newFolder').css('display','');
						
						$('#addShareBtn').css('display','');
					} else {
						$('#uploadBtn').css('display','none');
						$('#addShareBtn').css('display','none');
						$('#newFolder').css('display','none');
						
						$('#modifyShareBtn').css('display','');
						$('#deleteShareBtn').css('display','');
					}
				} else {
					$('#modifyShareBtn').css('display','none');
					$('#deleteShareBtn').css('display','none');
					$('#newFolder').css('display','');
					
					$('#uploadBtn').css('display','');
					$('#addShareBtn').css('display','');
				}
			}
			
			// originalPath 는 한글 path
			// folderPath 는 숫자 
			function setNamePath(folderPath, originalPath) {
				var orginalPathElmt = document.getElementById("originalPath");
				var nameTag = document.createElement("div");
				nameTag.setAttribute("class", "mainPath");
				var originPath;
				
				// for statement using
				var detailName;
				var imgElmt;
				var length;
				
				$('#originalPath').empty();
				orginalPathElmt.appendChild(nameTag);
				
				if (folderPath == null) {
					detailName = document.createElement("div");
					detailName.className = "aName";
					detailName.onclick = function() {
						isShareMode = true;
						isSubSearching = "N";
						nameFileList("");
					};
					
					var divName = document.createElement("div");
					divName.textContent = "<spring:message code='ezWebFolder.t267'/>";
					divName.setAttribute("style", "font-size:15px; padding-right:3px;");
					
					detailName.appendChild(divName);
					nameTag.appendChild(detailName);
					return;
				}
				
				folderPath = folderPath.substring(1, folderPath.length - 1);
				originPath = folderPath.split("|");
				path = originalPath.split("/");
				length = path.length - 1;
				
				for (var i = 0; i < length; i++) {
					detailName = document.createElement("div");
					var divName = document.createElement("div");
					
					detailName.className = "aName";
					detailName.id = originPath[i];
					detailName.onclick = function() {
						nameFileList(this.id);
					};

					divName.textContent = path[i] ;
					/* 2018-05-07 장진혁 - 상단 폰트사이즈 15px로 조정 */
					divName.setAttribute("style", "font-size:15px;");
					detailName.appendChild(divName);
					nameTag.appendChild(detailName);
					
					/*
					if (length == 1) {
						var divSeparator = document.createElement("div");
						divSeparator.setAttribute("class", "separator");
						divSeparator.textContent =  " > " + messages.strLang17 + " "; // 모든파일
						nameTag.appendChild(divSeparator);
					}
					*/
					
					/* 2018-05-07 장진혁 - 이미지 태그 안씀 */
					/* var imgElmt = document.createElement("img");
					imgElmt.setAttribute("style", "height: 14px; width: 14px; display: inline-block; margin: 0px 6px;");
					imgElmt.src = "/images/webfolder/arrow2.png"; */
					
					if (i != length - 1) {
						var divSeparator = document.createElement("div");
						divSeparator.setAttribute("class", "separator");
						divSeparator.textContent = " > ";
						nameTag.appendChild(divSeparator);
					}	
				}
			}
			
			function setMailBoxInfo(folderCount, fileCount) {
				dom.mailBoxInfo.innerHTML = "&nbsp;&nbsp;" + messages.strLang15 + " <span class='txt_color'>" + folderCount + " </span> / " + messages.strLang16 + " <span class='txt_color'> " + fileCount + " </span>";
				$("#listcount").val(pagination.listSize()).prop("selected", true);
			}
			
			function nameFileList(param) {
				folderIdReturnTemp = folderId;
				folderId = param;
				searchContext.clearRequirement();
				$("#fileTypeSelect").val("");
				onFileTypeChange("");
			}
			
			function renderList(result) {
				checkedArr = [];
				$('#tblFileList tr').remove();
				
				dom.allCheckBox.checked = false;
				if (isSubSearching === "Y") {
// 					$('#sharerHeader').css('display','none');
// 					$('#shareDateHeader').css('display','none');
// 					$('#updateDateHeader').css('display','');
					$('.wfFileShareMember').css('display','none');
					$('.wfFileShareDate2').css('display','none');
					$('.wfFileShareDate').css('display','');
					$('#newFolder').css('display','');
				} else {
// 					$('#updateDateHeader').css('display','none');
// 					$('#sharerHeader').css('display','');
// 					$('#shareDateHeader').css('display','');
					$('.wfFileShareDate').css('display','none');
					$('.wfFileShareMember').css('display','');
					$('.wfFileShareDate2').css('display','');
					$('#newFolder').css('display','none');
				}		
				if (result == null || result.length == 0) {
					var row = document.createElement("tr");
					var column = document.createElement("td");
					
					if (isSubSearching === "Y") {
						column.setAttribute("colspan", "10");
					} else {
						column.setAttribute("colspan", "11");
					}
					
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
					
					setStyles([ nameColumn, sizeColumn, creatorColumn, createDateColumn, updateDateColumn, sharerColumn, shareDateColumn, absolutePathColumn ], function(style) {
						style.overflow = "hidden";
						style.textOverflow = "ellipsis";
						style.whiteSpace = "nowrap";
						style.wordWrap = "normal";
					});
					
					setStyles([ checkboxColumn, favoriteIconColumn, fileIconColumn, sizeColumn, shareStatusColumn ], function(style) {
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
					row.addEventListener("contextmenu", openContextMenu);
					
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
					nameColumn.setAttribute("ext", resultJson["fileExt"]);
					creatorColumn.textContent = resultJson["createName"];
					createDateColumn.textContent = resultJson["createDate"].substring(0, 10);
					updateDateColumn.textContent = resultJson["updateDate"].substring(0, 10);
					sharerColumn.textContent = getUserSimpleListStr(resultJson["userListStr"]);
					shareDateColumn.textContent = resultJson["shareDate"].substring(0, 10);
					absolutePathColumn.textContent = resultJson["folderPath"];
					absolutePathColumn.setAttribute("title", resultJson["folderPath"]);
					sharerColumn.setAttribute("title", resultJson["userListStr"]);
					
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
					
					if (isSubSearching === "Y") {
						row.appendChild(updateDateColumn);
					} else {
						row.appendChild(sharerColumn);
						row.appendChild(shareDateColumn);
					}
					
					row.appendChild(absolutePathColumn);
					row.appendChild(shareStatusColumn);
					
					dom.listTable.appendChild(row);
				}
				scroll();
			}
			
			function renderList2(result) {
				checkedArr = [];
				$('#tblFileList tr').remove();
				
				dom.allCheckBox.checked = false;
				
// 				$('#sharerHeader').css('display','none');
// 				$('#shareDateHeader').css('display','none');
// 				$('#updateDateHeader').css('display','');
				$('.wfFileShareMember').css('display','none');
				$('.wfFileShareDate2').css('display','none');
				$('.wfFileShareDate').css('display','');
				
				document.getElementById("wfFileShareMember2").className = "wfFileCreator";
				document.getElementById("updateDateHeader").className = "wfFileUploadDate";
				document.getElementById("updateDateHeader2").className = "wfFileUploadDate";

				if (result == null || result.length == 0) {
					var row = document.createElement("tr");
					var column = document.createElement("td");

					column.setAttribute("colspan", "10");
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
					creatorColumn, createDateColumn, updateDateColumn, absolutePathColumn, shareStatusColumn;
				
				var inputElement;
				var fileIconElement;
				
				for (var i = 0; i < len; i++) {
					resultJson = result[i];
					
					if (resultJson["fileTypeName"] === 'folder') {
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
					absolutePathColumn = document.createElement("td");
					shareStatusColumn = document.createElement("td");
					
					checkboxColumn.setAttribute("class", "wfFilecheck");
					favoriteIconColumn.setAttribute("class", "wfFileFavorite");
					fileIconColumn.setAttribute("class", "wfFileType");
					nameColumn.setAttribute("class", "wfFileName");
					sizeColumn.setAttribute("class", "wfFileSize");
					creatorColumn.setAttribute("class", "wfFileCreator");
					createDateColumn.setAttribute("class", "wfFileUpdateDate");
					updateDateColumn.setAttribute("class", "wfFileUpdateDate");
					absolutePathColumn.setAttribute("class", "wfFilePath");
					shareStatusColumn.setAttribute("class", "wfFileShare");
					
					setStyles([ nameColumn, sizeColumn, creatorColumn, createDateColumn, updateDateColumn, absolutePathColumn ], function(style) {
						style.overflow = "hidden";
						style.textOverflow = "ellipsis";
						style.whiteSpace = "nowrap";
					});
					
					setStyles([ checkboxColumn, favoriteIconColumn, fileIconColumn, sizeColumn, shareStatusColumn ], function(style) {
						style.textAlign = "center";
					})
					
					row.setAttribute("class", "bnkWebFolder");
					row.setAttribute("targetId", resultJson["fileId"]);
					row.setAttribute("targetType", isFolder ? "D" : "F");
					row.setAttribute("targetPath", result[i]["filePosition"]);
					
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
					row.addEventListener("contextmenu", openContextMenu);
					
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
					creatorColumn.textContent = resultJson["createName1"];
					createDateColumn.textContent = resultJson["createDate"].substring(0, 10);
					updateDateColumn.textContent = resultJson["updateDate"].substring(0, 10);
					absolutePathColumn.textContent = resultJson["filePosition"];

					var fileExt = resultJson["fileExt"];
					if (fileExt) {
						nameColumn.setAttribute("ext", fileExt);
					}

					if (resultJson["fileShareStatus"] == "Y") {
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
					row.appendChild(updateDateColumn);
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
			
			function onFolderDoubleClick(obj) {
				isShareMode = false;
				folderId = obj.getAttribute("targetId");
				getFileList();
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
		        	
					if (requirement.extension == "" && requirement.name == "" && requirement.creatorName == "" 
							&& requirement.startDate == "" && requirement.endDate == "") {
						alert(messages.strLang20);
						return;
					}
		
					if (requirement.startDate != "" && requirement.endDate == "") {
						alert(messages.strLang21);
						return;
					}
		           
					if (requirement.startDate == "" && requirement.endDate != "") {
						alert(messages.strLang21);
						return;
					}
		
					if (new Date(requirement.startDate) > new Date(requirement.endDate)) {
						alert(messages.strLang21);
						return;
					}
	           		
					isSubSearching = "Y";
					
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
				clearDatepicker();
				document.getElementById("searchExt").value = "";
				document.getElementById("searchFileName").value = "";
				document.getElementById("searchCreateName").value = "";
		    
		        /* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
		        var leftBody = parent.frames["left"].document.body;
		        leftBody.style.overflow = "hidden";
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].searchOptionHidden();document.body.style.overflow=\"auto\";'></div>").appendTo(leftBody);        	
	        	var popupX = parent.document.body.clientWidth / 2 - (500 / 2) - 220;
	        	
	        	$("#searchpopup").css("left", popupX);
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	
	        	$("#searchpopup").modal();
	        	$("#searchpopup").off("modal:close").on("modal:close", function() {
	        		parent.frames["left"].document.body.style.overflow = "auto";
	        	});
		    }
			
			function searchOptionHidden() {
		    	$.modal.close();
		    }
			
			function refreshView() {
				getFileList();
			}
			
			function onFileTypeChange(value) {
				searchContext.setFileType(value);
				pagination.setPage(1);
			}
			
			function downloadFileByDbClick(event) {
				event.stopPropagation();
				event.preventDefault();
				var trElmt = event.currentTarget;
				var fileFolderId = trElmt.getAttribute("targetId");
				var filesList = [];
				filesList.push(fileFolderId);
				
				var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
				AttachDownFrame.location.href = downloadUrl;
			}
			
			function openLeftPanel() {
				var leftFrame = window.parent.frames["left"].document;
				var blockLeft = leftFrame.getElementById("bnkBlockLeft");
				var height = Math.max(leftFrame.documentElement.clientHeight, leftFrame.documentElement.scrollHeight);
				leftFrame.body.style.overflow = "hidden";
				blockLeft.style.height = height + "px";
				blockLeft.style.display = "";
			}
			
			function closeLeftPanel() {
				var leftFrame = window.parent.frames["left"].document;
				var blockLeft = leftFrame.getElementById("bnkBlockLeft");
				leftFrame.body.style.overflow = "auto";
				blockLeft.style.height = "100%";
				blockLeft.style.display = "none";
			}
			
			function getUserSimpleListStr(userListStr) {
				var result = "";
				
				userListStr = userListStr.replace(/\,$/, "");
				var userArr = userListStr.split(",");
				var userArrSize = userArr.length;
				
				if (userArrSize == 1) {
					result = userArr[0];
				} else if (userArrSize > 1) {
					result = userArr[0] + " " + messages.strLang26 + " " + (userArrSize - 1) + messages.strLang27;
				}
				
				return result;
			}
			
			function deleteShareSuccess() {
				closeAllPopup();
				
				alert(messages.strLang33);
				refreshView();
			}
			
			function disableCapacity() {
				$("#capacity-wrapper").css("display", "none");
				$("#capacity-folder-type").text("");
			}
		</script>
	</head>
	<body class="mainbody">
		<h1>
			<spring:message code='ezWebFolder.t266'/>
			<span id="mailBoxInfo"></span>
			<div id="capacity-wrapper">
				<span id="capacity-folder-type"></span>
				<div class="progressbar">
					<div id="capacity-bar" class="proggress"></div>
				</div>
				<span id="capacity-percent"></span>
			</div>
		</h1>
		
		<div id="pageArea">
			<div style="height: 40px;">
				<div style="font-size: 24px; font-weight: bold; padding: 8px 4px 0px;" id="originalPath"></div>
			</div>
			
			<div id="mainmenu">
				<ul>
					<li class="important"><span onclick="buttons.fileDownload()"><spring:message code='ezWebFolder.t161'/></span></li>
					<li class="important" id="uploadBtn" onclick="buttons.fileUpload()"><span><spring:message code='ezWebFolder.t160'/></span></li>
					<c:if test="${usePreview}">
						<li id="previewButton"><span onclick="buttons.filePreview()"><spring:message code='main.t4009' /></span></li>
					</c:if>
					<li id ="newFolder"><span onclick="buttons.newFolder()"><spring:message code='ezWebFolder.t255' /></span></li>
					<li onclick="buttons.fileRename()"><span><spring:message code='ezWebFolder.t508'/></span></li>
					<li onclick="buttons.fileMoveAndCopy()"><span><spring:message code='ezWebFolder.t251'/></span></li>
					<c:if test="${useVersionHistory}">
						<li><span onclick="buttons.openFileVersionHistory()"><spring:message code='webfolder.version.button' /></span></li>
					</c:if>
					<!-- <li><img src="/images/i_bar.gif"></li> -->
					<li id="addShareBtn" onclick="shareContext.addShareView()" style="display:none"><span><spring:message code='ezWebFolder.t254'/></span></li>
					<li id="modifyShareBtn" onclick="shareContext.addShareView()"><span><spring:message code='ezWebFolder.t217'/></span></li>
					<li id="deleteShareBtn" onclick="shareContext.deleteShareConfirm()"><span><spring:message code='ezWebFolder.t218'/></span></li>
					<!-- <li><img src="/images/i_bar.gif"></li> -->
					<li onclick="favoriteContext.toggleAll()"><span class="icon16 icon16_star"></span></li>
					<li id="SearchOption" mode="off" onclick="doLayerPopup(this)"><span class="icon16 icon16_search"></span></li>
					<li onclick="buttons.fileDelete()"><span class="icon16 icon16_delete"></span></li>
					<li onclick="refreshView()"><span class="icon16 icon16_refresh"></span></li>
					<!-- <li><img src="/images/i_bar.gif"></li> -->
					<div class="sub_frameIcon" style="float:right">
						<div class="sub_frameIconUL02">
							  <p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="webfolderlistoptiondiv"></span></p>  
						</div>
					</div>
					<li style="float:right;">
						<select id="fileTypeSelect" class="select" onchange="onFileTypeChange(this.value);">
							<option value=""><spring:message code='ezWebFolder.t191'/></option>
							<option value="document"><spring:message code='ezWebFolder.t192'/></option>
							<option value="music"><spring:message code='ezWebFolder.t193'/></option>
							<option value="video"><spring:message code='ezWebFolder.t194'/></option>
							<option value="image"><spring:message code='ezWebFolder.t195'/></option>
							<option value="folder"><spring:message code='ezWebFolder.t213'/></option>
							<option value="zip"><spring:message code='ezWebFolder.t196'/></option>
							<option value="unknown"><spring:message code='ezWebFolder.t311'/></option>
						</select>
					</li>
					<!-- <li id="right" style="float:right;">
						<img src ="/images/kr/cm/btn_arrow_down.gif" mode="off" id="webfolderlistoptiondiv">
					</li> -->
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
								<th class="wfFilecheck 			headListClick"  style="text-align: center;"><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="checkAll"></th>
								<th class="wfFileFavorite 		headListClick" headers="FAVORITE_STATUS" style=" text-align: center;"><img class="none-drag" src='/images/ImgIcon/icon-flag.gif'/></th><!-- 즐겨찾기 -->
								<th class="wfFileType 			headListClick" headers="TYPE_ICON" style="text-align: center;"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
								<th class="wfFileName 			headListClick" headers="FILE_NAME" style=""><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
								<th class="wfFileSize 			headListClick" headers="FILE_SIZE" style=" text-align: center;"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
								<th class="wfFileShareMember2 	headListClick" headers="CREATE_NAME" id="wfFileShareMember2"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
								<th class="wfFileSharedDate 	headListClick" headers="CREATE_DATE" id="updateDateHeader2"><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
								<th class="wfFileShareDate 		headListClick" headers="UPDATE_DATE" id="updateDateHeader" style="display:none;"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
								<th class="wfFileShareMember 	headListClick" headers="USER_LIST" id="sharerHeader" style=""><spring:message code='ezWebFolder.t320'/></th><!-- 공유자 -->
								<th class="wfFileShareDate2	 	headListClick" headers="SHARE_DATE" id="shareDateHeader" style=""><spring:message code='ezWebFolder.t321'/></th><!-- 공유받은날짜 -->
								<th class="wfFilePath 			" headers="FOLDER_PATH" style=""><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
								<th class="wfFileShare	 		headListClick" headers="SHARE_STATUS" style="margin:0px 0px 0px !important; text-align: center;"><spring:message code='ezWebFolder.t254'/></th><!-- 공유 -->
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
		
		<div id="searchpopup" class="popupwrap3" style="display:none;margin-bottom:70px">
			<div class="popupJQLayer" style="padding-top:6px">
				<div class="title"><spring:message code='ezWebFolder.t10' /><spring:message code='ezWebFolder.t123' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="searchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="content" style="margin-top:10px;">
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
			            <td><input type="text" id="searchExt" style="width:99%" value="" name="searchExt"></td>
			        </tr>
			        <tr>
			            <th style="text-align:center"><spring:message code='ezWebFolder.t153' /></th><!-- 파일명 -->
			            <td><input type="text" id="searchFileName" style="width:99%" value="" name="searchFileName"></td>
			        </tr>  
			         <tr>
			            <th style="text-align:center"><spring:message code='ezWebFolder.t154' /></th><!-- 작성자 -->
			            <td><input type="text" id="searchCreateName" style="width:99%" value="" name="searchCreateName"></td>
			        </tr>    
				</table>
				<table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezAddress.t142' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
			<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
		</div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<%@ include file="/WEB-INF/jsp/ezWebFolder/webFolderApplyPopUp.jsp" %>
		<%@ include file="/WEB-INF/jsp/ezWebFolder/component/contextMenu.jsp" %>
	</body>
</html>