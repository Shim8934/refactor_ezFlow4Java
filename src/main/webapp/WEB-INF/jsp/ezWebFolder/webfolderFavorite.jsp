<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">
<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css"/>
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
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/row-selector.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/favorite.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/buttons.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/search.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/share.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
<script type="text/javascript">
	"use strict";
	var folderType = "";
	var userId = "${userId}";
	var folderId = "";
	var inputNameDlg_cross_dialogArguments = new Array();
	
	var context = (function() {
		var isFavoriteMode = false;
		
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
			window.folderId = folderId;
			currentFolderId = folderId;
			
			if (isFavoriteMode) {
				currentFolderType = folderType;
			}
			
			isFavoriteMode = false;
			loadList(currentFolderId, currentFolderType, isAsync);

			onListTypeChangeEvent(false);
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
			isFavoriteMode: isFavoriteMode,
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
			type: "targetType"
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
			type: "fileTypeName"
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
		
		searchContext.setSearchStartEventHandler(function() {
			pagination.setPage(1, true);
			$("#idSelect").val("");
			searchContext.setFileType("");
			context.refreshList(true);
		});
		
		pagination.setPageChangeEventHandler(function() {
			context.refreshList(true);
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
				listCount: pagination.listSize()
			},
			success: function(result) {
				hideProgress();
				result = result.data;
				
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
				
				// TODO: 리펙토링
				pagination.setListSize(result.listCount);
				pagination.setAmount(result.totalCount);
				pagination.build();
				
				renderList(result.targetList, false);
				
				setMailBoxInfo(result.folderCount, result.fileCount);
			},
			error: function(error) {
				hideProgress();
			}
		})
		
	}

	function loadList(folderId, folderType, isAsync) {
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
				"searchEndDate": searchRequirement.endDate
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
				
				pagination.setListSize(data.listCount);
				pagination.setAmount(data.totalRows);
				pagination.build();
				
				var dragDropArea = dom.dragDropArea;
				
				if (data.folderUpp == "root") {
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
				
				renderList(data.fileList, true);
				setNamePath(data.folderPath, data.originalPath);
				setMailBoxInfo(data.fldCnt, data.fileCnt);
			},
			error: function(error) {
				hideProgress();
			}
		});
	}

	function setMailBoxInfo(folderCount, fileCount) {
		dom.mailBoxInfo.innerHTML = "&nbsp;&nbsp; " + messages.strLang15 + " <span style='color:#017BEC;'>" + folderCount + " </span> / " + messages.strLang16 + " <span style='color:#017BEC;'> " + fileCount + " </span>";
		$("#listcount").val(pagination.listSize()).prop("selected", true);
	}

	// originalPath 는 한글 path
	// folderPath 는 숫자 
	function setNamePath(folderPath, originalPath) {
		var nameTag = document.createElement("div");
		var originPath;
		var pathes;
		
		// for statement using
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
			
			if(length == 1) {
				// detailName = document.createElement("span");
				/* 2018-05-07 장진혁 - 상단 폰트사이즈 15px로 조정 및 꺽새 추가 */
				// detailName.textContent =  " > " + messages.strLang17 + " "; // 모든파일
				// detailName.setAttribute("style", "font-size:15px;");
				// nameTag.appendChild(detailName);
				divSeparator = document.createElement("div");
				divSeparator.setAttribute("class", "separator");
				divSeparator.textContent =  " > " + messages.strLang17 + " "; // 모든파일
				nameTag.appendChild(divSeparator);
			}
			
			/* 2018-05-07 장진혁 - 이미지 태그 안씀 */
			/* var imgElmt = document.createElement("img");
			imgElmt.setAttribute("style", "height: 14px; width: 14px; display: inline-block; margin: 0px 6px;");
			imgElmt.src = "/images/webfolder/arrow2.png"; */
			
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
			
			if (targetType.indexOf("D_") === 0 || (isFromFolder && targetType === "folder")) {
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
			})

			row.setAttribute("class", "bnkWebFolder");
			row.setAttribute("targetId", resultJson[columnMap.id]);
			row.setAttribute("targetPath", resultJson[columnMap.path]);
			row.setAttribute("targetCreater", result[i]["createId"]);
			row.addEventListener("click", function(event) {rowContext.onRowClick(event, this);});
			
			if (!isFromFolder && isFolder) {
				row.setAttribute("folderType", targetType.charAt(2));
			}
			
			if (isFolder) {
				row.setAttribute("targetType", "D");
			} else {
				row.setAttribute("targetType", "F");
			}
			
			inputElement = document.createElement("input");
			inputElement.setAttribute("type", "checkbox");
			inputElement.setAttribute("value", resultJson[columnMap.id]);
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
			
			if (resultJson[columnMap.favoriteStatus] === "0") {
				fileIconElement.src = "/images/ImgIcon/view-flag.gif";
			} else {
				fileIconElement.src = "/images/ImgIcon/icon-flag.gif";
				row.setAttribute("favorite", "");
			}
			
			favoriteIconColumn.appendChild(fileIconElement);
			
			fileIconElement = document.createElement("img");
			fileIconElement.setAttribute("class", "webFolderImg");
			fileIconElement.src = resultJson[columnMap.iconUrl];
			
			fileIconColumn.appendChild(fileIconElement);
			
			nameColumn.textContent = resultJson[columnMap.name];
			nameColumn.setAttribute("title", resultJson[columnMap.name]);
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
					downloadFileByDbClick(event);
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
		var folderId = obj.getAttribute("targetId");
		var folderType = obj.getAttribute("folderType");
		
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
			
			if (requirement.extension == "" && requirement.name == "" && requirement.creatorName == "" && requirement.startDate == "") {
				alert(messages.strLang20);// 검색조건을 입력하세요 
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

	function optionView(obj) {
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

	function refreshView() {
		getFileList(folderId);
	}
	
	// adapter function
	function refreshView() {
		context.refreshList(true);
	}
	
	// fileupload 함수 가로채기
	fileupload = function() {
		var progress_bar_id = '#progress-wrp';
		var fd = new FormData();
		fd.append("folderId", context.getFolderId());
		
		for (var i = 0; i < file.length; i++) {
			fd.append("fileToUpload", file[i]);
		}
		
		$.ajax({
			url: "/ezWebFolder/uploadFile.do",
			type: "POST",
			data: fd,
			contentType: false,
			dataType: "JSON",
			cache: false,
			processData: false,
			xhr: function() {
				//upload Progress
				document.getElementById('progress-wrp').style.display = "";
				var xhr = $.ajaxSettings.xhr();
				if (xhr.upload) {
					xhr.upload.addEventListener('progress', function(event) {
						var percent = 0;
						var position = event.loaded || event.position;
						var total = event.total;
						if (event.lengthComputable) {
							percent = Math.ceil(position / total * 100);
						}
						//update progressbar
						$(progress_bar_id + " .progress-bar").css("width", +percent + "%");
						$(progress_bar_id + " .status").text(percent == 100 ? percent + "%  -  Processing..." : percent + "%");
					}, true);
				}
				return xhr;
			},
			mimeType: "multipart/form-data",
			success: function(data) {
				var code = data.code;
				
				switch(code) {
					case 0: 
						context.refreshList(true);
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
					case 4:
						alert("<spring:message code='ezWebFolder.t249'/>");
						break;
					case 5:
						alert("<spring:message code='ezWebFolder.t250'/>");
						break;
				}
			},
			error: function(error) {
				alert(strErr);
			}
		}).complete(function(res) {
			$(progress_bar_id + " .progress-bar").css("width", "0%");
			$(progress_bar_id + " .status").text("0%");
			document.getElementById('progress-wrp').style.display = "none";
		});
	};
	
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
	
</script>
</head>
<body class="mainbody" favoritemode>
	<h1>
		즐겨찾기<span id="mailBoxInfo"></span>
	</h1>
	<div id="pageArea">
		<div id="originalPathWrapper" style="height:40px;">
			<div id="originalPath" style="font-size: 24px; font-weight: bold; padding: 8px 4px 0px;"></div>
		</div>
		<div id="mainmenu">
			<ul>
				<li favoritemenu onclick="buttons.fileDownload()" class="important"><span><spring:message code='ezWebFolder.t186'/></span></li>
				<li id="upload" onclick="buttons.fileUpload()" class="important"><span><spring:message code='ezWebFolder.t187'/></span></li>
				<li id ="newFolder"><span onclick="buttons.newFolder()"><spring:message code='ezWebFolder.t255' /></span></li>
				<li favoritemenu onclick="buttons.fileRename()"><span><spring:message code='ezWebFolder.t273'/></span></li>
				<li onclick="buttons.fileMoveAndCopy()"><span><spring:message code='ezWebFolder.t275'/></span></li>
				<li onclick="shareContext.addShareView()"><span><spring:message code='ezWebFolder.t254'/></span></li>			
				<!-- <li favoritemenu><img src="/images/i_bar.gif"></li> -->
				<li favoritemenu onclick="favoriteContext.toggleAll()"><span class="icon16 icon16_star"></span></li>
				<!-- <li><img src="/images/i_bar.gif"></li> -->
				<li id="SearchOption" favoritemenu mode="off" onclick="doLayerPopup(this)"><span class="icon16 icon16_search"></span></li>
				<li favoritemenu onclick="buttons.fileDelete()"><span class="icon16 icon16_delete"></span></li>
				<!-- <li><img src="/images/i_bar.gif"></li> -->
				<li favoritemenu onclick="context.refreshList(true)"><span class="icon16 icon16_refresh"></span></li>
				<!-- <li favoritemenu><img src="/images/i_bar.gif"></li> -->
				<li favoritemenu>
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
		<!-- 파일 리스트 10~ 50 선택 -->
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
							<th class="wfFilecheck" style="text-align: center;"><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="_checkAll"></th>
							<th class="wfFileFavorite" style="text-align: center;"><img class="none-drag" src='/images/ImgIcon/icon-flag.gif'/></th><!-- 즐겨찾기 -->
							<th class="wfFileType" style="text-align: center;"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
							<th class="wfFileName"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
							<th class="wfFileFavoriteSize" style="text-align: center;"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
							<th class="wfFileFavoriteDate"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
							<th class="wfFileFavoriteDate"><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
							<th class="wfFilePath"><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
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
</body>
</html>