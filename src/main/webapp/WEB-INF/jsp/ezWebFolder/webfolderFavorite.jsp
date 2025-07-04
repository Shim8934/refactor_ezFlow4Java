<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
<!-- date Picker -->
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/pageNav.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
<!-- date Picker -->
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
<!-- module -->
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/duplicate-file.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/row-selector.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/capacity.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/favorite.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/buttons.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/search.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
<script type="text/javascript">
	"use strict";
	var folderType = "";
	var userId = "${userId}";
	var folderId = "";
	var folderTypeCheck = "Y";
	var inputNameDlg_cross_dialogArguments = new Array();
	var parentId = "";
	var strSuccess = "<spring:message code='ezWebFolder.t27' />";
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
	var isFavoriteMode = false;
	var functionType;
	var unidocsDomain = "${unidocsDomain}";
	var containsReplyFiles = [];
	var contextClickedTr = null;
	// 2020-12-10 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
	var userManager = {
			targetId: "",
			targetType: ""
	};
	var managedList = [];
	var folderPath = "";

	var strictAuthList = [];
	var authListUser = [];
	var addUser = [];
	var deleteUser = [];
	var selectXhr;
	var uploadLimit = <c:out value="${uploadLimit}" />;
	var folderUpp = "";
	var uploadIng = false;
	var uploadIngStatusMessage = "<spring:message code='uploadIngStatusMessage'/>";
	
	var context = (function() {
		var currentFolderId = 0;
		var currentFolderType = "";
		
		var inputNameDlg_cross_dialogArguments = new Array();
// 		var parentId = folderId;

		// event listener
		var onListTypeChangeEvent = function(isFavoriteMode) {};
		
		var checkAccessFolderInfo = function() {
			if (isFavoriteMode) {
				throw "page is favorite mode."
			}
		};
		
		var getFolderId = function() {
			checkAccessFolderInfo();
			return currentFolderId;
		};
		
		var getFolderType = function() {
			checkAccessFolderInfo();
			return currentFolderType;
		};
		
		var setListAsFavorite = function(isAsync) {
			loadListAsFavorite(isAsync);
			
			if (!isFavoriteMode) {
				isFavoriteMode = true;
				onListTypeChangeEvent(true);
			}
		};
		
		var setList = function(folderId, folderType, isAsync) {
			if (isFavoriteMode) {
				currentFolderType = folderType;
			}
			
			isFavoriteMode = false;
			loadList(folderId, currentFolderType, isAsync, function() {
				onListTypeChangeEvent(false);
				window.folderId = folderId;
				currentFolderId = folderId;
			});

		};
		
		var refreshList = function(isAsync) {
			if (isAsync === undefined) {
				isAsync = false;
			}
			
			if (isFavoriteMode) {
				setListAsFavorite(isAsync);
			} else {
				setList(currentFolderId, undefined, isAsync);
			}
		};
		
		var setOnListTypeChangeEventListener = function(handle) {
			onListTypeChangeEvent = handle;
		};
		
		return {
			isFavoriteMode: function () { return isFavoriteMode; },
			getFolderId: getFolderId,
			getFolderType: getFolderType,
			setListAsFavorite: setListAsFavorite,
			setList: setList,
			refreshList: refreshList,
			setOnListTypeChangeEventListener: setOnListTypeChangeEventListener
		};
	}());
	
	// TODO: 리펙토링
	var resultColumn = {
		favorite: {
			id: "targetId",
			path: "targetPath",
			favoriteStatus: "favoriteStatus",
			iconUrl: "targetIconUrl",
			name: "targetName",
			size: "targetSize",
			creatorName: "creatorName",
			createDate: "createDate",
			type: "targetType",
			encryptedFlag: "encryptedFlag",
			depth: "depth"
		},
		
		folder: {
			id: "fileId",
			path: "filePosition",
			favoriteStatus: "favouriteStatus",
			iconUrl: "fileIconUrl",
			name: "fileName",
			size: "fileSize",
			creatorName: "createName1",
			createDate: "createDate",
			type: "fileTypeName",
			encryptedFlag: "encryptedFlag",
			depth: "depth"
		}
	};
	
	var dom;
	var checkedArr = [];
	
	// fileList 브라우저 화면 크기 변했을때 유동적화면 변화
	window.onresize = function() {
		var reheight = document.documentElement.clientHeight - 240;
		dom.dragDropArea.style.height = reheight + "px";
		
		reheight = document.documentElement.clientHeight - 90;
		dom.pageArea.style.height = reheight + "px";
		scroll();
	};
	
	document.onselectstart = function() {
		return false;
	}
	
	window.onbeforeunload = function() {
		closeAllPopup();
		searchOptionHidden();
	}
	
	$(function() {
		// dom elements setup
		initDomElement();
		
		// context event handle setup
		context.setOnListTypeChangeEventListener(function(isFavoriteMode) {
			// TODO: 즐겨찾기 메뉴 보이기/숨기기 html, js 소스 정리
			if (isFavoriteMode) {
				document.body.setAttribute("favoritemode", "");
			} else {
				document.body.removeAttribute("favoritemode");
			}
		});
		
		var listHeader = document.getElementsByClassName("headListClick");
		for(var i = 0 ; i <listHeader.length; i++) {
			listHeader[i].addEventListener("click", function(event) {
				sortByHeader(this);
			});
		}
		
		searchContext.setSearchStartEventHandler(function() {
			pagination.setPage(1, true);
			$("#idSelect").val("");
			searchContext.setFileType("");
			context.refreshList(true);
		});
		
		pagination.setPageChangeEventHandler(function() {
			context.refreshList(true);
		});
		
		capacity.setFolderIdProvider(function() {
			return context.getFolderId();
		});
		
		// load favorite list
		context.setListAsFavorite(true);
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
		
		dom.listSizeSelect.addEventListener("change", function(event) {
			optionHidden();
			pagination.setListSize(this.value);
			context.refreshList(true);
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
        var folderId = context.getfolderId;
        
	});
	
	function initDomElement() {
		dom = {
			mailBoxInfo: document.getElementById("mailBoxInfo"),
			mainmenu: document.getElementById("mainmenu"),
			upload: document.getElementById("upload"),
			originalPath: document.getElementById("originalPath"),
			dragDropArea: document.getElementById("dragDropArea"),
			pageArea: document.getElementById("pageArea"),
			layerViewpopup: document.getElementById("layer_Viewpopup"),
			allCheckBox: document.getElementById("checkAll"),
			listTable: document.getElementById("tblFileList"),
			listoptiondiv: document.getElementById("webfolderlistoptiondiv"),
			listSizeSelect: document.getElementById("listcount")
		};
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
		sortType = order;
		sortColumn = column;
		if(!isFavoriteMode) {
			loadList(folderId, folderType, true);
		} else {
			if (sortColumn == "FAVORITE_STATUS"){
				sortColumn = "";
				sortType = "";
			}
			loadListAsFavorite(true);
		}
	}
	
	function loadListAsFavorite(isAsync) {
		var searchRequirement = searchContext.getCurrentRequirement();
		showProgress();
		
		$.ajax({
			type: "post",
			async: isAsync,
			url: "/ezWebFolder/getFavorites.do",
			dataType: "json",
			data: {
				searchFileType: searchContext.getFileType(),
				searchExt: searchRequirement.extension,
				searchFileName: searchRequirement.name,
				searchCreatorName: searchRequirement.creatorName,
				searchStartDate: searchRequirement.startDate,
				searchEndDate: searchRequirement.endDate,
				startIndex: pagination.startPosition(),
				listCount: pagination.listSize(),
				sortType: sortType,
				sortColumn: sortColumn
			},
			success: function(result) {
				hideProgress();
				
				if (result.status == "error") {
					if (result.code == 1) {
						console.log("<spring:message code='ezWebFolder.t306'/>");
						return;
					} else if (result.code == 2) {
						alert("<spring:message code='ezWebFolder.t305'/>");
						return;
					} else if (result.code == 3) {
						alert("<spring:message code='ezWebFolder.t300'/>");
						return;
					}
				}
				
				result = result.data;
				containsReplyFiles = result.containsReplyFiles;
				managedList = result.managedList;
				folderPath = "";

				// TODO: 리펙토링
				pagination.setListSize(result.listCount);
				pagination.setAmount(result.totalCount);
				pagination.build();
				
				renderList(result.targetList, false);
				
				setMailBoxInfo(result.folderCount, result.fileCount);
				disableCapacity();
			},
			error: function(error) {
				hideProgress();
			}
		})
		
	}

	function loadList(folderId, folderType, isAsync, successHandler) {
		if (folderId === undefined || folderId == "") {
			return;
		}
		
		var searchRequirement = searchContext.getCurrentRequirement();
		showProgress();
		
		$.ajax({
			type: "POST",
			async: isAsync,
			url: "/ezWebFolder/fileList.do",
			dataType: "json",
			data: {
				"folderId": folderId,
				"folderType": folderType,
				"currPage": pagination.currentPage(),
				"listCount": pagination.listSize(),
				"pStart": pagination.startPosition(),
				"searchExt": searchRequirement.extension,
				"searchFileName": searchRequirement.name,
				"searchCreateName": searchRequirement.creatorName,
				"searchFileType": searchContext.getFileType(),
				"searchStartDate": searchRequirement.startDate,
				"searchEndDate": searchRequirement.endDate,
				"sortType"			: sortType,
				"sortColumn"		: sortColumn
			},
			success: function(result) {
				var data = result.data;
				
				hideProgress();
				
				if (result.status == "error") {
					if (result.code == 1) {
						console.log("<spring:message code='ezWebFolder.t306'/>");
						return;
					} else if (result.code == 2) {
						alert("<spring:message code='ezWebFolder.t305'/>");
						return;
					} else if (result.code == 3) {
						alert("<spring:message code='ezWebFolder.t300'/>");
						return;
					}
				}
				
				containsReplyFiles = data.containsReplyFiles;
				managedList = data.managedFolderList;
				folderPath = data.folderPath;
				parentId = data.folderUpp;

				pagination.setListSize(data.listCount);
				pagination.setAmount(data.totalRows);
				pagination.build();
				
				mailsendBtn(data.folderLevel);
				/* 
				document.getElementById("userManagerBtn").style.display =
					checkIsManager(folderId) ? "" : "none";
				 */
				
				var dragDropArea = dom.dragDropArea;
				folderUpp = data.folderUpp;
				 
				if (folderUpp == "root") {
					$('#upload').css('display','none');
					$('#newFolder').css('display','none');		
					$('#SearchOption').css('display','none');
					dragDropArea.ondragenter = null;
					dragDropArea.ondragover = null;
					dragDropArea.ondragover = null;
				} else {
					$('#upload').css('display','inline');
					$('#newFolder').css('display','inline');				
					$('#SearchOption').css('display','inline');	
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
				
				renderList(data.fileList, true);
				setNamePath(data.folderPath, data.originalPath);
				setMailBoxInfo(data.fldCnt, data.fileCnt);
				window.folderType = folderType;

				if (successHandler) {
					successHandler();
				}

				capacity.load();

				// 폴더 권한 비상속 (이동/복사 버튼 숨기기)
				$("#moveButton, #moveMenu").css("display", data.isNotInherit ? "none" : "");
			},
			error: function(error) {
				hideProgress();
			}
		});
	}

	function mailsendBtn(folderLevel) {
		if ($("#sendingMail").length > 0) {
			var displayVal = (isNaN(parseInt(folderLevel)) || folderLevel > 1) ? "none" : "block";
			$("#sendingMail").css("display", displayVal);
		}
	}

	function setMailBoxInfo(folderCount, fileCount) {
		dom.mailBoxInfo.innerHTML = "&nbsp;&nbsp; " + messages.strLang15 + " <span class='txt_color'>" + folderCount + " </span> / " + messages.strLang16 + " <span class='txt_color'> " + fileCount + " </span>";
		$("#listcount").val(pagination.listSize()).prop("selected", true);
	}

	// originalPath 는 한글 path
	// folderPath 는 숫자 
	function setNamePath(folderPath, originalPath) {
		var nameTag = document.createElement("div");
		var originPath;
		var pathes;
		
		var detailName, divName, divSeparator;
		var imgElmt;
		var length;
		
		nameTag.setAttribute("class", "mainPath");
		folderPath = folderPath.substring(1, folderPath.length - 1);
		originPath = folderPath.split("|");
		pathes = originalPath.split("/");
		
		$('#originalPath').empty();
		dom.originalPath.appendChild(nameTag);
		length = pathes.length - 1;
		
		for (var i = 0; i < length; i++) {
			detailName = document.createElement("div");
			divName = document.createElement("div");
			
			detailName.className = "aName";
			detailName.id = originPath[i];
			detailName.onclick = function() {
				searchContext.clearRequirement();
				searchContext.setFileType("");
				$("#idSelect").val("");
				context.setList(this.id);
			};

			divName.textContent = pathes[i] ;
			divName.setAttribute("title", pathes[i]);
			/* 2018-05-07 장진혁 - 상단 폰트사이즈 15px로 조정 */
			divName.setAttribute("style", "font-size:15px; padding-right:3px; ");
			detailName.appendChild(divName);
			nameTag.appendChild(detailName);

			if (i != length - 1) {
				/* detailName = document.createElement("span");
				detailName.textContent = " > ";
				nameTag.appendChild(detailName); */
				divSeparator = document.createElement("div");
				divSeparator.textContent = " > ";
				divSeparator.setAttribute("class", "separator");
				nameTag.appendChild(divSeparator);
			}
		}
	}

	function renderList(result, isFromFolder) {
		var columnMap = isFromFolder ? resultColumn.folder : resultColumn.favorite;
		
		checkedArr = [];
		$('#tblFileList tr').remove();
		
// 		dom.allCheckBox.checked = false;
		
		if (result == null || result.length == 0) {
			var row = document.createElement("tr");
			var column = document.createElement("td");
			
			column.setAttribute("colspan", "8");
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
		
		var row
		var checkboxColumn, favoriteIconColumn, fileIconColumn, nameColumn, sizeColumn, creatorColumn, createDateColumn, absolutePathColumn;
		
		var inputElement;
		var fileIconElement;
		
		var targetType;
		var isFolder;
		
		for (var i = 0; i < len; i++) {
			resultJson = result[i];
			targetType = resultJson[columnMap.type];
			isFolder = resultJson.folder || isFromFolder && targetType === "folder";

			row = document.createElement("tr");
			
			checkboxColumn = document.createElement("td");
			favoriteIconColumn = document.createElement("td");
			fileIconColumn = document.createElement("td");
			nameColumn = document.createElement("td");
			sizeColumn = document.createElement("td");
			creatorColumn = document.createElement("td");
			createDateColumn = document.createElement("td");
			absolutePathColumn = document.createElement("td");
			
			checkboxColumn.setAttribute("class", "wfFilecheck");
			favoriteIconColumn.setAttribute("class", "wfFileFavorite");
			fileIconColumn.setAttribute("class", "wfFileType");
			nameColumn.setAttribute("class", "wfFileName");
			sizeColumn.setAttribute("class", "wfFileFavoriteSize");
			creatorColumn.setAttribute("class", "wfFileFavoriteDate");
			createDateColumn.setAttribute("class", "wfFileFavoriteDate");
			absolutePathColumn.setAttribute("class", "wfFilePath");

			setStyles([ nameColumn, sizeColumn, creatorColumn, createDateColumn, absolutePathColumn ], function(style) {
				style.overflow = "hidden";
				style.textOverflow = "ellipsis";
				style.whiteSpace = "nowrap";
				style.wordWrap = "normal";
			});
			
			setStyles([ checkboxColumn, favoriteIconColumn, fileIconColumn, sizeColumn ], function(style) {
				style.textAlign = "center";
			});

			setStyles([ nameColumn ], function(style) {
				style.textAlign = "left";
			});

			row.setAttribute("class", "bnkWebFolder");
			row.setAttribute("targetId", resultJson[columnMap.id]);
			row.setAttribute("targetPath", resultJson[columnMap.path]);
			row.setAttribute("targetType", isFolder ? "D" : "F");
			row.setAttribute("targetCreater", resultJson["creatorId"] || resultJson["createId"]);

			row.addEventListener("click", function(event) {rowContext.onRowClick(event, this);});
			row.addEventListener("contextmenu", openContextMenu);
			
			if (!isFromFolder) {
				row.setAttribute("folderType", resultJson.folderType);
				row.setAttribute("targetFunction", targetType);
			}
			
			inputElement = document.createElement("input");
			inputElement.setAttribute("type", "checkbox");
			inputElement.setAttribute("value", resultJson[columnMap.id]);
			//inputElement.setAttribute("class", "checkBnk");
			inputElement.addEventListener("change", rowContext.onCheckboxChange);
			inputElement.addEventListener("click", function(event) {
				event.stopPropagation();
			});
			inputElement.addEventListener("dblclick", function(event) {
				event.stopPropagation();
			});
			
			//checkboxColumn.appendChild(inputElement);
			
			const customDiv = document.createElement("div");
            customDiv.className = "custom_checkbox";
            customDiv.appendChild(inputElement);
            
            checkboxColumn.appendChild(customDiv);
			
			fileIconElement = document.createElement("img");
			fileIconElement.setAttribute("class", "none-drag");
			fileIconElement.addEventListener("click", favoriteContext.onImageClick);
			fileIconElement.addEventListener("dblclick", function(event) {
				event.stopPropagation();
			});
			
			if (resultJson[columnMap.favoriteStatus] === "0") {
				fileIconElement.src = "/images/ImgIcon/view-flag.gif";
			} else {
				fileIconElement.src = "/images/ImgIcon/icon-flag.gif";
				row.setAttribute("favorite", "");
			}
			
			favoriteIconColumn.appendChild(fileIconElement);
			
			fileIconElement = document.createElement("img");
			fileIconElement.setAttribute("class", "webFolderImg");
			
			var iconUrl = "";
				iconUrl = resultJson[columnMap.iconUrl];
			fileIconElement.src = iconUrl;
			
			fileIconColumn.appendChild(fileIconElement);
			
			var depth = resultJson[columnMap.depth];
			var encryptedFlag = resultJson[columnMap.encryptedFlag];
			var fileName = resultJson[columnMap.name];

			row.setAttribute("encryptedFlag", encryptedFlag);
			row.setAttribute("depth", depth);

			nameColumn.textContent = fileName;
			nameColumn.setAttribute("title", fileName);

			if (depth > 1) {
				var additional = "↪ ";

				for (var j = 0; j < depth - 1; j++) {
					additional = " " + additional;
				}

				nameColumn.innerHTML = additional + nameColumn.innerHTML;
			}

			if (encryptedFlag == 1) {
				nameColumn.innerHTML = "<img src='/images/email/secureMail/security_icon.gif' width='12' /> " + nameColumn.innerHTML;
			}

			var fileExt = resultJson["targetExt"] || resultJson["fileExt"];
			if (fileExt) {
				nameColumn.setAttribute("ext", fileExt);
			}

			creatorColumn.textContent = resultJson[columnMap.creatorName];
			createDateColumn.textContent = resultJson[columnMap.createDate].substring(0, 10);
			absolutePathColumn.textContent = resultJson[columnMap.path];
			absolutePathColumn.setAttribute("title", resultJson[columnMap.path]);
			sizeColumn.style.textAlign = "center;"

			var targetType = resultJson[columnMap.type];
			
			if (isFolder) {
				row.ondblclick = function() {
					onFolderDoubleClick(this);
				};
				
				sizeColumn.textContent = "-";
			} else {
				row.addEventListener("dblclick", function(event) {
					if (this.getAttribute("encryptedFlag") == "1") {
						unidocsWebViewer(event);
					} else {
						downloadFileByDbClick(event);
					}

					rowContext.setSelectState(this, true);
				});
				
				sizeColumn.textContent = getFileSize(resultJson[columnMap.size]);
			}
			
			row.appendChild(checkboxColumn);
			row.appendChild(favoriteIconColumn);
			row.appendChild(fileIconColumn);
			row.appendChild(nameColumn);
			row.appendChild(sizeColumn);
			row.appendChild(creatorColumn);
			row.appendChild(createDateColumn);
			row.appendChild(absolutePathColumn);
			
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
		folderId = obj.getAttribute("targetId");
		folderType = obj.getAttribute("folderType");
		
		if (folderType === undefined) {
			forderType = context.getFolderType();
		}
		
		context.setList(folderId, folderType, false);
	}

	function search(type) {
		if (type == "basic") {
			var requirement = {
				startDate: $("#Sdatepicker").datepicker({
					dateFormat: 'yy-mm-dd'
				}).val(),
				endDate: $('#Edatepicker').datepicker({
					dateFormat: 'yy-mm-dd'
				}).val(),
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
				alert(messages.strLang22);
				return;
			}
			
			if (new Date(requirement.startDate) > new Date(requirement.endDate)) {
				alert(messages.strLang19);
				return;
			}
			
			searchContext.search(requirement.startDate, requirement.endDate, requirement.name, requirement.creatorName, requirement.extension);
		} else if (type == "quick") {
			if ($("#txt_keyword").val() == "") {
				alert(messages.strLang20);
				return;
			}
		}
		
		searchOptionHidden();
	}

	function doLayerPopup(obj) {
		$("#searchExt, #searchFileName, #searchCreateName").val("");
		$(".datepicker").datepicker('setDate', "");
		
		/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
		var leftBody = parent.frames["left"].document.body;
		leftBody.style.overflow = "hidden";
		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].searchOptionHidden();'></div>").appendTo(leftBody);
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
		getFileList(folderId);
	}
	
	// adapter function
	function refreshView() {
		context.refreshList(true);
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
		
		$.ajax({
			type: "POST",
			url: "/ezWebFolder/selectedFolderCheckPermission.do",
			data: {
				"fileId" : fileFolderId.toString()
			},
			dataType: "JSON",
			async: true,
			success : function(data) {
				var result = data.status;
				
				if (result != "ok" && data.code == "3") {
					alert(messages.strLang25);
				} else if (data.code == "1") {
					alert(messages.strLang7);
				} else {
					var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
					AttachDownFrame.location.href = downloadUrl;
				}
			},
			error : function(error) {
				alert(messages.strLang7 + error);
			}
		});
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
	
	function splitTargetType(data) {
		if (data === "F") {
			return data;
		}
		var jbString = data;
		var jbSplit = jbString.split('_');
		return jbSplit[1];
	}
	
	function getSelectedFoldersAndFiles() {
		var selectedRows = rowContext.getSelectedRows();
		var selectedLength = selectedRows.length;
		
		if (selectedLength <= 0) {
			alert(messages.strLang38);
			return undefined;
		}
		
		var files  = [];
		var folders = [];
		var creater = [];
		var targetFunction = [];
		var targetPath = [];
		var rowInfo;
		
		for (var i = 0; i < selectedLength; i++) {
			rowInfo = rowContext.getRowInfo(selectedRows[i]);
			
			if (rowInfo.type === 'D') {
				folders.push(rowInfo.id);
				creater.push(rowInfo.creator);
				targetFunction.push(rowInfo.targetFunction);
				functionType = targetFunction[0];
				targetPath.push(getPathSplit(rowInfo.targetPath).length);
			} else {
				files.push(rowInfo.id);
			}
		}
		
		return {
			folders : folders,
			files : files,
			creater : creater,
			targetFunction : targetFunction ,
			targetPath : targetPath
		}
	}
	
	function disableCapacity() {
		$("#capacity-wrapper").css("display", "none");
		$("#capacity-folder-type").text("");
	}
	
	function unidocsWebViewer(event){
		event.stopPropagation();
		event.preventDefault();
		var trElmt       = event.currentTarget;
		var fileId = trElmt.getAttribute("targetId");
		
		unidocsWebViewerOpen(fileId);
	}
	
	function unidocsWebViewerOpen(fileId) {
		openLeftPanel();
		document.getElementById("webFolderRightPanel").style.display = "block";
		document.getElementById("webFolderRightPanel").style.background = "rgba(0,0,0,0.5)";
		showProgress();

		$.ajax({
			type: "POST",
			async: true,
			url: "/ezWebFolder/webfolderFileDownForUnidocs.do",
			data: JSON.stringify({
				"folderId": folderId,
				"fileId": fileId
			}),
			contentType: "application/json; charset=UTF-8",
			dataType: "JSON",
			success: function(result) {
				hideProgress();
				document.getElementById("webFolderRightPanel").style.display = "none";
				closeLeftPanel();
				if (result.status == "OK") {
					var unidocsUrl = result.url + result.encData;
					window.open(unidocsUrl, '_blank');
				} else if (result.code == -1) {
					alert("<spring:message code='webfolder.wfjob.notsupport' />");
				} else if (result.code == 3) {
					alert(messages.strLang25);
				} else {
					alert("<spring:message code='ezWebFolder.t305' />");
				}
			},
			error: function(error) {
				alert("<spring:message code='ezWebFolder.t305' />");
				closeLeftPanel();
				hideProgress();
				document.getElementById("webFolderRightPanel").style.display = "none";
			}
		});
	}

	function hasContainsReplyFiles(fileIds) {
		if (!window.containsReplyFiles) {
			return false;
		}

		for (var i = 0; i < fileIds.length; i++) {
			for (var j = 0; j < containsReplyFiles.length; j++) {
				if (fileIds[i] == containsReplyFiles[j]) {
					return true;
				}
			}
		}

		return false;
	}

	// 2020-12-10 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
	function checkIsManager(targetId) {
		if (!window.managedList) {
			return false;
		}
		
		// 파라미터로 넘어온 폴더가 담당하는 폴더인 경우 true
		if (typeof(folderId) === "string") {
			// 문자열이면 바로 검사
			if (managedList.indexOf(targetId) > -1) {
				return true;
			}
		} else if (typeof(folderId) === "object") {
			// 배열이면 반복문 검사
			for (var i = 0; i < targetId.length; i++) {
				if (managedList.indexOf(targetId[i]) > -1) {
					return true;
				}
			}
		}
		
		if (folderPath.length > 0) {
			for (i = 0; i < managedList.length; i++) {
				if (folderPath.indexOf("|" + managedList[i] + "|") > -1) {
					return true;
				}
			}
		}
		
		return false;
	}
	
	function getUsersPage_manager() {
		authListUser = [];			
		addUser      = [];
		deleteUser   = [];
		var url 	 = "";
		if (selectXhr) {
			selectXhr.abort();
		}
		
		var selectedRows = rowContext.getSelectedRows();

		if (selectedRows.length > 1) {
			alert(messages.strLang39);
			return;
		}

		var targetRow = selectedRows[0];
		var targetId = targetRow.getAttribute("targetid");
		var targetType = targetRow.getAttribute("targettype");
        if (Number(targetRow.getAttribute("depth")) > 1) {
                alert("<spring:message code='ezWebFolder.kes019'/>");
                return;
        }
        if (!checkIsManager(targetId) && targetRow.getAttribute("targetcreater") != userId) {
                alert("<spring:message code='ezWebFolder.kes020' />");
                return;
        }


		if (targetType == "D"){
			url = "/admin/ezWebFolder/getFolderUsers.do"; 
		} else {
			url = "/admin/ezWebFolder/getFileUsers.do";
		}
		
		var data = {
			"fileId"	: targetId,
			"folderId"	: targetId
		}

		// global
		userManager.targetId = targetId;
		userManager.targetType = targetType;

		selectXhr = $.ajax({
			type: "POST",
			url: url,
			data: data,
			dataType: "JSON",
			async: true,
			success : function(data) {
				var code = data.code;
				
				switch(code) {
					case 0:
						var folderUsers = data.folderUsers;
						if(folderUsers != null && folderUsers.length != 0) {
							for (var i = 0; i < folderUsers.length ; i++) {
								if(folderUsers[i]["folderManager"]) {
									continue;
								}
								var auth         		= {};
								auth["userId"]   		= folderUsers[i]["userId"];
								auth["userName"] 		= "<spring:message code='main.t0619' />" == "ko" ? folderUsers[i]["displayName1"] : folderUsers[i]["displayName2"];
								auth["userType"]   		= folderUsers[i]["userType"];
								auth["subdeptPermitted"]= folderUsers[i]["subdeptPermitted"];
								auth["sn"] 		 		= i;
								auth["folderManager"]	= folderUsers[i]["folderManager"];
								auth["displayDeptName"] = "<spring:message code='main.t0619' />" == "ko" ? folderUsers[i]["displayDeptName1"] : folderUsers[i]["displayDeptName2"];
								authListUser.push(auth);
							}
							strictAuthList 		= authListUser;
						}
						menu_SelectRange("", 0);
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
				if (error.statusText == "abort") {
					return;
				}

				alert("<spring:message code='ezWebFolder.t134'/>" + error);
			},
			complete: function() {
				selectXhr = null;
			}
		});
	}
	
	function saveChanges_manager() {
		if(addUser.length == 0 && deleteUser.length == 0) {
			return;
		}
		
		var strAuthListUser = (typeof authListUser == "string")? authListUser : JSON.stringify(authListUser);
		var ajaxData = {
				"currFolderId"  : folderId,
				"targetId"   	: userManager.targetId,
				"targetType" 	: userManager.targetType,
				"folderUsers" 	: strAuthListUser,
				"addUser" 		: convertJSONToJSONStr(addUser),
				"deleteUser" 	: convertJSONToJSONStr(deleteUser),
				"subFolderType"	: "task"
			};

		$.ajax({
			type: "POST",
			url: "/ezWebFolder/changeUserFileORFolder.do",
			data: ajaxData,
			dataType: "JSON",
			async: false,
			success: function(data) {
				var code = data.code;
				
				switch(parseInt(code)) {
					case 0: 
						alert("<spring:message code='ezWebFolder.t182'/>");
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
					case 8:
						alert(messages.resultErrDuplicateRename);
						break;
				}
			},
			error: function (xhr, status, e){
				alert("<spring:message code='ezWebFolder.t134'/>");
			}
		});
	}

	function convertJSONToJSONStr(obj) {
		var returnStr = obj;
		if (typeof returnStr != "string") {
			var tmp = obj.length == 0 ? [] : obj;
			returnStr = JSON.stringify(tmp);
		}

		return returnStr;
	}
</script>
</head>
<body class="mainbody" favoritemode>
	<h1>
		<spring:message code="ezWebFolder.t216" />
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
		<div id="originalPathWrapper" style="height:40px;">
			<div id="originalPath" style="font-size: 24px; font-weight: bold; padding: 8px 4px 0px;"></div>
		</div>
		<div id="mainmenu">
			<ul>
				<li favoritemenu onclick="buttons.fileDownload()" class="important"><span><spring:message code='ezWebFolder.t161'/></span></li>
				<li id="upload" onclick="buttons.fileUpload()" class="important"><span><spring:message code='ezWebFolder.t160'/></span></li>
				<c:if test="${usePreview}">
					<li id="previewButton" favoritemenu><span onclick="buttons.filePreview()"><spring:message code='main.t4009' /></span></li>
				</c:if>
				<li id ="newFolder"><span onclick="buttons.newFolder()"><spring:message code='ezWebFolder.t255' /></span></li>
				<li favoritemenu onclick="buttons.fileRename()"><span><spring:message code='ezWebFolder.t508'/></span></li><!-- 파일명 변경에서 이름변경으로 수정  -->
				<li id="moveButton" onclick="buttons.fileMoveAndCopy()"><span><spring:message code='ezWebFolder.t251'/></span></li>
				<c:if test="${useVersionHistory}">
				<li><span onclick="buttons.openFileVersionHistory()"><spring:message code='webfolder.version.button' /></span></li>
				</c:if>
				<li id="userManagerBtn" style="display:none;"><span onclick="getUsersPage_manager()"><spring:message code='ezWebFolder.kes013' /></span></li>
				<li favoritemenu onclick="favoriteContext.toggleAll()"><span class="icon16 icon16_star"></span></li>
				<li id="SearchOption" favoritemenu mode="off" onclick="doLayerPopup(this)"><span class="icon16 icon16_search"></span></li>
				<li favoritemenu onclick="buttons.fileDelete()"><span class="icon16 icon16_delete"></span></li>
				<li favoritemenu onclick="context.refreshList(true)"><span class="icon16 icon16_refresh"></span></li>
				<div class="sub_frameIcon" style="float:right"  id="wfOptionDiv">
					<div class="sub_frameIconUL02">
						  <p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="webfolderlistoptiondiv"></span></p>  
					</div>
				</div>
				<li favoritemenu style="float:right;">
					<select class="select" id="idSelect" onchange="onFileTypeChange(this.value);">
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
				<!-- <li id="right" favoritemenu style="float: right;"><img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv"></li> -->
			</ul>
		</div>

		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>

		<div id="progress-wrp" style="display: none;">
			<div class="progress-bar"></div>
			<div class="status">0%</div>
		</div>
		<!-- 파일 리스트 10~ 50 선택 -->
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
							<th><spring:message code='ezBoard.t10021'/></th>
							<td><select id="listcount" style="width: 40px; height: 20px;">
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="30">30</option>
									<option value="40">40</option>
									<option value="50">50</option>
								</select></td>
						</tr>
					</table>
				</div>
			</div>
			<div class="shadow"></div>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;"></div>
		<div id="ResizeBarH" style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;"></div>
		<div id="ResizeBarW" style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;"></div>

		<div style="width:100%;"id ="tblFileList1_div">
			<div style="margin:0px 0px 0px !important;min-width: 700px;" >
				<table class="mainlist" style="width:100%"  id="tblFileList1">
					<thead id ="BoardList_THEAD">
						<tr>
							<th class="wfFilecheck			headListClick" style="text-align: center;"><div class="custom_checkbox"><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="_checkAll"></div></th>
							<th class="wfFileFavorite		headListClick" headers="FAVORITE_STATUS"style="text-align: center;"><img class="none-drag" src='/images/ImgIcon/icon-flag.gif'/></th><!-- 즐겨찾기 -->
							<th class="wfFileType			headListClick" headers="TARGET_ICON_URL"style="text-align: center;"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
							<th class="wfFileName			headListClick" headers="TARGET_NAME"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
							<th class="wfFileFavoriteSize	headListClick" headers="TARGET_SIZE"style="text-align: center;"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
							<th class="wfFileFavoriteDate	headListClick" headers="CREATOR_NAME"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
							<th class="wfFileFavoriteDate	headListClick" headers="CREATE_DATE"><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
							<th class="wfFilePath			" headers="TARGET_PATH"><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
						</tr>
					</thead>
				</table>
				<div id="dragDropArea"  style="overflow-y:auto;white-space:nowrap;">
					<table class="mainlist" style="width: 100%;margin:0px 0px 0px !important; white-space:nowrap;" id="tblFileList">
				
					</table>
				</div>
			</div>
		</div>
		<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width: 1px; height: 1px; display: none"/>
		<input type="hidden" onclick="fileupload()"/>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display: none"></iframe>
		<div id="paginationCorrector"></div>
		<div id="tblPageRayer"></div>
	</div>

	<div id="searchpopup" class="popupwrap3" style="display: none;margin-bottom: 70px">
		<div class="popupJQLayer">
			<div class="title"><spring:message code='ezWebFolder.t10'/><spring:message code='ezWebFolder.t123'/></div>
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span onclick="searchOptionHidden()"></span></a></li>
	            </ul>
	        </div>
			<table class="content" style="margin-top: 10px;">
				<tr>
					<th style="text-align: center"><spring:message code='ezBoard.t210'/></th>
					<td><input type="text" id="Sdatepicker" class="datepicker" style="width: 80px; text-align: center" readonly="readonly"> ~ <input type="text" id="Edatepicker" class="datepicker" style="width: 80px; text-align: center" readonly="readonly"></td>
				</tr>

				<tr>
					<th style="text-align: center"><spring:message code='ezWebFolder.t152'/></th>
					<!-- 확장자 -->
					<td><input id="searchExt" type="text" style="width: 99%" value="" name="searchExt"></td>
				</tr>
				<tr>
					<th style="text-align: center"><spring:message code='ezWebFolder.t153'/></th>
					<!-- 파일명 -->
					<td><input id="searchFileName" type="text" style="width: 99%" value="" name="searchFileName"></td>
				</tr>
				<tr>
					<th style="text-align: center"><spring:message code='ezWebFolder.t154'/></th>
					<!-- 작성자 -->
					<td><input type="text" id="searchCreateName" style="width: 99%" value="" name="searchCreateName"></td>
				</tr>
			</table>
			<table style="width: 100%">
				<tr>
					<td style="text-align: center;">
						<div class="btnpositionLayer" style="padding-top:6px">
							<a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezAddress.t142'/></span></a>
						</div>	
					</td>
				</tr>
			</table>
		</div>
	</div>

	<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
		<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
	</div>
	
	<div id="mailPanel" style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.5); display: none;">&nbsp;</div>
	<div id="iFramePanel" class="layerpopup" style="z-index: 2000; position: absolute; display: none; top: 163.5px; right: 513.5px; height: 250px;">
		<iframe id="iFrameLayer" src="" style="border: none;"></iframe>
	</div>

	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;" id="webFolderRightPanel">&nbsp;</div>

	<%@ include file="/WEB-INF/jsp/ezWebFolder/component/downloadOptionPopup.jsp" %>
	<%@ include file="/WEB-INF/jsp/ezWebFolder/component/contextMenu.jsp" %>
	<%@ include file="/WEB-INF/jsp/ezWebFolder/webFolderApplyPopUp.jsp" %>

	<!-- 2020-12-08 김은실 - [카이스트] 구성원관리 추가  -->
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
</body>
</html>
