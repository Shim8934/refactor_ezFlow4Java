<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<script type="text/javascript" src="<spring:message code='ezWebFolder.e1'/>"></script>	
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"></script>
	<!-- date Picker -->
	<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
	<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<!-- module -->
	<script type="text/javascript" src="/js/ezWebFolder/context/row-selector.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/context/favorite.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/context/search.js"></script>
    <script type="text/javascript">
    	/* pagination variable: 리팩토링, 함수도 포함 대상임.	*/
    	
    		var searchInfo = (function() {
    			var fileType = "";
    			
    			var clear = function() {
    				fileType = "";
    			};
    		
    			return {
    				fileType: fileType,
    				clear: clear
    			};
    		}());
    	
			function setListSize(changedSize) {
				blockSize = changedSize;
				currentPage = 1;
				
				context.refreshList();
			}
    	    
   		/*********************************************/
    	
    	var context = (function() {
    		var isFavoriteMode = false;
    		
    		var currentFolderId = 0;
    		var currentFolderType = "";
    		
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
    		
    		var setListAsFavorite = function() {
    			if (!isFavoriteMode) {
    				isFavoriteMode = true;
    				onListTypeChangeEvent(true);
    			}
    			
    			loadListAsFavorite();
    		};
    		
    		var setList = function(folderId, folderType) {
    			currentFolderId = folderId;
    			
    			if (isFavoriteMode) {
    				currentFolderType = folderType;
    			}
    			
    			isFavoriteMode = false;
    			onListTypeChangeEvent(false);
    			
    			loadList(currentFolderId, currentFolderType);
    		};
    		
    		var refreshList = function() {
    			if (isFavoriteMode) {
    				setListAsFavorite();
    			} else {
    				setList(currentFolderId);
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
    		favorite : {
    			id: "targetId",
    			path: "targetPath",
    			iconUrl: "targetIconUrl",
    			name: "targetName",
    			size: "targetSize",
    			creatorName: "creatorName",
    			createDate: "createDate",
    			type: "targetType"
    		},
    		
    		folder : {
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
    	
    	var message = {
    		fileUploadFail:	"<spring:message code = 'ezWebFolder.t107'/>",	// 파일 업로드에 실패했습니다.
    		previous:		"<spring:message code = 'ezWebFolder.t135'/>",	// 이전
    		next:			"<spring:message code = 'ezWebFolder.t136'/>",	// 다음
    		total:			"<spring:message code = 'ezWebFolder.t137'/>",	// 총
    		count:			"<spring:message code = 'ezWebFolder.t138'/>",	// 개
    		noData:			"<spring:message code = 'ezWebFolder.t144'/>"	// 데이터 없습니다.
    	};
    	
    	var dom;
    	var checkedArr = [];
		
		// fileList 브라우저 화면 크기 변했을때 유동적화면 변화
		window.onresize = function() {
			var divList          = dom.dragDropArea;
			var reheight         = document.documentElement.clientHeight - 220;
			divList.style.height = reheight + "px";
		};
		
		document.onselectstart = function() {
			return false;
		}
	    
		$(function() {
			// dom elements setup
			initDomElement();
			
			// context event handle setup
			context.setOnListTypeChangeEventListener(function(isFavoriteMode) {
				// TODO: 즐겨찾기 메뉴 보이기/숨기기 html, js 소스 정리
				if (isFavoriteMode) {
					dom.originalPathWrapper.style.display = "none";
					dom.mainmenu2.setAttribute("favoritemode", "");
				} else {
					dom.originalPathWrapper.style.display = "";
					dom.mainmenu2.removeAttribute("favoritemode");
				}
			});
			
			pagination.setPageChangeEventHandler(function() {
				context.refreshList();
			});
			
			// load favorite list
			context.setListAsFavorite();
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
	    
	    function initDomElement() {
	    	dom = (function(){
	    		return {
	    			mailBoxInfo : document.getElementById("mailBoxInfo"),
	    	    	mainmenu2 : document.getElementById("mainmenu2"),
	    	    	upload : document.getElementById("upload"),
	    	    	originalPath : document.getElementById("originalPath"),
	    	    	originalPathWrapper : document.getElementById("originalPathWrapper"),
	    	    	dragDropArea : document.getElementById("dragDropArea"),
	    	    	
	    	    	allCheckBox : document.getElementById("_checkAll"),
	    	    	listTable : document.getElementById("tblFileList")
	    		};
	    	}());
	    }
	    
	    function loadListAsFavorite() {
// 	    	var searchStartDate = $('#Sdatepicker').val();
// 	    	var searchEndDate = $('#Edatepicker').val();
	    	
// 	    	if (searchStartDate !== "") {
// 	    		searchStartDate += " 00:00:00";
// 	    	}
	    	
// 	    	if (searchEndDate !== "") {
// 	    		searchEndDate += " 23:59:59";
// 	    	}
	    	
			$.ajax ({
				type: "post",
				async: false,
				url : "/ezWebFolder/getFavorites.do",
				dataType: "json",
				
				data : {
					searchFileType : searchInfo.fileType,
					searchExt : $('#searchExt').val(),
					searchFileName : $('#searchFileName').val(),
					searchCreatorName : $('#searchCreateName').val(),
					searchStartDate: $('#Sdatepicker').val(),
					searchEndDate: $('#Edatepicker').val(),
					startIndex : pagination.startPosition(),
					listCount : pagination.listSize()
				},
				
				success : function (result) {
					result = result.data;
					// TODO: 리펙토링
					pagination.setListSize(result.listCount);
					pagination.setAmount(result.totalCount);
					pagination.build(true);
					
					renderList(result.targetList, false);
					
					setMailBoxInfo(result.folderCount, result.fileCount);
				},
				
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			})
		}
		
		function loadList(folderId, folderType) {
	    	if(folderId === undefined || folderId == "") {
	    		return;
	    	}
	    	
			$.ajax ({
				type:"POST",
				async: false,
				url : "/ezWebFolder/fileList.do",
				dataType: "json",
				data : { 
					 "folderId"   : folderId,
					 "folderType" : folderType,
					 "currPage"   : pagination.currentPage(),
					 "listCount"  : pagination.listSize(),
					 "pStart" : pagination.startPosition(),
					 "searchExt" : $('#searchExt').val(),
					 "searchFileName" : $('#searchFileName').val(),
					 "searchCreateName" : $('#searchCreateName').val(),
					 searchFileType : searchInfo.fileType
				},
				success : function (result) {
					result = result.data;

					pagination.setListSize(result.listCount);
					pagination.setAmount(result.totalRows);
					pagination.build(true);
					
					var dragDropArea = dom.dragDropArea;
					
					if (result.folderUpp == "root") {
						dom.upload.setAttribute("hidden", "");
						dragDropArea.ondragenter = null;
						dragDropArea.ondragover  = null;
						dragDropArea.ondragover  = null;
					} else {
						dom.upload.removeAttribute("hidden");
						dragDropArea.ondragenter = function(e) {onDragEnter(e)};
						dragDropArea.ondragover  = function(e) {onDragOver(e)};
						dragDropArea.ondrop      = function(e) {onDrop(e)};
					}
					
					renderList(result.fileList, true);
					setNamePath(result.folderPath, result.originalPath);
					setMailBoxInfo(result.fldCnt, result.fileCnt);
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
				}
			});
		}
		
		function setMailBoxInfo(folderCount, fileCount) {
			dom.mailBoxInfo.innerHTML = " - [ <spring:message code='ezWebFolder.t276'/> <span style='color:#017BEC;'>" + folderCount +" </span> / <spring:message code='ezWebFolder.t277'/> <span style='color:#017BEC;'>" + fileCount + "</span>" + message.count + "]";
			$("#listcount").val(pagination.listSize()).prop("selected", true);
		}
		
		// originalPath 는 한글 path
		// folderPath 는 숫자 
		function setNamePath(folderPath, originalPath) {
			var nameTag = document.createElement("span");
			var detailName = [];
			var imgElmt;
			
			path = originalPath.split("/");
			originPath = folderPath.split("|");
			$('#originalPath').empty();
			
			dom.originalPath.appendChild(nameTag);
			
			for (var i = 1; i < path.length - 1; i++) {
				detailName = document.createElement("span");
				
				detailName.className = "aName";
				detailName.id = originPath[i];
				detailName.onclick = function() {context.setList(this.id)};
				detailName.textContent = path[i];
				detailName.setAttribute("style", "font-size:22px; ");
				
				nameTag.appendChild(detailName);
				
				imgElmt = document.createElement("img");
				imgElmt.setAttribute("style", "height: 18px; width: 18px; display: inline-block;");
				imgElmt.src = "/images/webfolder/arrow.png";
				
				if (i != path.length - 2) {
					nameTag.appendChild(imgElmt);
				}	
			}
		}
		
		function renderList(result, isFromFolder) {
			var columnMap = isFromFolder ? resultColumn.folder : resultColumn.favorite;
			
			checkedArr = [];
			$('#tblFileList tr').not(":first").remove();
			
			dom.allCheckBox.checked = false;
			
			if (result == null || result.length == 0) {
				var row = document.createElement("tr");
				var column = document.createElement("td");
				
				column.setAttribute("colspan", "8");
				column.setAttribute("align", "center");
				column.setAttribute("bgcolor", "#FFFFFF");
				column.innerHTML = message.noData;
				column.setAttribute("id", "nodataRow");
				
				row.appendChild(column);
				dom.listTable.appendChild(row);
				
				return;
			}
			
			var len = result.length;
			var resultJson;
			
			var row
			var checkboxColumn, favoriteIconColumn, fileIconColumn, nameColumn, 
				sizeColumn, creatorColumn, createDateColumn, absolutePathColumn;
			
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
				
				row  = document.createElement("tr");
				
				checkboxColumn		= document.createElement("td");
				favoriteIconColumn	= document.createElement("td");
				fileIconColumn		= document.createElement("td");
				nameColumn			= document.createElement("td");
				sizeColumn			= document.createElement("td");
				creatorColumn		= document.createElement("td");
				createDateColumn	= document.createElement("td");	
				absolutePathColumn	= document.createElement("td");	
				
				row.setAttribute("class", "bnkWebFolder");
				row.setAttribute("targetId", resultJson[columnMap.id]);
				row.setAttribute("targetPath", resultJson[columnMap.path]);
				row.addEventListener("click", function(event) { rowContext.onRowClick(this); });
				
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
				inputElement.addEventListener("change", function(event) { event.stopPropagation(); rowContext.onCheckboxChange(this); });
				inputElement.addEventListener("click", function(event) { event.stopPropagation(); });
				inputElement.addEventListener("dblclick", function(event) { event.stopPropagation(); });
				
				checkboxColumn.appendChild(inputElement);
				
				fileIconElement = document.createElement("img");
				fileIconElement.setAttribute("class", "none-drag");
				fileIconElement.addEventListener("click", function() { favoriteContext.onImageClick(this); });
				fileIconElement.addEventListener("dblclick", function(event) { event.stopPropagation(); });
				
				if (isFromFolder && resultJson[columnMap.favoriteStatus] === "0") {
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
				creatorColumn.textContent = resultJson[columnMap.creatorName];
				createDateColumn.textContent = resultJson[columnMap.createDate].substring(0, 10);
				absolutePathColumn.textContent = resultJson[columnMap.path];
				sizeColumn.style.textAlign = "center;"
				
				var targetType = resultJson[columnMap.type];
				
				if(isFolder) {
					row.ondblclick = function() {
						onFolderDoubleClick(this);							
					};
					
					sizeColumn.textContent = "";
				} else {
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
		}
		
		function onFolderDoubleClick(obj) {
			var folderId = obj.getAttribute("targetId");
			var folderType = obj.getAttribute("folderType");
			
			if (folderType === undefined) {
				forderType = context.getFolderType();
			}
			
			context.setList(folderId, folderType);
		}
		
		// 날짜 초기화 버튼
		function clearDatepicker() {
			$(".datepicker").datepicker('setDate', "");
		}
	    
	   	// TODO : 여기서부터 코드 정리하면서 내려가서 list 뿌리기 
   		function search(type) {
	   		if (type == "basic") {
	   			var startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	   			var endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	   			
				if ($("#searchExt").val() == "" && $("#searchFileName").val() == "" && $("#searchCreateName").val() == "" && startDate == "") {
	                alert("<spring:message code='ezBoard.t192' />");// 검색조건을 입력하세요
	                return;
				}
	
				if (startDate != "" && endDate == "") {
					alert("<spring:message code='ezBoard.t189' />");
					return;
				}
	            
				if (new Date(startDate) > new Date(endDate)) {
					alert("<spring:message code='ezBoard.t191' />");
					return;
				}
			} else if (type == "quick") {
	            if (document.getElementById("txt_keyword").value == "") {
	                alert("<spring:message code='ezBoard.t192' />");
	                return;
	            }
	        }
	        
			context.refreshList();
	    }
	    
		function doLayerPopup(obj) {
			clearDatepicker();
			document.getElementById("searchExt").value = "";
			document.getElementById("searchFileName").value = "";
			document.getElementById("searchCreateName").value = "";
			
			if (obj.getAttribute("mode") == "off") {
				document.getElementById("layer_popup").style.left = "10px";
				document.getElementById("layer_popup").style.top = "100px";
				document.getElementById("layer_popup").style.display = "";           
				obj.setAttribute("mode", "on");
			} else {
				searchOptionHidden();
			}
		}
  
		function searchOptionHidden() {
		    document.getElementById("layer_popup").style.display = "none";
		    document.getElementById("SearchOption").setAttribute("mode", "off");
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
	       
	       function fileUpload() {
	    	   document.getElementById("file").click();
	    	   refreshView();
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
					alert("<spring:message code = 'ezWebFolder.t20'/>");
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
							alert("<spring:message code='ezWebFolder.t243'/>");
						} else {
							DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + selected.files.toString());
						}
						
						refreshView();
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function fileRename() {
				var selected = getSelectedFoldersAndFiles();
				
				if (selected === undefined) {
					return;
				}
				
				if (selected.folders.length > 0) {
					alert("<spring:message code = 'ezWebFolder.t20'/>");
					return;
				}
				
				if (selected.files.length > 1) {
					alert("<spring:message code = 'ezWebFolder.t115'/>");
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
							alert("<spring:message code='ezWebFolder.t243'/>");
						} else {
							DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function fileMove() {
				var selected = getSelectedFoldersAndFiles();
				
				if (selected === undefined) {
					return;
				}
				
				if (selected.folders.length > 0) {
					alert("<spring:message code = 'ezWebFolder.t20'/>");
					return;
				}
				
				DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + selected.files.toString());
			}
			
			function getSelectedFoldersAndFiles() {
				var selectedRows = rowContext.getSelectedRows();
				var selectedLength = selectedRows.length;
				
				if (selectedLength <= 0) {
					alert("<spring:message code = 'ezWebFolder.t108'/>");
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
        
		// adapter function
		function refreshView() {
			context.refreshList();
		}
		
		// fileupload 함수 가로채기
		fileupload = function() {
			var progress_bar_id = '#progress-wrp';
			var fd              = new FormData();
			fd.append("folderId", context.getFolderId());
			
			for (var i = 0; i < file.length; i++) {
				fd.append("fileToUpload", file[i]);
			}
			
			$.ajax({
				url : "/ezWebFolder/uploadFile.do",
				type: "POST",
				data : fd,
				contentType: false,
				dataType: "JSON",
				cache: false,
				processData:false,
				xhr: function(){
					//upload Progress
					document.getElementById('progress-wrp').style.display = "";
					var xhr = $.ajaxSettings.xhr();
					if (xhr.upload) {
						xhr.upload.addEventListener('progress', function(event) {
							var percent  = 0;
							var position = event.loaded || event.position;
							var total    = event.total;
							if (event.lengthComputable) {
								percent = Math.ceil(position / total * 100);
							}
							//update progressbar
							$(progress_bar_id + " .progress-bar").css("width", + percent +"%");
							$(progress_bar_id + " .status").text(percent == 100 ? percent +"%  -  Processing..." : percent +"%");
						}, true);
					}
					return xhr;
				},
				mimeType:"multipart/form-data",
				success : function(data) {
					var reason   = data.reason;
					var listFile = data.listFile;
					
					if (reason) {
						alert(reason);
					} else {
						context.refreshList();
					}
				},
				error : function(error) {
					alert(strErr);
				}
			})
			.complete(function(res){
				$(progress_bar_id + " .progress-bar").css("width", "0%");
				$(progress_bar_id + " .status").text("0%");
				document.getElementById('progress-wrp').style.display = "none";
			});
		};
		
		function onFileTypeChange(value) {
			searchInfo.fileType = value;
			
			if (value == "all") {
				searchInfo.fileType = ""
			};
			
			pagination.setPage(1);
			searchInfo.clear();
		}
    </script>
</head>
<body class="mainbody">
    <h1 onclick='context.setListAsFavorite();' style="cursor: pointer; display: inline-block;">즐겨찾기</h1>
    <span id="mailBoxInfo"></span>
	<div id="originalPathWrapper" style="height:40px; display: none;">
		<span style="font-size: 24px;font-weight: bold;font-weight: bold; display: block; float: left;" id ="originalPath"></span>
	</div>
	<div id="mainmenu2" favoritemode>
		<ul>
			<li id="" favoritemenu onClick="fileDownload()"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t186'/></span></a></li>
			<li id="upload" onClick="fileUpload()"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t187'/></span></a></li>
			<li id="" onClick="fileDelete()"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t274'/></span></a></li>
			<li id="" onClick="fileRename()"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t273'/></span></a></li>
			<li id="" onClick="fileMove()"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t275'/></span></a></li>
			<li id=""><img src="/images/i_bar.gif"></li>
			<li id="" onClick="favoriteContext.toggleAll()"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t281'/></span></a></li>
<%-- 			<li id=""><a onClick=""     style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t272'/></span></a></li> --%>
			<li id=""><img src="/images/i_bar.gif"></li>
			<li id="SearchOption" favoritemenu mode="off" onClick="doLayerPopup(this)"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t123'/></span></a></li>
			<li id=""><img src="/images/i_bar.gif"></li>
			<li id="" onClick="contet.refreshList()"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t139'/></span></a></li>
			<li id="right" favoritemenu style="float:right;"><span><spring:message code='ezWebFolder.t215'/></span><img src ="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv" onclick="optionView(this);"></li>
			<li id="right" favoritemenu style="float:right;">
				<select class="select" id="idSelect" onchange="idChange(this.value);" style="width:100px; display:none;">
					<option value="all" data-imagesrc="/images/webfolder/allTypes.png" selected><spring:message code='ezWebFolder.t191'/></option><!-- 전체 -->
					<option value="document" data-imagesrc="/images/webfolder/msWord.png"><spring:message code='ezWebFolder.t192'/></option><!-- 문서 -->
					<option value="music" data-imagesrc="/images/webfolder/mp3.png"><spring:message code='ezWebFolder.t193'/></option><!-- 음악 -->
					<option value="video" data-imagesrc="/images/webfolder/mp4.png"><spring:message code='ezWebFolder.t194'/></option><!-- 영상 -->
					<option value="image" data-imagesrc="/images/webfolder/jpg.png"><spring:message code='ezWebFolder.t195'/></option><!-- 그림 -->
					<option value="folder" data-imagesrc="/images/webfolder/fldr.png"><spring:message code='ezWebFolder.t213'/></option><!-- 폴더 -->
					<option value="zip" data-imagesrc="/images/webfolder/zip.png"><spring:message code='ezWebFolder.t196'/></option><!-- 압축파일 -->
				</select>
			</li>
		</ul>
	</div>
	
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu2"), "ul", "li", "0");
	</script>
 	
    <div id="progress-wrp" style="display: none;">
    	<div class="progress-bar"></div ><div class="status">0%</div>
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
                        <th><spring:message code='ezBoard.t10021' /></th>
                        <td>
                            <select id="listcount" style="width: 40px; height: 20px;" onchange="pagination.setListSize(this.value);pagination.build();">
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
 	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id=""></div>
    <div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
    <div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
	
	<div id="dragDropArea" style="margin: 10px 0px; overflow:auto;">
		<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
			<tr>
				<th width="15px" ><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="_checkAll"></th>
				<th width="20px" ><img class="none-drag" src='/images/ImgIcon/icon-flag.gif'/></th>
				<th width="40px" ><spring:message code='ezWebFolder.t188'/></th>
				<th width="330px"><spring:message code='ezWebFolder.t156'/></th>
				<th width="60px" ><spring:message code='ezWebFolder.t157'/></th>
				<th width="120px"><spring:message code='ezWebFolder.t189'/></th>
				<th width="80px" ><spring:message code='ezWebFolder.t190'/></th>
				<th width="160px"><spring:message code='ezWebFolder.t199'/></th>
			</tr>
		</table>
	</div>
	<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width: 1px; height: 1px; display:none" /> 
	<input type="hidden" onclick="fileupload()"/>
	<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
    </div>
    
    <div id="layer_popup" style="width:700px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
          <div class="popupwrap1">
            <div class="popupwrap2">
		        <table class="content">  
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
			    <br />
			    <table style="width:100%">
			        <tr>
			            <td style="text-align:center;">
			                <a class="imgbtn"><span onClick="clearDatepicker()"><spring:message code='ezBoard.t220' /></span></a><!-- 날짜초기화 -->
			                <a class="imgbtn"><span onClick="search('basic');doLayerPopup(document.getElementById('SearchOption'));"><spring:message code='ezBoard.t188' /></span></a><!-- 검색 -->
			                <a class="imgbtn"><span onClick="searchOptionHidden()"><spring:message code='ezBoard.t15' /></span></a><!-- 취소 -->
			            </td>
			        </tr>
			    </table>
	           </div>
	         </div>
	        
	        <div class="shadow">
	        </div>
		</div>
	<div id="tblPageRayer"></div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	
	<!-- date Picker -->
	<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/bnk.js"></script>
</body>
</html>